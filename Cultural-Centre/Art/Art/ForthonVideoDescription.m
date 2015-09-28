//
//  ForthonVideoDescription.m
//  Art
//
//  Created by Liu fushan on 15/7/6.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "ForthonVideoDescription.h"
#import "ForthonVideoCell.h"
#import "InputTextFieldMeasurement.h"
#import "commentCell.h"
#import "ForthonDataSpider.h"
#import "ForthonAllComments.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "LoginCurtain.h"
#import <ShareSDK/ShareSDK.h>
#import <QZoneConnection/QZoneConnection.h>
#import "NSString+packageNumber.h"
#import "ForthonVideoCell.h"
#import "NSString+imageUrlString.h"
#import "UICommon.h"
#import "ForthonAuthorDescription.h"
#import "SVProgressHUD.h"
#import "NetErrorView.h"


#define VIDEOINTERVAL 15 * HEIGHTPERCENTAGE
#define VIDEOSIDEINTERVAL 10 * WIDTHPERCENTAGE

#define VIDEOMIDDLEINTERVAL 232 * HEIGHTPERCENTAGE

#define VIDEOMIDDLEHEIGHT 75 * HEIGHTPERCENTAGE

#define VIDEOCONTENTLABELHEIGHT 20 * HEIGHTPERCENTAGE

#define COMMUNICATELABELHEIDHT 30 * HEIGHTPERCENTAGE
#define COMMUNICATELABELWIDTH 220 * WIDTHPERCENTAGE

#define CHECKMOREBUTTONWIDTH 60 * WIDTHPERCENTAGE
#define CHECKMOREBUTTONHEIGHT 25 * HEIGHTPERCENTAGE

#define BUTTOMBACKVIEWWIDTH WIDTH + 2
#define BUTTOMBACKVIEWHEIGHT 48 * HEIGHTPERCENTAGE

@interface ForthonVideoDescription () <LoginAndRefresh, UIScrollViewDelegate>

@property BOOL isFirstLoad;
@property CGFloat cellTotalHeight;
@property (nonatomic, strong) NSString *workId;
@property (nonatomic, strong) NSString *commentFartherId;
@property (nonatomic, strong) NSString *videoImageUrlStr;
@property int commentNumber;

@property (nonatomic, strong) NSArray *commentArray;
@property (nonatomic, strong) NSMutableArray *cellHeightArray;


@property (nonatomic, strong) UILabel *communicateLabel;
@property (nonatomic, strong) UIView *buttomView;
@property (nonatomic, strong) UITextField *commentText;
@property (nonatomic, strong) UITableView *commentTable;
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) ForthonVideoCell *videoCell;

@property (nonatomic, weak) id <GetVideoCommentDelegate> delegate;
@property (nonatomic, weak) id<ShareDelegate> shareDelegate;
@property (nonatomic, weak) id<Login> loginDelegate;

@property (nonatomic, strong) NetErrorView *netErrorView;

@end

@implementation ForthonVideoDescription

