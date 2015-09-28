//
//  ForthonMyComments.m
//  Art
//
//  Created by Liu fushan on 15/7/3.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "ForthonMyComments.h"
#import "ForthonDataContainer.h"
#import "ForthonDataSpider.h"
#import "ForthonMyCommentCell.h"
#import "LoginCurtain.h"
#import "ForthonVideoDescription.h"
#import "ForthonVastArtDescriptionView.h"
#import "ForthonAuthorDescription.h"
#import "pageWebViewController.h"
#import "RefreshControl.h"
#import "SVProgressHUD.h"
#import "UICommon.h"

typedef enum {
    LoadTypeRefresh,
    LoadTypeLoadMore
}LoadType;


@interface ForthonMyComments ()
<
UITableViewDataSource,
UITableViewDelegate,
myCommentPushDescription
>

@property int page;
@property BOOL isLoading;
@property CGFloat cellTotalHeight;

@property (nonatomic, strong) RefreshControl *myRefreshControl;
@property (strong, nonatomic) UITableView *table;
@property (strong, nonatomic) NSMutableArray *commentsArray;
@property (strong, nonatomic) NSMutableArray *cellHeightArray;

@property (nonatomic, strong) UIButton *loadButton;
@property (nonatomic, strong) UIImageView *loadImage;

@end

@implementation ForthonMyComments

- (void)viewDidLoad {
    [super viewDidLoad];

    UICommon *commonUI = [[UICommon alloc] init];
    NSString *videoTitle = @"我的评论";
    UILabel *navTitle = (UILabel *) [commonUI navTitle:videoTitle];
    self.navigationItem.titleView = navTitle;
    self.navigationItem.backBarButtonItem = HiddenBack;
    
    self.delegate = [ForthonDataSpider sharedStore];

    if (![[ForthonDataContainer sharedStore] valueForKey:@"myComments"]) {

        [self reloadDataWithType:LoadTypeRefresh];
        _isLoading = YES;
        [SVProgressHUD showWithStatus:@"加载中..."];
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
    if (![_commentsArray count]) {

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
    [self.delegate getMyCommentsByPage:1];
    _page = 1;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showLoadButton)
                                                 name:@"NotificationNetError"
                                               object:nil];
}


- (void)viewWillAppear:(BOOL)animated {
    

    [[ForthonDataContainer sharedStore] addObserver:self
                                         forKeyPath:@"myComments"
                                            options:NSKeyValueObservingOptionInitial context:NULL];

}

