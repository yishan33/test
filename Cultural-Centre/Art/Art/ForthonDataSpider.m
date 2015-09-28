//
//  ForthonDataSpider.m
//  Login
//
//  Created by Liu fushan on 15/5/16.
//  Copyright (c) 2015年 culturalCenter. All rights reserved.
//

#import "ForthonDataSpider.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPSessionManager.h"
#import "WXApiObject.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSString+imageUrlString.h"
#import "SVProgressHUD.h"


//
//#define HOST @"http://api.art.uestcbmi.com"
#define HOST @"http://120.26.222.176:8081"

#define KEY @"A6F7F0D6CD13058D40C1110F007E7F13"

@interface ForthonDataSpider ()

@property (nonatomic, strong) NSMutableDictionary *pageTestDic;
@property (nonatomic, strong) NSMutableDictionary *followsDic;

@property (nonatomic, strong) NSString *authKey;
@property (nonatomic, strong) NSString *userId;


@end


@implementation ForthonDataSpider


+ (ForthonDataSpider *)sharedStore
{
    static dispatch_once_t onceToken;
    static ForthonDataSpider *sSharedInstance;

    dispatch_once(&onceToken, ^{
        sSharedInstance = [[ForthonDataSpider alloc] init];
    });

    return sSharedInstance;
}


- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        
    }

    return self;
}


- (NSString *)startCaptureData
{
    NSLog(@"start!!!!!");
    
    return @"ok";
}


- (NSData *)captureImage
{
    NSString *url = @"http://dl.bizhi.sogou.com/images/2012/03/02/191412.jpg";
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    return data;
}

#pragma mark - 首页轮播图

- (void)getHomeBannerImages {

    NSString *url = [NSString stringWithFormat:@"%@/banner/getHomeBanner?apikey=%@", HOST, KEY];
    NSLog(@"url: %@", url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];

    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];

        if ([dic[@"invoke"] boolValue]) {

            NSMutableArray *imagesArray = [[dic objectForKey:@"result"] objectForKey:@"banners"];
      
            [[ForthonDataContainer sharedStore] setValue:imagesArray forKey:@"imagesArray"];
            [self dataCacheWithPath:@"mainBanner.plist" data:imagesArray];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - 易艺轮播图

- (void)getTradeBannerImages {

    NSString *url = [NSString stringWithFormat:@"%@/banner/getTradeBanner?apikey=%@", HOST, KEY];
    NSLog(@"url: %@", url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];

    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
     
        if ([dic[@"invoke"] boolValue]) {

         
            NSMutableArray *imagesArray = [[dic objectForKey:@"result"] objectForKey:@"banners"];
    
            [[ForthonDataContainer sharedStore] setValue:imagesArray forKey:@"tradeImagesArray"];
            [self dataCacheWithPath:@"tradeBanner.plist" data:imagesArray];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        NSLog(@"Error: %@", error);
    }];
}


#pragma mark - Get Data

- (void)getVideosByTypeid:(int)typeid page:(int)page
{

    NSString *url = [NSString stringWithFormat:@"%@/video/getVideos?apikey=%@&typeid=%i&page=%i",
                     HOST, KEY, typeid, page];
    NSLog(@"videoUrl: %@", url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
   
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];

        if ([dic[@"invoke"] boolValue]) {

            NSMutableArray *videoArray = [[dic objectForKey:@"result"] objectForKey:@"videos"];

            if (page == 1) {

                [ForthonDataContainer sharedStore].videosDic[typeid - 1] = videoArray;
            } else {

                [[ForthonDataContainer sharedStore].videosDic[typeid - 1] addObjectsFromArray:videoArray];
                NSLog(@"%@", videoArray);
            }

            [self sendNotification];
            [self dataCacheWithPath:@"videos.plist" data:[ForthonDataContainer sharedStore].videosDic];
        }

    }failure:^(AFHTTPRequestOperation *opreation, NSError *error){

        NSLog(@"Error: %@", error);
        [self sendNotificationNetError];

    }];

}

- (void)getVideoDescriptionById:(NSString *)workId {

    NSString *url = [NSString stringWithFormat:@"%@/video/getVideoInfo?apikey=%@&id=%@", HOST, KEY, workId];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];


        if ([dic[@"invoke"] boolValue]) {

            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationVideoDescription" object:nil userInfo:[dic[@"result"] objectForKey:@"video"]];
        }

    }failure:^(AFHTTPRequestOperation *opreation, NSError *error){

        NSLog(@"Error: %@", error);
        [self sendNotificationNetError];
    }];
}

- (void)getArtListByTypeid:(int)typeid trade:(BOOL)trade page:(int)page
{
    NSString *url;
    if (trade) {
        url = [NSString stringWithFormat:@"%@/art/getArtList?apikey=%@&typeid=%i&trade=true&page=%i",
                         HOST, KEY, typeid, page];
    } else {
        url = [NSString stringWithFormat:@"%@/art/getArtList?apikey=%@&typeid=%i&trade=false&page=%i",
                     HOST, KEY, typeid, page];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];

        NSArray *artList = [[dic objectForKey:@"result"] objectForKey:@"arts"];
        
        if (trade) {

            if (page == 1) {

                [ForthonDataContainer sharedStore].artTradeListDic[typeid - 1] = artList;
             

            } else {

                [[ForthonDataContainer sharedStore].artTradeListDic[typeid - 1] addObjectsFromArray:artList];

            }
            [self sendNotification];
            [self dataCacheWithPath:@"artTradeList.plist" data:[ForthonDataContainer sharedStore].artTradeListDic];

        } else {

            if (page == 1) {

                [ForthonDataContainer sharedStore].artListDic[typeid - 1] = artList;

            } else {

                [[ForthonDataContainer sharedStore].artListDic[typeid - 1] addObjectsFromArray:artList];
               
            }
            [self sendNotification];
            [self dataCacheWithPath:@"artList.plist" data:[ForthonDataContainer sharedStore].artListDic];
        }

        
    }failure:^(AFHTTPRequestOperation *opreation, NSError *error){
        NSLog(@"Error: %@", error);
        [self sendNotificationNetError];
    }];
}

- (void)getPagesByPage:(int)page
{
    NSString *url = [NSString stringWithFormat:@"%@/page/getPages?apikey=%@&page=%i", HOST, KEY, page];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];

        NSMutableArray *pages;
        
        if (page == 1) {
            
            pages = [dic[@"result"] objectForKey:@"pages"];
            
        } else {
            
            pages = [ForthonDataContainer sharedStore].pagesDic;
            [pages addObjectsFromArray:[dic[@"result"] objectForKey:@"pages"]];

            NSLog(@"%@", pages);
        }

        [ForthonDataContainer sharedStore].pagesDic = pages;
        [self sendNotification];
        [self dataCacheWithPath:@"pages.plist" data:[ForthonDataContainer sharedStore].pagesDic];
        
    }failure:^(AFHTTPRequestOperation *opreation, NSError *error){

        NSLog(@"Error: %@", error);
        [self sendNotificationNetError];
    }];
}

- (void)getPageById:(NSString *)pageId
{
    NSString *url = [NSString stringWithFormat:@"%@/page/getPageInfo?apikey=%@&id=%@", HOST, KEY, pageId];
//    NSLog(@"url: \n%@", url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];


        NSDictionary *pageWithIdDic = [[dic objectForKey:@"result"] objectForKey:@"page"];
        if (!_pageTestDic) {
            _pageTestDic = [[NSMutableDictionary alloc] init];
        }

        NSString *indexId = [NSString stringWithFormat:@"id%@", pageId];
        [_pageTestDic setValue:pageWithIdDic forKey:indexId];
        [[ForthonDataContainer sharedStore] setValue:_pageTestDic  forKey:@"pageDic"];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationPageDescription" object:nil  userInfo:pageWithIdDic];


    }failure:^(AFHTTPRequestOperation *opreation, NSError *error){
        NSLog(@"Error: %@", error);
        [self sendNotificationNetError];
    }];

}

