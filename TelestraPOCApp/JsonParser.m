//
//  JsonParser.m
//  TelestraPOCApp
//
//  Created by RamyaSubramaniam on 2/3/16.
//  Copyright © 2016 RamyaSubramaniam. All rights reserved.
//

#import "JsonParser.h"
#import "ContentItemsModel.h"
#import "StaticConstant.h"
#import "NSDictionary+safety.h"

@implementation JsonParser

#pragma mark - ==========Parsing JSON Data====================

-(NSMutableArray *)parseData:(NSDictionary*)json{
    // Initialise nsmutablearray for json feed
    NSMutableArray *responseData = [[NSMutableArray alloc] init];
    
    // Iterating number of records in json feeds
    for(NSDictionary *results in [json objectForKey:NUMBER_OF_ROWS]) {
        
        ContentItemsModel *data = [[ContentItemsModel alloc] init];
        data.cellTitle = [results safeObjectForKey:TITLE];
        data.cellDescription = [results safeObjectForKey:DESCRIPTION];
        data.cellImageUrl = [results safeObjectForKey:IMAGE_URL];
        data.title = [json objectForKey:TITLE];
        // Added json feed model in an array
        [responseData addObject:data];
    }

    return responseData;
}

@end
