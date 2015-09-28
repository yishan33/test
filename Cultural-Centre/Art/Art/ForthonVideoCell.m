//
//  ForthonVideoCellBeta.m
//  Art
//
//  Created by Liu fushan on 15/7/13.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "ForthonVideoCell.h"
#import "performMeasurement.h"
#import "ForthonDataContainer.h"
#import "ForthonDataSpider.h"
#import "UIImageView+WebCache.h"
#import "NSString+packageNumber.h"
#import "NSString+imageUrlString.h"
#import "ForthonVideoDescription.h"
#import "AFURLRequestSerialization.h"

#import <ShareSDK/ShareSDK.h>
#import <QZoneConnection/QZoneConnection.h>
#import "SVProgressHUD.h"

@interface ForthonVideoCell()<VideoAddSkim>

@property (nonatomic, strong) UIView *buttomView;

@property int favorMaxNumber;
@property int favorMinNumber;

@property (nonatomic, strong) NSString *workId;
@property (nonatomic, strong) NSString *authorId;
@property (nonatomic, strong) NSMutableDictionary *modelDic;
@property (nonatomic, strong) NSMutableArray *labelArray;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *collectNumberLabel;


@property (nonatomic, strong) UIButton *collectButton;
@property (nonatomic, strong) UIImageView *collectImageView;

@property (nonatomic, strong) ForthonVideoDescription *videoDescription;

@end

@implementation ForthonVideoCell

- (void)loadView
{

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    

    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BACKVIEWWIDTH, BACKVIEWHEIGHT)];
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, TOPVIEWHEIGHT)];
    _buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, TOPVIEWHEIGHT + IMAGEVIEWHEIGHT + 5, WIDTH, BUTTOMVIEWHEIGHT)];
    //    [backView setBackgroundColor:[UIColor grayColor]];
    
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SIDEINSET, TOPINSET, HEADIMAGESIDE, HEADIMAGESIDE)];
    
    //    [_headImageView setImage:[UIImage imageWithData:_headImageData]];
    [_headImageView.layer setCornerRadius:_headImageView.frame.size.width / 2];
    [_headImageView.layer setBorderWidth:2.0];
    [_headImageView.layer setBorderColor:AppColor.CGColor];
    [_headImageView setClipsToBounds:YES];
    UITapGestureRecognizer *tapHeadImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHead)];
    [_headImageView addGestureRecognizer:tapHeadImage];
    
    [topView addSubview:_headImageView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(TOPINSET * 2 + HEADIMAGESIDE, TOPINSET, WIDTH - (TOPINSET * 2 + HEADIMAGESIDE), HEADIMAGESIDE)];
    
    //    [nameLabel setText:_name];
    [_nameLabel setFont:[UIFont systemFontOfSize:16.0]];
    [_nameLabel setTextColor:[UIColor blackColor]];
    [topView addSubview:_nameLabel];
    
    _attentionButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 50 * WIDTHPERCENTAGE - SIDEINSET, (HEADIMAGESIDE / 2 + 10 *HEIGHTPERCENTAGE - 20*HEIGHTPERCENTAGE / 2), 50 * WIDTHPERCENTAGE, 20 * HEIGHTPERCENTAGE)];


//    [_attentionButton setTitle:@"无状态" forState:UIControlStateNormal];
    [_attentionButton .titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_attentionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_attentionButton.layer setBorderColor:AppColor.CGColor];
    [_attentionButton.layer setBorderWidth:1.5];
    [_attentionButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_attentionButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [_attentionButton addTarget:self action:@selector(setAndCancelFollow) forControlEvents:UIControlEventTouchUpInside];


    [topView addSubview:_attentionButton];
    
    UIView *middleView = [[UIView alloc] initWithFrame:CGRectMake(0, TOPVIEWHEIGHT, WIDTH, IMAGEVIEWHEIGHT)];
    
    NSLog(@"before rewrite");
    _videoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, IMAGEVIEWHEIGHT)];
    UITapGestureRecognizer *tapVideoImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(beginPushView)];
    [_videoImage addGestureRecognizer:tapVideoImage];
