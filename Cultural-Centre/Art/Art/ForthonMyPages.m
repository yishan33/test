//
//  ForthonMyPages.m
//  Art
//
//  Created by Liu fushan on 15/7/3.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "ForthonMyPages.h"
#import "ForthonDataContainer.h"
#import "ForthonDataSpider.h"
#import "ForthonSkimPaperCell.h"
#import "pageWebViewController.h"
#import "RefreshControl.h"
#import "LoginCurtain.h"
#import "SVProgressHUD.h"
#import "UICommon.h"
#import "ForthonCommentArtCell.h"


typedef enum {
    LoadTypeRefresh,
    LoadTypeLoadMore
}LoadType;


@interface ForthonMyPages () <UITableViewDataSource, UITableViewDelegate>

@property int page;
@property BOOL isLoading;

@property NSIndexPath *targetPath;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *pagesArray;
@property (nonatomic, strong) pageWebViewController *pageView;
@property (nonatomic, strong) RefreshControl *myRefreshControl;

@property (nonatomic, strong) UIButton *loadButton;
@property (nonatomic, strong) UIImageView *loadImage;


@end

@implementation ForthonMyPages

- (void)viewDidLoad {
    [super viewDidLoad];

    UICommon *commonUI = [[UICommon alloc] init];
    NSString *videoTitle = @"我的文章";
    UILabel *navTitle = (UILabel *) [commonUI navTitle:videoTitle];
    self.navigationItem.titleView = navTitle;
    self.navigationItem.backBarButtonItem = HiddenBack;

    self.delegate = [ForthonDataSpider sharedStore];


    if (![[ForthonDataContainer sharedStore] valueForKey:@"myPages"]) {

        _isLoading = YES;
        [self reloadDataWithType:LoadTypeRefresh];
        [SVProgressHUD showWithStatus:@"加载中..."];

    }

    self.automaticallyAdjustsScrollViewInsets = NO;
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64)];
    [_table setDelegate:self];
    [_table setDataSource:self];
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_table setFrame:CGRectMake(0, 64, WIDTH, self.view.frame.size.height - 64)];

    _loadButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [_loadButton setCenter:CGPointMake(self.view.center.x, 2 * (self.view.frame.size.height - 64) / 3)];
    _loadButton.backgroundColor = [UIColor blackColor];
    [_loadButton setTitle:@"点击重试" forState:UIControlStateNormal];
    [_loadButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_loadButton addTarget:self action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    [_table addSubview:_loadButton];
    _loadButton.hidden = YES;

    _loadImage = [[UIImageView alloc] init];
    _loadImage.frame = CGRectMake(0, 0, 100 * WIDTH / 320.0, 80 * WIDTH / 320.0);
    _loadImage.center = CGPointMake(self.view.center.x, (self.view.frame.size.height - 64) / 2);
    _loadImage.image = [UIImage imageNamed:@"ic_error_page"];
    [_table addSubview:_loadImage];
    _loadImage.hidden = YES;

    _myRefreshControl = [[RefreshControl alloc] initWithScrollView:_table delegate:self];
    _myRefreshControl.topEnabled = YES;
    _myRefreshControl.bottomEnabled = YES;

    [self.view addSubview:_table];
    [self.view setBackgroundColor:[UIColor whiteColor]];

}



#pragma mark - 显示点击加载按键

- (void)showLoadButton {

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"NotificationNetError"
                                                  object:nil];
    [SVProgressHUD showErrorWithStatus:@"加载失败" maskType:SVProgressHUDMaskTypeBlack];
    if (![_pagesArray count]) {

        _table.frame = CGRectMake(0, 64, WIDTH, self.view.frame.size.height - 64);
        _table.separatorStyle = NO;
        _loadButton.hidden = NO;
        _loadImage.hidden = NO;
    }

    if (self.myRefreshControl.refreshingDirection == RefreshingDirectionTop)
    {
        [self.myRefreshControl finishRefreshingDirection:RefreshDirectionTop];
    }
    else if (self.myRefreshControl.refreshingDirection == RefreshingDirectionBottom)
    {

        [self.myRefreshControl finishRefreshingDirection:RefreshDirectionBottom];

    }

}

#pragma mark - 点击点击加载

- (void)reload {

    [SVProgressHUD showWithStatus:@"加载中..."];
    [self.delegate getMyPagesByPage:1];
    _page = 1;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showLoadButton)
                                                 name:@"NotificationNetError"
                                               object:nil];
}