- (void)viewWillDisappear:(BOOL)animated {
    

    [[ForthonDataContainer sharedStore] removeObserver:self forKeyPath:@"myComments"];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    NSLog(@"回掉");
    if ([keyPath isEqualToString:@"myComments"]) {

        if ([[[ForthonDataContainer sharedStore] valueForKey:@"myComments"][0] isKindOfClass:[NSString class]] && [[[ForthonDataContainer sharedStore] valueForKey:@"myComments"][0] isEqualToString:@"None"]) {

            [SVProgressHUD showSuccessWithStatus:@"加载完成" maskType:SVProgressHUDMaskTypeBlack];
            _loadButton.hidden = YES;
            _loadImage.hidden = YES;

        } else {

            _commentsArray = [[ForthonDataContainer sharedStore] valueForKey:@"myComments"];
            [self loadCellHeight];

            _myRefreshControl.bottomEnabled = _cellTotalHeight > self.view.frame.size.height - 64;

            if ([_commentsArray count]) {

                if (_isLoading) {

                    [SVProgressHUD showSuccessWithStatus:@"加载完成" maskType:SVProgressHUDMaskTypeBlack];
                    _loadButton.hidden = YES;
                    _loadImage.hidden = YES;
                    _isLoading = NO;
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



#pragma mark UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_commentsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = (int)indexPath.row;

    return [_cellHeightArray[index] floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = (int)indexPath.row;
    
    static NSString *cellIdentifier = @"cell";
    
    ForthonMyCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ForthonMyCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell loadView];
    }


    [cell embarkWithData:_commentsArray[index]];
    cell.pushDelegate = self;


    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int index = (int)indexPath.row;
    NSDictionary *dic = _commentsArray[index];
//    [self pushArtDescriptionViewWithWorkId:[dic objectForKey:@"id"]];
}


#pragma mark - 获取评论高度

- (void)loadCellHeight
{
    if ([_commentsArray count])
        {
        NSLog(@"though spider get data");
        NSLog(@"commetnsArray: %@", _commentsArray);
        _cellHeightArray = [[NSMutableArray alloc] init];
        _cellTotalHeight = 0.0;
        NSString *text;
        for (int i = 0; i < [_commentsArray count]; i++) {
            if ([_commentsArray count] > i + 1) {
                text = [[_commentsArray[i] objectForKey:@"comment"] objectForKey:@"content"];
                NSLog(@"text: %@", text);
                
            } else {
                text = @"";
            }
            //                    NSString *text = ;
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0], NSParagraphStyleAttributeName:paragraphStyle.copy};
            
            CGSize size = CGSizeMake(REPLYLABELWIDTH, 1000);
            //            _cellTotalHeight += [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height ;
            NSNumber *cellHeightNumber = [NSNumber numberWithFloat:[text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height + 365 * HEIGHTPERCENTAGE];
            
            _cellTotalHeight += [cellHeightNumber floatValue];
            NSLog(@"cellcontentheight:%f", [cellHeightNumber floatValue] - 365 * HEIGHTPERCENTAGE);
            [_cellHeightArray addObject:cellHeightNumber];
        }
        
    }
}

#pragma mark - 推出详情页

- (void)pushDescriptionViewWithTypeId:(int)type workDic:(NSDictionary *)dic
{
    if (type == 1) {
        NSLog(@"pushVideo");
        
        ForthonVideoDescription *videoDescription = [[ForthonVideoDescription alloc] init];
        videoDescription.videoModelDic = dic;
        [self.navigationController pushViewController:videoDescription animated:YES];
        
    } else if (type == 2) {
        NSLog(@"pushArtDescription");
        
        ForthonVastArtDescriptionView *artDescription = [[ForthonVastArtDescriptionView alloc] init];
        artDescription.modelDic = dic;

        [self.navigationController pushViewController:artDescription animated:YES];
        
    } else if (type == 3) {
        NSLog(@"pushPageDescription");
        
        pageWebViewController *pageView = [[pageWebViewController alloc] init];
        pageView.pageDic = dic;
        [self.navigationController pushViewController:pageView animated:YES];
    } else {

        ForthonAuthorDescription *authorDescription = [ForthonAuthorDescription new];
        authorDescription.authorDic = dic;
        [self.navigationController pushViewController:authorDescription animated:YES];
    }
    
}

//#pragma mark - 登录刷新
//
//- (void)pushLoginCurtain {
//
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:@"NotificationUserError"
//                                                  object:nil];
//
//    NSLog(@"请登录...");
//    LoginCurtain *loginView = [[LoginCurtain alloc] init];
//    loginView.refreshDelegate = self;
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginView];
//    [self presentViewController:nav animated:YES completion:nil];
//
//}
//
//- (void)refresh {
//
//    [self.delegate getMyCommentsByPage:1];
//}


#pragma mark - 加载.刷新

-(void)reloadDataWithType:(LoadType)type
{
    if (type == LoadTypeRefresh) {
        
        [self.delegate getMyCommentsByPage:1];
        _page = 1;
        
    } else {
        
        NSLog(@"begin load more message:");
        _page++;
        [self.delegate getMyCommentsByPage:_page];
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

//- (void)viewWillDisappear:(BOOL)animated
//{
//    [[ForthonDataContainer sharedStore] removeObserver:self forKeyPath:@"myComments"];
//}

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
