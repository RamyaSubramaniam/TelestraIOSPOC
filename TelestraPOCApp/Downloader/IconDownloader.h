//
//  IconDownloader.h
//  TelestraPOCApp
//
//  Created by RamyaSubramaniam on 2/3/16.
//  Copyright © 2016 RamyaSubramaniam. All rights reserved.

#import "ContentItemsModel.h"

@interface IconDownloader : NSObject

@property (nonatomic, strong) ContentItemsModel *appRecord;
@property (nonatomic, copy) void (^completionHandler)(void);

- (void)startDownload;

@end