- (void)viewDidLoad {
    [super viewDidLoad];

    UICommon *commonUI = [[UICommon alloc] init];
    NSString *videoTitle = [_videoModelDic[@"modelDic"] objectForKey:@"title"];
    UILabel *navTitle = (UILabel *) [commonUI navTitle:videoTitle];
//    navTitle.font = [UIFont boldSystemFontOfSize:<#(CGFloat)fontSize#>]
    self.navigationItem.titleView = navTitle;
    self.navigationItem.backBarButtonItem = HiddenBack;

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.delegate = [ForthonDataSpider sharedStore];//设置代理


    _isFirstLoad = YES;
    [SVProgressHUD showWithStatus:@"加载中..."];
    _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, self.view.frame.size.height - 64 - BACKVIEWHEIGHT)];
    [self.view addSubview:_scroll];
    _scroll.delegate = self;
    
    
    _videoCell = [[ForthonVideoCell alloc] init];

    [_videoCell setPushDelegate:self];//设置播放视频代理
    [_videoCell setLoginDelegate:self];
    [_videoCell setTextFieldDelegate:self];
    [_videoCell setFrame:(CGRectMake(0, 0, WIDTH, VIDEOMIDDLEINTERVAL))];
    NSDictionary *dic = _videoModelDic;
    
    _commentNumber = [[dic[@"modelDic"] objectForKey:@"commentCnt"] intValue];
    _workId = [dic[@"modelDic"] objectForKey:@"id"];
    
    
    NSString *favorStr = dic[@"favor"];
    NSString *followStr = dic[@"follow"];
    
    if ([favorStr boolValue]) {
        _videoCell.isFavor = YES;
    } else {
        [_videoCell getFavorStatus];
    }
    
    if ([followStr boolValue]) {
        _videoCell.isFollow = YES;
    }
    _videoCell.isPlay = YES;
    [_videoCell loadView];
    [_videoCell embarkWithDictionary:dic[@"modelDic"]];
    
    if (_videoCell.isFollow == NO) {
        
        [_videoCell getFollowStatus];
    }

    [_videoCell setPushType:2];
    _videoCell.typeId = 1;
    _videoCell.categoryIndex = [dic[@"category"] intValue];
    _videoCell.tinyTag = [[dic objectForKey:@"tinyTag"] intValue];

    [self setValue:[[_videoModelDic[@"modelDic"] objectForKey:@"click"] stringValue] forKey:@"skimNumberStr"];
    _videoCell.videoImage.userInteractionEnabled = YES;
    _videoCell.headImageView.userInteractionEnabled = YES;
    [_videoCell getFavorStatus];
    [_scroll addSubview:_videoCell];

   
    
    UIView *middleView = [[UIView alloc] initWithFrame:CGRectMake(0, VIDEOMIDDLEINTERVAL + 10, WIDTH, VIDEOMIDDLEHEIGHT)];
//    [middleView setBackgroundColor:[UIColor yellowColor]];
   

    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(VIDEOSIDEINTERVAL, VIDEOINTERVAL, WIDTH, VIDEOCONTENTLABELHEIGHT)];
    NSString *contentText = [_videoModelDic[@"modelDic"] objectForKey:@"description"];
    _videoCell.shareStr = contentText;
    [contentLabel setText:contentText];
    contentLabel.font = [UIFont systemFontOfSize:16.0];
