//
//  YHLearnedArtVC.m
//  Art
//
//  Created by Tang yuhua on 15/5/18.
//  Copyright (c) 2015年 test. All rights reserved.
//

#define FirstHight 0.3*(HEIGHT-64)
#define FirstWidth 0.6*WIDTH

#define SecondHight 0.4*(HEIGHT-64)
#define SecondWidth 0.4*WIDTH

#define ThirdHight 0.3*(HEIGHT-64)
#define ThirdWidth SecondWidth

#define viewHeight (HEIGHT - 64)


#define GuoHuaHight 0.78*(SecondHight+ThirdWidth)

#import "YHLearnedArtVC.h"
#import "ForthonVastArtTable.h"
#import "Common.h"
#import "SVProgressHUD.h"
#import "ForthonTapGesture.h"

@interface YHLearnedArtVC ()

@property (nonatomic, strong) NSString *typeStr;

@end

@implementation YHLearnedArtVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UICommon *commonUI = [[UICommon alloc] init];
    UILabel *navTitle = [commonUI navTitle:@"博艺"];
    self.navigationItem.titleView = navTitle;
    self.navigationItem.backBarButtonItem = HiddenBack;
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // 布局


    NSArray *widthArray = @[@(0.6 * WIDTH), @(0.4 * WIDTH), @(0.4 * WIDTH),@(0.6 * WIDTH), @(0.4 * WIDTH), @(0.6 * WIDTH)];
    NSArray *heightArray = @[@(0.3 * viewHeight), @(0.3 * viewHeight), @(0.4 * viewHeight), @(0.3 * viewHeight), @(0.3 * viewHeight), @(0.4 * viewHeight)];
    NSArray *titleArray = @[@"油画", @"书法", @"篆刻", @"国画", @"雕塑", @"版画"];
    NSArray *titleEnglishArray = @[@"oilPaiting", @"Calligraphy", @"Seal cutting", @"Traditional Chinese painting", @"Sculpture", @"Engraving"];
    NSArray *imageArray = @[@"boyi_youhua_background", @"boyi_shufa_background", @"boyi_zhuanke_background", @"boyi_guohua_background", @"boyi_diaosu_background", @"boyi_banhua_background"];

    CGFloat specialWith;
    for (int i = 0; i < 6; i++) {

        UIImageView *oilPainting = [[UIImageView alloc] init];

        CGFloat topInterval = 0;
        CGFloat leftInterval;
        CGFloat buttonX;
        CGFloat buttonY;
        if (i == 3) {

            specialWith = 180;
        } else {

            specialWith = 85;
        }
        if (i % 2 == 0) {

            leftInterval = 0;

            for (int j = 0; j < i / 2; j++) {

                topInterval += [heightArray[j * 2] floatValue];
            }
            buttonX = 0;
        } else {

            leftInterval = [widthArray[i / 2] floatValue];
            for (int j = 0; j < i / 2; j++) {

                topInterval += [heightArray[j * 2 + 1] floatValue];
            }
            buttonX = [widthArray[i] floatValue] - specialWith;
        }
        buttonY = ([heightArray[i] floatValue] - 40.0) / 2.0;

        oilPainting.frame = CGRectMake(leftInterval, topInterval + 64, [widthArray[i] floatValue], [heightArray[i] floatValue]);
        oilPainting.image = [UIImage imageNamed:imageArray[i]];
        oilPainting.userInteractionEnabled = YES;
        UIView *buttonBackView = [[UIView alloc] initWithFrame:CGRectMake(buttonX, buttonY, specialWith, 40)];

        buttonBackView.backgroundColor = AppColor;
        buttonBackView.layer.borderColor = [UIColor whiteColor].CGColor;
        buttonBackView.layer.borderWidth = 2.0;
        [oilPainting addSubview:buttonBackView];

        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, specialWith, 20)];
        titleLabel.text = titleArray[i];
        titleLabel.font = [UIFont boldSystemFontOfSize:13.0];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        [buttonBackView addSubview:titleLabel];

        UILabel *titleEnglishLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, specialWith, 20)];
        titleEnglishLabel.text = titleEnglishArray[i];
        titleEnglishLabel.font = [UIFont boldSystemFontOfSize:13.0];
        titleEnglishLabel.textAlignment = NSTextAlignmentCenter;
        titleEnglishLabel.textColor = [UIColor whiteColor];
        [buttonBackView addSubview:titleEnglishLabel];

        ForthonTapGesture *tap = [[ForthonTapGesture alloc] initWithTarget:self action:@selector(showMethod:)];
        tap.tag = i + 1;
        [oilPainting addGestureRecognizer:tap];

        [self.view addSubview:oilPainting];


