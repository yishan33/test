//
//  ForhonCommentArtTable.m
//  Login
//
//  Created by Liu fushan on 15/5/21.
//  Copyright (c) 2015年 culturalCenter. All rights reserved.
//

#import "ForthonCommentArtTable.h"
#import "Common.h"
#import "ForthonCommentArtCell.h"
#import "ForthonDataContainer.h"
#import "ForthonDataSpider.h"
#import "pageWebViewController.h"
#import "NSString+regular.h"
#import "UIImageView+WebCache.h"
#import "RefreshControl.h"
#import "LoginCurtain.h"
#import "SVProgressHUD.h"

typedef enum {
    LoadTypeRefresh,
    LoadTypeLoadMore
}LoadType;



@interface ForthonCommentArtTable ()

@property int page;
@property BOOL isLoading;
@property BOOL shouldRefresh;

@property (strong, nonatomic) NSMutableArray *textArray;
@property (nonatomic,strong) RefreshControl * myRefreshControl;
@property (nonatomic, strong) UITableView *myTableView;

@property (nonatomic, strong) UIButton *loadButton;
@property (nonatomic, strong) UIImageView *loadImage;

@property (nonatomic, strong) NSIndexPath *targetPath;

@end

@implementation ForthonCommentArtTable

- (void)viewDidLoad {
    
    [super viewDidLoad];

    UICommon *commonUI = [[UICommon alloc] init];
    UILabel *navTitle = [commonUI navTitle:@"论议"];
    self.navigationItem.titleView = navTitle;
    self.navigationItem.backBarButtonItem = HiddenBack
    self.navigationController.navigationBar.tintColor = AppColor;



    _myTableView = [[UITableView alloc] init];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [_myTableView setFrame:CGRectMake(0, 64, WIDTH, self.view.frame.size.height - 64)];
    [_myTableView setDelegate:self];
    [_myTableView setDataSource:self];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    _loadButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [_loadButton setCenter:CGPointMake(self.view.center.x, 2 * (self.view.frame.size.height - 64) / 3)];
    _loadButton.backgroundColor = [UIColor blackColor];
    [_loadButton setTitle:@"点击重试" forState:UIControlStateNormal];
    [_loadButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_loadButton addTarget:self action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    [_myTableView addSubview:_loadButton];
    _loadButton.hidden = YES;

    _loadImage = [[UIImageView alloc] init];
    _loadImage.frame = CGRectMake(0, 0, 100 * WIDTH / 320.0, 80 * WIDTH / 320.0);
    _loadImage.center = CGPointMake(self.view.center.x, (self.view.frame.size.height - 64) / 2);
    _loadImage.image = [UIImage imageNamed:@"ic_error_page"];
    [_myTableView addSubview:_loadImage];
    _loadImage.hidden = YES;


    _page = 1;
    self.delegate = [ForthonDataSpider sharedStore];
    
    _myRefreshControl = [[RefreshControl alloc] initWithScrollView:_myTableView delegate:self];
    _myRefreshControl.topEnabled = YES;
    _myRefreshControl.bottomEnabled = YES;

    if ([ForthonDataSpider sharedStore].userName == nil) {

        _shouldRefresh = YES;
    }
    
    if (![[ForthonDataContainer sharedStore].pagesDic[0] count]) {

        _isLoading = YES;
        [SVProgressHUD showWithStatus:@"加载中..."];
        [self reloadDataWithType:LoadTypeRefresh];
        
    }
    
    
    _myTableView.separatorStyle = NO;
    [self.view addSubview:_myTableView];
}


#pragma mark - 显示点击加载按键

- (void)showLoadButton {

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"NotificationNetError"
                                                  object:nil];

    if ([[ForthonDataContainer sharedStore].pagesDic count]) {

        NSLog(@"暂时不显示");

    } else {

        [SVProgressHUD showErrorWithStatus:@"加载失败" maskType:SVProgressHUDMaskTypeBlack];
        _loadButton.hidden = NO;
        _loadImage.hidden = NO;
    }



}