//    contentLabel.backgroundColor = AppColor;
    CGSize size = [self labelAutoCalculateRectWith:contentText FontSize:16.0 MaxSize:CGSizeMake(WIDTH - VIDEOSIDEINTERVAL * 2, 1000)];
    [contentLabel setFrame:CGRectMake(VIDEOSIDEINTERVAL, VIDEOINTERVAL, size.width, size.height)];
    [middleView addSubview:contentLabel];

    _communicateLabel = [[UILabel alloc] initWithFrame:CGRectMake(VIDEOSIDEINTERVAL, VIDEOMIDDLEHEIGHT - COMMUNICATELABELHEIDHT , COMMUNICATELABELWIDTH, COMMUNICATELABELHEIDHT)];
    [_communicateLabel setText:[NSString stringWithFormat:@"一起交流(%i)", _commentNumber]];
    [middleView addSubview:_communicateLabel];
    
    UIButton *checkMoreButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - VIDEOSIDEINTERVAL - CHECKMOREBUTTONWIDTH, VIDEOMIDDLEHEIGHT - COMMUNICATELABELHEIDHT, CHECKMOREBUTTONWIDTH, CHECKMOREBUTTONHEIGHT)];
    [checkMoreButton setTitle:@"查看全部" forState:UIControlStateNormal];
    [checkMoreButton setTitleColor:AppColor forState:UIControlStateNormal];
    [checkMoreButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [checkMoreButton addTarget:self action:@selector(checkMoreComments) forControlEvents:UIControlEventTouchUpInside];
    [middleView addSubview:checkMoreButton];

    _commentTable = [[UITableView alloc] init];
    NSLog(@"frame.y: %f", VIDEOMIDDLEHEIGHT + VIDEOMIDDLEINTERVAL);

    [_scroll addSubview:middleView];
    [_scroll addSubview:_commentTable];

    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 1)];
    [topLine setBackgroundColor:[UIColor grayColor]];
    _buttomView = [[UIView alloc] initWithFrame:CGRectMake(-1, self.view.frame.size.height - BUTTOMBACKVIEWHEIGHT, BUTTOMBACKVIEWWIDTH, BUTTOMBACKVIEWHEIGHT)];
    //    [_buttomView.layer setBorderWidth:1.0];
    //    [_buttomView.layer setBorderColor:[UIColor grayColor].CGColor];
    [_buttomView setBackgroundColor:[UIColor whiteColor]];
    
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(L_INTERVAL - LINEINTERVAL, TEXTHEIGHT  - LINEHEIGHT, LINEWIDTH, LINEHEIGHT)];
    [leftLine setBackgroundColor:[UIColor grayColor]];
    
    
    _commentText = [[UITextField alloc] initWithFrame:CGRectMake(L_INTERVAL, 0, TEXTWIDTH, TEXTHEIGHT)];
    [_commentText setPlaceholder:@"我想说两句"];
    [_commentText setDelegate:self];
    [_commentText setKeyboardType:UIKeyboardTypeDefault];
    
    UIView *buttomLine = [[UIView alloc] initWithFrame:CGRectMake(L_INTERVAL - LINEINTERVAL, TEXTHEIGHT, TEXTWIDTH + 2 * LINEINTERVAL, LINEWIDTH)];
    [buttomLine setBackgroundColor:[UIColor grayColor]];
    
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(L_INTERVAL + TEXTWIDTH + LINEINTERVAL - LINEWIDTH, TEXTHEIGHT - LINEHEIGHT , LINEWIDTH, LINEHEIGHT)];
    [rightLine setBackgroundColor:[UIColor grayColor]];
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - SENDBUTTONSIDE - INTERVALRIGHT / 2, (BACKVIEWHEIGHT - SENDBUTTONSIDE) / 2, SENDBUTTONSIDE, SENDBUTTONSIDE)];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"comment_btn_normal.png"] forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"comment_btn_selected.png"] forState:UIControlStateSelected];
    [sendButton addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
    
    [_buttomView addSubview:topLine];
    [_buttomView addSubview:sendButton];
    [_buttomView addSubview:rightLine];
    [_buttomView addSubview:leftLine];
    [_buttomView addSubview:buttomLine];
    [_buttomView addSubview:_commentText];
    
    [self.view addSubview:_scroll];
    [self.view addSubview:_buttomView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:self action:@selector(shareVideo:)];
    self.loginDelegate = self;
    
    if (![[[ForthonDataContainer sharedStore].commentsDic objectForKey:@"videosComments"] objectForKey:_workId]) {



        [self.delegate getCommentByTypeid:1 targetId:_workId page:1];      //获取评论信息                             
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateComment)
                                                     name:@"NotificationA"
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(showLoadButton)
                                                     name:@"NotificationNetError"
                                                   object:nil];



        NSLog(@"way one");
    } else {
        
        NSLog(@"way two");
        [self updateComment];
    }

    NSLog(@"viewDidLoad");
}

- (void)viewWillDisappear:(BOOL)animated {

    if ([SVProgressHUD isVisible]) {

        [SVProgressHUD dismiss];
    }

}

- (void)viewDidAppear:(BOOL)animated {

    [_commentTable setDataSource:self];
    [_commentTable setDelegate:self];
    if (_isFirstLoad) {

        _isFirstLoad = NO;
        [_commentTable reloadData];
    }

}


