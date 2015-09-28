//
//  AppDelegate.m
//  Art
//
//  Created by Tang yuhua on 15/4/28.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarViewController.h"
#import "ForthonDataContainer.h"
#import "Reachability.h"
#import "LoginCurtain.h"



#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboApi.h"
#import "WXApi.h"

#import "AFHTTPSessionManager.h"
//#import "WeiboSDK.h"
//#import <ShareSDKConnector/ShareSDKConnector.h>

//case SSDKPlatformTypeSinaWeibo:
//    [ShareSDKConnector connectWeibo:[WeiboSDK class]];
//break;


@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize window;
@synthesize navigationController = _navigationController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //    LoginCurtain *login = [[LoginCurtain alloc] init];
    MainTabBarViewController *mainInterface = [[MainTabBarViewController alloc] init];
    _navigationController = [[UINavigationController alloc]initWithRootViewController:mainInterface];
    
    self.window.rootViewController = _navigationController;
    
    
    
    
    [NSThread sleepForTimeInterval:2.0];

    
    if (([Reachability reachabilityForInternetConnection].currentReachabilityStatus == NotReachable)||([Reachability reachabilityForLocalWiFi].currentReachabilityStatus == NotReachable))
        {
        [self loadDataFromiPhone];

        }
    [self.window makeKeyAndVisible];

    
    
    [ShareSDK registerApp:@"87352e31101f"];
    //
    //     [ShareSDK connectSinaWeiboWithAppKey:@"860761443" appSecret:@"f2cf8aba5f881fda2b72bc193639578d" redirectUri:@"http://www.sharesdk.cn" weiboSDKCls:[WeiboSDK class]];
//
//    当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台 （注意：2个方法只用写其中一个就可以）
//        当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台 （注意：2个方法只用写其中一个就可以）
//    [ShareSDK  connectSinaWeiboWithAppKey:@"568898243"
//                                appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
//                              redirectUri:@"http://www.sharesdk.cn"
//                              weiboSDKCls :[WeiboSDK class]];

//    [ShareSDK  connectSinaWeiboWithAppKey:@"860761443"
//                                appSecret:@"f2cf8aba5f881fda2b72bc193639578d"
//                              redirectUri:@"http://www.baidu.com"
//                              weiboSDKCls:[WeiboSDK class]];
    
//    添加新浪微博应用 注册网址 http://open.weibo.com
//    [ShareSDK connectSinaWeiboWithAppKey:@"860761443"
//                               appSecret:@"f2cf8aba5f881fda2b72bc193639578d"
//                             redirectUri:@"http://120.26.222.176:8081"];
    
    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:@"1104726851"
                           appSecret:@"QlWdCkToOZMfGO2b"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    //
    //
    //添加QQ应用  注册网址  http://mobile.qq.com/api/ni
    [ShareSDK connectQQWithQZoneAppKey:@"1104726851"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    //
    //添加微信应用  http://open.weixin.qq.com
    [ShareSDK connectWeChatWithAppId:@"wx316a7eb2fc145bbc"
                           appSecret:@"657f910a13c6b2ce8b1c14527cba51e8"
                           wechatCls:[WXApi class]];
    
    
    
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {

    return [ShareSDK handleOpenURL:url  wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:self];
}

- (void)loadDataFromiPhone
{
    NSLog(@"load Data from iPhone...");
    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = documents[0];
    NSLog(@"path: %@", docDir);
    NSString *videosPath = [docDir stringByAppendingPathComponent:@"videos.plist"];
    NSString *artListPath = [docDir stringByAppendingPathComponent:@"artList.plist"];
    NSString *artTradePath = [docDir stringByAppendingPathComponent:@"artTradeList.plist"];
    NSString *pagesPath = [docDir stringByAppendingPathComponent:@"pages.plist"];
    NSString *commentTopPath = [docDir stringByAppendingPathComponent:@"commentTop.plist"];
    NSString *skimTopPath = [docDir stringByAppendingPathComponent:@"skimTop.plist"];
    NSString *newsTopPath = [docDir stringByAppendingPathComponent:@"newsTop.plist"];
    NSString *mainBannerPath = [docDir stringByAppendingPathComponent:@"mainBanner.plist"];
    NSString *tradeBannerPath = [docDir stringByAppendingPathComponent:@"tradeBanner.plist"];

    [ForthonDataContainer sharedStore].videosDic = [NSMutableArray arrayWithContentsOfFile:videosPath];
    [ForthonDataContainer sharedStore].artListDic = [NSMutableArray arrayWithContentsOfFile:artListPath];
    [ForthonDataContainer sharedStore].artTradeListDic = [NSMutableArray arrayWithContentsOfFile:artTradePath];
    [ForthonDataContainer sharedStore].pagesDic = [NSMutableArray arrayWithContentsOfFile:pagesPath];

    [[ForthonDataContainer sharedStore] setValue:[NSMutableArray arrayWithContentsOfFile:commentTopPath] forKey:@"commentTop"];
    [[ForthonDataContainer sharedStore] setValue:[NSMutableArray arrayWithContentsOfFile:skimTopPath] forKey:@"skimTop"];
    [[ForthonDataContainer sharedStore] setValue:[NSMutableArray arrayWithContentsOfFile:newsTopPath] forKey:@"newsTop"];
    [[ForthonDataContainer sharedStore] setValue:[NSMutableArray arrayWithContentsOfFile:mainBannerPath] forKey:@"imagesArray"];
    [[ForthonDataContainer sharedStore] setValue:[NSMutableArray arrayWithContentsOfFile:tradeBannerPath] forKey:@"tradeImagesArray"];

}

//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//    return [ShareSDK handleOpenURL:url wxDelegate:self];
//}
//
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    return [ShareSDK handleOpenURL:url
//                 sourceApplication:sourceApplication
//                        annotation:annotation
//                        wxDelegate:self];
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
