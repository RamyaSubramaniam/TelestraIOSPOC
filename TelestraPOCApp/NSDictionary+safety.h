//
//  NSDictionary+safety.h
//  
//
//  Created by RamyaSubramaniam on 01/02/16.
//  Copyright © 2016 RamyaSubramaniam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (safety)
- (id)safeObjectForKey:(id)aKey;
@end