//    _videoImage.contentMode = UIViewContentModeScaleAspectFit;
    [middleView addSubview:_videoImage];

    if (_isPlay) {

        UIImageView *playImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"play.png"]];
        [playImage setFrame:CGRectMake(0, 0, IMAGEVIEWHEIGHT / 3, IMAGEVIEWHEIGHT / 3)];
        [playImage setCenter:CGPointMake(WIDTH / 2, IMAGEVIEWHEIGHT / 2)];
        playImage.userInteractionEnabled = YES;
        [_videoImage addSubview:playImage];
    }


    NSLog(@"labelArray is right");
    NSArray *iconNameArray = @[@"skimm", @"shareVideo", @"collect", @"comment"];
    NSArray *buttonTextArray = @[@" 浏览 ", @"    分享 ", @"    收藏 ", @"    评论 "];
    _labelArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 4; i++) {
        
        UILabel *label = [self createButtomLabel];
        UIButton *button = [self createButtomButton];
        UIImage *image = [UIImage imageNamed:iconNameArray[i]];
        UIImageView *imageView = [[UIImageView alloc] init];
        NSLog(@"iconName is right");
        [imageView setImage:image];
        [imageView setFrame:CGRectMake(0, (BUTTOMVIEWHEIGHT - 10) / 2, 10, 10)];
        SEL method;
        if (i == 0) {
            method = @selector(tapSkimButton);
            label.frame = CGRectMake(30, 0, 30, BUTTOMVIEWHEIGHT);
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            _skimNumberLabel = label;
            
        } else if (i == 1) {
            method = @selector(shareVideo:);
            imageView.frame = CGRectMake(-5, (BUTTOMVIEWHEIGHT - 10) / 2, 15, 10);

            _shareNumberLabel = label;
        } else if (i == 2) {
            method = @selector(setAndCancelFavor);
            _collectNumberLabel = label;
            _collectImageView = imageView;
            _collectButton = button;
            
        } else {
            method = @selector(tapCommentButton);
            _commentNumberLabel = label;
            
        }
        [_labelArray addObject:label];
        [button addTarget:self action:method forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:buttonTextArray[i] forState:UIControlStateNormal];
        [button addSubview:label];
        [button addSubview:imageView];
        [button setFrame:CGRectMake(SIDEINSET + i * (55 + BUTTOMVIEWINTERVAL), 0, 55, BUTTOMVIEWHEIGHT)];
        [_buttomView addSubview:button];
        

    }
    
 
    [backView addSubview:topView];
    [backView addSubview:middleView];
    [backView addSubview:_buttomView];
    [self addSubview:backView];
    
    
    [self setFollowDelegate:[ForthonDataSpider sharedStore]];
    [self setFavorDelegate:[ForthonDataSpider sharedStore]];
    [self setShareDelegate:[ForthonDataSpider sharedStore]];
    [self setNumberDelegate:[ForthonDataSpider sharedStore]];
    
    NSLog(@"loadView success");
}
    


- (UILabel *)createButtomLabel {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 30, BUTTOMVIEWHEIGHT)];
    [label setFont:[UIFont boldSystemFontOfSize:12.0]];
    label.textColor = [UIColor grayColor];

    return label;
}

- (UIButton *)createButtomButton {
    
    UIButton *button = [[UIButton alloc] init];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [button.titleLabel setFont:[UIFont systemFontOfSize:11.0]];
    [button setTitleColor:AppColor forState:UIControlStateNormal];
    
    return button;
}



- (void)tapSkimButton {
    
    NSLog(@"浏览");
}

- (void)tapShareButton {
    NSLog(@"分享");
}

- (void)tapCollectButton {
    NSLog(@"收藏");
}

- (void)tapCommentButton {
    [self beginPushView];
}




#pragma mark 加载模型

- (void)embarkWithDictionary:(NSMutableDictionary *)dic
{
    _modelDic = dic;
    _shareStr = dic[@"description"];
    NSLog(@"dic :%@", dic);
    NSArray *receiveKey = @[@"click", @"share", @"favorCnt", @"commentCnt"];
    
    for (int i = 0; i < 4; i++) {
        
        UILabel *label = _labelArray[i];

        [label setText:[[[dic objectForKey:receiveKey[i]] stringValue] numberToString]];
        NSLog(@"label.text: %@", label.text);
        
    }
    
    self.authorId = dic[@"userId"];
    self.workId = dic[@"id"];

    NSString *name;
    if ([dic[@"userNickName"] length]) {

        name = dic[@"userNickName"];
    } else if([dic[@"userName"] length]) {

        name = dic[@"userName"];
    } else {

        name = @"无用户名";
    }

    [self.nameLabel setText:name];
    
    NSString *headImageUrlString = [dic[@"userAvatarUrl"] changeToUrl];
    NSLog(@"headImageUrlString = %@", [dic[@"userAvatarUrl"] changeToUrl]);
    NSString *videoImageUrlString = [dic[@"picUrl"] changeToUrl];
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:headImageUrlString] placeholderImage:nil];
    [self.videoImage sd_setImageWithURL:[NSURL URLWithString:videoImageUrlString] prune:YES withPercentage:2.0];

    if (_isFollow) {
        [_attentionButton setTitle:@" - 取消 " forState:UIControlStateNormal];
    } else {
        [_attentionButton setTitle:@" + 关注 " forState:UIControlStateNormal];
    }
    
    
}

