//
//  NSDictionary+safety.m
//  
//
//  Created by RamyaSubramaniam on 01/02/16.
//  Copyright © 2016 RamyaSubramaniam. All rights reserved.
//

#import "NSDictionary+safety.h"

@implementation NSDictionary (safety)

#pragma mark - ==========Checking for NULL====================

- (id)safeObjectForKey:(id)aKey {
    NSObject *object = self[aKey];
    
    if (object == [NSNull null]) {
        return @"";
    }
    
    return object;
}
@end
