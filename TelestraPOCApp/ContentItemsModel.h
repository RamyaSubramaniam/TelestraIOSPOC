//
//  contentItemsModel.h
//  TelestraPOCApp
//
//  Created by RamyaSubramaniam on 01/02/16.
//  Copyright © 2016 RamyaSubramaniam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ContentItemsModel : NSObject

@property(strong,nonatomic)NSString *title;
@property(strong, nonatomic) NSString *cellTitle;
@property(strong, nonatomic) NSString *cellImageUrl;
@property(strong, nonatomic) NSString *cellDescription;
@property(strong,nonatomic) UIImage *imageCached;

@end