#pragma mark 获取关注状态

- (void)getFollowStatus
{
    [self.followDelegate getFollowStatusByTargetId:_authorId];
    //    NSLog(@"获取关注状态");
    NSString *notificationNameTrue = [NSString stringWithFormat:@"NotificationId%@Follow",_authorId];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeFollowStatus:)
                                                 name:notificationNameTrue
                                               object:nil];
    
    
}

#pragma  mark  关注回调

- (void)changeFollowStatus:(NSNotification *)notification
{
    NSString *notificationName = [NSString stringWithFormat:@"NotificationId%@Follow", _authorId];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notificationName object:nil];
    
    if ([[notification.userInfo objectForKey:@"result"] boolValue]) {
        
        NSLog(@"添加关注");
        _isFollow = YES;
        [_attentionButton setTitle:@"- 取消" forState:UIControlStateNormal];
        
    } else {
        
         NSLog(@"取消关注");
        _isFollow = NO;
        [_attentionButton setTitle:@"+ 关注" forState:UIControlStateNormal];
    }
}


#pragma mark  加关注，取消关注

- (void)setAndCancelFollow
{
    if (_isFollow == NO) {
        
        [self.followDelegate setFollowWithTargetId:_authorId];
    }
    
    if (_isFollow == YES) {
        [self.followDelegate cancelFollowWithTargetId:_authorId andNotification:YES];
        
    }
    
    NSString *notificationName = [NSString stringWithFormat:@"NotificationId%@Follow",_authorId];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeFollowStatus:)
                                                 name:notificationName
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(LoginPlease) name:@"NotificationUserError"
                                               object:nil];
    
}


#pragma mark 获取收藏状态

- (void)getFavorStatus
{
    NSString *typeid = [NSString stringWithFormat:@"%i", _typeId];
    [self.favorDelegate getFaovrStatusByTypeid:typeid TargetId:_workId];
    
    NSLog(@"获取收藏状态");
    
    NSString *notificationName = [NSString stringWithFormat:@"NotificationId%@Favor",  _workId];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeFavorStatus:)
                                                 name:notificationName
                                               object:nil];
   }

#pragma mark 收藏回调

- (void)changeFavorStatus:(NSNotification *)notification
{
    NSLog(@"dic: %@", notification.userInfo);
    NSString *notificationName = [NSString stringWithFormat:@"NotificationId%@Favor", _workId];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:notificationName
                                                  object:nil];
    if ([[notification.userInfo objectForKey:@"result"] boolValue]) {
        [self buttonDoFavor];
    } else {
        [self buttonCancelFavor];
    }
    
}


#pragma mark 添加/取消 收藏

- (void)setAndCancelFavor
{
    if (_isFavor == NO) {
        
        [self.favorDelegate setFavorWithTypeid:_typeId TargetId:_workId];
        
    }
    
    if (_isFavor == YES) {
        [self.favorDelegate cancelFavorWithTypeid:_typeId TargetId:_workId];
        
    }
    NSString *notificationName = [NSString stringWithFormat:@"NotificationId%@Favor",  _workId];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeFavorStatus:)
                                                 name:notificationName
                                               object:nil];

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(LoginPlease) name:@"NotificationUserError"
                                               object:nil];
    
    
}

#pragma mark 设置收藏、取消收藏

- (void)buttonDoFavor
{
    NSLog(@"收藏");
    [_collectButton setTitle:@"    已收藏" forState:UIControlStateNormal];
    [_collectImageView setImage:[UIImage imageNamed:@"collected.png"]];
    
    NSString *collectNumberStr = _collectNumberLabel.text;
    
    if (!_favorMaxNumber) {

        _favorMaxNumber = [collectNumberStr intValue];
        _favorMinNumber = [collectNumberStr intValue] - 1;
    }

    
    
    [_collectNumberLabel setText:[[NSString stringWithFormat:@"%i", _favorMaxNumber] numberToString]];
    [_collectNumberLabel setFrame:CGRectMake(50, 0, 25, BUTTOMVIEWHEIGHT)];
    
    _isFavor = YES;
}

