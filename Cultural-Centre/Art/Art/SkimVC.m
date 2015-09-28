//
//  SkimVC.m
//  Art
//
//  Created by Tang yuhua on 15/4/28.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "SkimVC.h"
#import "Common.h"
#import "ForthonSkimPaperCell.h"
#import "ForthSkimPersonCell.h"
#import "ForthonDataSpider.h"
#import "pageWebViewController.h"
#import "ForthonVastArtDescriptionView.h"
#import "ForthonAuthorDescription.h"
#import "LoginCurtain.h"
#import "ForthonVideoDescription.h"
#import "SVProgressHUD.h"
#import "RefreshControl.h"


#define WIDTH [UIScreen mainScreen].applicationFrame.size.width
#define HEIGTH [UIScreen mainScreen].applicationFrame.size.height

#define WIDTHPERCENTAGE WIDTH / 320
#define HEIGHTPERCENTAGE HEIGHT / 480

#define WIDTH_2_PERCENTAGE WIDTH / 720
#define HEIGHT_2_PERCENTAGE HEIGHT / 1250

#define TOPVIEWWIDTH WIDTH
#define TOPVIEWHEIGHT 40 * HEIGHTPERCENTAGE                 // 分类视图的长宽,最顶部装载三个按钮的视图

#define TOPVIEW_L_INTERVAL 15 * WIDTHPERCENTAGE            //评论TOP20按钮距离屏幕左边的距离

#define TOPBUTTONWIDTH (WIDTH - 2 * TOPVIEW_L_INTERVAL) / 3
#define TOPBUTTONHEIGHT TOPVIEWHEIGHT  // 分类按钮（评论/浏览/新晋）长宽


#define SIDEINTERVAL 30 * WIDTH_2_PERCENTAGE
#define MIDDLEINTERVAL 50 * HEIGHT_2_PERCENTAGE


#define TEXTLABELWIDTH WIDTH - 4 * SIDEINTERVAL
#define TEXTLABELHEIGHT (ADVISERHEIGHT / 2 - 5 * MIDDLEINTERVAL)

#define ADVISERHEIGHT (HEIGHT - TOPVIEWHEIGHT - 95)


@interface SkimVC ()

<
PushDescriptionView
>
@property (nonatomic, strong) UILabel *navTitle;

@property (nonatomic, strong) UIButton *commentTop;
@property (nonatomic, strong) UIButton *skimTop;
@property (nonatomic, strong) UIButton *updateTop;  //新晋

@property (nonatomic, strong) ForthSkimPersonCell *returnAuthor;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) RefreshControl * myRefreshControl;
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) NSMutableArray *topDataArray;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) ForthonVastArtDescriptionView *descriptionView;
@property (nonatomic, strong) pageWebViewController *pageView;
@property (nonatomic, strong) ForthonAuthorDescription *authorDescriptionView;

@property BOOL newIsFirstLoad;
@property int currentView;

@property (nonatomic, strong) UIButton *loadButton;
@property (nonatomic, strong) UIImageView *loadImage;


@end


typedef enum {
    CellTypePaper,
    CellTypePerson
}CellType;

typedef enum{
    DataTypeComment,
    DataTypeSkim,
    DataTypeUpdate
}DataType;

CellType TableCellType;
SkimViewType ReturnDataType;


@implementation SkimVC

