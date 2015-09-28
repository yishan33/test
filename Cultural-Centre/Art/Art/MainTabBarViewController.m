//
//  MainTabBarViewController.m
//  LF
//
//  Created by Tang yuhua on 15/4/13.
//  Copyright (c) 2015年 Laifu. All rights reserved.
//

#import "MainTabBarViewController.h"


@interface MainTabBarViewController ()

@end

@implementation MainTabBarViewController

-(id)init{
    if (self = [super initWithNibName:nil bundle:nil]) {
        
  
        //1
        
        HomePageVC *home = [[HomePageVC alloc]init];
        UINavigationController *homeNav = [[UINavigationController alloc]init];


        [homeNav pushViewController:home animated:NO];
        UIImage *image0 = [UIImage imageNamed:@"tab_home_nomal"];
        UIImage *imageSeleted0 = [UIImage imageNamed:@"tab_home_selected"];
        UIImage *homePageImage = [image0 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *homePageImageU = [imageSeleted0 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

        homeNav.tabBarItem = [[UITabBarItem alloc]initWithTitle:nil image:homePageImage selectedImage:homePageImageU];
        homeNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        
        //2
        SkimVC *skim = [[SkimVC alloc]init];
        UINavigationController *skimNav = [[UINavigationController alloc]init];
        [skimNav pushViewController:skim animated:NO];
        UIImage *image1 = [UIImage imageNamed:@"tab_find_nomal"];
        UIImage *imageSeleted1 = [UIImage imageNamed:@"tab_find_selected"];
        UIImage *skimImage = [image1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *skimImageU = [imageSeleted1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        skimNav.tabBarItem = [[UITabBarItem alloc]initWithTitle:nil image:skimImage selectedImage:skimImageU];
        skimNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        //3
        
        
        SearchVC *search = [[SearchVC alloc]init];
        UINavigationController *searchNav = [[UINavigationController alloc]init];
        [searchNav pushViewController:search animated:NO];
        UIImage *image2 = [UIImage imageNamed:@"tab_search_nomal"];
        UIImage *imageSeleted2 = [UIImage imageNamed:@"tab_search_selected"];
        UIImage *searchImage = [image2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *searchImageU = [imageSeleted2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        searchNav.tabBarItem = [[UITabBarItem alloc]initWithTitle:nil image:searchImage selectedImage:searchImageU];
        searchNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);

        
        //4
        
        
        MineVC *mine = [[MineVC alloc]init];
        UINavigationController *mineNav = [[UINavigationController alloc]init];
        [mineNav pushViewController:mine animated:NO];
        UIImage *image3 = [UIImage imageNamed:@"tab_profile_nomal"];
        UIImage *imageSeleted3 = [UIImage imageNamed:@"tab_profile_selcted"];
        UIImage *mineImage = [image3 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *mineImageU = [imageSeleted3 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        mineNav.tabBarItem = [[UITabBarItem alloc]initWithTitle:nil image:mineImage selectedImage:mineImageU];
        mineNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);

        self.tabBar.barTintColor = AppColor;
        self.tabBar.tintColor = [UIColor whiteColor];
        
        
        self.viewControllers = [NSArray arrayWithObjects:homeNav,skimNav,searchNav,mineNav, nil];

        for (UINavigationController *tinyNav in self.viewControllers) {

            UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(40, 0, WIDTH - 80, 44)];
            whiteView.backgroundColor = [UIColor clearColor];
            [tinyNav.navigationBar addSubview:whiteView];
        }
    
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //debug
    
    
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
