//
//  ForthonMyFavors.m
//  Art
//
//  Created by Liu fushan on 15/7/3.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "ForthonMyFavors.h"
#import "ForthonDataContainer.h"
#import "ForthonDataSpider.h"
#import "ForthonSkimPaperCell.h"
#import "ForthonAuthorDescription.h"
#import "pageWebViewController.h"
#import "ForthonVastArtDescriptionView.h"
#import "RefreshControl.h"
#import "LoginCurtain.h"
#import "SVProgressHUD.h"
#import "ForthonVideoDescription.h"
#import "UICommon.h"

@interface ForthonMyFavors () <UITableViewDataSource, UITableViewDelegate>

@property int page;
@property BOOL isLoading;
@property BOOL isObserverRemove;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) RefreshControl *myRefreshControl;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) ForthonVastArtDescriptionView *descriptionView;
@property (nonatomic, strong) pageWebViewController *pageView;
@property (nonatomic, strong) ForthonAuthorDescription *authorDescriptionView;

@property (nonatomic, strong) UIButton *loadButton;
@property (nonatomic, strong) UIImageView *loadImage;



@end

//typedef enum {
//    CellTypePaper,
//    CellTypePerson
//}CellType;

typedef enum {
    LoadTypeRefresh,
    LoadTypeLoadMore
}LoadType;


@implementation ForthonMyFavors

- (void)viewDidLoad {
    [super viewDidLoad];

    UICommon *commonUI = [[UICommon alloc] init];
    NSString *videoTitle = @"我的收藏";
    UILabel *navTitle = (UILabel *) [commonUI navTitle:videoTitle];
    self.navigationItem.titleView = navTitle;
    self.navigationItem.backBarButtonItem = HiddenBack;

    self.delegate = [ForthonDataSpider sharedStore];

    if (![[ForthonDataContainer sharedStore] valueForKey:@"myFavors"]) {

        [self reloadDataWithType:LoadTypeRefresh];
        _isLoading = YES;
        [SVProgressHUD showWithStatus:@"加载中..."];
    }

    
    NSLog(@"viewDidLoad");

    self.automaticallyAdjustsScrollViewInsets = NO;


    _table = [[UITableView alloc] init];
    [_table setDelegate: self];
    [_table setDataSource:self ];
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

//    _loadImage.backgroundColor = [UIColor purpleColor];
    _loadImage.hidden = YES;
    _myRefreshControl = [[RefreshControl alloc] initWithScrollView:_table delegate:self];
    _myRefreshControl.topEnabled = YES;
    _myRefreshControl.bottomEnabled = YES;
    
    
    [self.view setBackgroundColor:[UIColor whiteColor]];

}


#pragma mark - 显示点击加载按键

- (void)showLoadButton {

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"NotificationNetError"
                                                  object:nil];
    [SVProgressHUD showErrorWithStatus:@"加载失败" maskType:SVProgressHUDMaskTypeBlack];
    if (![_dataArray count]) {

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
    [self.delegate getMyFavorsByPage:1];
    _page = 1;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showLoadButton)
                                                 name:@"NotificationNetError"
                                               object:nil];
}


#pragma mark - 监听回调

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"myFavors"]) {

        if ([[[ForthonDataContainer sharedStore] valueForKey:@"myComments"][0] isKindOfClass:[NSString class]] &&[[[ForthonDataContainer sharedStore] valueForKey:@"myFavors"][0] isEqualToString:@"None"]) {

            [SVProgressHUD showSuccessWithStatus:@"加载完成" maskType:SVProgressHUDMaskTypeBlack];
            _loadButton.hidden = YES;
            _loadImage.hidden = YES;
            NSLog(@"空加载完成");

        } else {

            NSLog(@"i get myFavors%@", [[ForthonDataContainer sharedStore] valueForKey:@"myFavors"]);
            _dataArray = [[ForthonDataContainer sharedStore] valueForKey:@"myFavors"];

            if ([_dataArray count] * PAPERBACKVIEWHEIGHT > self.view.frame.size.height - 64) {

                _myRefreshControl.bottomEnabled = YES;

            } else {


                _myRefreshControl.bottomEnabled = NO;
            }

            if ([_dataArray count]) {

                if (_isLoading) {

                    [SVProgressHUD showSuccessWithStatus:@"加载完成" maskType:SVProgressHUDMaskTypeBlack];
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

#pragma mark - 加载.刷新

-(void)reloadDataWithType:(LoadType)type
{
    if (type == LoadTypeRefresh) {
        
        [self.delegate getMyFavorsByPage:1];
        _page = 1;
        
    } else {
        
        NSLog(@"begin load more message:");
        _page++;
        [self.delegate getMyFavorsByPage:_page];
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


#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    return PAPERBACKVIEWHEIGHT;
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = (int)indexPath.row;
    
    static NSString *cellIdentifier = @"cell";
    
    ForthonSkimPaperCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        
        cell = [[ForthonSkimPaperCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell loadCellView];
    }
    
    [cell loadWithData:_dataArray[index]];
    return cell ;
        
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = (int)indexPath.row;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    NSDictionary *dic = _dataArray[index];
    if ([dic[@"type"] intValue] == 3) {
        
        pageWebViewController *pageWebViewController1 = [pageWebViewController new];
        pageWebViewController1.pageDic = dic[@"obj"];
        [self.navigationController pushViewController:pageWebViewController1 animated:YES];


    } else if ([dic[@"type"] intValue] == 2) {

        ForthonVastArtDescriptionView *vastArtDescriptionView = [ForthonVastArtDescriptionView new];
        vastArtDescriptionView.modelDic = dic[@"obj"];
        [self.navigationController pushViewController:vastArtDescriptionView animated:YES];

    } else if([dic[@"type"] intValue] == 1) {

        NSMutableDictionary *objecDic = [NSMutableDictionary new];
        objecDic[@"favor"] = @"0";
        objecDic[@"follow"] = @"0";
        objecDic[@"modelDic"] = dic[@"obj"];

        ForthonVideoDescription *videoDescription = [ForthonVideoDescription new];
        videoDescription.videoModelDic = objecDic;
        [self.navigationController pushViewController:videoDescription animated:YES];

    }
    
    
}


- (void)viewWillAppear:(BOOL)animated
{

        [[ForthonDataContainer sharedStore] addObserver:self
                                             forKeyPath:@"myFavors"
                                                options:NSKeyValueObservingOptionInitial
                                                context:NULL];

}


- (void)viewWillDisappear:(BOOL)animated
{
    
    [[ForthonDataContainer sharedStore] removeObserver:self forKeyPath:@"myFavors"];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation
automaticallyNotifiesObserversForKey:
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