- (void)getArtDescriptionById:(NSString *)workId
{
    NSString *url = [NSString stringWithFormat:@"%@/art/getArtInfo?apikey=%@&id=%@", HOST, KEY, workId];
    NSLog(@"url: \n%@", url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];

   
        NSDictionary *artDescription = [[dic objectForKey:@"result"] objectForKey:@"art"];
        [[ForthonDataContainer sharedStore].artDescriptionDic setObject:artDescription forKey:workId];
        NSLog(@"values: %@", [[ForthonDataContainer sharedStore].artDescriptionDic objectForKey:workId]);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationArtContent" object:nil];
        
        
    }failure:^(AFHTTPRequestOperation *opreation, NSError *error){

        [self sendNotificationNetError];
        NSLog(@"Error: %@", error);

    }];
}

- (void)getPageInfoById:(NSString *)workId {

    NSString *url = [NSString stringWithFormat:@"%@/page/getPageInfo?apikey=%@&id=%@", HOST, KEY, workId];
    NSLog(@"url: \n%@", url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];

        NSDictionary *artDescription = [[dic objectForKey:@"result"] objectForKey:@"page"];

        NSNumber *commentNumber = artDescription[@"commentCnt"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationPageCommentNumber" object:nil  userInfo:@{
                @"commentNumber":commentNumber
        }];

    }failure:^(AFHTTPRequestOperation *opreation, NSError *error){
        NSLog(@"Error: %@", error);
    }];
}


- (void)getCommentByTypeid:(int)typeid targetId:(NSString *)workId page:(int)page
{
    NSString *url;
    url = [NSString stringWithFormat:@"%@/comment/getComments?apikey=%@&typeid=%i&targetid=%@&page=%i", HOST, KEY, typeid, workId, page];
    NSLog(@"url: %@", url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSString *workType = [[NSString alloc] init];
    if (typeid == 1) {
        workType = @"videosComments";
    } else if (typeid == 2) {
        workType = @"artsComments";
    } else {
        workType = @"pagesComments";
    }
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *err;
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];

        if ([[dic objectForKey:@"invoke"] boolValue] == YES) {
            
            NSLog(@"url成功获取评论");
            NSMutableArray *commentsArray;
            if (page == 1) {
                
                commentsArray = [NSMutableArray arrayWithArray:[[dic objectForKey:@"result" ] objectForKey:@"comments"]];

            } else {

                commentsArray = [[[ForthonDataContainer sharedStore].commentsDic objectForKey:workType] objectForKey:workId];
                [commentsArray addObjectsFromArray:[NSMutableArray arrayWithArray:[[dic objectForKey:@"result"] objectForKey:@"comments"]]];
            }
            if ([commentsArray count]) {

                [[[ForthonDataContainer sharedStore].commentsDic objectForKey:workType] setObject:commentsArray forKey:workId];
                NSLog(@"commentsCount: %i", (int)[commentsArray count]);
            }

        }
        NSLog(@"nihao ");
        [self sendNotification];

    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        [self sendNotificationNetError];
    }];
    

}


- (void)getSkimsByType:(SkimViewType)type
{
    NSString *url;
    NSString *category = [[NSString alloc] init];
    if (type == SkimViewTypeComment) {
        url = [NSString stringWithFormat:@"%@/rank/topComment?apikey=%@&size=%i", HOST, KEY, 20];
        category = @"commentTop";
        NSLog(@"get comment");
        
    } else if (type == SkimViewTypeSkim) {
        url = [NSString stringWithFormat:@"%@/rank/topClick?apikey=%@&size=%i", HOST, KEY, 20];
        category = @"skimTop";
        NSLog(@"get skim");
    } else {
        url = [NSString stringWithFormat:@"%@/rank/topCertifyUser?apikey=%@&size=%i", HOST, KEY, 10];
        category = @"newsTop";
        NSLog(@"get new");
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];

        if ([dic[@"invoke"] boolValue]) {

            NSArray *array = [[dic objectForKey:@"result"] objectForKey:@"list"];
            [[ForthonDataContainer sharedStore] setValue:array forKey:category];

            NSString *pathStr = [category stringByAppendingString:@".plist"];
            [self dataCacheWithPath:pathStr data:array];

        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"ERROR!: %@", error);
        [self sendNotificationNetError];
    }];

}


- (void)getResultBySearchKeyword:(NSString *)keyword
{
    NSString *url;
    url = [NSString stringWithFormat:@"%@/other/search?apikey=%@&keyword=%@", HOST, KEY, keyword];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//URL里不能加中文，因此编码一下

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer  = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSError *err;
        NSDictionary *dic = [[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err] objectForKey:@"result"];
//        NSLog(@"result: %@", dic);
        
        NSMutableDictionary *resultDic = [ForthonDataContainer sharedStore].searchResultDic;
        [resultDic setObject:[[dic objectForKey:@"page"] objectForKey:@"pages"] forKey:@"page"];
        [resultDic setObject:[[dic objectForKey:@"art"] objectForKey:@"arts"] forKey:@"art"];
        [resultDic setObject:[[dic objectForKey:@"user"] objectForKey:@"users"] forKey:@"user"];
        [resultDic setObject:[[dic objectForKey:@"video"] objectForKey:@"videos"] forKey:@"video"];
        
        [self sendNotification];

        
        NSLog(@"resultDic: %@", [ForthonDataContainer sharedStore].searchResultDic);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
        NSLog(@"ERROR: %@", error);
    }];
    
}


- (void)getUserArtGroupById:(NSString *)authorId
{
    NSString *url = [NSString stringWithFormat:@"%@/art/getUserArtGroup?apikey=%@&userid=%@", HOST, KEY, authorId];
    NSLog(@"artUrl: %@", url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];

        
        if ([[dic objectForKey:@"invoke"] boolValue]) {
            
//            [ForthonDataContainer sharedStore].authorArtGroup = [[dic objectForKey:@"result"] objectForKey:@"group"];
            NSMutableDictionary *returnDic = [NSMutableDictionary new];
            [returnDic setObject:[[dic objectForKey:@"result"] objectForKey:@"group"] forKey:@"artGroup"];
        
            [self sendNotificationWithReturnDic:returnDic];
        }
        
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"ERROR: %@", error);
    }];
    
    
}

- (void)getUserPagesById:(NSString *)authorId {

    NSString *url = [NSString stringWithFormat:@"%@/page/getPages?apikey=%@&userid=%@", HOST, KEY, authorId];
    NSLog(@"pageUrl: %@", url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){

        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];


        if ([[dic objectForKey:@"invoke"] boolValue]) {

//            [ForthonDataContainer sharedStore].authorArtGroup = [[dic objectForKey:@"result"] objectForKey:@"group"];
            NSMutableDictionary *returnDic = [NSMutableDictionary new];
            [returnDic setObject:[[dic objectForKey:@"result"] objectForKey:@"pages"] forKey:@"pageGroup"];

            [self sendNotificationWithReturnDic:returnDic];
        }


    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"ERROR: %@", error);
    }];

}


#pragma mark - MY series

- (void)getMyPagesByPage:(int)page {

    NSLog(@"before get");
    NSString *url = [NSString stringWithFormat:@"%@/page/getPages?apikey=%@&userid=%@&page=%i", HOST, KEY, _userId, page];
    
    NSLog(@"Url: %@", url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *err = [[NSError alloc] init];;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];


        if (!_userId) {

            [self sendNotificationUserError];
        }

        if ([dic[@"invoke"] boolValue]) {

            NSMutableArray *pagesArray;

            if (page == 1) {

                pagesArray = [[dic objectForKey:@"result"] objectForKey:@"pages"];
            } else {

                pagesArray = [[ForthonDataContainer sharedStore] valueForKey:@"myPages"];
                [pagesArray addObjectsFromArray:[dic[@"result"] objectForKey:@"pages"]];
            }
            if ([pagesArray count]) {

                [[ForthonDataContainer sharedStore] setValue:pagesArray forKey:@"myPages"];

            } else {

                NSArray *noneArray = @[@"None"];
                [[ForthonDataContainer sharedStore] setValue:noneArray forKey:@"myPages"];
            }

        } else {

            NSLog(@"ERROR: %@", [dic objectForKey:@"error"]);
        }

    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"ERROR: %@", error);
        [self sendNotificationNetError];
    }];
    
}