#pragma mark TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if ([_commentArray count] < 3) {
        
        return [_commentArray count];
    } else {
        
        return 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = (int)indexPath.row;
    if ([_cellHeightArray count])
        {
            NSLog(@"cell in web : %f", [_cellHeightArray[index] floatValue]);
            return [_cellHeightArray[index] floatValue];
        } else
            return 76;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int index = (int)indexPath.row;
    NSLog(@"index %i", index);

        NSDictionary *dic = _commentArray[index];
    
    static NSString *cellIdentifier = @"cell";
    commentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[commentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell load];
    }

    [cell resetContentLabeWithDic:dic];
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = (int)indexPath.row;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *fName = [[NSString alloc] init];
    NSDictionary *dic = _commentArray[index];
    _commentFartherId = dic[@"id"];
    if ([dic[@"userNickName"] length]) {

        fName = dic[@"userNickName"];
    } else {

        fName = dic[@"userName"];
    }

    [_commentText setPlaceholder:[NSString stringWithFormat:@"回复%@", fName]];
    [_commentText becomeFirstResponder];
    
    
    
}


#pragma mark - 发表评论

- (void)sendComment
{
    NSLog(@"send !");
    NSString *commentString = _commentText.text;
    NSLog(@"comment: %@", commentString);
    [_commentText setText:@""];
    NSLog(@"fatherID is--------------------------\n%@\n", _commentFartherId);
    [_delegate sendCommentsByTypeid:1 targetId:_workId fatherId:_commentFartherId content:commentString];
//    spider中添加发送评论的接口，参数为 作品种类 、Id  和  commentString
//    让spider 把 commentString 发出去
//    添加通知，当服务器添加评论成功，立马刷新出新的评论。
    _commentFartherId = 0;
    
    if ([[[ForthonDataContainer sharedStore] valueForKey:@"appIsLogin"] boolValue]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(addComment)
                                                     name:@"NotificationA"
                                                   object:nil];

    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(LoginPlease) name:@"NotificationUserError"
                                               object:nil];

    
    [self endInput];
    
    
    
}

#pragma mark  查看更多评论

- (void)checkMoreComments {
    
    ForthonAllComments *commentsView = [[ForthonAllComments alloc] init];
    commentsView.workId = _workId;
    commentsView.typeId = 1;
    [self.navigationController pushViewController:commentsView animated:YES];
    
    
}



- (void)loadCellHeight
{
    NSLog(@"loadHeight");
    NSLog(@"diccomment: %@", [[[ForthonDataContainer sharedStore].commentsDic objectForKey:@"videosComments"]objectForKey:_workId]);
    if ([[[[ForthonDataContainer sharedStore].commentsDic objectForKey:@"videosComments"]objectForKey:_workId] count])
        {
        NSLog(@"though spider get data");
        _commentArray = [[[ForthonDataContainer sharedStore].commentsDic objectForKey:@"videosComments"]objectForKey:_workId];
        NSLog(@"commentArray :%@", _commentArray);
        _cellHeightArray = [[NSMutableArray alloc] init];
        NSString *text;
        for (int i = 0; i < 3; i++) {
            if ([_commentArray count] > i) {
                text = [_commentArray[i] objectForKey:@"content"];
                
            } else {
                text = @"";
            }
            //                    NSString *text = ;
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0], NSParagraphStyleAttributeName:paragraphStyle.copy};
            
            CGSize size = CGSizeMake(250 * WIDTHPERCENTAGE, 1000);
            _cellTotalHeight += [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height;
            _cellTotalHeight += HEIGHTNOCONTENT;
            NSNumber *cellHeightNumber = [NSNumber numberWithFloat:[text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height + HEIGHTNOCONTENT];
            NSLog(@"the %i cellNoContent: %f",i, [NSNumber numberWithFloat:[text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height].floatValue);
            [_cellHeightArray addObject:cellHeightNumber];
        }
        
        }
}


#pragma mark 获取评论

- (void)updateComment
{

    if (_netErrorView) {

        [_netErrorView removeFromSuperview];

    }
    if (_buttomView.hidden) {

        _buttomView.hidden = NO;
    }
    [SVProgressHUD showSuccessWithStatus:@"加载成功" maskType:SVProgressHUDMaskTypeBlack];
    _commentArray = [[[ForthonDataContainer sharedStore].commentsDic objectForKey:@"videosComments"]objectForKey:_workId];
    [self loadCellHeight];
    
    [_commentTable setFrame:CGRectMake(0, VIDEOMIDDLEINTERVAL + VIDEOMIDDLEHEIGHT + 10, WIDTH, _cellTotalHeight)];
    [_commentTable reloadData];
    [_scroll setContentSize:CGSizeMake(WIDTH, VIDEOMIDDLEHEIGHT + VIDEOMIDDLEINTERVAL + 10 + _cellTotalHeight)];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"NotificationA"
                                                  object:nil];

}