- (void)viewDidLoad {
    [super viewDidLoad];

    UICommon *commonUI = [[UICommon alloc] init];
    _navTitle = [commonUI navTitle:@"点击排行"];
    
    self.navigationItem.titleView = _navTitle;
    self.navigationItem.backBarButtonItem = HiddenBack
    self.navigationController.navigationBar.tintColor = AppColor;
    
    _delegate = [ForthonDataSpider  sharedStore];
    _topDataArray = [[NSMutableArray alloc] init];//初始化数据数组（存放评论TOP20、浏览、新晋）

    _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 75, WIDTH, HEIGHT - 75)];
    [_scroll setContentSize:CGSizeMake(WIDTH * 2, HEIGHT - 75)];

    UIView *adviserView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH, TOPBUTTONHEIGHT, WIDTH, ADVISERHEIGHT)];
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, ADVISERHEIGHT / 2)];
    [image setImage:[UIImage imageNamed:@"yiyi_adviser_img.png"]];
    [image setBackgroundColor:[UIColor purpleColor]];
    [adviserView addSubview:image];
    
    UIView *textView = [[UIView alloc] initWithFrame:CGRectMake(SIDEINTERVAL , MIDDLEINTERVAL + ADVISERHEIGHT / 2, WIDTH - SIDEINTERVAL * 2, TEXTLABELHEIGHT +  MIDDLEINTERVAL)];
    [textView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"yiyi_adviser_bg.png"]]];
    [adviserView addSubview:textView];
    
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIDEINTERVAL, MIDDLEINTERVAL / 2, TEXTLABELWIDTH, TEXTLABELHEIGHT)];
    [textLabel setText:@"    我们的私人艺术顾问会帮您找到您的精神语言,丰富您的私人空间。在您每日看到墙上的艺术品时,能在视觉和精神上感到愉悦。"];
    [textLabel setTextColor:[UIColor blackColor]];
//    [textLabel setBackgroundColor:[UIColor orangeColor]];
    [textLabel setNumberOfLines:4];
    
    [textView addSubview:textLabel];



    UIImageView *messageIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yiyi_adviser_msg.png"]];
    [messageIcon setFrame:CGRectMake(0, 5, 20, 10)];


    UIButton *connectionLabel = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 100, ADVISERHEIGHT / 2 + TEXTLABELHEIGHT + 2 * MIDDLEINTERVAL + 5, 100, 20)];
//    [connectionLabel setBackgroundColor:[UIColor greenColor]];
    [connectionLabel setTitle:@"联系我们" forState:UIControlStateNormal];
    [connectionLabel.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [connectionLabel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [connectionLabel addSubview:messageIcon];
    [connectionLabel addTarget:self action:@selector(connectionUs) forControlEvents:UIControlEventTouchUpInside];
//    [connectionLabel setBackgroundColor:[UIColor purpleColor]];
    [adviserView addSubview:connectionLabel];

    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((WIDTH - 50) / 2, 70, 50, 10)];
    [self.view addSubview:_pageControl];
    _pageControl.currentPageIndicatorTintColor = AppColor;
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
//    [pageControl setBackgroundColor:AppColor];
    [_pageControl setNumberOfPages:2];
    
    
    UIView *categoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, TOPVIEWHEIGHT)];
//    [categoryView setBackgroundColor:[UIColor purpleColor]];
    
    
    
    for (int i = 0; i < 3; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(TOPVIEW_L_INTERVAL + i * TOPBUTTONWIDTH, 0, TOPBUTTONWIDTH, TOPBUTTONHEIGHT)];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [categoryView addSubview:button];
        switch (i) {
            case 0:
                
                [button setTitle:@"评论TOP20" forState:UIControlStateNormal];
                [button addTarget:self action:@selector(getCommentTop:) forControlEvents:UIControlEventTouchUpInside];
                _commentTop = button;
                break;
            
            case 1:
                [button setTitle:@"浏览TOP20" forState:UIControlStateNormal];
                [button addTarget:self action:@selector(getSkimTop:) forControlEvents:UIControlEventTouchUpInside];
                _skimTop = button;
                break;
                
            case 2:
                [button setTitle:@"新晋TOP10" forState:UIControlStateNormal];
                [button addTarget:self action:@selector(getNewTop:) forControlEvents:UIControlEventTouchUpInside];
                _updateTop = button;
        
            default:
                break;
                
        }
    }
    
    
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(TOPVIEW_L_INTERVAL + TOPBUTTONWIDTH, (TOPBUTTONHEIGHT - 20 * HEIGHTPERCENTAGE) / 2, 1, 20 * HEIGHTPERCENTAGE)];
    [line1 setBackgroundColor:AppColor];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(TOPVIEW_L_INTERVAL + 2 * TOPBUTTONWIDTH, (TOPBUTTONHEIGHT - 20 * HEIGHTPERCENTAGE) / 2, 1, 20 * HEIGHTPERCENTAGE)];
    [line2 setBackgroundColor:AppColor];
    
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, TOPVIEWHEIGHT, WIDTH, HEIGHT - 65 - TOPVIEWHEIGHT - 30)];
    
    [_table setContentSize:CGSizeMake(WIDTH * 2, _table.contentSize.height)];
    [_table setDelegate:self];
    [_table setDataSource:self];
    _table.separatorStyle = NO;
