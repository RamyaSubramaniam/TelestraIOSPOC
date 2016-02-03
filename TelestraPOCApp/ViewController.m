//
//  ViewController.m
//  TelestraPOCApp
//
//  Created by RamyaSubramaniam on 01/02/16.
//  Copyright © 2016 RamyaSubramaniam. All rights reserved.
//

#import "ViewController.h"
#import "StaticConstant.h"
#import "ContentTableViewCell.h"
#import "ContentItemsModel.h"
#import "Reachability.h"
#import "Utils.h"
#import "ServiceOperationManager.h"
#import "NSDictionary+safety.h"
#import "JsonParser.h"

@interface ViewController ()
{
    ContentTableViewCell *contentCell;
}
@end

@implementation ViewController
CGRect viewRect;
- (void)viewDidLoad {
    [super viewDidLoad];
      
    // Register notification for orientation change
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(detectOrientation)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    // Refresh button on navigation bar
    UIBarButtonItem *refresh = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadTableData:)];
    self.navigationItem.rightBarButtonItem = refresh;
    
    // Loading Activity View.
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.activityIndicatorView setCenter:self.view.center];
    [self.view addSubview:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];
    
    // Create a new NSMutableDictionary object so we can store images once they are downloaded.
    self.ImagesCacheDictionary = [[NSMutableDictionary alloc]init];
    
   
    // Register custom cell
    [self.tableView registerClass:[ContentTableViewCell class] forCellReuseIdentifier:[ContentTableViewCell reuseIdentifier]];
    
    // Remove separator
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Fetch json feed from the server
    [self fetchContentData];
}

#pragma mark - ==========UITableView Delegates and DataSource Methods====================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.responseData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Models for json feed
    ContentItemsModel *listData = self.responseData[indexPath.row];
    NSString *description = listData.cellDescription.length > 0 ? listData.cellDescription : DESCRIPTION_NOT_FOUND;
    
    //Calculate height of the description text
    CGSize descSize = CGSizeMake(SCREEN_WIDTH - DESCRIPTION_WIDTH,MAX_HEIGHT);
    UIFont *descFont = DESCRIPTION_FONT;
    
    //Expected height
    CGSize expectedDescSize = [self rectForText:description
                                      usingFont:descFont
                                  boundedBySize:descSize].size;
    
    CGFloat totalHeight = expectedDescSize.height;
    if (totalHeight > EXPECTED_HEIGHT)
        return totalHeight + OFFSET_HEIGHT;
    else
        return DEFAULT_HEIGHT;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = kTableCellIdentifier;
    
    contentCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    contentCell.backgroundColor=[UIColor clearColor];
    
    if (contentCell == nil){
        contentCell = [[ContentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Get feed data based on indexpath
    ContentItemsModel *listData = self.responseData[indexPath.row];
    NSString *title=  listData.cellTitle.length > 0 ? listData.cellTitle : TITLE_NOT_FOUND;
    contentCell.labelTitle.text = title;
    
    NSString *description = listData.cellDescription.length > 0 ? listData.cellDescription : DESCRIPTION_NOT_FOUND;
    contentCell.labelDescription.text = description;
    
    //Calculate height of the text
    CGSize descSize = CGSizeMake(SCREEN_WIDTH - 150,9999);
    UIFont *descFont = DESCRIPTION_FONT;
    
    CGRect expectedDescRect = [self rectForText:description usingFont:descFont
                                  boundedBySize:descSize];
    //Adjust the label to the new height.
    CGRect descFrame = contentCell.labelDescription.frame;
    descFrame.size.height = expectedDescRect.size.height;
    
    // Set description frame
    contentCell.labelDescription.frame = descFrame;
    
    // Only load cached images; defer new downloads until scrolling ends
    if (!listData.imageCached)
    {
        
        // if a download is deferred or in progress, return a placeholder image
        contentCell.contentimgViewImage.image = [UIImage imageNamed:IMG_PLACEHOLDER];
    }
    else
    {
         contentCell.contentimgViewImage.image = listData.imageCached;
    }
    
    contentCell.contentimgViewImage.image = listData.imageCached;
    
    [contentCell layoutIfNeeded];
    return contentCell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor whiteColor]];
    
    // set gradient background color of the cell
    CAGradientLayer *grad = [CAGradientLayer layer];
    
    grad.frame = cell.bounds;
    
    grad.colors = [NSArray arrayWithObjects:(id)[[UIColor lightGrayColor] CGColor], (id)[[UIColor whiteColor] CGColor], nil];
    
    [cell setBackgroundView:[[UIView alloc] init]];
    
    [cell.backgroundView.layer insertSublayer:grad atIndex:0];
    [cell layoutIfNeeded];
    
}


//Calculate Height of Label
-(CGRect)rectForText:(NSString *)text
           usingFont:(UIFont *)font
       boundedBySize:(CGSize)maxSize
{
    NSAttributedString *attrString =
    [[NSAttributedString alloc] initWithString:text
                                    attributes:@{ NSFontAttributeName:font}];
    
    return [attrString boundingRectWithSize:maxSize
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                    context:nil];
}


#pragma mark - ==========Fetch JSON Feed====================

// Downloading Json feed
-(void)fetchContentData {
    
    // Check Network Connection
    if([Utils checkReachability]) {
        
        [ServiceOperationManager getFeedResponseForUrl:JSON_FEED_URL withCallback:^(NSDictionary *json, NSError *error) {
           
            if (!error) {
                //Parsing JSON data
                JsonParser *jsonParser =[[JsonParser alloc]init];
                self.responseData =[jsonParser parseData:json];

            }
            else{
                
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                               message:error.localizedDescription
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {}];
                
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.tableView.delegate = self;
                self.tableView.dataSource = self;
                [self.tableView reloadData];
                [self.activityIndicatorView stopAnimating];
                
            });
        }];
        
    } else {
        [Utils showAlert:NO_INTERNET];
        [self.activityIndicatorView stopAnimating];
    }
}


// Orientaion change detection
-(void) detectOrientation {
    [self.tableView reloadData];
}
#pragma mark - ==========ReloadTableData====================


// Refresh List Feed
-(void)reloadTableData:(id)sender {
    // Refresh Json Feeds
    if([Utils checkReachability]) {
        [self.responseData removeAllObjects];
        [self.tableView reloadData];
        [self.activityIndicatorView startAnimating];
        [self fetchContentData];
    } else {
        [Utils showAlert:NO_INTERNET];
    }
}

@end
