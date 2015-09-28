//
//  YHTradeOfArtVC.m
//  Art
//
//  Created by Tang yuhua on 15/6/24.
//  Copyright (c) 2015年 test. All rights reserved.
//


#define UISCREENHEIGHT  self.view.bounds.size.height
#define UISCREENWIDTH  self.view.bounds.size.width



#import "Common.h"
#import "YHTradeOfArtVC.h"
#import "AdScrollView.h"
#import "ForthonDataContainer.h""
#import "ForthonVastArtTable.h"
#import "ForthonDataSpider.h"
#import "ForthonVideoDescription.h"
#import "ForthonVastArtDescriptionView.h"
#import "pageWebViewController.h"
#import "ForthonTapGesture.h"

#define LINE_HEIGHT 40.0f
#define IMAE_HEIGHT (HEIGHT - LINE_HEIGHT - WIDTH/2 - 94) / 3
#define START_IMAGE (WIDTH/2+LINE_HEIGHT)

@interface YHTradeOfArtVC ()


@end

@implementation YHTradeOfArtVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.backBarButtonItem = HiddenBack;

    self.delegate = [ForthonDataSpider sharedStore];
    if ([[[ForthonDataContainer sharedStore] valueForKey:@"tradeImagesArray"] count]) {

        [self readyToCreateScrollView];

    } else {

        [self.delegate getTradeBannerImages];
        [[ForthonDataContainer sharedStore] addObserver:self forKeyPath:@"tradeImagesArray" options:NSKeyValueObservingOptionInitial context:NULL];

    }

    UICommon *imageButton =[[UICommon alloc]init];

    UIImageView *line =[[UIImageView alloc]init];
    line.frame = CGRectMake(0, WIDTH/2, WIDTH, LINE_HEIGHT);
    line.image = [UIImage imageNamed:@"yiyi_jiaoyi_line"];
    [self.view addSubview:line];

    [self.view addSubview:    [imageButton imageName:@"yiyi_jiaoyi_youhua_bg"
                                               frame:CGRectMake(0, START_IMAGE, WIDTH/2, IMAE_HEIGHT)
                                                 tag:1
                                         buttonTitle:@"油画"
                                            delegate:self

    ]];
    [self.view addSubview:    [imageButton imageName:@"yiyi_jiaoyi_guohua_bg"
                                               frame:CGRectMake(WIDTH/2, START_IMAGE, WIDTH/2, IMAE_HEIGHT)
                                                 tag:4
                                         buttonTitle:@"国画"
                                            delegate:self

    ]];


    [self.view addSubview:    [imageButton imageName:@"yiyi_jiaoyi_shufa_bg"
                                               frame:CGRectMake(0, START_IMAGE +IMAE_HEIGHT, WIDTH/2, IMAE_HEIGHT)
                                                 tag:2
                                         buttonTitle:@"书法"
                                            delegate:self

    ]];

    [self.view addSubview:    [imageButton imageName:@"yiyi_jiaoyi_banhua_bg"
                                               frame:CGRectMake(WIDTH/2, START_IMAGE +IMAE_HEIGHT, WIDTH/2, IMAE_HEIGHT)
                                                 tag:5
                                         buttonTitle:@"版画"
                                            delegate:self

    ]];
    [self.view addSubview:    [imageButton imageName:@"yiyi_jiaoyi_diaosu_bg"
                                               frame:CGRectMake(0, START_IMAGE +2*IMAE_HEIGHT, WIDTH/2, IMAE_HEIGHT)
                                                 tag:3
                                         buttonTitle:@"雕塑"
                                            delegate:self


    ]];
    [self.view addSubview:    [imageButton imageName:@"yiyi_jiaoyi_zhuanke_bg"
                                               frame:CGRectMake(WIDTH/2, START_IMAGE +2*IMAE_HEIGHT, WIDTH/2, IMAE_HEIGHT)
                                                 tag:6
                                         buttonTitle:@"篆刻"
                                            delegate:self


    ]];



}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    if ([keyPath isEqualToString:@"tradeImagesArray"] && [[[ForthonDataContainer sharedStore] valueForKey:@"tradeImagesArray"] count])
    {
        [self readyToCreateScrollView];
        [[ForthonDataContainer sharedStore] removeObserver:self forKeyPath:@"tradeImagesArray"];

    }
}

- (void)readyToCreateScrollView {

    NSArray *imagesArray = [[ForthonDataContainer sharedStore] valueForKey:@"tradeImagesArray"];
    [self createScrollViewWithImagesArray:imagesArray];
}

//- (void)viewWillAppear:(BOOL)animated {
//
//
//
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//
//
//
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-(void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//
//}

#pragma mark - 构建广告滚动视图
- (void)createScrollViewWithImagesArray:(NSArray *)imagesArray
{
    AdScrollView * scrollView = [[AdScrollView alloc]initWithFrame:CGRectMake(0, 0, UISCREENWIDTH, WIDTH / 2)];

    scrollView.imagesArray = imagesArray;

    scrollView.PageControlShowStyle = UIPageControlShowStyleRight;
    scrollView.pushDelegate = self;

    [self.view addSubview:scrollView];
}

-(void)onClickButton:(ForthonTapGesture *)sender {


    NSLog(@"heheda sender tag%ld",sender.tag);
    ForthonVastArtTable *vastArt = [[ForthonVastArtTable alloc] init];
    [vastArt setCanTrady:YES];
    [vastArt setCategoryIndex:sender.tag];
    NSArray *typeArray = @[@"油画", @"书法", @"雕塑", @"国画", @"版画", @"篆刻"];
    vastArt.typeStr = typeArray[sender.tag - 1];
    [self.navigationController pushViewController:vastArt animated:YES];

    
}

- (void)pushVideoDescriptionWithDic:(NSMutableDictionary *)dic {

    ForthonVideoDescription *videoDescription = [[ForthonVideoDescription alloc] init];
    NSString *category = [NSString stringWithFormat:@"%@", [dic objectForKey:@"typeId"]];
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

@end
