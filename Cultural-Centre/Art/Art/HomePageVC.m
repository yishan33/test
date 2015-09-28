//
//  HomePageVC.m
//  Art
//
//  Created by Tang yuhua on 15/4/28.
//  Copyright (c) 2015年 test. All rights reserved.
//


#define UISCREENHEIGHT  self.view.bounds.size.height
#define UISCREENWIDTH  self.view.bounds.size.width

#import "HomePageVC.h"
#import "AdScrollView.h"
#import "ForthonDataSpider.h"
#import "ForthonVastArtDescriptionView.h"
#import "pageWebViewController.h"
#import "ForthonVideoDescription.h"


#define WIDTHPERCENTAGE WIDTH / 320
#define HEIGHTPERCENTAGE HEIGHT / 480

#define NAVHEIGHT 50 * HEIGHTPERCENTAGE

@interface HomePageVC ()

@property (nonatomic, strong) NSString *appUrl;

@property (nonatomic, strong) UIImageView *myTitleView;
@property (nonatomic, strong) AdScrollView *scrollView;

@property (assign, nonatomic) id <VersionDelegate> versionDelegate;

@end

@implementation HomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"HomePage");


    self.versionDelegate = [ForthonDataSpider sharedStore];
    [self.versionDelegate getVersion];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkUpdate:)
                                                 name:@"NotificationVersion"
                                               object:nil];

    self.delegate = [ForthonDataSpider sharedStore];
    [self.delegate getHomeBannerImages];

    [[ForthonDataContainer sharedStore] addObserver:self
                                         forKeyPath:@"imagesArray"
                                            options:NSKeyValueObservingOptionInitial
                                            context:NULL];

    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.navigationController.navigationBarHidden =YES;
    _myTitleView = [[UIImageView alloc]init];
    _myTitleView.frame = CGRectMake(0, 0, WIDTH, NAVHEIGHT);
    _myTitleView.image = [UIImage imageNamed:@"home_title_bg.png"];

    [self.navigationController.navigationBar addSubview:_myTitleView];
    NSLog(@"width : %f, height: %f", self.navigationItem.titleView.frame.size.width, self.navigationItem.titleView.frame.size.height);

    UILabel *homeStr = [[UILabel alloc] init];
    [homeStr setTextAlignment:NSTextAlignmentCenter];
    [homeStr setText:@"中国首家艺术品租赁平台"];
    [homeStr setTextColor:[UIColor whiteColor]];
    [homeStr setFont:[UIFont boldSystemFontOfSize:18.0]];
    [homeStr setFrame:CGRectMake(0, 0, WIDTH, 60)];
    [homeStr setCenter:CGPointMake(WIDTH / 2, NAVHEIGHT / 2 + 5 * HEIGHTPERCENTAGE)];
    [_myTitleView addSubview:homeStr];

    // 消除navigation 回退的back 。回退箭头设置为红色
    self.navigationItem.backBarButtonItem = HiddenBack;
    self.navigationController.navigationBar.tintColor = AppColor;


//    UIView *whiteIntervalView = [[UIView alloc] initWithFrame:CGRectMake(0, UISCREENWIDTH / 2 + NAVHEIGHT + 20, WIDTH, 20 * HEIGHTPERCENTAGE)];

    UIButton *appreciateButton = [[UIButton alloc]init];
    [appreciateButton setFrame:CGRectMake(0, UISCREENWIDTH / 2 + 64 + 20 * HEIGHTPERCENTAGE, WIDTH, (HEIGHT - 64 - UISCREENWIDTH / 2 - 48) / 2)];
    UIImageView *shangyiBack = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, (HEIGHT - 64 - UISCREENWIDTH / 2 - 48) / 2)];
    [shangyiBack setImage:[UIImage imageNamed:@"shang_yi_back.png"]];
    [appreciateButton addSubview:shangyiBack];

    UILabel *shangyiLabel = [UILabel new];
    [shangyiLabel setFont:[UIFont systemFontOfSize:16.0]];
    shangyiLabel.textColor = AppColor;
    [shangyiLabel setTextAlignment:NSTextAlignmentCenter];
    [shangyiLabel setText:@"赏艺"];
    [shangyiLabel setFrame:CGRectMake(0, 0, 60 * WIDTHPERCENTAGE, 25 * HEIGHTPERCENTAGE)];
    [shangyiLabel setCenter:CGPointMake(WIDTH / 2, (HEIGHT - 64 - UISCREENWIDTH / 2 - 48) / 4 + 7 * HEIGHTPERCENTAGE)];
