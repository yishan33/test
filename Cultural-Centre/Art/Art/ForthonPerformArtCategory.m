//
//  testTableTableViewController.m
//  Login
//
//  Created by Liu fushan on 15/5/17.
//  Copyright (c) 2015年 culturalCenter. All rights reserved.
//

#import "ForthonPerformArtCategory.h"
#import "performMeasurement.h"
#import "ForthonDataContainer.h"
#import "ForthonTapGesture.h"
#import "ForthonDataSpider.h"
#import "UIImageView+WebCache.h"
#import "ForthonAuthorDescription.h"
#import "ForthonVideoDescription.h"
#import "LoginCurtain.h"
#import "ForthonVideoCell.h"
#import "ForthonVideoDescription.h"
#import "NSString+imageUrlString.h"
#import "SVProgressHUD.h"
#import "UICommon.h"


#import "RefreshControl.h"

#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

typedef enum {
    LoadTypeRefresh,
    LoadTypeLoadMore
}LoadType;

@interface ForthonPerformArtCategory ()
<
PushAuthorDelegate
>

@property BOOL isFirstLoad;

@property (nonatomic, strong) RefreshControl * myRefreshControl;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *videoImageArray;

@property (nonatomic, strong) UIButton *loadButton;
@property (nonatomic, strong) UIImageView *loadImage;

@property (nonatomic, strong) ForthonVideoCell *reloadCell;

@property int flag;
@property int page;


@end

@implementation ForthonPerformArtCategory

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.backBarButtonItem = HiddenBack;

    UICommon *commonUI = [[UICommon alloc] init];
    NSArray *categoryName = @[@"油画",@"书法",@"篆刻",@"国画",@"雕塑",@"版画"];
    UILabel *navTitle = (UILabel *) [commonUI navTitle:categoryName[_categoryIndex - 1]];
    self.navigationItem.titleView = navTitle;



    _myTableView = [[UITableView alloc] init];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [_myTableView setFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64)];
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

//    _loadImage.backgroundColor = [UIColor purpleColor];
    _loadImage.hidden = YES;

    _page = 1;
     self.delegate = [ForthonDataSpider sharedStore];

    _isFirstLoad = YES;
    _myRefreshControl = [[RefreshControl alloc] initWithScrollView:_myTableView delegate:self];
    _myRefreshControl.topEnabled = YES;
    _myRefreshControl.bottomEnabled = YES;

    
    
    if (![[ForthonDataContainer sharedStore].videosDic[_categoryIndex - 1] count] ) {

        [SVProgressHUD showWithStatus:@"加载中..."];
        [self reloadDataWithType:LoadTypeRefresh];

    }
    
    
    _myTableView.separatorStyle = NO;
    [self.view addSubview:_myTableView];
}