- (void)getMyFavorsByPage:(int)page
{

    NSString *url = [NSString stringWithFormat:@"%@/favor/getFavors?apikey=%@&authkey=%@&page=%i", HOST, KEY, _authKey, page];
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSLog(@"favorUrl: %@", url);
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSError *err;
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        
        if ([[dic objectForKey:@"invoke"] boolValue] == YES) {
            
            NSLog(@"成功获取我的收藏");
            NSMutableArray *favorsArray;
            if (page == 1) {
                
                favorsArray = [NSMutableArray arrayWithArray:[[dic objectForKey:@"result" ] objectForKey:@"favors"]];
            } else {
                
                favorsArray = [[ForthonDataContainer sharedStore] valueForKey:@"myFavors"];
                [favorsArray addObjectsFromArray:[NSMutableArray arrayWithArray:[[dic objectForKey:@"result" ] objectForKey:@"favors"]]];
            }
            
            if ([favorsArray count]) {

                 [[ForthonDataContainer sharedStore] setValue:favorsArray forKey:@"myFavors"];
            }  else {

                NSArray *noneArray = @[@"None"];
                [[ForthonDataContainer sharedStore] setValue:noneArray forKey:@"myFavors"];
            }

        } else {

            [SVProgressHUD showErrorWithStatus:dic[@"error"] maskType:SVProgressHUDMaskTypeBlack];
        }


    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
        NSLog(@"ERROR: %@", error);
        [self sendNotificationNetError];
    }];
    
    
}

- (void)getMyCommentsByPage:(int)page
{

    NSString *url = [NSString stringWithFormat:@"%@/comment/getReplies?apikey=%@&authkey=%@&page=%i", HOST, KEY, _authKey, page];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
     
        if ([[dic objectForKey:@"invoke"] boolValue] == YES) {
            
            NSLog(@"成功获取我的评论");
            NSMutableArray *commentsArray;
            if (page == 1) {
                
                commentsArray = [NSMutableArray arrayWithArray:[[dic objectForKey:@"result" ] objectForKey:@"replies"]];
            } else {
                
                commentsArray = [[ForthonDataContainer sharedStore] valueForKey:@"myComments"];
                [commentsArray addObjectsFromArray:[NSMutableArray arrayWithArray:[[dic objectForKey:@"result" ] objectForKey:@"replies"]]];
            }

            if ([commentsArray count]) {

                [[ForthonDataContainer sharedStore] setValue:commentsArray forKey:@"myComments"];

            } else {

                NSArray *noneArray = @[@"None"];
                [[ForthonDataContainer sharedStore] setValue:noneArray forKey:@"myComments"];
            }

        } else {
            
            NSLog(@"ERROR: %@", [dic objectForKey:@"error"]);

        }
    
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
        NSLog(@"ERROR: %@", error);
        [self sendNotificationNetError];
    }];
    
}

#pragma mark 获取未阅读评论数

- (void)getMyCommentsNoRead {
    
    NSString *url = [NSString stringWithFormat:@"%@/comment/unReadCnt?apikey=%@&authkey=%@", HOST, KEY, _authKey];
//    NSLog(@"commentUrl : %@", url);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * operation, id responseObject) {
        
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        if ([[dic objectForKey:@"invoke"] boolValue]) {
            
            NSLog(@"成功获取未评论数");
            NSNumber *unRead = [[dic objectForKey:@"result"] objectForKey:@"unreadCnt"];
            
            [[ForthonDataContainer sharedStore] setValue:unRead forKey:@"unReadCommentsNumber"];

        } else {

            _userId = nil;
            _avatarUrl = nil;

            [[ForthonDataContainer sharedStore] setValue:@"0" forKey:@"unReadCommentsNumber"];
            [[ForthonDataContainer sharedStore] setValue:@"out" forKey:@"appIsLogin"];

        }
        
    } failure:^ (AFHTTPRequestOperation * operation, NSError * error) {
        
        NSLog(@"Error: %@", error);
        [self sendNotificationNetError];
    }];
    
    
}


#pragma mark 设置评论状态为阅读

- (void)setCommentStatusRead:(NSString *)commentId {
    
    NSString *url = [NSString stringWithFormat:@"%@/comment/markRead?apikey=%@&id=%@&read=true", HOST, KEY, commentId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * operation, id responseObject) {
        
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        if ([[dic objectForKey:@"invoke"] boolValue]) {
            
            NSLog(@"朕已阅");
        }
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        
        NSLog(@"error: %@", error);
        
    }];
    
}


- (void)getMyFollowsByPage:(int)page {

    NSString *url = [NSString stringWithFormat:@"%@/follow/getFollowList?apikey=%@&authkey=%@&page=%i", HOST, KEY, _authKey, page];
    NSLog(@"url :%@", url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        if ([[dic objectForKey:@"invoke"] boolValue] == YES) {
            
            NSLog(@"成功获取我的关注");
            
            NSMutableArray *followsArray;
            if (page == 1) {
                
                followsArray = [NSMutableArray arrayWithArray:[dic[@"result"] objectForKey:@"users"]];
            } else {
                
                followsArray = [[ForthonDataContainer sharedStore] valueForKey:@"myFollows"];
                [followsArray addObjectsFromArray:[NSMutableArray arrayWithArray:[dic[@"result"] objectForKey:@"users"]]];
            }
            if ([followsArray count]) {

                [[ForthonDataContainer sharedStore] setValue:followsArray forKey:@"myFollows"];
            } else {
                NSArray *noneArray = @[@"None"];
                [[ForthonDataContainer sharedStore] setValue:noneArray forKey:@"myFollows"];
            }

            
        } else {
            
            NSLog(@"ERROR: %@", [dic objectForKey:@"error"]);
            if ([[dic objectForKey:@"error"] isEqualToString:@"用户验证失败"]) {
            
                [self sendNotificationUserError];
            }
        }
//

    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
        NSLog(@"ERROR: %@", error);
        [self sendNotificationNetError];
    }];

    
}

- (void)getMyWorksByPage:(int)page {
    
    NSString *url = [NSString stringWithFormat:@"%@/art/getUserArtGroup?apikey=%@&userid=%@&page=%i", HOST, KEY, _userId, page];;
    NSLog(@" url : %@", url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        if ([[dic objectForKey:@"invoke"] boolValue]) {
    
            NSMutableArray *worksArray = [NSMutableArray new];
            if (page == 1) {

                for (int i = 0; i < [dic[@"result"][@"cnt"] intValue]; i++) {

                    [worksArray addObjectsFromArray:dic[@"result"][@"group"][i][@"artList"]];
                 
                }

            } else {

                NSLog(@"loadMore");
                worksArray = [[ForthonDataContainer sharedStore] valueForKey:@"myWorks"];
                for (int i = 0; i < [dic[@"cut"] intValue]; i++) {

                    [worksArray addObjectsFromArray:dic[@"group"][i][@"artList"]];
                }

            }
            if ([worksArray count]) {

                [[ForthonDataContainer sharedStore] setValue:worksArray forKey:@"myWorks"];
            } else {
                NSArray *noneArray = @[@"None"];
                [[ForthonDataContainer sharedStore] setValue:noneArray forKey:@"myWorks"];
            }


        } else if ([[dic objectForKey:@"error"] isEqualToString:@"用户验证错误"]) {
            
            [self sendNotificationUserError];
        }
        
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
        NSLog(@"ERROR: %@", error);
        [self sendNotificationNetError];
        
    }];
    
}



