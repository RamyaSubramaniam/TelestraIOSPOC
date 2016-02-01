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
#import "contentItemsModel.h"
#import "Reachability.h"
#import "Utils.h"
#import "ServiceOperationManager.h"
#import "NSDictionary+safety.h"
@interface ViewController ()
{
    ContentTableViewCell *contentCell;
}
@end

@implementation ViewController
CGRect viewRect;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // Create session for downloading images
    _sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:_sessionConfig];
    
    // Register notification for orientation change
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(detectOrientation)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    // Refresh button on navigation bar
    UIBarButtonItem *refresh = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshList:)];
    self.navigationItem.rightBarButtonItem = refresh;
    
    // Loading Activity View.
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.activityIndicatorView setCenter:self.view.center];
    [self.view addSubview:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];
    
    // Create a new NSMutableDictionary object so we can store images once they are downloaded.
    self.ImagesCacheDictionary = [[NSMutableDictionary alloc]init];
   
    // creating the tableview to list the contents.
    viewRect = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    self.contentListTableView=[[UITableView alloc]initWithFrame:viewRect];
    self.contentListTableView.delegate=self;
    self.contentListTableView.dataSource=self;
    self.contentListTableView.rowHeight=UITableViewAutomaticDimension;
    self.contentListTableView.estimatedRowHeight=UITableViewAutomaticDimension;
    [self.view addSubview:self.contentListTableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Fetch json feed from the server
    [self fetchJsonFeed];
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
    contentItemsModel *listData = self.responseData[indexPath.row];
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
    contentItemsModel *listData = self.responseData[indexPath.row];
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
    
    // Assign key for each images
    NSString *key =  [NSString stringWithFormat:@"%li",(long)indexPath.row];
    
    
    [contentCell.activityView startAnimating];
    contentCell.contentimgViewImage.image = nil;
    
    // Check Image Exists
    if (![self.ImagesCacheDictionary valueForKey:key])
    {
        // Set Image Url
        NSURL *imageURL = [NSURL URLWithString:listData.cellImageUrl];
        if (imageURL)
        {
            // Send request to download image
            contentCell.imageDownloadTask = [_session dataTaskWithURL:imageURL
                                             completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              if (error) {
                                                  [self.ImagesCacheDictionary setValue:[UIImage imageNamed:IMG_NOT_FOUND] forKey:key];
                                                  [contentCell.contentimgViewImage setImage:[UIImage imageNamed:IMG_NOT_FOUND]];
                                                  [contentCell.activityView stopAnimating];
                                                  
                                              }
                                              else {
                                                  NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                                  
                                                  if (httpResponse.statusCode == 200) {
                                                      UIImage *image = [UIImage imageWithData:data];
                                                      
                                                      [self.ImagesCacheDictionary setValue:image forKey:key];
                                                      [contentCell.contentimgViewImage setImage:image];
                                                      [contentCell.activityView stopAnimating];
                                                      
                                                  }
                                                  else {
                                                      [self.ImagesCacheDictionary setValue:[UIImage imageNamed:IMG_NOT_FOUND] forKey:key];
                                                      [contentCell.contentimgViewImage setImage:[UIImage imageNamed:IMG_NOT_FOUND]];
                                                      [contentCell.activityView stopAnimating];
                                                  }
                                              }
                                          });
                                      }];
            
            [contentCell.imageDownloadTask resume];
        }
    }
    else {
        // Set loaded image in the cell
        [contentCell.contentimgViewImage setImage:[self.ImagesCacheDictionary valueForKey:key]];
        [contentCell.activityView stopAnimating];
    }
    return contentCell;
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


//================================================================================
/*
 @method        fetchJsonFeed
 @abstract      get the json feed from server and update data to UITablview
 @param         nil
 @return        void
 */
//================================================================================

// Downloading Json feed
-(void)fetchJsonFeed {
    
    // Check Network Connection
    if([Utils checkReachability]) {
        
        [ServiceOperationManager getFeedResponseForUrl:JSON_FEED_URL withCallback:^(NSDictionary *json, NSError *error) {
            
            // Initialise nsmutablearray for json feed
            self.responseData = [[NSMutableArray alloc] init];
            
            // Iterating number of records in json feeds
            for(NSDictionary *results in [json objectForKey:NUMBER_OF_ROWS]) {
                
                contentItemsModel *data = [[contentItemsModel alloc] init];
                data.cellTitle = [results safeObjectForKey:TITLE];
                data.cellDescription = [results safeObjectForKey:DESCRIPTION];
                data.cellImageUrl = [results safeObjectForKey:IMAGE_URL];
                
                // Added json feed model in an array
                [self.responseData addObject:data];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.title = [json objectForKey:TITLE];
                self.contentListTableView.delegate = self;
                self.contentListTableView.dataSource = self;
                [self.contentListTableView reloadData];
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
    [self.contentListTableView reloadData];
}

//================================================================================
/*
 @method        refreshList
 @abstract      Refresh the List Items
 @param         id
 @return        void
 */
//================================================================================

// Refresh List Feed
-(void)refreshList:(id)sender {
    // Refresh Json Feeds
    if([Utils checkReachability]) {
        [self.responseData removeAllObjects];
        [self.contentListTableView reloadData];
        [self.activityIndicatorView startAnimating];
        [self fetchJsonFeed];
    } else {
        [Utils showAlert:NO_INTERNET];
    }
}

@end
