//
//  ForthonVastArtTable.m
//  Login
//
//  Created by Liu fushan on 15/5/20.
//  Copyright (c) 2015年 culturalCenter. All rights reserved.
//

#import "ForthonVastArtTable.h"
#import "UICommon.h"
#import "ForthonVastArtCell.h"
#import "ForthonDataSpider.h"
#import "RefreshControl.h"
#import "ForthonVastArtDescriptionView.h"
#import "ForthonTapGesture.h"
#import "UIImageView+WebCache.h"
#import "artSearchView.h"
#import "ForthonAuthorDescription.h"
#import "NSString+imageUrlString.h"
#import "SVProgressHUD.h"  


typedef enum {
    LoadTypeRefresh,
    LoadTypeLoadMore
}LoadType;

@interface ForthonVastArtTable ()


@property BOOL isOk;

@property int flag;
@property int page;
@property BOOL isLoading;

@property (nonatomic, strong) NSMutableArray *artArray;

@property (strong, nonatomic) UITableView *myTableView;
@property (strong, nonatomic) RefreshControl *myRefreshControl;

@property (strong, nonatomic) UIButton *loadButton;
@property (strong, nonatomic) UIImageView *loadImage;

@end

@implementation ForthonVastArtTable

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UICommon *commonUI = [[UICommon alloc] init];
    UILabel *navTitle = [commonUI navTitle:_typeStr];
    self.navigationItem.titleView = navTitle;
    self.navigationItem.backBarButtonItem = HiddenBack;

    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 44)];
    [btn addTarget:self action:@selector(searchArt) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:@"search_art"] forState:UIControlStateNormal];

//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search_art"] style:UIBarButtonItemStylePlain target:self action:@selector(searchArt)];


    _myTableView = [[UITableView alloc] init];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [_myTableView setFrame:CGRectMake(0, 65, WIDTH, HEIGHT - 45)];
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
    
    if (_canTrady) {

        if (![[ForthonDataContainer sharedStore].artTradeListDic[_categoryIndex - 1] count]) {

            [SVProgressHUD showWithStatus:@"加载中..."];
            _isLoading = YES;
            [self reloadDataWithType:LoadTypeRefresh];

        } else {

            [self updateUI];
        }

    } else {

        if (![[ForthonDataContainer sharedStore].artListDic[_categoryIndex - 1] count]) {

            [SVProgressHUD showWithStatus:@"加载中..."];
            _isLoading = YES;
            [self reloadDataWithType:LoadTypeRefresh];

        } else {

            [self updateUI];
        }
    }

    _myTableView.separatorStyle = NO;
    [self.view addSubview:_myTableView];


}

//- (void)viewWillDisappear:(BOOL)animated {
//
//    [SVProgressHUD dismiss];
//
//}

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
        
        [_delegate getArtListByTypeid:_categoryIndex trade:_canTrady page:1];
        _page = 1;
        
    } else {
        
        NSLog(@"begin load more message:");
        _page++;
        [_delegate getArtListByTypeid:_categoryIndex trade:_canTrady page:_page];
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

#pragma mark - 显示点击加载按键

- (void)showLoadButton {

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"NotificationNetError"
                                                  object:nil];

    [SVProgressHUD showErrorWithStatus:@"加载失败" maskType:SVProgressHUDMaskTypeBlack];
    if (![[ForthonDataContainer sharedStore].artListDic[_categoryIndex - 1] count]) {

        _loadButton.hidden = NO;
        _loadImage.hidden = NO;
    }

}

#pragma mark - 点击点击加载

