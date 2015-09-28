//
//  ForthonDataSpider.m
//  Login
//
//  Created by Liu fushan on 15/5/16.
//  Copyright (c) 2015年 culturalCenter. All rights reserved.
//

#import "ForthonDataSpider.h"
#import "AFHTTPRequestOperationManager.h"
#import <UIKit/UIKit.h>


#define HOST @"http://api.art.uestcbmi.com"
#define KEY @"A6F7F0D6CD13058D40C1110F007E7F13"


@implementation ForthonDataSpider


+ (instancetype)sharedStore
{
    static ForthonDataContainer *sharedStore;
    
    // Do I need to create a sharedStore?
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    
    return sharedStore;
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

- (void)getVideosByTypeid:(int)typeid page:(int)page
{

    NSString *url = [NSString stringWithFormat:@"%@/video/getVideos?apikey=%@&typeid=%i&page=%i",
                     HOST, KEY, typeid, page];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
   
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSArray *videoArray = [[dic objectForKey:@"result"] objectForKey:@"videos"];
        
        NSLog(@"getVideos:");
        [ForthonDataContainer sharedStore].videosDic = videoArray;
        [NSThread detachNewThreadSelector:@selector(sendNotification)
                                 toTarget:self
                               withObject:nil];
        
        
    }failure:^(AFHTTPRequestOperation *opreation, NSError *error){
        NSLog(@"Error: %@", error);
        
    }];

}

- (void)sendNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationA"
                                                        object:self
                                                      userInfo:@{@"key1":@"Hello", @"key2":@"Bye"}];
}
- (void)getArtListByTypeid:(int)typeid trade:(BOOL)trade page:(int)page
{
    NSString *url = [[NSString alloc] init];
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
        NSLog(@"%@", responseString);
        NSArray *artList = [[dic objectForKey:@"result"] objectForKey:@"arts"];
        
        NSLog(@"getArts:");
        [ForthonDataContainer sharedStore].artListDic = artList;
        [NSThread detachNewThreadSelector:@selector(sendNotification)
                                 toTarget:self
                               withObject:nil];
        
        
    }failure:^(AFHTTPRequestOperation *opreation, NSError *error){
        NSLog(@"Error: %@", error);
    }];
}



@end
