//
//  NSDictionary+safety.m
//  
//
//  Created by RamyaSubramaniam on 01/02/16.
//  Copyright © 2016 RamyaSubramaniam. All rights reserved.
//

#import "NSDictionary+safety.h"

@implementation NSDictionary (safety)

//================================================================================
/*
 @method        CheckForNull
 @abstract      Checking null from server respose params
 @param         id
 @return        id
 */
//================================================================================
- (id)safeObjectForKey:(id)aKey {
    NSObject *object = self[aKey];
    
    if (object == [NSNull null]) {
        return @"";
    }
    
    return object;
}
@end