- (void)getMyWorksByTypeid:(int)typeid  {
    
    
    NSString *url = [NSString stringWithFormat:@"%@/art/getArtList?apikey=%@&typeid=%i&usernick=%@", HOST, KEY, typeid, _userNick];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//URL里不能加中文，因此编码一下
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        if ([dic[@"invoke"] boolValue]) {
            
            NSMutableArray *worksArray = [dic[@"result"] objectForKey:@"arts"];
            
        

            if ([worksArray count]) {

                [[ForthonDataContainer sharedStore] setValue:worksArray forKey:@"myWorks"];

            } else {

                NSArray *noneArray = @[@"None"];
                [[ForthonDataContainer sharedStore] setValue:noneArray forKey:@"myWorks"];
            }


        } else if ([dic[@"error"] isEqualToString:@"用户验证失败"]) {
           
            [self sendNotificationUserError];
        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
        NSLog(@"ERROR: %@", error);
        
    }];
    
    
}

#pragma mark 获取关注状态

- (void)getFollowStatusByTargetId:(NSString *)targetId
{

    NSString *url = [NSString stringWithFormat:@"%@/follow/isFollow", HOST];
    NSLog(@"url: %@", url);
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    parameters[@"apikey"] = KEY;
    parameters[@"targetid"] = targetId;
    if (_userId) {
        
        parameters[@"userid"] = _userId;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        
        NSString *followResult = [[NSString alloc] init];
        
        if ([dic[@"invoke"] boolValue]) {
            
            BOOL isFollow = [[[dic[@"result"] objectForKey:@"follows"][0] objectForKey:@"follow"] boolValue];
            if (isFollow) {
                
                NSLog(@"发送已关注");
                followResult = @"1";
                
            } else if (!isFollow) {
                
                followResult = @"0";
                NSLog(@"发送关注取消");
                
            }
            NSDictionary *resultDic = @{
                                        @"result":followResult
                                        };
            
            NSString *notificationName = [NSString stringWithFormat:@"NotificationId%@Follow",targetId];
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:resultDic];
        } else {
            
            NSDictionary *resultDic = @{
                                        @"result":@"0"
                                        };
            NSString *notificationName = [NSString stringWithFormat:@"NotificationId%@Follow", targetId];
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:resultDic];
        }
        
        
    }failure:^(AFHTTPRequestOperation *opreation, NSError *error){
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark 添加/取消 关注

- (void)setFollowWithTargetId:(NSString *)targetId
{
    
    NSString *url = [NSString stringWithFormat:@"%@/follow/addFollow?apikey=%@&authkey=%@&targetid=%@", HOST, KEY, _authKey, targetId];
    NSLog(@"url: %@", url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        
        
        if ([dic[@"invoke"] boolValue]) {
            
            NSLog(@"关注成功");
            NSString *followResult = @"1";
            NSDictionary *dic = @{
                                  @"result":followResult
                                  };

            NSString *notificationName = [NSString stringWithFormat:@"NotificationId%@Follow",targetId];
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:dic];
            
        } else {
            
            NSLog(@"ERROR: %@", dic[@"error"]);
            id o = dic[@"error"];
            if ([o respondsToSelector:@selector(isEqualToString:)]) {
                if ([o isEqualToString:@"用户验证失败"]) {

                    [self sendNotificationUserError];
                }
            }
        }
        
        
        
        
    }failure:^(AFHTTPRequestOperation *opreation, NSError *error){
        NSLog(@"Error: %@", error);
        [SVProgressHUD showErrorWithStatus:@"网络异常" maskType:SVProgressHUDMaskTypeBlack];
    }];
}


- (void)cancelFollowWithTargetId:(NSString *)targetId andNotification:(BOOL)notification
{

    
    NSString *url = [NSString stringWithFormat:@"%@/follow/delFollow?apikey=%@&authkey=%@&targetid=%@", HOST, KEY, _authKey, targetId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        
        if ([dic[@"invoke"] boolValue]) {

            NSLog(@"取消关注成功");
            
            if (notification) {
                
                NSString *followResult = @"0";
                NSDictionary *dic = @{
                                      @"result":followResult
                                      };
                
                NSString *notificationName = [NSString stringWithFormat:@"NotificationId%@Follow",targetId];
                [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:dic];
            }

            
        } else {
            
             NSLog(@"ERROR: %@", [dic objectForKey:@"error"]);
            if ([[dic objectForKey:@"error"] isEqualToString:@"用户验证失败"]) {
                
                [self sendNotificationUserError];
            }

        }
        
        
       

        
    }failure:^(AFHTTPRequestOperation *opreation, NSError *error){
        NSLog(@"Error: %@", error);
    }];
}



#pragma mark - 获取收藏状态

- (void)getFaovrStatusByTypeid:(NSString *)typeId TargetId:(NSString *)targetId
{

    
    NSString *url = [NSString stringWithFormat:@"%@/favor/isFavor", HOST];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    NSLog(@"userId: %@", _userId);
    
    [parameters setObject:KEY forKey:@"apikey"];
    if ([_userId boolValue]) {
        
        [parameters setObject:_userId forKey:@"userid"];
    }
    [parameters setObject:typeId forKey:@"typeid"];
    [parameters setObject:targetId forKey:@"targetid"];

    NSLog(@"url: %@", url);
    NSLog(@"para: %@", parameters);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        
        
        if ([[dic objectForKey:@"invoke"] boolValue] == YES) {
           NSString *favorResult;
            BOOL isFavor = [[[[dic objectForKey:@"result"] objectForKey:@"favors"][0] objectForKey:@"favor"] boolValue];
            
            if (isFavor == YES) {
                
                favorResult = @"1";

            } else {
//                NSLog(@"未收藏");
                favorResult = @"0";
                
            }
            
            NSDictionary *dic = @{
                                  @"result":favorResult
                                  };
            
            NSString *notificationName = [NSString stringWithFormat:@"NotificationId%@Favor",targetId];
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:dic];
            
        } else {
            NSLog(@"error: %@", [dic objectForKey:@"error"]);
        }
        
        
    }failure:^(AFHTTPRequestOperation *opreation, NSError *error){
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark 添加/取消 收藏

- (void)setFavorWithTypeid:(int)typeid TargetId:(NSString *)targetId
{

    
    NSString *url = [NSString stringWithFormat:@"%@/favor/addFavor?apikey=%@&authkey=%@&typeid=%i&targetid=%@", HOST, KEY, _authKey, typeid, targetId];
    NSLog(@"url: %@", url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        
        if ([[dic objectForKey:@"invoke"] boolValue] == YES) {
            
            NSLog(@"收藏成功");
            NSString *favorResult = @"1";
            NSDictionary *dic = @{
                                  @"result":favorResult
                                  };
            
            NSString *notificationName = [NSString stringWithFormat:@"NotificationId%@Favor",targetId];
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:dic];

            
        }  else {
             NSLog(@"ERROR: %@", [dic objectForKey:@"error"]);
            if ([[dic objectForKey:@"error"] isEqualToString:@"用户验证失败"]) {
                
                [self sendNotificationUserError];
            }

        }
        
        
        
        
    }failure:^(AFHTTPRequestOperation *opreation, NSError *error){
        NSLog(@"Error: %@", error);
        [SVProgressHUD showErrorWithStatus:@"网络异常" maskType:SVProgressHUDMaskTypeBlack];
    }];
}

- (void)cancelFavorWithTypeid:(int)typeid TargetId:(NSString *)targetId
{

    
    NSString *url = [NSString stringWithFormat:@"%@/favor/delFavor?apikey=%@&authkey=%@&typeid=%i&targetid=%@", HOST, KEY, _authKey, typeid, targetId];
    NSLog(@"url: %@", url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        
        if ([[dic objectForKey:@"invoke"] boolValue] == YES) {
            
            NSLog(@"取消收藏成功");
            NSString *favorResult = @"0";
            NSDictionary *returnDic = @{
                                  @"result":favorResult
                                  };
            
            NSString *notificationName = [NSString stringWithFormat:@"NotificationId%@Favor",targetId];
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:returnDic];

        } else {
            
            NSLog(@"ERROR: %@", dic[@"error"]);
            NSLog(@"%@", [dic objectForKey:@"error"]);
            if ([[dic objectForKey:@"error"] isEqualToString:@"用户验证失败"]) {
                
                [self sendNotificationUserError];
            }

        }
        
        
    }failure:^(AFHTTPRequestOperation *opreation, NSError *error){
        NSLog(@"Error: %@", error);
    }];
}


