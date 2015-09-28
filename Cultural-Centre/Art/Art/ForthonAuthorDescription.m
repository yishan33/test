//
//  ForthonAuthorDescription.m
//  Art
//
//  Created by Liu fushan on 15/6/22.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "ForthonAuthorDescription.h"
#import "AuthorDescriptionMeasurement.h"
#import "ForthonWorkCell.h"
#import "ForthonDataSpider.h"
#import "LoginCurtain.h"
#import "UIImageView+WebCache.h"
#import "UICommon.h"
#import "ForthonCommentArtCell.h"
#import "ForthonVideoCell.h"
#import "UILabel+autoSizeToFit.h"
#import "ForthonVastArtDescriptionView.h"
#import "pageWebViewController.h"
#import "NSString+imageUrlString.h"
#import "AFURLRequestSerialization.h"

@interface ForthonAuthorDescription ()<UITableViewDataSource, UITableViewDelegate>

@property BOOL isFollow;
@property (nonatomic, strong) NSString *authorId;
@property BOOL isPages;

@property (nonatomic, strong) NSMutableArray *artGroupHeightArray;
@property (nonatomic, strong) NSMutableArray *artGroupArray;
@property (nonatomic, strong) NSMutableArray *pageArray;
@property (nonatomic, strong) NSMutableArray *tableDataArray;

@property (nonatomic, strong) UIButton *attentionButton;
@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UITextView *descriptionText;

@property (nonatomic, strong) UIButton *workButton;
@property (nonatomic, strong) UIButton *pageButton;

@property (nonatomic, strong) UITableView *table;



@end

@implementation ForthonAuthorDescription

- (void)viewDidLoad {
    [super viewDidLoad];

    UICommon *commonUI = [[UICommon alloc] init];
    NSString *name;
    if ([_authorDic[@"userNickName"] boolValue]) {

        name = _authorDic[@"userNickName"];
    } else {

        name = _authorDic[@"userName"];
    }
    UILabel *navTitle = (UILabel *) [commonUI navTitle:name];
    self.navigationItem.titleView = navTitle;
    self.navigationItem.backBarButtonItem = HiddenBack;

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.artGroupHeightArray = [NSMutableArray new];
    if ([_authorDic[@"userId"] boolValue]) {

        _authorId = _authorDic[@"userId"];
    } else {

        _authorId = _authorDic[@"id"];
    }

    self.delegate = [ForthonDataSpider sharedStore];
    self.followDelegate = [ForthonDataSpider sharedStore];
    NSLog(@"获取个人资料");

    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, TOPINTERVAL, BACKVIEWWIDTH, BACKVIEWHEIGHT)];
