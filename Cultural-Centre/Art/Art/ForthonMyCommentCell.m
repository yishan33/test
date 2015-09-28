//
//  ForthonMyCommentCell.m
//  Art
//
//  Created by Liu fushan on 15/7/3.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "ForthonMyCommentCell.h"
#import "ForthonDataSpider.h"
#import "ForthonDataContainer.h"
#import "UIImageView+WebCache.h"
#import "NSString+regular.h"
#import "NSString+imageUrlString.h"

@interface ForthonMyCommentCell ()

@property (nonatomic, strong) NSString *keyPath;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *targetId;
@property (nonatomic, strong) NSDictionary *workDic;


@property (nonatomic, strong) UIImageView *pictureView;
@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *replyLabel;
@property (nonatomic, strong) UIButton *replyButton;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentNameLabel;
@property (nonatomic, strong) UILabel *contentDescriptionLabel;

@property (nonatomic, strong) UIView *middleView;
@property (nonatomic, strong) UIButton *bottomButton;
@property (nonatomic, strong) UIView *backView;

@end

@implementation ForthonMyCommentCell

-(void)getLable{
    NSLog(@"_contentNameLabel = %@",_contentNameLabel.text);
}


- (void)loadView {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _backView = [[UIView alloc] init];
    [self addSubview:_backView];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, TOPINTERVAL, TOPVIEWWIDTH, TOPVIEWHEIGHT)];
//    [topView setBackgroundColor:AppColor];
    [_backView addSubview:topView];
    
    _headImage = [[UIImageView alloc] initWithFrame:CGRectMake(SIDEINTERVAL, 0, HEADIMAGESIDE, HEADIMAGESIDE)];
    [_headImage.layer setCornerRadius:HEADIMAGESIDE / 2];
    [_headImage.layer setBorderColor:AppColor.CGColor];
    [_headImage.layer setBorderWidth:2.0];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushAuthorView)];
    [_headImage addGestureRecognizer:tap];
    _headImage.clipsToBounds = YES;
    _headImage.userInteractionEnabled = YES;
//       [_headImage setBackgroundColor:[UIColor blackColor]];
    [topView addSubview:_headImage];
    topView.userInteractionEnabled = YES;
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIDEINTERVAL + HEADIMAGESIDE + I_N_INTERVAL, N_TOP_INTERVAL, NAMELABELWIDTH, NAMELABELHEIGHT)];
//    [_nameLabel setTextColor:[UIColor blackColor]];
    [topView addSubview:_nameLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIDEINTERVAL + HEADIMAGESIDE + I_N_INTERVAL, N_TOP_INTERVAL + NAMELABELHEIGHT + N_T_INTERVAL, TIMELABELWIDTH , TIMELABELHEIGHT)];
    [_timeLabel setTextColor:[UIColor grayColor]];
    [_timeLabel setFont:[UIFont systemFontOfSize:12.0]];
//       [_timeLabel setTextColor:[UIColor blackColor]];
    [topView addSubview:_timeLabel];
    
    _middleView = [[UIView alloc] init];
//    [_middleView setBackgroundColor:[UIColor greenColor]];
    [_backView addSubview:_middleView];
    
    _replyLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIDEINTERVAL, 0, REPLYLABELWIDTH, REPLYLABELHEIGHT)];
    [_replyLabel setNumberOfLines:10];
    [_replyLabel setFont:[UIFont systemFontOfSize:14.0]];
//    [_replyLabel setTextColor:[UIColor blackColor]];
    [_middleView addSubview:_replyLabel];
    
    _replyButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - SIDEINTERVAL - REPLYBUTTONWIDTH, 0, REPLYBUTTONWIDTH, REPLYBUTTONHEIGHT)];
    _replyButton.layer.borderWidth = 1.0;
    _replyButton.layer.borderColor = GrayColor.CGColor;
    [_replyButton setTitle:@"回复" forState:UIControlStateNormal];
    _replyButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_replyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_replyButton addTarget:self action:@selector(pushDescriptionView:) forControlEvents:UIControlEventTouchUpInside];
    [_middleView addSubview:_replyButton];
    
    _bottomButton = [[UIButton alloc] init ];
    [_bottomButton setBackgroundColor:GrayColor];
    [_bottomButton addTarget:self action:@selector(pushDescriptionView:) forControlEvents:UIControlEventTouchUpInside];
    
    