- (void)addComment
{
    NSLog(@"i receive new comment");
    [SVProgressHUD showSuccessWithStatus:@"评论更新成功"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationA" object:nil];
    _commentArray = [[ForthonDataContainer sharedStore].commentsDic[@"videosComments"] objectForKey:_workId];
    [self loadCellHeight];
    _commentNumber++;
    [_communicateLabel setText:[NSString stringWithFormat:@"一起交流(%i)", _commentNumber]];
    NSString *commentNumber = [NSString stringWithFormat:@"%i", _commentNumber];
    [self.addSkimNumberDelegate setTheCommentNumber:commentNumber];
    _videoCell.commentNumberLabel.text = [commentNumber numberToString];
    if (_videoCell.categoryIndex > 0) {
        int category = _videoCell.categoryIndex;
        int tinyTag = _videoCell.tinyTag;
        [ForthonDataContainer sharedStore].videosDic[category - 1][tinyTag][@"commentCnt"] = @([commentNumber intValue]);
    }
    [_commentTable reloadData];
}


#pragma mark - 移动输入框


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //开始输入时，小视图上移80，加了动画效果，时常0.3 s
    NSLog(@"end input!");
    if (self.view.center.y == self.view.frame.size.height / 2) {
        
        [UIView animateWithDuration:0.3 animations:^{

            [_buttomView setCenter:CGPointMake(_buttomView.center.x, self.view.frame.size.height - BACKVIEWHEIGHT/ 2 - KEYBOARDHEIGHT )];
        }];
        
        
    }
    
}- (void)textFieldDidEndEditing:(UITextField *)textField {

    [self endInput];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endInput];
    
    return YES;
}


- (void)commentReplyWithHeight:(CGFloat)moveHeight
{
    [UIView animateWithDuration:0.3 animations:^{
        
        [self.view setCenter:CGPointMake(self.view.center.x, self.view.frame.size.height / 2 - KEYBOARDHEIGHT + moveHeight)];
        [_buttomView setCenter:CGPointMake(_buttomView.center.x, self.view.frame.size.height - (BACKVIEWHEIGHT / 2) - moveHeight)];
        
    }];
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    [self endInput];
 
}


- (void)endInput
{
    //触碰视图，则输入结束，小视图回到原位
    NSLog(@"tap view");

    [UIView animateWithDuration:0.3 animations:^{
        
        //            [self.view setCenter:CGPointMake(self.view.center.x, HEIGHT / 2)];
        [_buttomView setCenter:CGPointMake(_buttomView.center.x, self.view.frame.size.height - BACKVIEWHEIGHT / 2)];
    }];
    [_commentText resignFirstResponder];
    //    }
    _commentText.placeholder = @"我想说两句";

    
}



#pragma mark - 播放视频


- (void)beginPushViewWithDic:(NSMutableDictionary *)dic
{
    [_videoCell.numberDelegate addSkimNumber:_workId WithCategoryIndex:_videoCell.categoryIndex tinyTag:_videoCell.tinyTag typeId:1];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addOneSkim:)
                                                 name:@"NotificationSkim"
                                               object:nil];
    NSString *urlStr = dic[@"videoUrl"];
    NSLog(@"videoUrl: %@", urlStr);
    MPMoviePlayerViewController *playerViewController =[[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:urlStr]];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [self presentMoviePlayerViewControllerAnimated:playerViewController];

    NSLog(@"push Video");

}

#pragma mark 浏览数+1
- (void)addOneSkim:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationSkim" object:nil];
    NSLog(@"numberDic :%@", notification.userInfo);

    [self setValue:notification.userInfo[@"clickNumber"] forKey:@"skimNumberStr"];
    [_videoCell.skimNumberLabel setText:[notification.userInfo[@"clickNumber"] numberToString]];
    [self.addSkimNumberDelegate setTheSkimNumber:[notification.userInfo[@"clickNumber"] numberToString]];
}