#pragma mark - 添加浏览数

- (void)addSkimNumber:(NSString *)workId WithCategoryIndex:(int)category tinyTag:(int)tinyTag typeId:(int)typeId
{
    NSString *url;

    if (typeId == 1) {

        url = [NSString stringWithFormat:@"%@/video/addClick?apikey=%@&id=%@", HOST, KEY, workId];
    } else if (typeId  == 2) {

        url = [NSString stringWithFormat:@"%@/art/addClick?apikey=%@&id=%@", HOST, KEY, workId];
    } else {

        url = [NSString stringWithFormat:@"%@/page/addClick?apikey=%@&id=%@", HOST, KEY, workId];
    }


    NSLog(@"url: \n%@", url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        NSNumber *clickTimes;
        if ([dic[@"invoke"] boolValue]) {

            if (typeId  == 1) {

                clickTimes = [[[dic objectForKey:@"result"] objectForKey:@"video"] objectForKey:@"click"];
                if (tinyTag) {

                    [[ForthonDataContainer sharedStore].videosDic[category - 1][tinyTag] setObject:clickTimes forKey:@"click"];
                }

                [self sendSkimNotificationWithNumber:[clickTimes stringValue]];

            } else if (typeId == 3) {

                clickTimes = [[[dic objectForKey:@"result"] objectForKey:@"page"] objectForKey:@"click"];
                if (tinyTag) {

                    [[ForthonDataContainer sharedStore].pagesDic[tinyTag] setObject:clickTimes forKey:@"click"];
                }

                [self sendSkimNotificationWithNumber:[clickTimes stringValue]];

            } else if (typeId  == 2) {

                clickTimes = [[[dic objectForKey:@"result"] objectForKey:@"art"] objectForKey:@"click"];
                [self sendSkimNotificationWithNumber:[clickTimes stringValue]];
            }

        }

    }failure:^(AFHTTPRequestOperation *opreation, NSError *error){
        NSLog(@"Error: %@", error);
    }];
}




#pragma mark - login&register

- (void)registerUserWithName:(NSString *)name passWord:(NSString *)password phoneNumber:(NSString *)phoneNumber
{
    NSString *passwordMD5 = [self md5:password];
    NSString *url = [NSString stringWithFormat:@"%@/user/regUser?apikey=%@&pwd=%@&phone=%@", HOST, KEY, passwordMD5, phoneNumber];
    NSLog(@"url: \n%@", url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){

        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        if ([dic[@"invoke"] boolValue]) {

            [SVProgressHUD showSuccessWithStatus:@"注册成功" maskType:SVProgressHUDMaskTypeBlack];
//            [self loginWithIdstr:phoneNumber passWord:password];

            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationD" object:nil];
        } else {
            [SVProgressHUD showErrorWithStatus:dic[@"error"] maskType:SVProgressHUDMaskTypeBlack];
            NSLog(@"Error: %@", dic);
        }
//        [self sendNotification];

    }failure:^(AFHTTPRequestOperation *opreation, NSError *error){
        NSLog(@"Error: %@", error);
        [SVProgressHUD showErrorWithStatus:@"网络异常" maskType:SVProgressHUDMaskTypeBlack];
    }];
}

- (void)loginWithIdstr:(NSString *)idStr passWord:(NSString *)password
{
    NSString *url;
    password = [self md5:password];
    url = [NSString stringWithFormat:@"%@/user/doLogin?apikey=%@&idstr=%@&pwd=%@", HOST, KEY, idStr, password];
    NSLog(@"url: \n%@", url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        
        NSLog(@"invoke: %@", [dic objectForKey:@"invoke"]);

        if ([[dic objectForKey:@"invoke"] intValue] == 1) {
            
            NSLog(@"登录成功！！！");
            
            [[ForthonDataContainer sharedStore] setValue:@"1" forKey:@"appIsLogin"];
            _authKey = [[dic objectForKey:@"result"] objectForKey:@"authKey"];
            NSLog(@"authKey : %@", _authKey);
            NSDictionary *messageDic = [[dic objectForKey:@"result"] objectForKey:@"user"];
            
            _userId = [messageDic objectForKey:@"id"];
            _phoneNumber = [messageDic objectForKey:@"phone"];
            _userName = [messageDic objectForKey:@"name"];
            NSString *avatarUrlStr = [[messageDic objectForKey:@"avatarUrl"] changeToUrl];
            _avatarUrl = avatarUrlStr;
            
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:_userName forKey:@"userName"];
            [user setObject:_phoneNumber forKey:@"phoneNumber"];

            NSString *myNickName = [messageDic objectForKey:@"nickName"];
            _userNick = myNickName;
//            NSLog(@"messageDicUrl: %@", _avatarUrl);

            //            NSLog(@"user: %@", )
//            {
//            "result": {
//                "authKey": "F5B2112AA599565869DF104006C02EAF",
//                "user": {
//                    "favorPage": 0,
//                    "phone": "15928580434",
//                    "favorArt": 0,
//                    "fans": 0,
//                    "favorVideo": 0,
//                    "id": 824,
//                    "createtime": "2015-06-01 16:07:34",
//                    "name": "OEKL06349775",
//                    "reply": 0,
//                    "favor": 0,
//                    "follow": 0
//                }
//            },
//            
        [self sendNotification];
            
        } else {

            [SVProgressHUD showErrorWithStatus:dic[@"error"] maskType:SVProgressHUDMaskTypeBlack];
            NSLog(@"登录失败: 用户名或密码错误！");
        }
        
        
    }failure:^(AFHTTPRequestOperation *opreation, NSError *error){
        NSLog(@"Error: %@", error);
        [SVProgressHUD showErrorWithStatus:@"网络异常" maskType:SVProgressHUDMaskTypeBlack];
    }];
}

#pragma mark 退出登录

- (void)logOut
{
    NSString *url = [NSString stringWithFormat:@"%@/user/doLogout?apikey=%@&authkey=%@", HOST, KEY, _authKey];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSError *err = [[NSError alloc] init];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        NSLog(@"logout: %@:", dic);
        if ([[dic objectForKey:@"invoke"] boolValue]) {

//            [ForthonDataSpider sharedStore].avatarUrl = nil;
            _userId = nil;
            _avatarUrl = nil;
            [[ForthonDataContainer sharedStore] setValue:@"out" forKey:@"appIsLogin"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationLogout" object:nil];

        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
    }];
    

}


- (void)chageNameTo:(NSString *)name
{

     NSString *url = [NSString stringWithFormat:@"%@/user/changeName?apikey=%@&authkey=%@&name=%@", HOST, KEY, _authKey, name];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSError *err = [[NSError alloc] init];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        NSLog(@"NewName: %@:", dic);
        
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
    }];
    
    
}

#pragma mark - 获取版本号

- (void)getVersion {
    
    NSString *url = [NSString stringWithFormat:@"http://itunes.apple.com/search"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary *para = @{
                           @"term":@"主尚文化馆",
                           @"entity":@"software"
                           };
    
    [manager POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSError *err = [[NSError alloc] init];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        
        if ([dic[@"resultCount"] boolValue]) {

            NSString *appUrl = dic[@"results"][0][@"trackViewUrl"];
            NSString *version = dic[@"results"][0][@"version"];

            [self sendNotificationVersion:@{

                    @"appUrl":appUrl,
                    @"version":version
            }];

        } else {

            NSLog(@"无此应用！");
        }

    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
    }];
}

#pragma mark - 获取个人信息

- (void)getUserInfoByAuthkey:(NSString *)authkey
{
    NSString *url = [NSString stringWithFormat:@"%@/user/getInfo?apikey=%@&authkey=%@&", HOST, KEY, _authKey];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSError *err = [[NSError alloc] init];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        
        NSMutableDictionary *returnDic = [[NSMutableDictionary alloc] init];
        
        if ([[dic objectForKey:@"invoke"] boolValue]) {
            
            [returnDic setObject:@"1" forKey:@"invoke"];
            
        }
        else {
            
            [returnDic setObject:@"0" forKey:@"invoke"];
        }
        
        [self sendNotificationWithReturnDic:returnDic];   //用通知传字典回去。
        
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
    }];
    
}


