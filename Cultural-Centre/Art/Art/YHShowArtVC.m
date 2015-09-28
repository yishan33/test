//
//  YHShowArtVC.m
//  Art
//
//  Created by Tang yuhua on 15/5/18.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "YHShowArtVC.h"

#import "ForthonPerformArtCategory.h"
#import "Common.h"
#import "SVProgressHUD.h"
#import "ForthonTapGesture.h"

@interface YHShowArtVC ()

@property (strong, nonatomic) ForthonPerformArtCategory *performArt;


@end

@implementation YHShowArtVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [super viewDidLoad];
    UICommon *commonUI = [[UICommon alloc] init];
    UILabel *navTitle = [commonUI navTitle:@"演艺"];
    
    self.navigationItem.titleView = navTitle;
    self.navigationItem.backBarButtonItem = HiddenBack;
    // hidden tabbar
    
    
    // log
    UIView *logview = [[UIView alloc]init];
    logview.frame = CGRectMake(0, 64, WIDTH, (HEIGHT-64)/4);
    logview.backgroundColor = [UIColor whiteColor];
    UIImageView *log = [[UIImageView alloc] init];
    log.frame = CGRectMake((WIDTH-80)/2, 20, 80, (HEIGHT-64)/4-40);
    log.image = [UIImage imageNamed:@"shangyi_logo"];
    
    [logview addSubview:log];
    [self.view addSubview:logview];
    
    // 油画

    NSArray *titleArray = @[@"油画", @"国画", @"书法", @"版画", @"雕塑", @"篆刻"];
    NSArray *tagArray = @[@1, @4, @2, @6, @5, @3];
    NSArray *imageArray = @[@"yanyi_youhua_background", @"yanyi_guohua_background", @"yanyi_shufa_background", @"yanyi_banhua_background",@"yanyi_diaosu_background",@"yanyi_zhuanke_background"];

    for(int i = 0; i < 6; i++) {

        UIImageView *labelView = [[UIImageView alloc] init];
        labelView.frame = CGRectMake(i % 2 * WIDTH / 2, ((i / 2) + 1) * (HEIGHT-64)/4+64, WIDTH/2, (HEIGHT-64)/4);
        labelView.image = [UIImage imageNamed:imageArray[i]];
        labelView.userInteractionEnabled = YES;


        UILabel *label = [UILabel new];
        label.tag = [tagArray[i] intValue];
        label.frame = CGRectMake((labelView.frame.size.width-100)/2, (labelView.frame.size.height-40)/2, 100, 40);
        label.text = titleArray[i];
        label.textColor = AppColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = ButtonColor;
        [label.layer setCornerRadius:10.0f];
        label.layer.borderColor = [UIColor clearColor].CGColor;
        label.layer.borderWidth = 1.0;
        label.clipsToBounds = YES;


        ForthonTapGesture *tapView = [[ForthonTapGesture alloc] initWithTarget:self action:@selector(showMethod:)];
        tapView.tag = [tagArray[i] intValue];
        [labelView addGestureRecognizer:tapView];
        [labelView addSubview:label];
        [self.view addSubview:labelView];
    }



