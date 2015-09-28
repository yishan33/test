//
//  YHJoinOfArtVC.m
//  Art
//
//  Created by Tang yuhua on 15/6/24.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "YHJoinOfArtVC.h"
#import "Common.h"


#define width [UIScreen mainScreen].applicationFrame.size.width
#define height HEIGHT

@interface YHJoinOfArtVC ()

@end

@implementation YHJoinOfArtVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   
      NSLog(@"YHJoinOfArtVC.view.frame %@",NSStringFromCGRect(self.view.frame));
    
    UIView *logo = [[UIView alloc]init];
    logo.frame = CGRectMake(0, 0, width, height/4);
    NSLog(@"height %f",height);
    logo.backgroundColor = [UIColor whiteColor];
    UIImageView *logoImage = [[UIImageView alloc]init];
    logoImage.frame = CGRectMake((width-80)/2, 20, 80, (height)/4-40);
    logoImage.image = [UIImage imageNamed:@"yiyi_join_logo"];
    [logo addSubview:logoImage];
    [self.view addSubview:logo];
    
    
    
    
    // 投资
    UIImageView *invest = [[UIImageView alloc]init];
    invest.frame = CGRectMake(0, height/4, width, height/4);
    invest.image = [UIImage imageNamed:@"yiyi_join_touzi_bg"];
    invest.userInteractionEnabled =YES;
    [self.view addSubview:invest];
    
    // 论坛
    UIImageView *forum = [[UIImageView alloc]init];
    forum.frame = CGRectMake(0, height/2, width, height/4);
    forum.image = [UIImage imageNamed:@"yiyi_join_luntan_bg"];
    forum.userInteractionEnabled = YES;
    [self.view addSubview:forum];
    
    // 开店
    UIImageView *shop = [[UIImageView alloc]init];
    shop.frame = CGRectMake(0,3*height/4, width, height/4);
    shop.image = [UIImage imageNamed:@"yiyi_join_touzi_bg"];
    shop.userInteractionEnabled = YES;
    [self.view addSubview:shop];

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