- (void)getUserInfoByUserId:(NSString *)userId {
    
    NSString *url = [NSString stringWithFormat:@"%@/user/getInfo?apikey=%@&id=%@&", HOST, KEY, userId];
    NSLog(@"url: %@", url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSError *err = [[NSError alloc] init];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        
        NSMutableDictionary *returnDic = [[NSMutableDictionary alloc] init];
        
        if ([[dic objectForKey:@"invoke"] boolValue]) {
            
            [returnDic setObject:@"1" forKey:@"invoke"];
            
            [[ForthonDataContainer sharedStore] setValue:[[dic objectForKey:@"result"] objectForKey:@"user"] forKey:@"userInfo"];
        }
        else {
            
            [returnDic setObject:@"0" forKey:@"invoke"];
        }
        
//        [self sendNotificationWithReturnDic:returnDic];   //用通知传字典回去。
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
    }];

    
}

-(void)uploadPhotoWithImage:(UIImage *)image {

    NSLog(@"开始上传");

    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://120.26.222.176:8080/upload-avatar.php"]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    UIImage *image = [UIImage imageNamed:@"spiderMan.jpg"];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    NSDictionary *parameters = @{@"username": @"dsf", @"password" : @"fsd"};
    AFHTTPRequestOperation *op = [manager POST:@"upload" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //do not put image inside parameters dictionary as I did, but append it!
        [formData appendPartWithFileData:imageData name:@"img" fileName:@"spiderMan.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        if ([dic[@"isOk"] boolValue]) {

            [SVProgressHUD showSuccessWithStatus:@"头像上传成功" maskType:SVProgressHUDMaskTypeBlack];
            [self updateInfoWithTargetId:nil avatarUrl:[dic objectForKey:@"msg"] profile:nil];

        } else {

            [SVProgressHUD showErrorWithStatus:@"头像上传失败" maskType:SVProgressHUDMaskTypeBlack];
        }



    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
    }];
    [op start];
}

#pragma mark - 修改个人头像


- (void)updateInfoWithTargetId:(NSString *)targetId
                     avatarUrl:(NSString *)imageUrl
                       profile:(NSString *)profile
{

    NSString *url = [NSString stringWithFormat:@"%@/user/updateInfo", HOST];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
//    [parameters setObject:1 forKey:targetId];
//    [parameters setObject:@"" forKey:nickName];
//    [parameters setObject:@"" forKey:profile];
    [parameters setObject:_authKey forKey:@"authkey"];
    [parameters setObject:KEY forKey:@"apikey"];
    if (targetId) {
        [parameters setObject:targetId forKey:@"id"];
    }
    if (imageUrl) {
        [parameters setObject:imageUrl forKey:@"avatarurl"];
    }
    if (profile) {
        [parameters setObject:profile forKey:@"profile"];
    }
   
    
    NSLog(@"para: %@", parameters);
//    NSDictionary *parameters = @{
//                                 @"apikey":KEY,
//                                 @"authKey":_authKey,
//                                 @"id":targetId,
//                                 @"nickName":nickName,
//                                 @"avatarUrl":imageUrl,
//                                 @"profile":profile
//                                 };
//    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSError *err = [[NSError alloc] init];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        NSDictionary *messageDic = [[dic objectForKey:@"result"] objectForKey:@"user"];
       
        [[ForthonDataSpider sharedStore] setValue:[[messageDic objectForKey:@"avatarUrl"] changeToUrl] forKey:@"avatarUrl"];
        
        NSLog(@"updateInfo: %@", dic);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
    }];
    
}

#pragma mark 修改昵称

- (void)modifyNickNameWithName:(NSString *)nickName
{
    NSString *url = [NSString stringWithFormat:@"%@/user/updateInfo?apikey=%@&authkey=%@&nickname=%@", HOST, KEY, _authKey, nickName];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];


    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSError *err = [[NSError alloc] init];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];

        if ([[dic objectForKey:@"invoke"] boolValue]) {

            NSDictionary *messageDic = [[dic objectForKey:@"result"] objectForKey:@"user"];
            NSString *myNickName = [messageDic objectForKey:@"nickName"];

            [[ForthonDataSpider sharedStore] setValue:myNickName forKey:@"userNick"];
        }

    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        [self sendNotificationNetError];
    }];
    
}


#pragma mark 修改密码

- (void)modifyPasswordWithOldPassword:(NSString *)oldPassword
                                   To:(NSString *)newPassword
{
    
    NSString *url = [NSString stringWithFormat:@"%@/user/changePwd?apikey=%@&authkey=%@&oldpwd=%@&pwd=%@", HOST, KEY, _authKey, [self md5:oldPassword], [self md5:newPassword]];
    NSLog(@"url: \n%@", url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        NSString *result;
        if ([[dic objectForKey:@"invoke"] boolValue]) {
            
            NSLog(@"密码修改成功!");
            result = @"1";

            
        } else {

            result = @"0";
            NSLog(@"error: %@", [dic objectForKey:@"error"]);
        }
        NSDictionary *resultDic = @{
                                    @"result":result
                                     };
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationPassword"
                                                            object:nil
                                                          userInfo:resultDic];

    }failure:^(AFHTTPRequestOperation *opreation, NSError *error){
        NSLog(@"Error: %@", error);
        [self sendNotificationNetError];
    }];

    
}

#pragma mark 重置密码

- (void)resetPasswordByPhoneNumber:(NSString *)phoneNumber password:(NSString *)newPassword
{
    NSString *url = [NSString stringWithFormat:@"%@/user/resetPwd?apikey=%@&phone=%@&pwd=%@", HOST, KEY, phoneNumber, [self md5:newPassword]];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        if ([[dic objectForKey:@"invoke"] boolValue]) {
            //lfs
//            _userName = [[[dic objectForKey:@"result"] objectForKey:@"user"] objectForKey:@"name"];
            NSLog(@"密码重置成功");
            [SVProgressHUD showSuccessWithStatus:@"密码重置成功" maskType:SVProgressHUDMaskTypeBlack];
        } else {

            NSLog(@"error: %@", [dic objectForKey:@"error"]);
        }
        
        
        
    }failure:^(AFHTTPRequestOperation *opreation, NSError *error){
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark 修改用户名

- (void)modifyUserNameWithName:(NSString *)name
{
    
    NSString *url = [NSString stringWithFormat:@"%@/user/changeName?apikey=%@&authkey=%@&name=%@", HOST, KEY, _authKey, name];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        if ([[dic objectForKey:@"invoke"] boolValue]) {
            NSString *newName = [[[dic objectForKey:@"result"] objectForKey:@"user"] objectForKey:@"name"];
            [[ForthonDataSpider sharedStore] setValue:newName forKey:@"userName"];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:newName forKey:@"userName"];
            NSLog(@"用户名修改成功");
//            [self sendNotification];
            NSLog(@"dic: %@", dic);
        } else {
            NSLog(@"error: %@", [dic objectForKey:@"error"]);
        }
        

    }failure:^(AFHTTPRequestOperation *opreation, NSError *error){
        NSLog(@"Error: %@", error);
        [self sendNotificationNetError];
    }];

}

#pragma mark 修改手机号

- (void)modifyPhoneNumberWithNumber:(NSString *)phoneNumber
{
    NSString *url = [NSString stringWithFormat:@"%@/user/changePhone?apikey=%@&authkey=%@&name=%@", HOST, KEY, _authKey, phoneNumber];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        NSMutableDictionary *returnDic = [NSMutableDictionary new];
        if ([dic[@"invoke"] boolValue]) {
            
            _phoneNumber = [[dic[@"result"] objectForKey:@"user"] objectForKey:@"phone"];
            NSLog(@"手机号修改成功");
            [returnDic setObject:@"1" forKey:@"result"];

        } else {
            NSLog(@"error: %@", dic[@"error"]);
            [returnDic setObject:@"0" forKey:@"result"];
            [returnDic setObject:dic[@"error"] forKey:@"message"];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationModifyPhone" object:nil userInfo:returnDic];
        
    }failure:^(AFHTTPRequestOperation *opreation, NSError *error){
        NSLog(@"Error: %@", error);
    }];
}