- (void)viewWillDisappear:(BOOL)animated {

    [SVProgressHUD dismiss];
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

-(void)reloadDataWithType:(LoadType)type
{
    if (type == LoadTypeRefresh) {
        
        [_delegate getVideosByTypeid:_categoryIndex page:1];
        _page = 1;
        
    } else {
        
        NSLog(@"begin load more message:");
        _page++;
        [_delegate getVideosByTypeid:_categoryIndex page:_page];
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


- (void)reload {

    [SVProgressHUD showWithStatus:@"加载中..."];
    [_delegate getVideosByTypeid:_categoryIndex page:1];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return [[ForthonDataContainer sharedStore].videosDic[_categoryIndex - 1] count];
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return BACKVIEWHEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    int index = (int)indexPath.row;
    NSLog(@"reload cellView: %i", index);
    static NSString *cellIdentifier = @"cell";

    ForthonVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ForthonVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
        [cell loadView];
        cell.typeId = 1;
        cell.pushType = 1;

   
    }

    NSDictionary *dic = [ForthonDataContainer sharedStore].videosDic[_categoryIndex - 1][index];
    [cell embarkWithDictionary:dic];
    
    
    cell.tinyTag = index;
    cell.categoryIndex = _categoryIndex;
    cell.loginDelegate = self;
    [cell setPushDelegate:self];
    [cell getFollowStatus];
    [cell getFavorStatus];
    cell.videoImage.userInteractionEnabled = YES;
    cell.headImageView.userInteractionEnabled = YES;
    
    
    return cell;

}


- (void)addSkimNumber:(UIButton *)sender
{
    NSLog(@"%i", sender.tag);
}

- (void)beginPushViewWithDic:(NSMutableDictionary *)dic
{

    ForthonVideoDescription *videoDescription = [[ForthonVideoDescription alloc] init];
    videoDescription.videoModelDic = dic;
    [videoDescription setAddSkimNumberDelegate:[dic objectForKey:@"viewObject"]];
    _reloadCell = [dic objectForKey:@"viewObject"];
    [self.navigationController pushViewController:videoDescription animated:YES];

}


- (void)pushAuthorDescriptionWitDic:(NSMutableDictionary *)dic {

    NSLog(@"push author description view");

    ForthonAuthorDescription *authorView = [[ForthonAuthorDescription alloc] init];
    authorView.authorDic = dic;
    [self.navigationController pushViewController:authorView animated:YES];
}

- (void)updateUI
{
    NSLog(@"Now: updateUI:-------");

    _loadButton.hidden = YES;
    _loadImage.hidden = YES;
    _isFirstLoad = NO;
    [SVProgressHUD showSuccessWithStatus:@"加载成功" maskType:SVProgressHUDMaskTypeBlack];

    for (int i = 0; i < [[ForthonDataContainer sharedStore].videosDic[_categoryIndex - 1] count]; i++) {
        NSString *videoImageUrlStringBody = [[ForthonDataContainer sharedStore].videosDic[_categoryIndex - 1][i] objectForKey:@"picUrl"];
        NSString *videoImageUrlString = [videoImageUrlStringBody changeToUrl];

        NSString *headImageUrlStringBody = [[ForthonDataContainer sharedStore].videosDic[_categoryIndex - 1][i] objectForKey:@"userAvatarUrl"];
        NSString *headImageUrlString = [headImageUrlStringBody changeToUrl];
        [[ForthonDataContainer sharedStore].videosDic[_categoryIndex - 1][i] setObject:headImageUrlString forKey:@"headImageUrlString"];
        [[ForthonDataContainer sharedStore].videosDic[_categoryIndex - 1][i] setObject:videoImageUrlString forKey:@"videoImageUrlString"];
    }

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationA" object:nil];
    [_myTableView reloadData];
    [self refreshControlBack];

}


- (void)showLoadButton {

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"NotificationNetError"
                                                  object:nil];

    [SVProgressHUD showErrorWithStatus:@"加载失败" maskType:SVProgressHUDMaskTypeBlack];

    if (![[ForthonDataContainer sharedStore].videosDic[_categoryIndex - 1] count]) {

        _loadButton.hidden = NO;
        _loadImage.hidden = NO;
    }

    [self refreshControlBack];
};


- (void)refreshControlBack {

    if (self.myRefreshControl.refreshingDirection == RefreshingDirectionTop)
    {
        [self.myRefreshControl finishRefreshingDirection:RefreshDirectionTop];
    }
    else if (self.myRefreshControl.refreshingDirection == RefreshingDirectionBottom)
    {

        [self.myRefreshControl finishRefreshingDirection:RefreshDirectionBottom];

    }

}

- (void)pushLoginCurtain
{
    NSLog(@"请登录...");
    LoginCurtain *loginView = [[LoginCurtain alloc] init];
    loginView.refreshDelegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginView];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)refresh
{
    [self reloadDataWithType:LoadTypeRefresh];
}


- (void)viewWillAppear:(BOOL)animated
{
    if (_reloadCell) {
        [_reloadCell getFavorStatus];
        [_reloadCell getFollowStatus];
        _reloadCell.shareNumberLabel.text = [[ForthonDataContainer sharedStore].videosDic[_categoryIndex - 1][_reloadCell.tinyTag][@"share"] stringValue];

    }


}



/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 
 
 
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
