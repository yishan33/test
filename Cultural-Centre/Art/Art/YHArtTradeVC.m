//
//  YHArtTradeVC.m
//  Art
//
//  Created by Tang yuhua on 15/5/17.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "YHArtTradeVC.h"
#import "YHTradeOfArtVC.h"
#import "YHJoinOfArtVC.h"

#import "Common.h"

@interface YHArtTradeVC ()

@end

@implementation YHArtTradeVC

YHTradeOfArtVC *tradeVC;
YHJoinOfArtVC  *joinVC;

- (void)viewDidLoad {
    [super viewDidLoad];
    UICommon *commonUI = [[UICommon alloc] init];
    UILabel *navTitle = [commonUI navTitle:@"易艺"];
    self.navigationItem.titleView = navTitle;
    self.navigationItem.backBarButtonItem = HiddenBack;

    NSLog(@"self.view.frame.size.width = %f",self.view.frame.size.width);
    UIView *fragement = [[UIView alloc] init];

    fragement.frame = CGRectMake([UIScreen mainScreen].applicationFrame.size.width / 2, 66, 1, 25);
    fragement.backgroundColor = AppColor;
    [self.view addSubview:fragement];

    tradeVC = [[YHTradeOfArtVC alloc] init];
    tradeVC.view.frame = CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height);
    [self addChildViewController:tradeVC];

    joinVC = [[YHJoinOfArtVC alloc] init];
    joinVC.view.frame = CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height);
    [self addChildViewController:joinVC];
    [contentView addSubview:tradeVC.view];

    currentViewController = tradeVC;

}
//-(void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//
//}

-(IBAction)onClickbutton:(id)sender{
    if ((currentViewController == tradeVC && [sender tag] ==1)||(currentViewController == joinVC && [sender tag] ==2)) {
        return;
    }
    UIViewController *oldViewController = currentViewController;
    
    switch ([sender tag]) {
        case 1:
        {
            NSLog(@"点击了艺术交易");
            [self transitionFromViewController:currentViewController
                              toViewController:tradeVC
                                      duration:0.5
                                       options:UIViewAnimationOptionTransitionCurlDown
                                    animations:^{}
                                    completion:^(BOOL finished){
                                        if (finished) {
                                            currentViewController = tradeVC;
                                        }else{
                                            currentViewController = oldViewController;
                                        }
                                    }];
        }
            break;
        case 2:
        {
            NSLog(@"点击了艺术参与");
            [self transitionFromViewController:currentViewController
                              toViewController:joinVC
                                      duration:0.5
                                       options:UIViewAnimationOptionTransitionCurlUp
                                    animations:^{}
                                    completion:^(BOOL finished){
                                        if (finished) {
                                            currentViewController = joinVC;
                                        }else{
                                            currentViewController = oldViewController;
                                        }
                                    }];
            
        }
            break;
            
        default:
            break;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