#pragma mark 验证用户和手机号是否存在

- (void)confirmUserExistByUserName:(NSString *)userName phoneNumber:(NSString *)phone
{

    NSString *url = [NSString stringWithFormat:@"%@/user/isUserExist?apikey=%@&name=%@&phone=%@", HOST, KEY, userName, phone];
    NSLog(@"numberUrl: %@", url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        if ([[dic objectForKey:@"invoke"] boolValue]) {

            NSString *result;
            if ([[dic[@"result"] objectForKey:@"phone"] boolValue]) {

                NSLog(@"手机号正确");
                result = @"1";
            }
            else {
                NSLog(@"当前手机号不存在");
                result = @"0";
            }

            NSDictionary *resultDic = @{

                            @"result":result
                    };
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationNumberConfirm" object:nil userInfo:resultDic];

        } else {

            NSLog(@"error: %@", [dic objectForKey:@"error"]);
            [SVProgressHUD showErrorWithStatus:dic[@"error"] maskType:SVProgressHUDMaskTypeBlack];
        }

    }failure:^(AFHTTPRequestOperation *opreation, NSError *error){

        NSLog(@"Error: %@", error);
        [self sendNotificationNetError];

    }];
}


#pragma mark 短信验证

- (void)sendIdentifyingCode:(NSString *)phoneNumber
{
    NSString *url = [NSString stringWithFormat:@"%@/sms/sendCode?apikey=%@&phone=%@", HOST, KEY, phoneNumber];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];

        NSMutableDictionary *returnDic = [NSMutableDictionary new];
        if ([[dic objectForKey:@"invoke"] boolValue]) {

            [SVProgressHUD showSuccessWithStatus:@"验证码已发送" maskType:SVProgressHUDMaskTypeBlack];
            [returnDic setObject:@"1" forKey:@"result"];

        } else {
            [returnDic setObject:@"0" forKey:@"result"];
            [returnDic setObject:dic[@"error"] forKey:@"message"];
            NSLog(@"code error: %@", [dic objectForKey:@"error"]);
            [SVProgressHUD showErrorWithStatus:dic[@"error"] maskType:SVProgressHUDMaskTypeBlack];
        }

        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationCode" object:nil userInfo:returnDic];

    }failure:^(AFHTTPRequestOperation *opreation, NSError *error){
        NSLog(@"Error: %@", error);

    }];
}

- (void)confirmPhone:(NSString *)phoneNumber WithCode:(NSString *)code {

    NSString *url = [NSString stringWithFormat:@"%@/sms/verifyCode?apikey=%@&phone=%@&code=%@", HOST, KEY, phoneNumber, code];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        if ([[dic objectForKey:@"invoke"] boolValue]) {

            NSString *returnResult;
            if ([[dic[@"result"] objectForKey:@"valid"] boolValue]) {

                NSLog(@"验证成功");
                returnResult = @"1";

            } else {

                NSLog(@"%@", [dic[@"result"] objectForKey:@"msg"]);
                [SVProgressHUD showErrorWithStatus:[dic[@"result"] objectForKey:@"msg"] maskType:SVProgressHUDMaskTypeBlack];

                returnResult = @"0";
            }
            NSDictionary *resultDic = @{

                    @"returnResult":returnResult
            };
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationConfirmCode" object:nil userInfo:resultDic];

        } else {

            NSLog(@"error: %@", [dic objectForKey:@"error"]);
            [SVProgressHUD showErrorWithStatus:dic[@"error"] maskType:SVProgressHUDMaskTypeBlack];
        }

    }failure:^(AFHTTPRequestOperation *opreation, NSError *error){
        NSLog(@"Error: %@", error);
    }];

}

#pragma mark 绑定手机

- (void)bindPhoneToAppWithPhoneNumber:(NSString *)phoneNumber identifyingCode:(NSString *)code
{
    NSString *url = [NSString stringWithFormat:@"%@/sms/verifyCode?apikey=%@&phone=%@&code=%@", HOST, KEY, phoneNumber, code];
    NSLog(@"绑定手机: %@", url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        NSMutableDictionary *returnDic = [NSMutableDictionary new];
        if ([[dic objectForKey:@"invoke"] boolValue]) {

            if ([[dic[@"result"] objectForKey:@"valid"] boolValue]) {

                NSLog(@"该手机号可用于绑定");
                [self modifyPhoneNumberWithNumber:phoneNumber];

            } else {
                [returnDic setObject:@"0" forKey:@"result"];
                [returnDic setObject:[dic[@"result"] objectForKey:@"msg"] forKey:@"message"];

                NSLog(@"error: %@", [dic[@"result"] objectForKey:@"msg"]);
            }

            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationModifyPhone" object:nil userInfo:returnDic];
        } else {
            NSLog(@"error: %@", [dic objectForKey:@"error"]);
        }
        
    }failure:^(AFHTTPRequestOperation *opreation, NSError *error){
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - 用图片生成url


//-(void)uploadPhoto{
//    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://120.26.222.176:8080/upload-avatar.php"]];
//    NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"boyi_youhua_btn.png"], 0.5);
//    NSDictionary *parameters = @{@"username": @"dsf", @"password" : @"fsd"};
//    AFHTTPRequestOperation *op;
//    op = [manager POST:@"upload" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        //do not put image inside parameters dictionary as I did, but append it!
//        [formData appendPartWithFileData:imageData name:@"img" fileName:@"boyi_you.png" mimeType:@"image/jpeg"];
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//
//        NSError *err;
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
//        if ([dic[@"isOk"] boolValue]) {
//
//            NSLog(@"图片上传成功");
//
//        } else {
//
//            NSLog(@"图片上传失败");
//            [SVProgressHUD showErrorWithStatus:@"上传图片失败" maskType:SVProgressHUDMaskTypeBlack];
//        }
//
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//
//        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
//
//
//
//    }];
//    [op start];
//}



#pragma mark 提交订单

- (void)submitOrderWithWorkId:(NSString *)workId
                    recipient:(NSString *)recipient
                  phoneNumber:(NSString *)phoneNumber
                      address:(NSString *)address {
    
    NSString *url = [NSString stringWithFormat:@"%@/trade/addTrade?apikey=%@&artid=%@&userid=%@&recipient=%@&contact=%@&addr=%@",
                    HOST, KEY, workId, _userId, recipient, phoneNumber, address];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"orderUrl :  %@", url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        
        NSString *resultStr;
        if ([[dic objectForKey:@"invoke"] boolValue]) {
            NSLog(@"恭喜！订单提交成功！");
            resultStr = @"1";
        } else {
            NSLog(@"error: %@", [dic objectForKey:@"error"]);
            resultStr = @"0";
        }
        
        [self sendNotificationOrderResult:resultStr];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"ERROR: %@", error);
    }];
    
    
}

- (void)getWorkTradeState:(NSString *)workId
{

    NSString *url = [NSString stringWithFormat:@"%@/art/getArtInfo?apikey=%@&id=%@", HOST, KEY, workId];
    NSLog(@"url: \n%@", url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];

        NSDictionary *artDescription = [[dic objectForKey:@"result"] objectForKey:@"art"];
        NSLog(@"art: %@", artDescription);
       
        [self sendNotificationTradeState:[artDescription objectForKey:@"tradeState"]];
        
        
        
    }failure:^(AFHTTPRequestOperation *opreation, NSError *error){
        NSLog(@"Error: %@", error);
    }];

}