//#pragma mark - 分享文章
//
//- (void)shareVideo:(UIBarButtonItem *)sender
//{
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(justShare:)
//                                                 name:@"NotificationUrl"
//                                               object:nil];
//
//
//    [self.shareDelegate getShareUrlWithTypeid:1 TargetId:_workId];
//    NSLog(@"开始分享");
//
//}
//
//
//
//- (void)justShare:(NSNotification *)notification {
//
//
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationUrl" object:nil];
//    NSString *url = [notification.userInfo objectForKey:@"shareUrl"];
//
//    NSString *resultString = @"123";
//    NSLog(@"receive notification");
//    //构造分享内容
//    id<ISSContent> publishContent = [ShareSDK content:resultString
//                                       defaultContent:@"测试一下"
//                                                image:[ShareSDK imageWithUrl:_videoImageUrlStr]
//                                                title:[[_videoModelDic objectForKey:@"modelDic"] objectForKey:@"title"]
//                                                  url:url
//                                          description:@"这是一条测试信息"
//                                            mediaType:SSPublishContentMediaTypeNews];
//    //创建弹出菜单容器
//    id<ISSContainer> container = [ShareSDK container];
//    //    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
//
//    //弹出分享菜单
//    [ShareSDK showShareActionSheet:container
//                         shareList:nil
//                           content:publishContent
//                     statusBarTips:YES
//                       authOptions:nil
//                      shareOptions:nil
//                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//
//                                if (state == SSResponseStateSuccess)
//                                    {
//                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
//                                    }
//                                else if (state == SSResponseStateFail)
//                                    {
//                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
//                                    }
//                            }];
//
//}


#pragma mark - 弹出登录界面
- (void)LoginPlease
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationUserError" object:nil];
    [self.loginDelegate pushLoginCurtain];
    
}


- (void)pushLoginCurtain
{
    NSLog(@"请登录...");
    LoginCurtain *loginView = [[LoginCurtain alloc] init];
    loginView.refreshDelegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginView];
    [self presentViewController:nav animated:YES completion:nil];
//    [self.navigationController pushViewController:loginView animated:YES];
}


#pragma mark  视屏详情页刷新

- (void)refresh
{
    [_videoCell getFollowStatus];
    [_videoCell getFavorStatus];
}


- (void)pushAuthorDescriptionWitDic:(NSMutableDictionary *)dic {

    NSLog(@"push author description view");

    ForthonAuthorDescription *authorView = [[ForthonAuthorDescription alloc] init];
    authorView.authorDic = dic;
    [self.navigationController pushViewController:authorView animated:YES];

}

#pragma mark - LabelFrame自动适配文字内容

- (CGSize)labelAutoCalculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize

{
    //随内容变换Label长度
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    
    NSDictionary* attributes =@{
                                NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName:paragraphStyle.copy
                                };
    
    CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    
    labelSize.height=ceil(labelSize.height);
    labelSize.width=ceil(labelSize.width);
    return labelSize;
    
}



#pragma mark - 显示重新加载按钮

- (void)showLoadButton {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationNetError" object:nil];

    [SVProgressHUD showErrorWithStatus:@"加载失败" maskType:SVProgressHUDMaskTypeBlack];
    if (!_netErrorView) {

        _netErrorView = [[NetErrorView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, self.view.frame.size.height - 64)];
        [_netErrorView.loadButton addTarget:self action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];

    }
    _buttomView.hidden = YES;
    [self.view addSubview:_netErrorView];
}

- (void)reload {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationNetError" object:nil];

    [SVProgressHUD showWithStatus:@"加载中..."];

    [self.delegate getCommentByTypeid:1 targetId:_workId page:1];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateComment)
                                                 name:@"NotificationA"
                                               object:nil];


    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showLoadButton)
                                                 name:@"NotificationNetError"
                                               object:nil];


}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
