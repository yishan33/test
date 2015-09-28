//
//  ForthSkimPersonCell.m
//  Art
//
//  Created by Liu fushan on 15/6/18.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "ForthSkimPersonCell.h"
#import "UIImageView+WebCache.h"
#import "ForthonDataSpider.h"
#import "NSString+imageUrlString.h"
#import "NSString+packageNumber.h"



@interface ForthSkimPersonCell ()

@property (nonatomic, strong) NSString *authorId;
@property (nonatomic, strong) NSMutableDictionary *dic;


@property (nonatomic, strong) UILabel *fansLabel;
@property (nonatomic, strong) UILabel *nameLabel;


@property BOOL isFollow;

@end


@implementation ForthSkimPersonCell


- (void)loadWithData:(NSDictionary *)dic
{
    
    _authorId = [dic objectForKey:@"id"];
    _dic = dic;
    if ([dic[@"nickName"] length]) {

        [_nameLabel setText:dic[@"nickName"]];

    } else {

        [_nameLabel setText:dic[@"name"]];
    }
    NSString *fansNumber = [NSString stringWithFormat:@"%@位粉丝", [[dic[@"fans"] stringValue] numberToString]];
    [_fansLabel setText: fansNumber];

    if ([dic[@"avatarUrl"] length]) {

        NSString *headImageUrlStringBody = dic[@"avatarUrl"];
        NSString *headImageUrlString = [headImageUrlStringBody changeToUrl];
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:headImageUrlString]];
    } else {

        _headImageView.image = [UIImage imageNamed:@"profile_avatar_default.png"];
    }

    
}

- (void)loadCellView
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PERSONBACKVIEWWIDTH, PERSONBACKVIEWHEIGHT)];
    
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(PERSON_L_INTERVAL, (PERSONBACKVIEWHEIGHT - PERSONIMAGESIDE) / 2, PERSONIMAGESIDE, PERSONIMAGESIDE)];
    
    [_headImageView.layer setCornerRadius:_headImageView.frame.size.width / 2];
    [_headImageView.layer setBorderWidth:2.0];
    [_headImageView.layer setBorderColor:AppColor.CGColor];
    [_headImageView setClipsToBounds:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushAuthorDescriptionView)];
    [_headImageView addGestureRecognizer:tap];
    
    _attentionButton = [[UIButton alloc] initWithFrame:CGRectMake(PERSONBACKVIEWWIDTH - PERSON_R_INTERVAL - PERSONATTENTIONWIDTH, (PERSONBACKVIEWHEIGHT - PERSONATTENTIONHEIGHT) / 2, PERSONATTENTIONWIDTH, PERSONATTENTIONHEIGHT)];
    
    [_attentionButton setTitle:@"+ 关注" forState:UIControlStateNormal];
    [_attentionButton .titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_attentionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_attentionButton.layer setBorderWidth:1.5];
    [_attentionButton.layer setBorderColor:AppColor.CGColor];
    [_attentionButton addTarget:self action:@selector(setAndCancelFollow) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_attentionButton];
    
    
    _fansLabel = [[UILabel alloc] initWithFrame:CGRectMake(PERSON_L_INTERVAL + PERSONIMAGESIDE + PERSON_M_INTERVAL, 40 * PERSONHEIGHTPERCENTAGE + PERSONNAMEHEIGHT + 10 * PERSONHEIGHTPERCENTAGE, PERSONFANSWIDTH, PERSONFANSHEIGHT)];
    [_fansLabel setFont:[UIFont systemFontOfSize:12.0]];

    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(PERSON_L_INTERVAL + PERSONIMAGESIDE + PERSON_M_INTERVAL,  40 * PERSONHEIGHTPERCENTAGE, PERSONNAMEWIDTH, PERSONNAMEHEIGHT)];
    [_nameLabel setFont:[UIFont systemFontOfSize:15.0]];
    [_nameLabel setTextColor:[UIColor blackColor]];
    [_nameLabel setTextAlignment:NSTextAlignmentLeft];

    [backView addSubview:_headImageView];
    [backView addSubview:_nameLabel];
    [backView addSubview:_fansLabel];
    
    self.delegate = [ForthonDataSpider sharedStore];
    
    [self addSubview:backView];


}


- (void)getFollowStatus
{
    [self.delegate getFollowStatusByTargetId:_authorId];
    
    NSLog(@"获取关注状态%@", _authorId);
    
    NSString *notificationName = [NSString stringWithFormat:@"NotificationId%@Follow",_authorId];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFollowStatus:) name:notificationName   object:nil];

    
}


- (void)changeFollowStatus:(NSNotification *)notification
{
    NSLog(@"添加关注: %@", _authorId);
    
    NSString *notificationName = [NSString stringWithFormat:@"NotificationId%@Follow", _authorId];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notificationName object:nil];
    if ([[notification.userInfo objectForKey:@"result"] boolValue]) {
        
        _isFollow = YES;
        [_attentionButton setTitle:@"- 取消" forState:UIControlStateNormal];
        NSLog(@"设置关注1:%@", _authorId);

    } else {
        
        _isFollow = NO;
        [_attentionButton setTitle:@"+ 关注" forState:UIControlStateNormal];
        NSLog(@"取消关注1:%@", _authorId);
    }
    
}


#pragma mark  加关注，取消关注

- (void)setAndCancelFollow
{
    if (_isFollow == NO) {
        
        [self.delegate setFollowWithTargetId:_authorId];
   
    } else {

        [self.delegate cancelFollowWithTargetId:_authorId andNotification:YES];
    }
    
    NSString *notificationName = [NSString stringWithFormat:@"NotificationId%@Follow", _authorId];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeFollowStatus:)
                                                 name:notificationName
                                               object:nil];

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(LoginPlease) name:@"NotificationUserError"
                                               object:nil];
}


#pragma mark 弹出登录界面

- (void)LoginPlease
{
    NSLog(@"ready login");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationUserError" object:nil];
    [self.loginDelegate pushLoginCurtain];
    
}


//- (void)refresh
//{
//    
//}

- (void)pushAuthorDescriptionView {
    
    NSLog(@"pushAuthorDescription！！！");
    [self.pushDelegate pushAuthorDescriptionWithDic:_dic returnObject:self];
}

@end
