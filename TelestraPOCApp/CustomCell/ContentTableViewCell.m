//
//  ContentTableViewCell.m
//  TelestraPOCApp
//
//  Created by RamyaSubramaniam on 01/02/16.
//  Copyright © 2016 RamyaSubramaniam. All rights reserved.
//

#import "ContentTableViewCell.h"
#import "StaticConstant.h"

@implementation ContentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
#pragma mark - ==========Initialise the Custom TableViewCell ====================

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //creating Title for the cell
        self.labelTitle = [[UILabel alloc] init];
        self.labelTitle.backgroundColor = [UIColor clearColor];
        self.labelTitle.numberOfLines = 0;
        self.labelTitle.font=TITLE_FONT;
        self.labelTitle.lineBreakMode = NSLineBreakByWordWrapping;
        self.labelTitle.textAlignment = NSTextAlignmentLeft;
        self.labelTitle.textColor = TITLE_COLOR;
        [self.contentView addSubview:self.labelTitle];
        
        //creating Description for the cell
        self.labelDescription = [[UILabel alloc] init];
        self.labelDescription.numberOfLines = 0;
        self.labelDescription.backgroundColor = [UIColor clearColor];
        self.labelDescription.font=DESCRIPTION_FONT;
        self.labelDescription.textAlignment = NSTextAlignmentLeft;
        self.labelDescription.textColor=DESCRIPTION_COLOR;
        self.labelDescription.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:self.labelDescription];
        
        //creating imageView for the cell
        self.contentimgViewImage = [[UIImageView alloc] init];
        self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.contentimgViewImage];
        
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.contentimgViewImage addSubview:self.activityView];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];

    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - ==========Set Layout Subviews for TableViewCell====================

-(void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self.labelTitle sizeToFit];
    
    CGRect rect=self.labelTitle.frame;
    rect.origin.x= 10;
    rect.origin.y= 10;
    rect.size.width = SCREEN_WIDTH - 20;
    rect.size.height = 30;
    self.labelTitle.frame=rect;
    
    rect=self.labelDescription.frame;
    rect.origin.x=10;
    rect.size.width = SCREEN_WIDTH - 150;
    rect.origin.y=CGRectGetHeight(self.labelTitle.frame) + 20;
    self.labelDescription.frame=rect;
    
    rect=self.contentimgViewImage.frame;
    rect.origin.x= SCREEN_WIDTH - 120;
    rect.origin.y=CGRectGetHeight(self.labelTitle.frame) + 20;
    rect.size.width= 100;
    rect.size.height= 100;
    self.contentimgViewImage.frame=rect;
    
    rect = self.activityView.frame;
    rect.size.height = 50;
    rect.size.width = 50;
    rect.origin.x = 25;
    rect.origin.y = 25;
    self.activityView.frame = rect;
}

// Custom Cell Identifier
+(NSString *)reuseIdentifier {
    
    return @"CellIdentifier";
}

@end
