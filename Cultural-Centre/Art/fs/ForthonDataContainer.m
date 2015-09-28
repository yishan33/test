//
//  ForthonDataContainer.m
//  Login
//
//  Created by Liu fushan on 15/5/18.
//  Copyright (c) 2015年 culturalCenter. All rights reserved.
//

#import "ForthonDataContainer.h"
#define HOST @"http://art.uestcbmi.com"





@implementation ForthonDataContainer



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

//
//- (NSMutableArray *)getVideoDic
//{
//    if (![_videosDic[0] objectForKey:@"headImage") {
//       
////        NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(updateUI) object:nil];
////        [thread start];
//        for (int i = 0; i < _videosDic.count; i++)
//            {
//            NSString *videoImageUrlStr = [NSString stringWithFormat:@"%@%@", HOST, [_videos[i] objectForKey:@"picUrl"]];
//            //    NSLog(@"videoImageUrl: \n%@", videoImageUrlStr);
//            NSString *headImageUrlStr = [NSString stringWithFormat:@"%@%@", HOST, [_videos[i] objectForKey:@"userAvatarUrl"]];
//            NSURL *videoImageUrl = [NSURL URLWithString:videoImageUrlStr];
//            NSURL *headImageUrl = [NSURL URLWithString:headImageUrlStr];
//            NSData *videoImageData = [[NSData alloc] initWithContentsOfURL:videoImageUrl];
//            //    NSLog(@"videoImageData: \n%@", videoImageData);
//            NSData *headImageData = [[NSData alloc] initWithContentsOfURL:headImageUrl];
////            [_videos[i] setObject:videoImageData forKey:@"videoImageData"];
////            [_videos[i] setObject:headImageData forKey:@"headImageData"];
//      
//            }
//
//    }
//    
//    return _videos;
//    
//}




@end