#pragma mark 监听回调

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"myPages"]) {

        NSLog(@"myPages is return");
        if ([[[ForthonDataContainer sharedStore] valueForKey:@"myPages"][0] isKindOfClass:[NSString class]] && [[[ForthonDataContainer sharedStore] valueForKey:@"myPages"][0] isEqualToString:@"None"]) {

            [SVProgressHUD showSuccessWithStatus:@"加载完成" maskType:SVProgressHUDMaskTypeBlack];
            _loadButton.hidden = YES;
            _loadImage.hidden = YES;
            NSLog(@"空加载完成");

        } else {

            _pagesArray = [[ForthonDataContainer sharedStore] valueForKey:@"myPages"];
            _myRefreshControl.bottomEnabled = [_pagesArray count] * PAPERBACKVIEWHEIGHT > self.view.frame.size.height - 64;


            if ([_pagesArray count]) {
                NSLog(@"Pages  : %@", _pagesArray);
                if (_isLoading) {

                    [SVProgressHUD showSuccessWithStatus:@"加载完成" maskType:SVProgressHUDMaskTypeBlack];
                    _isLoading = NO;
                    _loadButton.hidden = YES;
                    _loadImage.hidden = YES;

                }
                [_table reloadData];
            }
            NSLog(@"refreshControl");

        }

        if (self.myRefreshControl.refreshingDirection == RefreshingDirectionTop)
        {
            [self.myRefreshControl finishRefreshingDirection:RefreshDirectionTop];
        }
        else if (self.myRefreshControl.refreshingDirection == RefreshingDirectionBottom)
        {
            [self.myRefreshControl finishRefreshingDirection:RefreshDirectionBottom];
        }

    }
    
}

#pragma mark - 加载.刷新

-(void)reloadDataWithType:(LoadType)type
{
    if (type == LoadTypeRefresh) {

        [self.delegate getMyPagesByPage:1];
        _page = 1;
        NSLog(@"begin refresh message:");

    } else {

        NSLog(@"begin load more message:");
        _page++;
        [self.delegate getMyPagesByPage:_page];
    }

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

        } else {

            [strongSelf reloadDataWithType:LoadTypeLoadMore];

        }


    });

}

#pragma mark TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_pagesArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 300 * HEIGHT / 1250;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = (int)indexPath.row;
    NSLog(@"index: %i  data: %@", index, _pagesArray[index]);
    static NSString *cellIdentifier = @"cell";

    ForthonCommentArtCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ForthonCommentArtCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];

        [cell loadView];
    }

    cell.pushDelegate = self;
    cell.tinyTag = index;
    [cell loadDataWithDic:[[ForthonDataContainer sharedStore] valueForKey:@"myPages"][index]];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    int index = indexPath.row;
    _targetPath = indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [[ForthonDataContainer sharedStore] valueForKey:@"myPages"][index];
    pageWebViewController *pageView = [[pageWebViewController alloc] init];
    pageView.tinyTag = index;
    pageView.pageDic = dic;
    [self.navigationController pushViewController:pageView  animated:YES];
}

#pragma mark ViewＷillDisappear


- (void)viewWillDisappear:(BOOL)animated
{
    [[ForthonDataContainer sharedStore] removeObserver:self forKeyPath:@"myPages"];

}

- (void)viewWillAppear:(BOOL)animated
{

        
    [[ForthonDataContainer sharedStore] addObserver:self forKeyPath:@"myPages" options:NSKeyValueObservingOptionInitial context:NULL];
    NSLog(@"viewWillAppear");
    if (_targetPath) {

        NSLog(@"indexPath : %@", _targetPath);
        ForthonCommentArtCell *targetCell = (ForthonCommentArtCell *) [_table cellForRowAtIndexPath:_targetPath];
        targetCell.commentNumberLabel.text = [[[ForthonDataContainer sharedStore] valueForKey:@"myPages"][_targetPath.row][@"commentCnt"] stringValue];
    }

}

- (void)pushPageViewByDic:(NSDictionary *)dic {

    pageWebViewController *pageView = [[pageWebViewController alloc] init];
    pageView.tinyTag = [dic[@"tinyTag"] intValue];
    pageView.pageDic = dic;
    [self.navigationController pushViewController:pageView  animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
