//
//  YHAboutUSVC.m
//  Art
//
//  Created by Tang yuhua on 15/6/30.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "YHAboutUSVC.h"
#import "Common.h"
#import "UILabel+autoSizeToFit.h"

#define SideInterval 20

@interface YHAboutUSVC ()

@end

@implementation YHAboutUSVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UICommon *commonUI = [[UICommon alloc] init];
    UILabel *navTitle = [commonUI navTitle:@"关于我们"];
    
    self.navigationItem.titleView = navTitle;
    
    self.navigationItem.backBarButtonItem = HiddenBack
    self.navigationController.navigationBar.tintColor = AppColor;

    [self.view setBackgroundColor:[UIColor whiteColor]];

    UILabel *usLabel = [[UILabel alloc] initWithFrame:CGRectMake(SideInterval, 80, WIDTH - SideInterval * 2, 0)];
    [usLabel setNumberOfLines:15];
    NSString *profile = @"主尚文化馆（APP）以“普及百姓艺术知识,提高大众艺术品位”为己任。发布并展示不同艺术类别的艺术家的作品与视频。“天地人为主,古今心为尚”——以人为主,关注人,尊重人,发现人;以心为尚,作品走心,工作用心,服务贴心。主尚文化馆,我们的文化欢乐谷。";
    usLabel.textColor = [UIColor blackColor];
    usLabel.textAlignment = NSTextAlignmentNatural;
    usLabel.font = [UIFont systemFontOfSize:14.0];
    [usLabel labelAutoCalculateRectWith:profile FontSize:18.0 MaxSize:CGSizeMake(WIDTH - 2 * SideInterval, 1000)];

    [self.view addSubview:usLabel];

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
