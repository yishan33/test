//
//  YHUserInfoCell.m
//  Art
//
//  Created by Tang yuhua on 15/6/30.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "YHUserInfoCell.h"
#import "UIImageView+WebCache.h"
#import "ForthonDataSpider.h"

@interface YHUserInfoCell ()

@property (nonatomic, strong) UIImageView *headImage;


@end

#define LABEL_Width 150
#define LABEL_Height 44
#define Image_Width 35
#define LABEL_LeadingSpace [UIScreen mainScreen].applicationFrame.size.width - LABEL_Width - 15
#define Image_LeadingSpace [UIScreen mainScreen].applicationFrame.size.width - Image_Width - 15

@implementation YHUserInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.textLabel.textColor = AppColor;
        self.textLabel.font = [UIFont boldSystemFontOfSize:17.0];
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(LABEL_LeadingSpace, 0, LABEL_Width, LABEL_Height)];
        [_messageLabel setTextColor:AppColor];
        _messageLabel.font = [UIFont boldSystemFontOfSize:17.0];
        [_messageLabel setTextAlignment:NSTextAlignmentRight];
        [self addSubview:_messageLabel];
 
    }
    return self;
}

- (void)loadWithImageRight
{
    _headImage = [[UIImageView alloc] initWithFrame:CGRectMake(Image_LeadingSpace, (44 - Image_Width) / 2, Image_Width, Image_Width)];
    [_headImage.layer setBorderColor:AppColor.CGColor];
    [_headImage.layer setBorderWidth:1.0];
    [_headImage.layer setCornerRadius:Image_Width / 2];
    _headImage.clipsToBounds = YES;
    NSString *headImageUrl = [ForthonDataSpider sharedStore].avatarUrl;
    NSLog(@"now picture: %@", headImageUrl);
    [_headImage sd_setImageWithURL:[NSURL URLWithString:headImageUrl]];

    [self addSubview:_headImage];
}

- (void)loadWithImage:(UIImage *)image {

    _headImage.image = image;
}


- (void)awakeFromNib {
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
