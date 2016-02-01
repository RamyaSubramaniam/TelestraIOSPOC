//
//  ViewController.h
//  TelestraPOCApp
//
//  Created by RamyaSubramaniam on 01/02/16.
//  Copyright © 2016 RamyaSubramaniam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)UITableView *contentListTableView;

@end

