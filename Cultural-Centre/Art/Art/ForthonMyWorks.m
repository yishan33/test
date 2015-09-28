//
//  ForthonMyWorks.m
//  Art
//
//  Created by Liu fushan on 15/7/3.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "ForthonMyWorks.h"
#import "ForthonDataContainer.h"
#import "ForthonDataSpider.h"
#import "ForthonSkimPaperCell.h"
#import "ForthonVastArtDescriptionView.h"
#import "SVProgressHUD.h"
#import "UICommon.h"
#import "RefreshControl.h"

typedef enum {
    LoadTypeRefresh,
    LoadTypeLoadMore
}LoadType;

@interface ForthonMyWorks () <UITableViewDelegate, UITableViewDataSource>

@property int page;
@property BOOL isLoading;

@property (nonatomic, strong) RefreshControl *myRefreshControl;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *worksArray;
@property (nonatomic, strong) ForthonVastArtDescriptionView *descriptionView;

@property (nonatomic, strong) UIButton *loadButton;
@property (nonatomic, strong) UIImageView *loadImage;


@end

@implementation ForthonMyWorks

- (void)viewDidLoad {
    [super viewDidLoad];

    UICommon *commonUI = [[UICommon alloc] init];
    NSString *videoTitle = @"我的作品";
    UILabel *navTitle = (UILabel *) [commonUI navTitle:videoTitle];
    self.navigationItem.titleView = navTitle;
    self.navigationItem.backBarButtonItem = HiddenBack;

    self.delegate = [ForthonDataSpider sharedStore];

    if (![[ForthonDataContainer sharedStore] valueForKey:@"myWorks"]) {

        [self.delegate getMyWorksByPage:1];
        _isLoading = YES;
        [SVProgressHUD showWithStatus:@"加载中..."];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(showLoadButton)
                                                     name:@"NotificationNetError"
                                                   object:nil];

    }



    self.automaticallyAdjustsScrollViewInsets = NO;
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, self.view.frame.size.height - 64)];
    [_table setDelegate:self];
    [_table setDataSource:self];
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_table setFrame:CGRectMake(0, 64, WIDTH, self.view.frame.size.height - 64)];
    [self.view addSubview:_table];

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



    self.view.backgroundColor = [UIColor whiteColor];
}


#pragma mark - 显示点击加载按键

- (void)showLoadButton {

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"NotificationNetError"
                                                  object:nil];
    [SVProgressHUD showErrorWithStatus:@"加载失败" maskType:SVProgressHUDMaskTypeBlack];

    if (![_worksArray count]) {

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
    [self.delegate getMyWorksByPage:1];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showLoadButton)
                                                 name:@"NotificationNetError"
                                               object:nil];
}


#pragma mark 监听回调

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"myWorks"]) {

        if ([[[ForthonDataContainer sharedStore] valueForKey:@"myWorks"][0] isKindOfClass:[NSString class]] && [[[ForthonDataContainer sharedStore] valueForKey:@"myWorks"][0] isEqualToString:@"None"]) {

            [SVProgressHUD showSuccessWithStatus:@"加载完成"];
            _loadButton.hidden = YES;
            _loadImage.hidden = YES;
            NSLog(@"空加载完成");


        } else {


            _worksArray = [[ForthonDataContainer sharedStore] valueForKey:@"myWorks"];

            _myRefreshControl.bottomEnabled = [_worksArray count] * PAPERBACKVIEWHEIGHT > self.view.frame.size.height - 64;

            if ([_worksArray count]) {

                if (_isLoading) {

                    [SVProgressHUD showSuccessWithStatus:@"加载完成"];
                    _isLoading = NO;
                    _loadButton.hidden = YES;
                    _loadImage.hidden = YES;
                }

                [_table reloadData];
            }
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



#pragma mark TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_worksArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return PAPERBACKVIEWHEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    ForthonSkimPaperCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ForthonSkimPaperCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell loadCellView];
    }
    _worksArray[indexPath.row][@"typeId"] = @(2);
    [cell loadWithData:_worksArray[indexPath.row]];

//    cell.backgroundColor = [UIColor purpleColor];
    NSLog(@"work: %@", _worksArray[indexPath.row]);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int index = (int)indexPath.row;
    NSDictionary *dic = _worksArray[index];
    ForthonVastArtDescriptionView * descriptionView = [[ForthonVastArtDescriptionView alloc] init];
    descriptionView.modelDic = dic;
    descriptionView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:descriptionView animated:YES];
}



- (void)viewWillAppear:(BOOL)animated {
    
    [[ForthonDataContainer sharedStore] addObserver:self
                                         forKeyPath:@"myWorks"
                                            options:NSKeyValueObservingOptionInitial
                                            context:NULL];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[ForthonDataContainer sharedStore] removeObserver:self forKeyPath:@"myWorks"];
    
}

#pragma mark - 加载.刷新

-(void)reloadDataWithType:(LoadType)type
{
    if (type == LoadTypeRefresh) {

        [self.delegate getMyWorksByPage:1];
        _page = 1;

    } else {

        NSLog(@"begin load more message:");
        _page++;
        [self.delegate getMyWorksByPage:_page];
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