//    [backView setBackgroundColor:[UIColor yellowColor]];
    NSLog(@"backView : %f, %f, %f, backviewheight: %f", TOPINTERVAL, TOPINTERVAL, BACKVIEWWIDTH, BACKVIEWHEIGHT);

    _headImage = [[UIImageView alloc] initWithFrame:CGRectMake(SIDEINTERVAL, 0, IMAGESIDE, IMAGESIDE)];
    [_headImage.layer setCornerRadius:IMAGESIDE / 2];
    [_headImage.layer setBorderColor:AppColor.CGColor];
    [_headImage.layer setBorderWidth:2.0];
    [_headImage setClipsToBounds:YES];
    NSString *urlStr;
    if (!_authorDic[@"avatarUrl"]) {

        urlStr = [_authorDic[@"userAvatarUrl"] changeToUrl];

    } else {

        urlStr = [_authorDic[@"avatarUrl"] changeToUrl];
    }
    [_headImage sd_setImageWithURL:[NSURL URLWithString:urlStr]];

    _attentionButton = [[UIButton alloc] initWithFrame:CGRectMake(SIDEINTERVAL + (IMAGESIDE - ATTENTIONBUTTONWIDTH) / 2, IMAGESIDE + 5 * HEIGHTPERCENTAGE, ATTENTIONBUTTONWIDTH, ATTENTIONBUTTONHEIGHT - 5 * HEIGHTPERCENTAGE)];

    
    if (_isFollow) {
        
        [_attentionButton setTitle:@"- 取消" forState:UIControlStateNormal];
        
    } else {

        [_attentionButton setTitle:@"+ 关注" forState:UIControlStateNormal];
    }
    [_attentionButton.layer setBorderWidth:1.0];
    [_attentionButton.layer setBorderColor:AppColor.CGColor];
    [_attentionButton setTitle:@"+ 关注" forState:UIControlStateNormal];
    [_attentionButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_attentionButton addTarget:self action:@selector(setAndCancelFollow) forControlEvents:UIControlEventTouchUpInside];
    [_attentionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_attentionButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    
    _descriptionText = [[UITextView alloc] initWithFrame:CGRectMake(2 * SIDEINTERVAL + IMAGESIDE, 0, DESCRIPTIONTEXTWIDTH, DESCRIPTIONTEXTHEIGHT)];
    [_descriptionText setFont:[UIFont systemFontOfSize:13.0]];
    
    _workButton = [[UIButton alloc] initWithFrame:CGRectMake(0, BACKVIEWHEIGHT - CATEGORYBUTTONHEIGHT, CATEGORYBUTTONWIDTH, CATEGORYBUTTONHEIGHT)];
    [_workButton setTitle:@"作品" forState:UIControlStateNormal];
    [_workButton setTitleColor:AppColor forState:UIControlStateNormal];
    [_workButton addTarget:self action:@selector(changeTypeToArt) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH / 2, BACKVIEWHEIGHT - CATEGORYBUTTONHEIGHT, 1, CATEGORYBUTTONHEIGHT)];
    [lineView setBackgroundColor:AppColor];
    _pageButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH / 2, BACKVIEWHEIGHT - CATEGORYBUTTONHEIGHT, CATEGORYBUTTONWIDTH, CATEGORYBUTTONHEIGHT)];
    [_pageButton setTitle:@"文章" forState:UIControlStateNormal];
    [_pageButton setTitleColor:AppColor forState:UIControlStateNormal];
    [_pageButton addTarget:self action:@selector(changeTypeToPage) forControlEvents:UIControlEventTouchUpInside];
    
//    [_nameLabel setBackgroundColor:AppColor];
//    [_attentionButton setBackgroundColor:[UIColor yellowColor]];
//    [_descriptionText setBackgroundColor:[UIColor greenColor]];
//    [_workButton setBackgroundColor:[UIColor grayColor]];
//    [lineView setBackgroundColor:AppColor];
//    [_pageButton setBackgroundColor:[UIColor grayColor]];
    
    [backView addSubview:_headImage];
    [backView addSubview:_attentionButton];
    [backView addSubview:_descriptionText];
    [backView addSubview:_workButton];
    [backView addSubview:_pageButton];
    [backView addSubview:lineView];


    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, BACKVIEWHEIGHT + TOPINTERVAL , WIDTH, HEIGHT - BACKVIEWHEIGHT - TOPINTERVAL)];
//    [_table setBackgroundColor:[UIColor purpleColor]];
    [_table setDelegate:self];
    [_table setDataSource:self];
    _table.bounces = NO;

    [self changeTypeToArt];
    [self.delegate getUserInfoByUserId:_authorId];
    [self getFollowStatus];


    [[ForthonDataSpider sharedStore] addObserver:self
                                      forKeyPath:@"userInfo"
                                         options:NSKeyValueObservingOptionInitial
                                         context:NULL];


    [self.view addSubview:backView];
    [self.view addSubview:_table];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
}

