//
//  ForthonCommentArtCell.m
//  Login
//
//  Created by Liu fushan on 15/5/21.
//  Copyright (c) 2015年 culturalCenter. All rights reserved.
//

#import "ForthonCommentArtCell.h"
#import "commentArtMeasurement.h"
#import "UIImageView+WebCache.h"
#import "NSString+regular.h"
#import "NSString+imageUrlString.h"
#import "ForthonDataSpider.h"
#import "NSString+packageNumber.h"

@interface ForthonCommentArtCell ()

@property int favorMaxNumber;
@property int favorMinNumber;

@property BOOL isFavor;
@property (strong, nonatomic) NSString *workId;
@property (strong, nonatomic) NSMutableDictionary *dic;

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *pageImageView;
@property (strong, nonatomic) UILabel *descriptionLabel;


@property (strong, nonatomic) UILabel *collectNumberLabel;
@property (strong, nonatomic) UIButton *collectButton;
@property (strong, nonatomic) UIImageView *collectImageView;

@end

@implementation ForthonCommentArtCell

- (void)loadView
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BACKVIEWWIDTH, BACKVIEWHEIGHT)];
    [backView setBackgroundColor:[UIColor whiteColor]];
    
    UIView *frontView = [[UIView alloc] initWithFrame:CGRectMake(INTERVAL, TOPINTERVAL, FRONTVIEWWIDTH, FRONTVIEWHEIGHT)];
    [frontView setBackgroundColor:[UIColor whiteColor]];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, TITLELABELWIDTH, TITLELABELHEIGHT)];
    [_titleLabel setTextColor:[UIColor blackColor]];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel setFont:[UIFont systemFontOfSize:14.0]];
//    [titleLabel setBackgroundColor:[UIColor redColor]];
    
    _pageImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, TITLELABELHEIGHT, IMAGEVIEWWIDTH, IMAGEVIEWHEIGHT)];
//    [_pageImageView setImage:[UIImage imageNamed:@"spiderMan.jpg"]];
//    [imageView setBackgroundColor:[UIColor yellowColor]];
    
    _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(IMAGEVIEWWIDTH + TEXTINTERVAL, TITLELABELHEIGHT, TEXTVIEWWIDTH, TEXTVIEWHEIGHT)];
    [_descriptionLabel setNumberOfLines:4];
    [_descriptionLabel setFont:[UIFont systemFontOfSize:12.0]];
//    [_descriptionLabel setText:@"你是在父视图上添加了点击的手势，是吗？ 你可以在触发手势的方法里添加一个区域的判断，如果点击区域正好是子视图的区域，则过滤掉，不处理此时的手势，如果点击的区域没有被子视图覆盖则，处理手势的事件。具体的代码如下 "];
    

    [_descriptionLabel setTextAlignment:NSTextAlignmentJustified];
    [_descriptionLabel setTextColor:[UIColor grayColor]];



    [frontView addSubview:_descriptionLabel];
    [frontView addSubview:_titleLabel];
    [frontView addSubview:_pageImageView];

    UIButton *commentButton = [self createButtonWithTitle:@"评论" imageName:@"comment.png" number:@"21"];
    UIButton *favorButton = [self createButtonWithTitle:@"收藏" imageName:@"collect.png" number:@"1111"];
    [commentButton setFrame:CGRectMake(IMAGEVIEWWIDTH + INTERVAL / 2, TITLELABELHEIGHT + TEXTVIEWHEIGHT + 10, 50, 20)];
    [favorButton setFrame:CGRectMake(WIDTH - 50 - 2 * INTERVAL - INTERVAL / 2, TITLELABELHEIGHT + TEXTVIEWHEIGHT + 10, 50, 20)];

    [commentButton addTarget:self action:@selector(touchComment) forControlEvents:UIControlEventTouchUpInside];
    [favorButton addTarget:self action:@selector(setAndCancelFavor) forControlEvents:UIControlEventTouchUpInside];

    [frontView addSubview:commentButton];
    [frontView addSubview:favorButton];
    [backView addSubview:frontView];

    self.favorDelegate = [ForthonDataSpider sharedStore];
    [self addSubview:backView];

}