//    [_table setBackgroundColor:[UIColor yellowColor]];
     self.automaticallyAdjustsScrollViewInsets = NO;

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
//    _myRefreshControl.bottomEnabled = YES;
    
    
    [categoryView addSubview:line1];
    [categoryView addSubview:line2];
    
    [_scroll setDelegate:self];
    _scroll.bounces = NO;
    _scroll.showsHorizontalScrollIndicator = NO;
    [_scroll addSubview:_table];
    [_scroll addSubview:categoryView];
    [_scroll addSubview:adviserView];
    
    [self.view addSubview:_scroll];
    [self getCommentTop:_commentTop];
    
    [[ForthonDataContainer sharedStore] addObserver:self forKeyPath:@"commentTop" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    [[ForthonDataContainer sharedStore] addObserver:self forKeyPath:@"skimTop" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    [[ForthonDataContainer sharedStore] addObserver:self forKeyPath:@"newsTop" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];

}


#pragma mark - 显示点击加载按键

- (void)showLoadButton {

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"NotificationNetError"
                                                  object:nil];
    [SVProgressHUD showErrorWithStatus:@"加载失败" maskType:SVProgressHUDMaskTypeBlack];
    if (![_topDataArray count]) {

//        _table.frame = CGRectMake(0, 64, WIDTH, self.view.frame.size.height - 64);
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

    [self.delegate getSkimsByType:ReturnDataType];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showLoadButton)
                                                 name:@"NotificationNetError"
                                               object:nil];


}