#pragma mark - 点击点击加载

- (void)reload {

    [SVProgressHUD showWithStatus:@"加载中..."];
    [_delegate getPagesByPage:1];
    _page = 1;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUI)
                                                 name:@"NotificationA"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showLoadButton)
                                                 name:@"NotificationNetError"
                                               object:nil];
}


- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction
{
    
    
    __weak typeof(self)weakSelf=self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf)strongSelf=weakSelf;
        if (direction == RefreshDirectionTop) {
            [strongSelf reloadDataWithType:LoadTypeRefresh];
            [[ForthonDataContainer sharedStore].pagesDic removeAllObjects];
            
        } else {
            
            [strongSelf reloadDataWithType:LoadTypeLoadMore];
            
        }
        
        
    });
    
}

-(void)reloadDataWithType:(LoadType)type
{
    if (type == LoadTypeRefresh) {
        
        [_delegate getPagesByPage:1];
        _page = 1;
        
    } else {
        
        NSLog(@"begin load more message:");
        _page++;
        [_delegate getPagesByPage:_page];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUI)
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return [[ForthonDataContainer sharedStore].pagesDic count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int index = indexPath.row;
    static NSString *cellIdentifier = @"cell";
    
    ForthonCommentArtCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ForthonCommentArtCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        [cell loadView];
    }
    cell.loginDelegate = self;
    cell.pushDelegate = self;
    cell.tinyTag = index;
    [cell loadDataWithDic:[ForthonDataContainer sharedStore].pagesDic[index]];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300 * HEIGHT / 1250;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = indexPath.row;
    _targetPath = indexPath;
    NSLog(@"%i",(int)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [ForthonDataContainer sharedStore].pagesDic[index];
    pageWebViewController *pageView = [[pageWebViewController alloc] init];
    pageView.tinyTag = index;
    pageView.pageDic = dic;
    [self.navigationController pushViewController:pageView  animated:YES];

}

- (void)updateUI
{

    _loadButton.hidden = YES;
    _loadImage.hidden = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationA" object:nil];

    if (_isLoading) {

        [SVProgressHUD showSuccessWithStatus:@"加载成功" maskType:SVProgressHUDMaskTypeBlack];
    }

    [_myTableView reloadData];
    
    if (self.myRefreshControl.refreshingDirection == RefreshingDirectionTop)
        {
            [self.myRefreshControl finishRefreshingDirection:RefreshDirectionTop];
        }
    else if (self.myRefreshControl.refreshingDirection == RefreshingDirectionBottom)
        {
        
            [self.myRefreshControl finishRefreshingDirection:RefreshDirectionBottom];
        
        }

    
}

#pragma mark - 登录刷新

- (void)pushLoginCurtain {


    NSLog(@"请登录...");
    LoginCurtain *loginView = [[LoginCurtain alloc] init];
    loginView.refreshDelegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginView];
    [self presentViewController:nav animated:YES completion:nil];

}

- (void)refresh {

    [_myTableView reloadData];
    if ([ForthonDataSpider sharedStore].userName) {

        _shouldRefresh = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated {

    NSLog(@"viewWillAppear");
    if (_targetPath) {

        NSLog(@"indexPath : %@", _targetPath);
        ForthonCommentArtCell *targetCell = (ForthonCommentArtCell *) [_myTableView cellForRowAtIndexPath:_targetPath];
        targetCell.commentNumberLabel.text = [[ForthonDataContainer sharedStore].pagesDic[_targetPath.row][@"commentCnt"] stringValue];
    }

    if (_shouldRefresh && [ForthonDataSpider sharedStore].userName) {

        [_myTableView reloadData];
        NSLog(@"favorState reget");
        _shouldRefresh = NO;
    }
}


- (void)pushPageViewByDic:(NSDictionary *)dic {

    pageWebViewController *pageView = [[pageWebViewController alloc] init];
    pageView.tinyTag = [dic[@"tinyTag"] intValue];
    pageView.pageDic = dic;
    [self.navigationController pushViewController:pageView  animated:YES];
}

@end