//    [shangyiLabel setBackgroundColor:[UIColor grayColor]];

    UILabel *shangLabel = [UILabel new];
    [shangLabel setFont:[UIFont systemFontOfSize:14.0]];
    [shangLabel setText:@"Aritistic Appreciation"];
    [shangLabel setTextAlignment:NSTextAlignmentCenter];
    shangLabel.textColor = AppColor;
//    [shangLabel setBackgroundColor:[UIColor yellowColor]];
    [shangLabel setFrame:CGRectMake(0, 0, 200 * WIDTHPERCENTAGE, 25 * HEIGHTPERCENTAGE)];
    [shangLabel setCenter:CGPointMake(WIDTH / 2, (HEIGHT - 64 - UISCREENWIDTH / 2 - 48) / 4 + 23 * HEIGHTPERCENTAGE)];

    [shangyiBack addSubview:shangyiLabel];
    [shangyiBack addSubview:shangLabel];


    [appreciateButton addTarget:self action:@selector(appreciateArt) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:appreciateButton];
    
    UIView *redIntervalView = [[UIView alloc] initWithFrame:CGRectMake(0, (HEIGHT + 64 + UISCREENWIDTH / 2 - 48) / 2 + 20 * HEIGHTPERCENTAGE, WIDTH, 12 * HEIGHTPERCENTAGE)];
    redIntervalView.backgroundColor = [UIColor colorWithRed:230.0 / 255.0 green:0.0 blue:0.0 alpha:1.0];
    [self.view addSubview:redIntervalView];

    UIButton *tradeButton = [[UIButton alloc]init];
    [tradeButton setFrame:CGRectMake(0, (HEIGHT + 64 + UISCREENWIDTH / 2 - 48) / 2 + 32 * HEIGHTPERCENTAGE , WIDTH,  (HEIGHT - 64 - UISCREENWIDTH / 2 - 48) / 2 - 20 * HEIGHTPERCENTAGE)];

    UILabel *yiyiLabel = [UILabel new];
    [yiyiLabel setFont:[UIFont systemFontOfSize:16.0]];
    yiyiLabel.textColor = AppColor;
    [yiyiLabel setTextAlignment:NSTextAlignmentCenter];
    [yiyiLabel setText:@"易艺"];
    [yiyiLabel setFrame:CGRectMake(0, 0, 60 * WIDTHPERCENTAGE, 25 * HEIGHTPERCENTAGE)];
    [yiyiLabel setCenter:CGPointMake(WIDTH / 2, (HEIGHT - 64 - UISCREENWIDTH / 2 - 48) / 4 - 20 * HEIGHTPERCENTAGE)];
//    [shangyiLabel setBackgroundColor:[UIColor grayColor]];

    UILabel *yiLabel = [UILabel new];
    [yiLabel setFont:[UIFont systemFontOfSize:14.0]];
    [yiLabel setText:@"Art Trade"];
    [yiLabel setTextAlignment:NSTextAlignmentCenter];
    yiLabel.textColor = AppColor;
//    [shangLabel setBackgroundColor:[UIColor yellowColor]];
    [yiLabel setFrame:CGRectMake(0, 0, 200, 25 * HEIGHTPERCENTAGE)];
    [yiLabel setCenter:CGPointMake(WIDTH / 2, (HEIGHT - 64 - UISCREENWIDTH / 2 - 48) / 4 - 4 * HEIGHTPERCENTAGE)];

    [tradeButton addSubview:yiyiLabel];
    [tradeButton addSubview:yiLabel];


    [tradeButton addTarget:self action:@selector(tradeArt) forControlEvents:UIControlEventTouchUpInside];
    [tradeButton setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:tradeButton];

    NSLog(@"homeDidLoad");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)appreciateArt
{
    WHERE;
    YHAppreciateArtVC *appre = [[YHAppreciateArtVC alloc]init];
    appre.hidesBottomBarWhenPushed =YES;
    [self.navigationController pushViewController:appre animated:YES];
}
-(void)tradeArt
{
    WHERE;
    YHArtTradeVC *trade = [[YHArtTradeVC alloc]initWithNibName:@"YHArtTradeVC" bundle:nil];
    trade.hidesBottomBarWhenPushed =YES;
    [self.navigationController pushViewController:trade animated:YES];
}

