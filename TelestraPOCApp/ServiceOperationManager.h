//
//  ServiceOperationManager.h
//  TelestraPOCApp
//
//  Created by RamyaSubramaniam on 01/02/16.
//  Copyright © 2016 RamyaSubramaniam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceOperationManager : NSObject

typedef void (^CompletionBlock)(NSDictionary *response, NSError *error);
+(void)getFeedResponseForUrl:(NSString *)url withCallback:(CompletionBlock)callback;
@end