//    [_bottomButton setBackgroundImage:[UIImage im] forState:<#(UIControlState)#>
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushDescriptionView)];
//    [_bottomButton addGestureRecognizer:tap];
    [_backView addSubview:_bottomButton];
    
    _pictureView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, PICTUREWIDTH , PICTUREHEIGHT)];
    [_bottomButton addSubview:_pictureView];
    
    _contentNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(PICTUREWIDTH + P_N_INTERVAL, N_INTERVAL * 2, REPLYCONTENTNAMELABELWIDTH, REPLYCONTENTNAMELABELHEIGHT)];
    _contentNameLabel.font = [UIFont systemFontOfSize:14.0];
    [_contentNameLabel setText:@"张三"];
    [_bottomButton addSubview:_contentNameLabel];
    
    _contentDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 + PICTUREWIDTH + P_N_INTERVAL, N_INTERVAL * 4 + REPLYCONTENTNAMELABELHEIGHT, REPLYDESCRIPTIONWIDTH,  REPLYDESCRIPTIONHEIGHT)];
    [_contentDescriptionLabel setFont:[UIFont systemFontOfSize:12.0]];
    [_contentDescriptionLabel setTextColor:[UIColor grayColor]];
    [_contentDescriptionLabel setText:@"麻阳写生"];
//    [_contentDescriptionLabel setTextColor:[UIColor blackColor]];
    [_bottomButton addSubview:_contentDescriptionLabel];
    
    
    
}


