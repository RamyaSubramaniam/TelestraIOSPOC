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
#pragma mark - ==========UITableView Delegates and DataSource Methods====================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = kTableCellIdentifier;
    
    contentCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    contentCell.backgroundColor=[UIColor clearColor];
    
    if (contentCell == nil){
        contentCell = [[ContentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    contentCell.labelTitle.text =@"title";
    contentCell.labelDescription.text=@"Description";
    
    return contentCell;
}
@end