- (void)reload {

    [SVProgressHUD showWithStatus:@"加载中..."];
    [_delegate getArtListByTypeid:_categoryIndex trade:_canTrady page:1];
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

    NSArray *rowsArray ;
    if (_canTrady) {

        rowsArray = [ForthonDataContainer sharedStore].artTradeListDic[_categoryIndex - 1];
    } else {

        rowsArray = [ForthonDataContainer sharedStore].artListDic[_categoryIndex - 1];
    }
    return [rowsArray count] / 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    int index = indexPath.row;
    static NSString *cellIdentifier = @"cell";
    ForthonVastArtCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ForthonVastArtCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell = [cell load];
    }
    
    
    cell.tag = index;
    cell.selectionStyle = NO;


    for (int i = 0; i < 2; i++)
    {
        NSMutableDictionary *dic;
        if (_canTrady) {

            dic = [ForthonDataContainer sharedStore].artTradeListDic[_categoryIndex - 1][index * 2 + i];

        } else {

            dic = [ForthonDataContainer sharedStore].artListDic[_categoryIndex - 1][index * 2 + i];
        }

        NSString *Name;
        if ([dic[@"userNickName"] length]) {

            Name = dic[@"userNickName"];
        } else {

            Name = dic[@"userName"];
        }
        NSString *headImageUrlString = dic[@"headImageUrlString"];
        NSString *artImageUrlString = dic[@"artImageUrlString"];
        
        ForthonTapGesture *tapHead = [[ForthonTapGesture alloc] initWithTarget:self  action:@selector(tapHeadImage:)];
        
        ForthonTapGesture *tapPicture = [[ForthonTapGesture alloc] initWithTarget:self action:@selector(tapPictureImage:)];
        tapPicture.tag = index * 2 + i;
        tapHead.tag = index * 2 + i;
        
        if (i == 0) {

            [cell.leftNameLabel setText:Name];
            [cell.leftHeadImageView sd_setImageWithURL:[NSURL URLWithString:headImageUrlString]];
            if ([artImageUrlString length]) {

                [cell.leftPictureView sd_setImageWithURL:[NSURL URLWithString:artImageUrlString]];
            }

            
            [cell.leftHeadImageView setTag:index];
            [cell.leftPictureView setTag:index];
            
        
            [cell.leftHeadImageView addGestureRecognizer:tapHead];
            [cell.leftPictureView addGestureRecognizer:tapPicture];
            cell.leftPictureView.userInteractionEnabled = YES;
            cell.leftHeadImageView.userInteractionEnabled = YES;
            
            
        } else {
            

            [cell.rightNameLabel setText:Name];
            [cell.rightHeadImageView sd_setImageWithURL:[NSURL URLWithString:headImageUrlString]];
            [cell.rightPictureView sd_setImageWithURL:[NSURL URLWithString:artImageUrlString]];
            
            [cell.rightHeadImageView setTag:index];
            [cell.rightPictureView setTag:index];

            [cell.rightHeadImageView addGestureRecognizer:tapHead];
            [cell.rightPictureView addGestureRecognizer:tapPicture];
            
            cell.rightPictureView.userInteractionEnabled = YES;
            cell.rightHeadImageView.userInteractionEnabled = YES;
            
        }
        
    }
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return BACKVIEWHEIGHT;
}

#pragma mark UpdateUI

- (void)updateUI
{
    _loadButton.hidden = YES;
    _loadImage.hidden = YES;
    if (_isLoading) {

        [SVProgressHUD showSuccessWithStatus:@"加载成功" maskType:SVProgressHUDMaskTypeBlack];
        _isLoading = NO;
    }

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationA" object:nil];

    if (_canTrady) {

        _artArray = [ForthonDataContainer sharedStore].artTradeListDic[_categoryIndex - 1];
    } else {

        _artArray = [ForthonDataContainer sharedStore].artListDic[_categoryIndex - 1];
    }
    for (int i = 0; i < [_artArray count]; i++) {
        NSString *artImageUrlStringBody = [_artArray[i] objectForKey:@"titleImg"];
        NSString *artImageUrlString = [artImageUrlStringBody changeToUrl];

        NSString *headImageUrlStringBody = [_artArray[i] objectForKey:@"userAvatarUrl"];
        NSString *headImageUrlString = [headImageUrlStringBody changeToUrl];
        
        if (artImageUrlString) {
            
             [_artArray[i] setObject:artImageUrlString forKey:@"artImageUrlString"];
        }
        
        [_artArray[i] setObject:headImageUrlString forKey:@"headImageUrlString"];
    }
    if (_canTrady) {
        
        NSLog(@"这个列表是可以交易的");
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


#pragma mark TapHeadImage&TapPicture


- (void)tapHeadImage:(ForthonTapGesture *)gesture
{
    
    NSLog(@"name %lu", gesture.tag);

    int index = gesture.tag;
    NSMutableDictionary *authorDic = _artArray[index];

    ForthonAuthorDescription *authorDescription = [ForthonAuthorDescription new];
    authorDescription.authorDic = authorDic;

    [self.navigationController pushViewController:authorDescription animated:YES];
}

- (void)tapPictureImage:(ForthonTapGesture *)gesture
{
    int index = gesture.tag;
    NSMutableDictionary *artDic = _artArray[index];

    ForthonVastArtDescriptionView *descriptionView = [[ForthonVastArtDescriptionView alloc] init];
    descriptionView.modelDic = artDic;


    [self.navigationController pushViewController:descriptionView animated:YES];
}

#pragma mark - 作品搜索

- (void)searchArt {
    
    NSLog(@"search beagin");
    artSearchView *artSearch = [[artSearchView alloc] init];
    artSearch.typeStr = [NSString stringWithFormat:@"%@搜索", _typeStr];
    artSearch.isTrade = _canTrady;
    artSearch.typeId = _categoryIndex;

    [self.navigationController pushViewController:artSearch animated:YES];
    
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

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
