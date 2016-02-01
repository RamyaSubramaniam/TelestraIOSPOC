//
//  ViewController.h
//  TelestraPOCApp
//
//  Created by RamyaSubramaniam on 01/02/16.
//  Copyright © 2016 RamyaSubramaniam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>
//To store the downloaded images into a Dictionary.
@property (atomic, strong)NSMutableDictionary *ImagesCacheDictionary;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

// Store json feeds in response data
@property (nonatomic,retain) NSMutableArray *responseData;

// Create session configuration for downloading images
@property (nonatomic, strong) NSURLSessionConfiguration *sessionConfig;
@property (nonatomic, strong) NSURLSession *session;
@end