//    UIImageView *oilPainting = [[UIImageView alloc] init];
//    oilPainting.frame = CGRectMake(0, (HEIGHT-64)/4+64, WIDTH/2, (HEIGHT-64)/4);
//    oilPainting.image = [UIImage imageNamed:@"yanyi_youhua_background"];
//    oilPainting.userInteractionEnabled = YES;
//
//
//    UIButton *oilPaintingButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    oilPaintingButton.tag = 1;
//    oilPaintingButton.frame = CGRectMake((oilPainting.frame.size.width-100)/2, (oilPainting.frame.size.height-40)/2, 100, 40);
//    [oilPaintingButton setTitle:@"油画" forState:UIControlStateNormal];
//    [oilPaintingButton setTitleColor:AppColor forState:UIControlStateNormal];
//    oilPaintingButton.backgroundColor = ButtonColor;
//    [oilPaintingButton.layer setCornerRadius:10.0f];
//
//    [oilPaintingButton addTarget:self action:@selector(showMethod:) forControlEvents:UIControlEventTouchUpInside];
//    [oilPainting addSubview:oilPaintingButton];
//    [self.view addSubview:oilPainting];
//
//    // 国画
//    UIImageView *traditionalPainting = [[UIImageView alloc] init];
//    traditionalPainting.frame = CGRectMake(WIDTH/2, (HEIGHT-64)/4+64, WIDTH/2, (HEIGHT-64)/4);
//    traditionalPainting.image = [UIImage imageNamed:@"yanyi_guohua_background"];
//    traditionalPainting.userInteractionEnabled = YES;
//
//    UIButton *traditionalButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    traditionalButton.tag = 4;
//    traditionalButton.frame = CGRectMake((traditionalPainting.frame.size.width-100)/2, (traditionalPainting.frame.size.height-40)/2, 100, 40);
//    [traditionalButton setTitle:@"国画" forState:UIControlStateNormal];
//    [traditionalButton setTitleColor:AppColor forState:UIControlStateNormal];
//    traditionalButton.backgroundColor = ButtonColor;
//    [traditionalButton.layer setCornerRadius:10.0f];
//    [traditionalButton addTarget:self action:@selector(showMethod:) forControlEvents:UIControlEventTouchUpInside];
//    [traditionalPainting addSubview:traditionalButton];
//    [self.view addSubview:traditionalPainting];
//
//    // 书法
//
//    UIImageView *handwriting = [[UIImageView alloc] init];
//    handwriting.frame = CGRectMake(0, 2*(HEIGHT-64)/4+64, WIDTH/2, (HEIGHT-64)/4);
//    handwriting.image = [UIImage imageNamed:@"yanyi_shufa_background"];
//    handwriting.userInteractionEnabled = YES;
//
//    UIButton *handwritingButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    handwritingButton.tag = 2;
//    handwritingButton.frame = CGRectMake((handwriting.frame.size.width-100)/2, (handwriting.frame.size.height-40)/2, 100, 40);
//    [handwritingButton setTitle:@"书法" forState:UIControlStateNormal];
//    [handwritingButton setTitleColor:AppColor forState:UIControlStateNormal];
//    handwritingButton.backgroundColor = ButtonColor;
//    [handwritingButton.layer setCornerRadius:10.0f];
//    [handwritingButton addTarget:self action:@selector(showMethod:) forControlEvents:UIControlEventTouchUpInside];
//    [handwriting addSubview:handwritingButton];
//    [self.view addSubview:handwriting];
//
//    // 版画
//
//    UIImageView *print = [[UIImageView alloc] init];
//    print.frame = CGRectMake(WIDTH/2, 2*(HEIGHT-64)/4+64, WIDTH/2, (HEIGHT-64)/4);
//    print.image = [UIImage imageNamed:@"yanyi_banhua_background"];
//    print.userInteractionEnabled = YES;
//
//    UIButton *printButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    printButton.tag = 6;
//    printButton.frame = CGRectMake((print.frame.size.width-100)/2, (print.frame.size.height-40)/2, 100, 40);
//    [printButton setTitle:@"版画" forState:UIControlStateNormal];
//    [printButton setTitleColor:AppColor forState:UIControlStateNormal];
//    printButton.backgroundColor = ButtonColor;
//    [printButton.layer setCornerRadius:10.0f];
//    [printButton addTarget:self action:@selector(showMethod:) forControlEvents:UIControlEventTouchUpInside];
//    [print addSubview:printButton];
//    [self.view addSubview:print];
//
//    // 雕塑
//
//    UIImageView *carve = [[UIImageView alloc] init];
//    carve.frame = CGRectMake(0, 3*(HEIGHT-64)/4+64, WIDTH/2, (HEIGHT-64)/4);
//    carve.image = [UIImage imageNamed:@"yanyi_diaosu_background"];
//    carve.userInteractionEnabled = YES;
//
//    UIButton *carveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    carveButton.tag = 5;
//    carveButton.frame = CGRectMake((carve.frame.size.width-100)/2, (carve.frame.size.height-40)/2, 100, 40);
//    [carveButton setTitle:@"雕塑" forState:UIControlStateNormal];
//    [carveButton setTitleColor:AppColor forState:UIControlStateNormal];
//    carveButton.backgroundColor = ButtonColor;
//    [carveButton.layer setCornerRadius:10.0f];
//    [carveButton addTarget:self action:@selector(showMethod:) forControlEvents:UIControlEventTouchUpInside];
//    [carve addSubview:carveButton];
//    [self.view addSubview:carve];
//
//    // 篆刻
//
//
//    UIImageView *sealCutting = [[UIImageView alloc] init];
//    sealCutting.frame = CGRectMake(WIDTH/2, 3*(HEIGHT-64)/4+64, WIDTH/2, (HEIGHT-64)/4);
//    sealCutting.image = [UIImage imageNamed:@"yanyi_zhuanke_background"];
//    sealCutting.userInteractionEnabled = YES;
//
//    UIButton *sealCutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    sealCutButton.tag = 3;
//    sealCutButton.frame = CGRectMake((sealCutting.frame.size.width-100)/2, (sealCutting.frame.size.height-40)/2, 100, 40);
//    [sealCutButton setTitle:@"篆刻" forState:UIControlStateNormal];
//    [sealCutButton setTitleColor:AppColor forState:UIControlStateNormal];
//    sealCutButton.backgroundColor = ButtonColor;
//    [sealCutButton.layer setCornerRadius:10.0f];
//    [sealCutButton addTarget:self action:@selector(showMethod:) forControlEvents:UIControlEventTouchUpInside];
//    [sealCutting addSubview:sealCutButton];
//    [self.view addSubview:sealCutting];

}


- (void)viewWillAppear:(BOOL)animated {

    if ([SVProgressHUD isVisible]) {

        [SVProgressHUD dismiss];
    }
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

-(void)showMethod:(ForthonTapGesture *)sender

{
    _performArt = [[ForthonPerformArtCategory alloc] init];
    [_performArt setCategoryIndex:sender.tag];
    [self.navigationController pushViewController:_performArt animated:YES];
}
@end
