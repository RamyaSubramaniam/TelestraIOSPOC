//
//  ServiceOperationManager.m
//  TelestraPOCApp
//
//  Created by RamyaSubramaniam on 01/02/16.
//  Copyright © 2016 RamyaSubramaniam. All rights reserved.
//

#import "ServiceOperationManager.h"
#import "StaticConstant.h"
#import "GenericClass.h"
@implementation ServiceOperationManager

//================================================================================
/*
 @method        getFeedResponseForUrl
 @abstract      Get Json Feed From the server
 @param         url
 @return        nil
 */
//================================================================================

+(void)getFeedResponseForUrl:(NSString *)url withCallback:(CompletionBlock)callback {
    
    // Create a url for json feed
    NSURL *URL = [NSURL
                  URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    // Creates a session
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse
                                    *response, NSError *error) {
                                      
                                      NSString *feedString = [[NSString
                                                               alloc] initWithData:data encoding:NSASCIIStringEncoding];
                                      
                                      NSData *jsonData = [feedString dataUsingEncoding:NSUTF8StringEncoding];
                                      NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
                                      
                                      callback(json,error);
                                      
                                  }];
    [task resume];
}


@end