#pragma mark TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableDataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isPages) {

        return 300 * HEIGHT / 1250;

    } else {
        if ([_artGroupHeightArray count]) {

            return [_artGroupHeightArray[indexPath.row] floatValue];

        } else {

            return 0;

        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    int index = (int) indexPath.row;
    if (_isPages) {

        static NSString *commentArtCell = @"artCell";
        ForthonCommentArtCell * cell = [tableView dequeueReusableCellWithIdentifier:commentArtCell];
        if (cell == nil) {

            cell = [[ForthonCommentArtCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentArtCell];
            [cell loadView];
            cell.loginDelegate = self;
            cell.pushDelegate = self;
        }

        [cell loadDataWithDic:_pageArray[index]];
        return cell;

    } else {

        static NSString *workCellIdentifier = @"workCell";
        ForthonWorkCell *cell = [tableView dequeueReusableCellWithIdentifier:workCellIdentifier];

        if (cell == nil) {

            cell = [[ForthonWorkCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:workCellIdentifier];
            [cell loadView];
            cell.delegate = self;
        }

        [cell loadDataWithDic:_artGroupArray[index]];
        return cell;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (_isPages) {

        pageWebViewController *page = [pageWebViewController new];
        [page setPageDic:_pageArray[indexPath.row]];
        [self.navigationController pushViewController:page animated:YES];
    }
}

- (void)loadHeight {

    if ([_artGroupArray count]) {
        for (NSDictionary *dic in _artGroupArray) {
            
            NSString *text = [dic[@"group"] objectForKey:@"des"];
            UILabel *label = [UILabel new];
            [label labelAutoCalculateRectWith:text FontSize:14.0 MaxSize:CGSizeMake(WIDTH - 10 * WIDTHPERCENTAGE, 1000)];
            NSNumber *height = @(label.frame.size.height + 110 * HEIGHTPERCENTAGE);
            [_artGroupHeightArray addObject:height];
        }
    } else {
        
        NSLog(@"作品集不存在");
    }
}

- (void)updateUI:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationA" object:nil];

    if (_isPages) {

        _pageArray = notification.userInfo[@"pageGroup"];
        _tableDataArray = _pageArray;
    } else {

        _artGroupArray = notification.userInfo[@"artGroup"];
        _tableDataArray = _artGroupArray;
        [self loadHeight];
    }

    [_table reloadData];

}

- (void)fastUpdateUI {

    if (_isPages) {

        _tableDataArray = _pageArray;
    } else {

        _tableDataArray = _artGroupArray;
    }

    [_table reloadData];
}

- (void)LoginPlease
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationUserError" object:nil];
    [self pushLoginCurtain];
    
}

- (void)pushLoginCurtain
{
    NSLog(@"请登录...");
    LoginCurtain *loginView = [[LoginCurtain alloc] init];
    loginView.refreshDelegate = self;

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginView];
    [self presentViewController:nav animated:YES completion:nil];
}


#pragma mark 获取关注状态

- (void)getFollowStatus
{
    [self.followDelegate getFollowStatusByTargetId:_authorId];
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
    
    if (_isFollow) {
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


- (void)refresh
{
    [self getFollowStatus];
}

#pragma mark - 监听作者个人信息

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"userInfo"]) {
        
        NSMutableDictionary *dic = [[ForthonDataContainer sharedStore] valueForKey:@"userInfo"];
        [_descriptionText setText:dic[@"profile"]];
    }

}

- (void)viewWillDisappear:(BOOL)animated {
    
    [[ForthonDataContainer sharedStore] removeObserver:self forKeyPath:@"userInfo"];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [[ForthonDataContainer sharedStore] addObserver:self
                                         forKeyPath:@"userInfo"
                                            options:NSKeyValueObservingOptionInitial
                                            context:NULL];
}


#pragma mark - 作品文章切换

- (void)changeTypeToArt {

    _isPages = NO;
    NSLog(@"change to art");
    [_workButton setBackgroundColor:[UIColor grayColor]];
    [_pageButton setBackgroundColor:[UIColor whiteColor]];

    if (![_artGroupArray count]) {

        [self.delegate getUserArtGroupById:_authorId];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateUI:)
                                                     name:@"NotificationA"
                                                   object:nil];
    } else {

        [self fastUpdateUI];
    }

}

- (void)changeTypeToPage {

    _isPages = YES;
    NSLog(@"change to page");
    [_workButton setBackgroundColor:[UIColor whiteColor]];
    [_pageButton setBackgroundColor:[UIColor grayColor]];

    if (![_pageArray count]) {

        [self.delegate getUserPagesById:_authorId];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateUI:)
                                                     name:@"NotificationA"
                                                   object:nil];
    } else {

        [self fastUpdateUI];
    }

}

#pragma mark - 推出作品详情

- (void)pushArtDescriptionWithDic:(NSMutableDictionary *)dic {

    ForthonVastArtDescriptionView *artDescriptionView = [ForthonVastArtDescriptionView new];
    artDescriptionView.modelDic = dic;

    [self.navigationController pushViewController:artDescriptionView animated:YES];
}


- (void)pushPageViewByDic:(NSDictionary *)dic {

    pageWebViewController *pageWebViewController1 = [pageWebViewController new];
    pageWebViewController1.pageDic = dic;
    [self.navigationController pushViewController:pageWebViewController1 animated:YES];

}

@end