- (void)embarkWithData:(NSDictionary *)modelDic
{
    self.delegate = [ForthonDataSpider sharedStore];
    self.readDelegate = [ForthonDataSpider sharedStore];

    
    NSDictionary *dic = [modelDic objectForKey:@"comment"];
    NSDictionary *contentDic = [modelDic objectForKey:@"obj"];
    
    if (![[dic objectForKey:@"isRead"] boolValue]) {
        
        [self.readDelegate setCommentStatusRead:[dic objectForKey:@"id"]];
    }

    
    NSString *createTime = [dic objectForKey:@"createTime"];
    NSString *name;
    if ([dic[@"userNickName"] boolValue]) {

        name = dic[@"userNickName"];
    } else {

        name = dic[@"userName"];
    }
    NSString *content = [dic objectForKey:@"content"];
    if ([dic[@"userAvatarUrl"] length]) {

        NSString *headImageUrlBody = [dic objectForKey:@"userAvatarUrl"];
        NSString *headImageUrl = [headImageUrlBody changeToUrl];
        [_headImage sd_setImageWithURL:[NSURL URLWithString:headImageUrl] placeholderImage:nil];
    } else {

        _headImage.image = [UIImage imageNamed:@"profile_avatar_default.png"];
    }

    _bottomButton.tag = [dic[@"typeId"] intValue];
    _replyButton.tag = [dic[@"typeId"] intValue];
//    NSLog(@"integerValue: %i", (int)_bottomButton.tag);
    
    _workDic = contentDic;
    NSString *pictureImageUrlBody;
    NSString *pictureImageUrl;
    if ([dic[@"typeId"] intValue] == 1) {

        pictureImageUrlBody = contentDic[@"picUrl"];
        pictureImageUrl = [pictureImageUrlBody changeToUrl];
    } else if ([dic[@"typeId"] intValue] == 3) {

        pictureImageUrl = [NSString imageUrlWithHTMLData:contentDic[@"content"]];
        NSLog(@"pageImageUrl: %@", pictureImageUrl);
    }


    NSString *contentName;

    if ([contentDic[@"userNickName"] boolValue]) {

        contentName = contentDic[@"userNickName"];
    } else {

        contentName = contentDic[@"userName"];
    }

    NSLog(@"contentName: %@", [contentDic objectForKey:@"userNickName"]);
    NSString *contentDescription = [contentDic objectForKey:@"title"];
    

    [_nameLabel setText:name];
    [_replyLabel setText:content];
    [_timeLabel setText:createTime];
    
    [_pictureView sd_setImageWithURL:[NSURL URLWithString:pictureImageUrl] prune:YES withPercentage:23.0 / 20.0];
    [_contentNameLabel setText:contentName];
    [_contentDescriptionLabel setText:contentDescription];
    [_contentDescriptionLabel setNumberOfLines:2];


    
    CGSize size = CGSizeMake(REPLYLABELWIDTH, 1000);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:_replyLabel.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize replyLabelSize = [_replyLabel.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    NSLog(@"contentLabelSize: height: %f",  replyLabelSize.height);
    _replyLabel.frame = CGRectMake(SIDEINTERVAL, 0, replyLabelSize.width, replyLabelSize.height);
    [_middleView setFrame:CGRectMake(0, TOPINTERVAL + TOPVIEWHEIGHT + T_M_INTERVAL, MIDDLEVIEWWIDTH, MIDDLEVIEWHEIGHT)];
    
    [_bottomButton setFrame:CGRectMake(SIDEINTERVAL, BACKVIEWHEIGHT - BUTTOMINTERVAL - BUTTOMVIEWHEIGTH, BUTTOMVIEWWIDTH, BUTTOMVIEWHEIGTH)];
    
    [_backView setFrame:CGRectMake(0, 0, BACKVIEWWIDTH, BACKVIEWHEIGHT)];
    NSLog(@"backView:%f", BACKVIEWHEIGHT);
//    if (type.intValue == 3) {
    
//        _keyPath = [NSString stringWithFormat:@"pageDic.id%@", _targetId];
//        
//        [self.delegate getPageById:_targetId];
////        NSLog(@"keyPath: %@", _keyPath);
//        [[ForthonDataContainer sharedStore] addObserver:self forKeyPath:_keyPath options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
//    }
    
    
//    switch (type.intValue) {
//        case 1:
////            [titleLabel setText:[tinyDic objectForKey:@"title"]];
////            [descriptionLabel setText:[tinyDic objectForKey:@"description"]];
//            pictureUrlStringBody = [tinyDic objectForKey:@"picUrl"];
//            break;
//        case 2:
//            [titleLabel setText:[tinyDic objectForKey:@"title"]];
//            break;
//        case 3:
//            [titleLabel setText:[tinyDic objectForKey:@"title"]];
//            NSString *responseString = [tinyDic objectForKey:@"content"];
//            
//            NSString *imageRegular = @"/up\\S+png";
//            imageUrlStringBody = [responseString substringArrayByRegular:imageRegular][0];
//            
//            NSString *regstr1 = @"\\d*[\u4e00-\u9fa5]+[^<]+";
//            NSArray *responseTextArray = [responseString substringArrayByRegular:regstr1];
//            NSMutableString *resultString = [[NSMutableString alloc] init];
//            
//            for (int j = 0; j < responseTextArray.count; j++) {
//                
//                [resultString appendString:responseTextArray[j]];
//            }
//            [descriptionLabel setText:resultString];
//            break;
//            
//    }
//    imageUrlString = [NSString stringWithFormat:@"%@%@", HOST, imageUrlStringBody];

    
    
    
}

- (void)pushDescriptionView:(UIButton *)sender {
    
    if ((int)sender.tag == 1) {
        
        NSMutableDictionary *objecDic = [NSMutableDictionary new];
        [objecDic setObject:@"0" forKey:@"favor"];
        [objecDic setObject:@"0" forKey:@"follow"];
        [objecDic setObject:_workDic forKey:@"modelDic"];
        NSLog(@"put video description");
        [self.pushDelegate pushDescriptionViewWithTypeId:(int)sender.tag workDic:objecDic];
    } else {
    
        [self.pushDelegate pushDescriptionViewWithTypeId:(int)sender.tag workDic:_workDic];
        NSLog(@"tap the bottomView");
    }
}

- (void)pushAuthorView {

    [self.pushDelegate pushDescriptionViewWithTypeId:4 workDic:_workDic];
}

//- (void)pushView {
//
//    NSLog(@"push descriptionView");
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
