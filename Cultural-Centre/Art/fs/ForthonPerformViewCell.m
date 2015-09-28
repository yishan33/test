//
//  ForthonPerformViewCell.m
//  Login
//
//  Created by Liu fushan on 15/5/17.
//  Copyright (c) 2015年 culturalCenter. All rights reserved.
//

#import "ForthonPerformViewCell.h"
#import "performMeasurement.h"

typedef enum {
    ButtonTypeSkim,
    ButtonTypeShare,
    ButtonTypeCollect,
    ButtonTypeComment
}ButtonType;

@interface ForthonPerformViewCell()

@property (nonatomic, strong) UIView *buttomView;

@end


@implementation ForthonPerformViewCell

+ (UITableViewCell *)loadDataWithHeadImage:(UIImage *)headImage
                                      Name:(NSString *)name
                                 Attention:(BOOL)attention
                                VideoImage:(UIImage *)videoImage
                                      Skim:(int)skimNumber
                                     Share:(int)shareNumber
                                   Collect:(BOOL)collect
                             CollectNumber:(int)collectNumber
                                   Comment:(int)commentNumber


{
    NSLog(@"fs");
    return nil;
}




- (ForthonPerformViewCell *)load
{
    
  
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BACKVIEWWIDTH, BACKVIEWHEIGHT)];
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, TOPVIEWHEIGHT)];
    _buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, TOPVIEWHEIGHT + IMAGEVIEWHEIGHT, WIDTH, BUTTOMVIEWHEIGHT)];
    //    [backView setBackgroundColor:[UIColor grayColor]];
    
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SIDEINSET, TOPINSET, HEADIMAGESIDE, HEADIMAGESIDE)];
    
//    [_headImageView setImage:[UIImage imageWithData:_headImageData]];
    [_headImageView.layer setCornerRadius:_headImageView.frame.size.width / 2];
    [_headImageView.layer setBorderWidth:2.0];
    [_headImageView.layer setBorderColor:[UIColor redColor].CGColor];
    [_headImageView setClipsToBounds:YES];
    
    [topView addSubview:_headImageView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(TOPINSET * 2 + HEADIMAGESIDE, TOPINSET, 72 * WIDTHPERCENTAGE, HEADIMAGESIDE)];
    
//    [nameLabel setText:_name];
    [_nameLabel setFont:[UIFont systemFontOfSize:16.0]];
    [_nameLabel setTextColor:[UIColor blackColor]];
    [topView addSubview:_nameLabel];
    
    _attentionButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 56 * WIDTHPERCENTAGE, (HEADIMAGESIDE / 2 + 10 *HEIGHTPERCENTAGE - 15*HEIGHTPERCENTAGE / 2), 46 * WIDTHPERCENTAGE, 15 * HEIGHTPERCENTAGE)];
    [_attentionButton setTitle:@"+关注" forState:UIControlStateNormal];
    [_attentionButton .titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_attentionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_attentionButton.layer setBorderColor:[UIColor redColor].CGColor];
    [_attentionButton.layer setBorderWidth:1.0];
    [_attentionButton addTarget:self action:@selector(gotoPlay) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_attentionButton];
    
    _videoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, TOPVIEWHEIGHT, WIDTH, IMAGEVIEWHEIGHT)];
//    [_videoImage setImage:[UIImage imageWithData:_videoImageData]];
//    [_videoImage setImage:[UIImage imageNamed:@"spiderMan.jpg"]];
//

    _skimButton = [self buttomButtonWithString:@"1" number:100 category:ButtonTypeSkim];
    _shareButton = [self buttomButtonWithString:@"2" number:50 category:ButtonTypeShare];
    _collectButton = [self buttomButtonWithString:@"3" number:25 category:ButtonTypeCollect];
    _commentButton = [self buttomButtonWithString:@"4" number:1000 category:ButtonTypeComment];
    [backView addSubview:topView];
    [backView addSubview:_videoImage];
    [backView addSubview:_buttomView];
    [self addSubview:backView];
 

    return self;
   
}

- (void)beginPushView
{
    NSLog(@"push!push!");
}

- (UIButton *)buttomButtonWithString:(NSString *)urlString
                              number:(int)number
                            category:(ButtonType)type

{
    int i;
    NSString *labelName = [[NSString alloc] init];
    UIImage *buttonImage = [[UIImage alloc] init];
    switch (type) {
        case ButtonTypeSkim:
            i = 0;
            buttonImage = [UIImage imageNamed:@"skim"];
            labelName = [NSString stringWithFormat:@"    浏览 %i", number];
            break;
        case ButtonTypeShare:
            i = 1;
            buttonImage = [UIImage imageNamed:@"share"];
            labelName = [NSString stringWithFormat:@"    分享 %i", number];

            break;
        case ButtonTypeCollect:
            i = 2;
            buttonImage = [UIImage imageNamed:@"collect"];
            labelName = [NSString stringWithFormat:@"    收藏 %i", number];

            break;
        default:
            i = 3;
            buttonImage = [UIImage imageNamed:@"comment"];
            labelName = [NSString stringWithFormat:@"    评论 %i", number];

            break;
    }
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SIDEINSET + i * (65 + BUTTOMVIEWINTERVAL), 0, 65, BUTTOMVIEWHEIGHT)];
  
    
    UIImageView *skimImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (BUTTOMVIEWHEIGHT - 10) / 2, 10, 10)];
    
  
    [button setTitle:labelName  forState:UIControlStateNormal];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    [button.titleLabel setFont:[UIFont systemFontOfSize:11.0]];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [skimImageView setImage:buttonImage];
    [button addSubview:skimImageView];
    [_buttomView addSubview:button];
    return button;
}

- (void)gotoPlay
{
    NSLog(@"button be tap");
}

@end
