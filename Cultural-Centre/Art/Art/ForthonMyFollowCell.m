//
//  ForthonMyFollowCell.m
//  Art
//
//  Created by Liu fushan on 15/7/5.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "ForthonMyFollowCell.h"
#import "UIImageView+WebCache.h"
#import "ForthonDataSpider.h"
#import "NSString+imageUrlString.h"
#import "AFURLRequestSerialization.h"


@interface ForthonMyFollowCell ()

@property (nonatomic, strong) NSString *authorId;
@property (nonatomic, strong) NSMutableDictionary *dic;

@end

@implementation ForthonMyFollowCell

- (void)loadWithData:(NSDictionary *)dic
{
    self.delegate = [ForthonDataSpider sharedStore];
    _authorId = dic[@"id"];
    _dic = dic;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PERSONBACKVIEWWIDTH, PERSONBACKVIEWHEIGHT)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(PERSON_L_INTERVAL, (PERSONBACKVIEWHEIGHT - PERSONIMAGESIDE) / 2, PERSONIMAGESIDE, PERSONIMAGESIDE)];
    
    [imageView.layer setCornerRadius:imageView.frame.size.width / 2];
    [imageView.layer setBorderWidth:2.0];
    [imageView.layer setBorderColor:AppColor.CGColor];
    [imageView setClipsToBounds:YES];
    UITapGestureRecognizer *tapHead = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushAuthorDescription)];
    [imageView addGestureRecognizer:tapHead];
    imageView.userInteractionEnabled = YES;

    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(PERSON_L_INTERVAL + PERSONIMAGESIDE + PERSON_M_INTERVAL,  40 * PERSONHEIGHTPERCENTAGE, PERSONNAMEWIDTH, PERSONNAMEHEIGHT)];
    [nameLabel setTextColor:[UIColor blackColor]];
    
    
    UILabel *fansLabel = [[UILabel alloc] initWithFrame:CGRectMake(PERSON_L_INTERVAL + PERSONIMAGESIDE + PERSON_M_INTERVAL, 40 * PERSONHEIGHTPERCENTAGE + PERSONNAMEHEIGHT + 5, PERSONFANSWIDTH, PERSONFANSHEIGHT)];
    [fansLabel setTextColor:[UIColor grayColor]];
    
    
    UIButton *attentionButton = [[UIButton alloc] initWithFrame:CGRectMake(PERSONBACKVIEWWIDTH - PERSON_R_INTERVAL - PERSONATTENTIONWIDTH, (PERSONBACKVIEWHEIGHT - PERSONATTENTIONHEIGHT) / 2, PERSONATTENTIONWIDTH, PERSONATTENTIONHEIGHT)];
    [attentionButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [attentionButton.layer setBorderWidth:1.5];
    [attentionButton.layer setBorderColor:AppColor.CGColor];
    
//    NSString *followStr = [[NSString alloc] init];
//    if (_isFollow == YES) {
//        followStr = @"- 取消";
//    } else if (_isFollow == NO) {
//        followStr = @"+ 关注";
//    }
    [attentionButton setTitle:@"- 取消" forState:UIControlStateNormal];
    [attentionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [attentionButton addTarget:self action:@selector(cancelFollow) forControlEvents:UIControlEventTouchUpInside];

    NSString *name;
    if ([dic[@"nickName"] length]) {

        name = dic[@"nickName"];
    } else if([dic[@"name"] length]) {

        name = dic[@"name"];
    }


    [nameLabel setText:name];
    [nameLabel setTextAlignment:NSTextAlignmentLeft];
    NSString *fansNumber = [NSString stringWithFormat:@"%@位粉丝", [dic[@"fans"] stringValue]];
    [fansLabel setText: fansNumber];
    [fansLabel setFont:[UIFont systemFontOfSize:12.0]];
    if ([dic[@"avatarUrl"] length]) {

        NSString *headImageUrlStringBody = dic[@"avatarUrl"];
        NSString *headImageUrlString = [headImageUrlStringBody changeToUrl];
        [imageView sd_setImageWithURL:[NSURL URLWithString:headImageUrlString]];
    } else {

        imageView.image = [UIImage imageNamed:@"profile_avatar_default.png"];
    }

    

    
    [backView addSubview:imageView];
    [backView addSubview:nameLabel];
    [backView addSubview:fansLabel];
    [backView addSubview:attentionButton];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self addSubview:backView];
}

- (void)cancelFollow
{
    [self.delegate cancelFollowWithTargetId:_authorId andNotification:YES];
    NSString *notificationName = [NSString stringWithFormat:@"NotificationId%@Follow", _authorId];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(afterCancelFollow:)
                                                 name:notificationName
                                               object:nil];
    

}

- (void)afterCancelFollow:(NSNotification *)notification
{
    NSString *notificationName = [NSString stringWithFormat:@"NotificationId%@Follow", _authorId];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notificationName object:nil];
    if (![[notification.userInfo objectForKey:@"result"] boolValue]) {
        
        [self.updateDelegate updateTable];
    }

}

- (void)pushAuthorDescription {

    NSLog(@"作者强请");
    [self.authorDelegate pushAuthorDescriptionWitDic:_dic];
}


@end
