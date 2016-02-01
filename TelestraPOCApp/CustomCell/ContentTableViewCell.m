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



@end
