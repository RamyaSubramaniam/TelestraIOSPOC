//
//  Utils.m
//  TelestraPOCApp
//
//  Created by RamyaSubramaniam on 01/02/16.
//  Copyright © 2016 RamyaSubramaniam. All rights reserved.
//

#import "Utils.h"
#import "StaticConstant.h"

@implementation Utils
//================================================================================
/*
 @method        ShowAlert
 @abstract      alert showing to the customer
 @param         NSString
 @return        void
 */
//================================================================================

// Alert Dialog
+(void)showAlert:(NSString *)text {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                    message:text
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil,nil];
    [alert show];
}

//================================================================================
/*
 @method        checkReachability
 @abstract      Checking Internet Connectivity
 @param         Nil
 @return        Bool
 */
//================================================================================

// Check Internet Connection
+(BOOL) checkReachability {
    
    CFNetDiagnosticRef dReference;
    dReference = CFNetDiagnosticCreateWithURL (NULL, (__bridge CFURLRef)[NSURL URLWithString:JSON_FEED_URL]);
    
    CFNetDiagnosticStatus status;
    status = CFNetDiagnosticCopyNetworkStatusPassively (dReference, NULL);
    
    CFRelease (dReference);
    
    if ( status == kCFNetDiagnosticConnectionUp )
        return YES;
    else
        return NO;
}

@end
