//
//  JsonParser.h
//  TelestraPOCApp
//
//  Created by RamyaSubramaniam on 2/3/16.
//  Copyright © 2016 RamyaSubramaniam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonParser : NSObject
-(NSMutableArray *)parseData:(NSDictionary*)json;
@end