#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_topDataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (TableCellType == CellTypePaper) {
        return PAPERBACKVIEWHEIGHT;
        
    } else {
        return PERSONBACKVIEWHEIGHT;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = (int)indexPath.row;
    static NSString *paperIdentifier = @"papercell";
    static NSString *personIdentifier = @"personcell";

    if (TableCellType == CellTypePaper) {
        
        NSLog(@"cellpaperupdate");
        ForthonSkimPaperCell  *cell = [tableView dequeueReusableCellWithIdentifier:paperIdentifier];
        if (cell == nil) {
            
            cell = [[ForthonSkimPaperCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:paperIdentifier];
            [cell loadCellView];

        }
        [cell loadWithData:_topDataArray[index]];
        
         return cell ;
    } else {
        
        NSLog(@"updateCellPerson");
        ForthSkimPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:personIdentifier];
        
        if (cell == nil) {
            cell = [[ForthSkimPersonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:personIdentifier];
            [cell loadCellView];
        }
       
        [cell loadWithData:_topDataArray[index]];
        cell.loginDelegate = self;
        cell.pushDelegate = self;
        [cell getFollowStatus];
        cell.headImageView.userInteractionEnabled = YES;
        
        
        NSLog(@"index: %i", index);
        return cell ;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = indexPath.row;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    NSDictionary *dic = _topDataArray[index];
    if ([[dic objectForKey:@"type"] intValue] == 3) {
        
        [self pushPaperViewWithDic:[dic objectForKey:@"obj"]];
    } else if ([[dic objectForKey:@"type"] intValue] == 2) {
        
        [self pushArtDescriptionViewWithDic:[dic objectForKey:@"obj"]];
    }
      else if([[dic objectForKey:@"type"] intValue] == 1) {
        
        [self pushVideoDescriptionWithDic:[dic objectForKey:@"obj"]];
    }
    
}

#pragma mark buttonChangeView

- (void)getCommentTop:(UIButton *)button
{
    [button setTitleColor:AppColor forState:UIControlStateNormal];
    [_skimTop setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_updateTop setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    if (![[ForthonDataContainer sharedStore] valueForKey:@"commentTop"]) {
        
        [_delegate getSkimsByType:SkimViewTypeComment];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(showLoadButton)
                                                     name:@"NotificationNetError"
                                                   object:nil];

    } else {
        _topDataArray = [[ForthonDataContainer sharedStore] valueForKey:@"commentTop"];
        [_table reloadData];
    }

    TableCellType = CellTypePaper;
    ReturnDataType = SkimViewTypeComment;
    _currentView = 1;
    
    NSLog(@"get comment top");
}


- (void)getSkimTop:(UIButton *)button
{
    
    [button setTitleColor:AppColor forState:UIControlStateNormal];
    [_commentTop setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_updateTop setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    if (![[ForthonDataContainer sharedStore] valueForKey:@"skimTop"]) {
         [_delegate getSkimsByType:SkimViewTypeSkim];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(showLoadButton)
                                                     name:@"NotificationNetError"
                                                   object:nil];
    } else {
        _topDataArray = [[ForthonDataContainer sharedStore] valueForKey:@"skimTop"];
        [_table reloadData];
    }
   
    TableCellType = CellTypePaper;
    ReturnDataType = SkimViewTypeSkim;
    _currentView = 2;
//    [_table reloadData];
    NSLog(@"get skim top");
    
}

- (void)getNewTop:(UIButton *)button
{
    [button setTitleColor:AppColor forState:UIControlStateNormal];
    [_skimTop setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_commentTop setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    if (![[ForthonDataContainer sharedStore] valueForKey:@"newsTop"]) {
        
        [_delegate getSkimsByType:SkimViewTypeNew];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(showLoadButton)
                                                     name:@"NotificationNetError"
                                                   object:nil];
        _newIsFirstLoad = YES;
    } else {
        _topDataArray = [[ForthonDataContainer sharedStore] valueForKey:@"newsTop"];
        [_table reloadData];
        _newIsFirstLoad = NO;
    }
    
    TableCellType = CellTypePerson;
     ReturnDataType = SkimViewTypeNew;
    _currentView = 3;

    NSLog(@"get new top");
    
  
}

    



#pragma mark ScrollView

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _table) {
        NSLog(@"is table");
    }
    if (scrollView == _scroll) {
        
        if ((scrollView.contentOffset.x < WIDTH / 2) ) {
            
            NSLog(@"is scrollView _ 2");
            [_pageControl setCurrentPage:0];
            [_navTitle setText:@"点击排行"];
            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            //        NSLog(@" x is less than half %f",scrollView.contentOffset.x);
        } else {
            [_navTitle setText:@"艺术顾问"];
            [_pageControl setCurrentPage:1];
            [scrollView setContentOffset:CGPointMake(WIDTH, 0) animated:YES];
            //        NSLog(@"x is more than half %f",scrollView.contentOffset.x);
            
        }
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == _table) {
        NSLog(@"is table");
    }
    
    if (scrollView == _scroll) {
        
        if ((scrollView.contentOffset.x < WIDTH / 2) ) {
            [_navTitle setText:@"点击排行"];
            [_pageControl setCurrentPage:0];
            NSLog(@"is scrollView _ 2");
            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            //        NSLog(@" x is less than half %f",scrollView.contentOffset.x);
        } else {
            [_navTitle setText:@"艺术顾问"];
            [_pageControl setCurrentPage:1];
            [scrollView setContentOffset:CGPointMake(WIDTH, 0) animated:YES];
            //        NSLog(@"x is more than half %f",scrollView.contentOffset.x);
            
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 选中cell实现跳转

- (void)pushPaperViewWithDic:(NSDictionary *)dic
{

    
    pageWebViewController *pageView = [[pageWebViewController alloc] init];
    pageView.pageDic = dic;

    pageView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pageView animated:YES];
}

- (void)pushArtDescriptionViewWithDic:(NSDictionary *)workDic
{
    ForthonVastArtDescriptionView *artDescription = [[ForthonVastArtDescriptionView alloc] init];
    artDescription.modelDic = workDic;

    artDescription.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:artDescription animated:YES];
}


- (void)pushVideoDescriptionWithDic:(NSDictionary *)dic {
    
    NSMutableDictionary *objecDic = [NSMutableDictionary new];
    [objecDic setObject:@"0" forKey:@"favor"];
    [objecDic setObject:@"0" forKey:@"follow"];
    [objecDic setObject:dic forKey:@"modelDic"];
    
    ForthonVideoDescription *videoDescription = [[ForthonVideoDescription alloc] init];
    videoDescription.videoModelDic = objecDic;
    videoDescription.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:videoDescription animated:YES];
}


