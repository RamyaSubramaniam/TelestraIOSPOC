//
//  StaticConstant.h
//  TelestraPOCApp
//
//  Created by RamyaSubramaniam on 01/02/16.
//  Copyright © 2016 RamyaSubramaniam. All rights reserved.
//

#ifndef StaticConstant_h
#define StaticConstant_h

// Screen Bounds
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define DESCRIPTION_WIDTH 150
#define EXPECTED_HEIGHT 130
#define DEFAULT_HEIGHT 170
#define OFFSET_HEIGHT 60

#define MAX_HEIGHT 9999
#define kTableCellIdentifier                   @"CellIdentifier"
#define JSON_FEED_URL                         @"https://dl.dropboxusercontent.com/u/746330/facts.json"
#define ALERT  @"Alert"
#define OK  @"Ok"

//Model Constant
#define NUMBER_OF_ROWS @"rows"
#define TITLE @"title"
#define IMAGE @"image"
#define DESCRIPTION @"description"
#define IMAGE_URL @"imageHref"

//Errors Notification
#define NO_INTERNET @"Internet service not available"
#define HOST_UNREACHABLE @"Host Unreachable"
#define REMOTE_UNAVALIABLE @"Problem with remote service"

//Error Messages
#define IMG_NOT_FOUND @"no_image"
#define IMG_PLACEHOLDER @"placeholder"
#define DESCRIPTION_NOT_FOUND @"No Description"
#define TITLE_NOT_FOUND @"No Title"

//Font
#define TITLE_FONT [UIFont boldSystemFontOfSize:14];
#define DESCRIPTION_FONT [UIFont systemFontOfSize:15];

//Color
#define TITLE_COLOR [UIColor purpleColor];
#define DESCRIPTION_COLOR [UIColor grayColor];

#endif /* StaticConstant_h */