//        UILabel *oilPaintingLabel = [UILabel new];
//        oilPaintingLabel.frame = CGRectMake(0, (oilPainting.frame.size.height-40)/2, 100, 40);
//        oilPaintingLabel.text = titleArray[i];
//        [oilPaintingLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        oilPaintingLabel.backgroundColor = [UIColor grayColor];
//        [oilPaintingLabel.layer setCornerRadius:10.0f];
//        [oilPaintingLabel setBackgroundImage:[UIImage imageNamed:@"boyi_youhua_btn"] forState:UIControlStateNormal];
//
//        [oilPaintingLabel setTag:1];
//        [oilPaintingLabel addTarget:self action:@selector(showMethod:) forControlEvents:UIControlEventTouchUpInside];
//        [oilPainting addSubview:oilPaintingLabel];
//        [self.view addSubview:oilPainting];
    }


    // 油画
//    UIImageView *oilPainting = [[UIImageView alloc] init];
//    oilPainting.frame = CGRectMake(0, 64, FirstWidth, FirstHight);
//    oilPainting.image = [UIImage imageNamed:@"boyi_youhua_background"];
//    oilPainting.userInteractionEnabled = YES;
//
//    UIButton *oilPaintingButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    oilPaintingButton.frame = CGRectMake(0, (oilPainting.frame.size.height-40)/2, 100, 40);
//    [oilPaintingButton setTitle:@"油画" forState:UIControlStateNormal];
//    [oilPaintingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    oilPaintingButton.backgroundColor = [UIColor grayColor];
//    [oilPaintingButton.layer setCornerRadius:10.0f];
//    [oilPaintingButton setBackgroundImage:[UIImage imageNamed:@"boyi_youhua_btn"] forState:UIControlStateNormal];
//
//    [oilPaintingButton setTag:1];
//    [oilPaintingButton addTarget:self action:@selector(showMethod:) forControlEvents:UIControlEventTouchUpInside];
//    [oilPainting addSubview:oilPaintingButton];
//    [self.view addSubview:oilPainting];
//
//    // 书法
//
//    UIImageView *handwriting = [[UIImageView alloc] init];
//    handwriting.frame = CGRectMake(FirstWidth, 64, WIDTH - FirstWidth, FirstHight);
//    handwriting.image = [UIImage imageNamed:@"boyi_shufa_background"];
//    handwriting.userInteractionEnabled = YES;
//
//    UIButton *handwritingButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    handwritingButton.frame = CGRectMake(handwriting.bounds.size.width - 100, (handwriting.bounds.size.height-40)/2, 100, 40);
//    [handwritingButton setTitle:@"书法" forState:UIControlStateNormal];
//    [handwritingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    handwritingButton.backgroundColor = [UIColor grayColor];
//    [handwritingButton.layer setCornerRadius:10.0f];
//    [handwritingButton setBackgroundImage:[UIImage imageNamed:@"boyi_shufa_btn.png"] forState:UIControlStateNormal];
//
//    [handwritingButton setTag:2];
//    [handwritingButton addTarget:self action:@selector(showMethod:) forControlEvents:UIControlEventTouchUpInside];
//    [handwriting addSubview:handwritingButton];
//    [self.view addSubview:handwriting];
//
//
//    // 篆刻
//
//
//    UIImageView *sealCutting = [[UIImageView alloc] init];
//    sealCutting.frame = CGRectMake(0, FirstHight+64, SecondWidth, SecondHight);
//    sealCutting.image = [UIImage imageNamed:@"boyi_zhuanke_background"];
//    sealCutting.userInteractionEnabled = YES;
//
//    UIButton *sealCutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    sealCutButton.frame = CGRectMake(0, (sealCutting.frame.size.height-40)/2, 100, 40);
//    [sealCutButton setTitle:@"篆刻" forState:UIControlStateNormal];
//    [sealCutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    sealCutButton.backgroundColor = [UIColor grayColor];
//    [sealCutButton.layer setCornerRadius:10.0f];
//    [sealCutButton setBackgroundImage:[UIImage imageNamed:@"boyi_zhuanke_btn"] forState:UIControlStateNormal];
//
//    [sealCutButton setTag:3];
//    [sealCutButton addTarget:self action:@selector(showMethod:) forControlEvents:UIControlEventTouchUpInside];
//    [sealCutting addSubview:sealCutButton];
//    [self.view addSubview:sealCutting];
//
//
//    // 国画
//    UIImageView *traditionalPainting = [[UIImageView alloc] init];
//    traditionalPainting.frame = CGRectMake(SecondWidth, FirstHight+64, WIDTH - SecondWidth, GuoHuaHight);
//    traditionalPainting.image = [UIImage imageNamed:@"boyi_guohua_background"];
//    traditionalPainting.userInteractionEnabled = YES;
//
//    UIButton *traditionalButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    traditionalButton.frame = CGRectMake(traditionalPainting.frame.size.width - 100, (traditionalPainting.frame.size.height-40)/2, 100, 40);
//    [traditionalButton setTitle:@"国画" forState:UIControlStateNormal];
//    [traditionalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    traditionalButton.backgroundColor = [UIColor grayColor];
//    [traditionalButton.layer setCornerRadius:10.0f];
//    [traditionalButton setBackgroundImage:[UIImage imageNamed:@"boyi_guohua_btn"] forState:UIControlStateNormal];
//
//    [traditionalButton setTag:4];
//    [traditionalButton addTarget:self action:@selector(showMethod:) forControlEvents:UIControlEventTouchUpInside];
//    [traditionalPainting addSubview:traditionalButton];
//    [self.view addSubview:traditionalPainting];
//
//
//
//
//    // 雕塑
//
//    UIImageView *carve = [[UIImageView alloc] init];
//    carve.frame = CGRectMake(0, FirstHight+SecondHight+64, ThirdWidth, ThirdHight);
//    carve.image = [UIImage imageNamed:@"boyi_diaosu_background"];
//    carve.userInteractionEnabled = YES;
//
//    UIButton *carveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    carveButton.frame = CGRectMake(0, (carve.frame.size.height-40)/2, 100, 40);
//    [carveButton setTitle:@"雕塑" forState:UIControlStateNormal];
//    [carveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    carveButton.backgroundColor = [UIColor grayColor];
//    [carveButton.layer setCornerRadius:10.0f];
//    [carveButton setBackgroundImage:[UIImage imageNamed:@"boyi_diaosu_btn"] forState:UIControlStateNormal];
//
//    [carveButton setTag:5];
//    [carveButton addTarget:self action:@selector(showMethod:) forControlEvents:UIControlEventTouchUpInside];
//    [carve addSubview:carveButton];
//    [self.view addSubview:carve];
//
//    //版画
//
//
//    UIImageView *print = [[UIImageView alloc] init];
//    print.frame = CGRectMake(SecondWidth,64+FirstHight+GuoHuaHight, WIDTH-SecondWidth, SecondHight+ThirdHight -GuoHuaHight);
//    print.image = [UIImage imageNamed:@"yanyi_banhua_background"];
//    print.userInteractionEnabled = YES;
//
//    UIButton *printButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    printButton.frame = CGRectMake(print.frame.size.width -100, (print.frame.size.height-40)/2, 100, 40);
//    [printButton setTitle:@"版画" forState:UIControlStateNormal];
//    [printButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    printButton.backgroundColor = [UIColor grayColor];
//    [printButton.layer setCornerRadius:10.0f];
//    [printButton setBackgroundImage:[UIImage imageNamed:@"boyi_banhua_btn"] forState:UIControlStateNormal];
//
//    [printButton setTag:6];
//    [printButton addTarget:self action:@selector(showMethod:) forControlEvents:UIControlEventTouchUpInside];
//    [print addSubview:printButton];
//    [self.view addSubview:print];

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
-(void)showMethod:(UIButton *)sender {
    
    
    ForthonVastArtTable *vastArt = [[ForthonVastArtTable alloc] init];
    [vastArt setCanTrady:NO];
    [vastArt setCategoryIndex:sender.tag];
    NSArray *typeArray = @[@"油画", @"书法", @"篆刻", @"国画", @"雕塑", @"版画"];
    vastArt.typeStr = typeArray[sender.tag - 1];
    [self.navigationController pushViewController:vastArt animated:YES];
}
@end