- (void)pushAuthorDescriptionWithDic:(NSMutableDictionary *)dic returnObject:(id)object {

    NSLog(@"ready to push");
    _returnAuthor = object;
    ForthonAuthorDescription *authorDescriptionView = [[ForthonAuthorDescription alloc] init];
    authorDescriptionView.authorDic = dic;
    authorDescriptionView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:authorDescriptionView animated:YES];
}


#pragma mark 刷新方法

- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction
{
    
    
    __weak typeof(self)weakSelf=self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf)strongSelf=weakSelf;
        if (direction == RefreshDirectionTop) {
            if (_currentView == 1) {
                NSLog(@"刷新评论Top");
                [_delegate getSkimsByType:SkimViewTypeComment];
                
            } else if (_currentView == 2) {
                
                [_delegate getSkimsByType:SkimViewTypeSkim];
                NSLog(@"刷新浏览Top");
                
            } else {
                
                [_delegate getSkimsByType:SkimViewTypeNew];
                NSLog(@"刷新新晋Top");
                
            }
            
        }
        
    });
    
}


#pragma mark 监听回调

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {


//    if ([keyPath isEqualToString:@"appIsLogin"]) {
//
//        _topDataArray = [[ForthonDataContainer sharedStore] valueForKey:@"newsTop"];
//        [_table reloadData];
//
//    } else {
//
//    _topDataArray = [[ForthonDataContainer sharedStore] valueForKey:keyPath];
//    [_table reloadData];
//    [self.myRefreshControl finishRefreshingDirection:RefreshDirectionTop];
//    }
//
    if ([keyPath isEqualToString:@"newsTop"] || [keyPath isEqualToString:@"skimTop"] || [keyPath isEqualToString:@"commentTop"]) {

        _topDataArray = [[ForthonDataContainer sharedStore] valueForKey:keyPath];
        if ([_topDataArray count]) {

            _loadButton.hidden = YES;
            _loadImage.hidden = YES;
            [SVProgressHUD showSuccessWithStatus:@"加载成功" maskType:SVProgressHUDMaskTypeBlack];
        }
        [_table reloadData];
        [self.myRefreshControl finishRefreshingDirection:RefreshDirectionTop];
    }

}


- (void)viewWillAppear:(BOOL)animated
{
    if ( self.tabBarController.tabBar.hidden == YES) {
        self.tabBarController.tabBar.hidden = NO;
    }
    
    if (_returnAuthor) {
        [_returnAuthor getFollowStatus];
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
    
    [_table reloadData];
}


#pragma mark - 联系我们
- (void)connectionUs {

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"艺术品私人定制,请联系电话 15928580431" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];

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