- (void)loadDataWithDic:(NSMutableDictionary *)dic {

    _workId = dic[@"id"];
    _dic = dic;
    NSString *pageImageUrlString = [NSString imageUrlWithHTMLData:dic[@"content"]];
    [_pageImageView sd_setImageWithURL:[NSURL URLWithString:pageImageUrlString]];
    [_titleLabel setText:dic[@"title"]];
    [_descriptionLabel setText:[NSString stringWithHTMLData:dic[@"content"]]];
    NSNumber *commentNumber = dic[@"commentCnt"];
    NSNumber *favorNumber = dic[@"favorCnt"];
    [_commentNumberLabel setText:[commentNumber stringValue]];
    [_collectNumberLabel setText:[favorNumber stringValue]];
    [self getFavorStatus];

}

- (UIButton *)createButtonWithTitle:(NSString *)title imageName:(NSString *)imageStr number:(NSString *)number
{
    UIButton *button = [[UIButton alloc] init];
    [button setTitleColor:AppColor forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:12.0]];

    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 10, 10)];
    [icon setImage:[UIImage imageNamed:imageStr]];

    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 30, 10)];
    [numberLabel setText:number];
    numberLabel.textColor = [UIColor grayColor];
    [numberLabel setFont:[UIFont systemFontOfSize:12.0]];

    if ([title isEqualToString:@"评论"]) {

        _commentNumberLabel = numberLabel;

    } else {

        _collectImageView = icon;
        _collectNumberLabel = numberLabel;
        _collectButton = button;
    }

    [button addSubview:icon];
    [button addSubview:numberLabel];
//    [button setBackgroundColor:[UIColor purpleColor]];
    return button;
}

- (void)touchComment {

    NSLog(@"touchComment");
    _dic[@"tinyTag"] = @(_tinyTag);
    [self.pushDelegate pushPageViewByDic:_dic];
}


#pragma mark 获取收藏状态

- (void)getFavorStatus
{

    [self.favorDelegate getFaovrStatusByTypeid:@"3" TargetId:_workId];

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
    if ([notification.userInfo[@"result"] boolValue]) {
        [self buttonDoFavor];
    } else {
        [self buttonCancelFavor];
    }

}


#pragma mark 添加/取消 收藏

- (void)setAndCancelFavor
{

    NSLog(@"touch the favorButton!!!!!");
    if (!_isFavor) {

        [self.favorDelegate setFavorWithTypeid:3 TargetId:_workId];

    }

    if (_isFavor) {
        [self.favorDelegate cancelFavorWithTypeid:3 TargetId:_workId];

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
    [_collectButton setTitle:@"  已收藏" forState:UIControlStateNormal];
    [_collectImageView setImage:[UIImage imageNamed:@"collected.png"]];

    NSString *collectNumberStr = _collectNumberLabel.text;

    if (!_favorMaxNumber) {

        _favorMaxNumber = [collectNumberStr intValue];
        _favorMinNumber = [collectNumberStr intValue] - 1;
    }

    [_collectNumberLabel setText:[[NSString stringWithFormat:@"%i", _favorMaxNumber] numberToString]];
    [_collectNumberLabel setFrame:CGRectMake(50, 5, 30, 10)];

    _isFavor = YES;
}

- (void)buttonCancelFavor
{
    NSLog(@"取消收藏");
    [_collectButton setTitle:@"收藏" forState:UIControlStateNormal];
    [_collectImageView setImage:[UIImage imageNamed:@"collect"]];

    NSString *collectNumberStr = _collectNumberLabel.text;

    if (!_favorMaxNumber) {
        _favorMaxNumber = [collectNumberStr intValue] + 1;
        _favorMinNumber = [collectNumberStr intValue];

    }

    [_collectNumberLabel setText:[[NSString stringWithFormat:@"%i", _favorMinNumber] numberToString]];
    [_collectNumberLabel setFrame:CGRectMake(40, 5, 30, 10)];

    _isFavor = NO;
}


#pragma mark 弹出登录界面

- (void)LoginPlease
{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationUserError" object:nil];
    [self.loginDelegate pushLoginCurtain];

}
@end