- (void)getOrderProtocol {

    NSString *url = [NSString stringWithFormat:@"%@/trade/getTreaty?apikey=%@", HOST, KEY];
    NSLog(@"url: \n%@", url);

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager GET:url parameters: nil success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        if ([dic[@"invoke"] boolValue]) {

            [[ForthonDataContainer sharedStore] setValue:dic[@"result"][@"treaty"][@"content"] forKey:@"orderProtocol"];
            [SVProgressHUD showSuccessWithStatus:@"加载成功" maskType:SVProgressHUDMaskTypeBlack];
        } else {

            [SVProgressHUD showErrorWithStatus:@"加载失败" maskType:SVProgressHUDMaskTypeBlack];
        }

    }failure:^(AFHTTPRequestOperation *opreation, NSError *error){
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - 分享URL

- (void)getShareUrlWithTypeid:(int)typeid TargetId:(NSString *)targetId
{
    NSString *url = [NSString stringWithFormat:@"%@/other/getShareUrl?apikey=%@&typeid=%i&targetid=%@&showlink=true", HOST, KEY, typeid, targetId];
    NSLog(@"url: \n%@", url);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        
        NSLog(@"shareDic: %@", dic) ;
        NSMutableDictionary *urlDic = [[NSMutableDictionary alloc] init];
        
        NSString *shareUrl = [[[dic objectForKey:@"result"] objectForKey:@"resUrl"] changeToUrl];

        [urlDic setObject:shareUrl  forKey:@"shareUrl"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationUrl" object:nil userInfo:urlDic];
        
    }failure:^(AFHTTPRequestOperation *opreation, NSError *error){
        NSLog(@"Error: %@", error);
    }];
}

- (void)addShareByType:(int)type workId:(NSString *)workId {

    NSArray *typeArray = @[@"None",@"video", @"art", @"page"];
    NSString *url = [NSString stringWithFormat:@"%@/%@/addShare?apikey=%@&id=%@", HOST, typeArray[type], KEY,workId];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];

        if ([dic[@"invoke"] boolValue]) {

            NSString *shareStr = dic[@"result"][typeArray[type]][@"share"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationAddShare" object:nil userInfo:@{
                    @"share":shareStr
            }];
        }

    }failure:^(AFHTTPRequestOperation *opreation, NSError *error){
        NSLog(@"Error: %@", error);
    }];
}



#pragma mark - 发送评论

- (void)sendCommentsByTypeid:(int)typeid targetId:(NSString *)workId fatherId:(NSString *)fatherId content:(NSString *)content
{
 
    NSString *typeidString = [NSString stringWithFormat:@"%i",typeid];
    if (fatherId == NULL)
        fatherId = @"";
     NSString *url = [NSString stringWithFormat:@"%@/comment/addComment?apikey=%@&authkey=%@&typeid=%@&targetid=%@&fatherid=%@&content=%@", HOST, KEY, _authKey, typeidString, workId, fatherId, content];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//URL里不能加中文，因此编码一下
    NSLog(@"url:%@", url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];

    

    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];

        NSLog(@"error: %@", [dic objectForKey:@"error"]);
        if ([[dic objectForKey:@"invoke"] intValue] == 1) {
            
            NSLog(@"发布成功！君、棒棒哒");
            
            [self getCommentByTypeid:typeid targetId:workId page:1];
            
        } else if ([[dic objectForKey:@"error"] isEqualToString:@"用户验证失败"]) {
            
            [self sendNotificationUserError];
            
        } else {
            
             NSLog(@"发表评论失败！君、请重来");
        }

        
    
    }
        failure:^(AFHTTPRequestOperation *operation, NSError *error){
            NSLog(@"Error: %@", error);

            [SVProgressHUD showErrorWithStatus:@"网络异常" maskType:SVProgressHUDMaskTypeBlack];
        }];



}

#pragma mark - 艺术品搜索

/**
 *  艺术品搜索
 *
 *  @param keyword    <#keyword description#>
 *  @param typeid     <#typeid description#>
 *  @param isTrade    <#isTrade description#>
 *  @param pagenumber <#pagenumber description#>
 */

- (void)seachArtByKeyword:(NSString *)keyword typeid:(int)typeid trade:(BOOL)isTrade pageNumber:(int)pagenumber
{
    NSString *T_F;
    if (isTrade) {
        T_F = @"true";
    } else {
        T_F = @"false";
    }
    NSString *url = [NSString stringWithFormat:@"%@/other/artSearch?apikey=%@&keyword=%@&typeid=%i&trade=%@&pagenumber=%i", HOST, KEY, keyword, typeid, T_F, pagenumber];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        
        NSMutableArray *targetArray = [[dic objectForKey:@"result"] objectForKey:@"arts"];
        if (pagenumber == 1) {
            
            [[ForthonDataContainer sharedStore] setValue:targetArray forKey:@"artSearchResultArray"];
        } else {
            NSMutableArray *resultArray = [[ForthonDataContainer sharedStore] valueForKeyPath:@"artSearchResultArray"];
            [resultArray addObjectsFromArray:targetArray];
            [[ForthonDataContainer sharedStore] setValue:resultArray forKey:@"artSearchResultArray"];
        }
        
    } failure:^(AFHTTPRequestOperation * peration, NSError *error) {
        NSLog(@"ERROR: %@", error);
    }];
    
}

#pragma mark - 意见反馈

- (void)sendSuggestWithContent:(NSString *)content contact:(NSString *)contact
{
    NSString *url = [NSString stringWithFormat:@"%@/other/addSuggest?apikey=%@&content=%@&contact=%@", HOST, KEY, content,contact];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];

    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        NSString *resultStr;
        if ([dic[@"invoke"] boolValue]) {

            NSLog(@"反馈信息提交成功");
            resultStr = @"1";
        } else {

            NSLog(@"反馈信息提交失败, again!~");
            resultStr = @"0";
        }
        NSDictionary *resultDic = @{
                @"result":resultStr
        };
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationAdvice" object:nil userInfo:resultDic];

    } failure:^(AFHTTPRequestOperation * peration, NSError *error) {
        NSLog(@"ERROR: %@", error);
    }];

}


#pragma mark - Notification

- (void)sendNotificationNetError {

    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationNetError"
                                                        object:nil
                                                      userInfo:nil];
}


- (void)sendNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationA"
                                                        object:self
                                                      userInfo:@{@"key1":@"Hello", @"key2":@"Bye"}];
}

- (void)sendNotificationWithReturnDic:(NSDictionary *)returnDic
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationA"
                                                        object:self
                                                      userInfo:returnDic];
}

- (void)sendNotificationVersion:(NSDictionary *)dic
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationVersion"
                                                        object:self
                                                      userInfo:dic];

}

- (void)sendSkimNotificationWithNumber:(NSString *)clickNumber

{
    NSLog(@"send skim");
    NSDictionary *numberDic = @{
                                @"clickNumber":clickNumber
                                };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationSkim"
                                                        object:nil
                                                      userInfo:numberDic];
}

- (void)sendNotificationB
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationB" object:self];
}

- (void)sendCommentNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationComment" object:self];
}

- (void)sendNotificationUserError
{
    NSLog(@"发送重新登录通知");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationUserError" object:self];
}

- (void)sendNotificationTradeState:(NSString *)tradeState
{
    NSDictionary *dic = @{
                          @"tradeState":tradeState
                          };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationTradeState" object:nil userInfo:dic];
}


- (void)sendNotificationOrderResult:(NSString *)result
{
    NSDictionary *dic = @{
                          @"result":result
                          };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationOrderResult" object:nil userInfo:dic];
}

#pragma mark - MD5

- (NSString *)md5:(NSString *)str

{
    
    const char *cStr = [str UTF8String];
    
    unsigned char result[16];
    
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    
    return [NSString stringWithFormat:
            
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            
            result[0], result[1], result[2], result[3],
            
            result[4], result[5], result[6], result[7],
            
            result[8], result[9], result[10], result[11],
            
            result[12], result[13], result[14], result[15]
            
            ];
    
}

#pragma mark - 缓存数据

- (void)dataCacheWithPath:(NSString *)pathKey data:(id)cacheData {

    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = documents[0];

    NSString *path = [docDir stringByAppendingPathComponent:pathKey];
    [cacheData writeToFile:path atomically:YES];

    NSLog(@"缓存数据");
}


@end