- (void)buttonCancelFavor
{
    NSLog(@"取消收藏");
    [_collectButton setTitle:@"    收藏" forState:UIControlStateNormal];
    [_collectImageView setImage:[UIImage imageNamed:@"collect"]];
    
    NSString *collectNumberStr = _collectNumberLabel.text;
    
    if (!_favorMaxNumber) {
        _favorMaxNumber = [collectNumberStr intValue] + 1;
        _favorMinNumber = [collectNumberStr intValue];

    }
    
    [_collectNumberLabel setText:[[NSString stringWithFormat:@"%i", _favorMinNumber] numberToString]];
    [_collectNumberLabel setFrame:CGRectMake(40, 0, 25, BUTTOMVIEWHEIGHT)];
    
    _isFavor = NO;
}

#pragma mark 推出界面

- (void)beginPushView
{
    
    NSMutableDictionary *objectDic = [[NSMutableDictionary alloc] init];
    
    if (_pushType == 1) {                                               //推出视频详情页
        
        NSString *favor = @"0";
        NSString *follow = @"0";
        if (_isFollow) {
            
            follow = @"1";
        }
        if (_isFavor) {
            
            favor = @"1";
        }
        NSString *tinyTagStr = [NSString stringWithFormat:@"%i", _tinyTag];
        NSString *category = [NSString stringWithFormat:@"%i", _categoryIndex];
        
        objectDic[@"category"] = category;
        objectDic[@"favor"] = favor;
        objectDic[@"follow"] = follow;
        objectDic[@"tinyTag"] = tinyTagStr;

        [objectDic setValue:_modelDic forKey:@"modelDic"];
        [objectDic setValue:self forKey:@"viewObject"];

    } else if (_pushType == 2) {

        [objectDic setValue:_modelDic[@"videoUrl"] forKey:@"videoUrl"]; // 播放视频
        
    } else {
        
        NSLog(@"艺术品图片放大");

    }
    [self.pushDelegate beginPushViewWithDic:objectDic];
    //展览页中则推出详情页
}




- (void)tapHead
{
    NSLog(@"tap head");
    [self.pushDelegate pushAuthorDescriptionWitDic:_modelDic];
    NSLog(@"modelDic: %@", _modelDic);
}



#pragma mark 弹出登录界面

- (void)LoginPlease
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationUserError" object:nil];
    [self.loginDelegate pushLoginCurtain];
    
}

#pragma mark 浏览数代理回调

- (void) setTheSkimNumber:(NSString *)numberStr
{
    [_skimNumberLabel setText:numberStr];
}

- (void)setTheCommentNumber:(NSString *)commentStr {

    [_commentNumberLabel setText:commentStr];
}


#pragma mark - 分享文章

- (void)shareVideo:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(justShare:)
                                                 name:@"NotificationUrl"
                                               object:nil];
    
    
    [self.shareDelegate getShareUrlWithTypeid:1 TargetId:_workId];
    NSLog(@"开始分享");
    
}



- (void)justShare:(NSNotification *)notification {
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationUrl" object:nil];
    NSString *url = [notification.userInfo objectForKey:@"shareUrl"];
    
    NSString *resultString = [_modelDic objectForKey:@"description"];
    NSString *shareImageUrl = [[_modelDic objectForKey:@"picUrl"] changeToUrl];
    NSLog(@"receive notification");
    //构造分享内容
    if ([_shareStr length] > 50) {

        _shareStr = [_shareStr substringToIndex:50];
    }

    id<ISSContent> publishContent = [ShareSDK content:resultString
                                       defaultContent:@"测试一下"
                                                image:[ShareSDK imageWithUrl:shareImageUrl]
                                                title:[_modelDic objectForKey:@"title"]
                                                  url:url
                                          description:_shareStr
                                            mediaType:SSPublishContentMediaTypeNews];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    //    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                    {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                     [SVProgressHUD showSuccessWithStatus:@"分享成功" maskType:SVProgressHUDMaskTypeBlack];
                                     [self.shareDelegate addShareByType:self.typeId workId:_workId];
                                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addShare:) name:@"NotificationAddShare" object:nil];

                                    }
                                else if (state == SSResponseStateFail)
                                    {
                                        NSLog(@"错误:%@", [error errorDescription]);
                                         NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                    }
                            }];
    
}

- (void)addShare:(NSNotification *)notification {

    NSNumber *shareNumber = notification.userInfo[@"share"];
    self.shareNumberLabel.text = [shareNumber stringValue];
    if (self.typeId == 1) {
        [ForthonDataContainer sharedStore].videosDic[_categoryIndex - 1][_tinyTag][@"share"] = shareNumber;

    } else if (self.typeId == 2) {

        [ForthonDataContainer sharedStore].artDescriptionDic[_workId][@"share"] = shareNumber;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationAddShare" object:nil];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

//    NSLog(@"touch the videoCell");
    if ([self.textFieldDelegate performSelector:@selector(endInput)]) {

        [self.textFieldDelegate endInput];
    }
}

@end