-(void)setButton:(UIButton *)button  withFrame:(CGRect) frame withImage:(UIImage *)image withTitle:(NSString *)title {
    
    
    NSLog(@"%@>>",NSStringFromCGSize(image.size));
    [button setBackgroundImage:image forState:UIControlStateNormal];
    
    [button setBackgroundColor:[UIColor whiteColor]];
    [button setFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];

    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar addSubview:_myTitleView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_myTitleView removeFromSuperview];
}

#pragma mark - 监听回调

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    if ([keyPath isEqualToString:@"imagesArray"] && [[[ForthonDataContainer sharedStore] valueForKey:@"imagesArray"] count]) {

        NSArray *imagesArray = [[ForthonDataContainer sharedStore] valueForKey:@"imagesArray"];
        [self createScrollViewWithImagesArray:imagesArray];
//        [[ForthonDataContainer sharedStore] removeObserver:self forKeyPath:@"imagesArray"];
    }

}


#pragma mark - 构建广告滚动视图
- (void)createScrollViewWithImagesArray:(NSArray *)imagesArray
{
    UIView *scrollBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 20 + NAVHEIGHT, UISCREENWIDTH, UISCREENWIDTH / 2)];
    [self.view addSubview:scrollBackView];

    AdScrollView * _scrollView = [[AdScrollView alloc]initWithFrame:CGRectMake(0, 0, UISCREENWIDTH, UISCREENWIDTH / 2)];
    _scrollView.imagesArray = imagesArray;
    _scrollView.PageControlShowStyle = UIPageControlShowStyleRight;
    _scrollView.pushDelegate = self;
    [scrollBackView addSubview:_scrollView];
}

- (void)pushVideoDescriptionWithDic:(NSMutableDictionary *)dic {

    ForthonVideoDescription *videoDescription = [[ForthonVideoDescription alloc] init];
    NSString *category = [NSString stringWithFormat:@"%@", dic[@"typeId"]];
    NSMutableDictionary *objectDic = [[NSMutableDictionary alloc] init];

    [objectDic setObject:category forKey:@"category"];
    [objectDic setObject:@"0" forKey:@"favor"];
    [objectDic setObject:@"0" forKey:@"follow"];
    [objectDic setObject:@"10000000" forKey:@"tinyTag"];
    [objectDic setObject:dic forKey:@"modelDic"];
    videoDescription.videoModelDic = objectDic;
    videoDescription.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:videoDescription animated:YES];
}

- (void)pushArtDescriptionWithDic:(NSMutableDictionary *)dic {

    ForthonVastArtDescriptionView *descriptionView = [[ForthonVastArtDescriptionView alloc] init];
    descriptionView.modelDic = dic;
    descriptionView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:descriptionView animated:YES];
}

- (void)pushPaperViewWithDic:(NSDictionary *)dic {

    pageWebViewController *pageView = [[pageWebViewController alloc] init];
    [pageView setPageDic:dic];
    pageView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pageView  animated:YES];
}


- (void)checkUpdate:(NSNotification *)notification {
    
    NSString *version = notification.userInfo[@"version"];
    _appUrl = notification.userInfo[@"appUrl"];

    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *nowVersion = infoDict[@"CFBundleVersion"];

    NSLog(@"nowVersion == %@",nowVersion);
    NSLog(@"url: %@", _appUrl);

    if ([version isEqualToString:nowVersion]) {

        NSLog(@"最新");
    } else {

        UIAlertView *createUserResponseAlert = [[UIAlertView alloc] initWithTitle:@"提示" message: @"有新的版本可供下载" delegate:self cancelButtonTitle:@"下次再说" otherButtonTitles: @"去下载", nil];
        createUserResponseAlert.delegate = self;
        [createUserResponseAlert show];
    }

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationVersion" object:nil];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_appUrl]];

    }
}




@end
