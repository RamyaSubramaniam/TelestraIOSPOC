//
//  IconDownloader.m
//  TelestraPOCApp
//
//  Created by RamyaSubramaniam on 2/3/16.
//  Copyright © 2016 RamyaSubramaniam. All rights reserved.

#import "IconDownloader.h"



@interface IconDownloader ()

@property (nonatomic, strong) NSURLSessionDataTask *sessionTask;

@end


#pragma mark -

@implementation IconDownloader

// -------------------------------------------------------------------------------
//	startDownload
// -------------------------------------------------------------------------------
- (void)startDownload
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.appRecord.cellImageUrl]];

    // create an session data task to obtain and download the app icon
    _sessionTask = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                   completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        

        if (error != nil)
        {
            if ([error code] == NSURLErrorAppTransportSecurityRequiresSecureConnection)
            {
                // if you get error abort() will call,
               
                abort();
            }
        }
                                                       
        [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
            
            // Set appIcon and clear temporary data/image
            UIImage *image = [[UIImage alloc] initWithData:data];
            
            self.appRecord.imageCached = image;
            NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];

            if (HTTPStatusCode!=200) {
                self.appRecord.imageCached =nil;
            }
            // completion handler 
            if (self.completionHandler != nil)
            {
                self.completionHandler();
            }
        }];
    }];
    
    [self.sessionTask resume];
}


@end

