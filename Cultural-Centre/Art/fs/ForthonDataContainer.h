//
//  ForthonDataContainer.h
//  Login
//
//  Created by Liu fushan on 15/5/18.
//  Copyright (c) 2015年 culturalCenter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ForthonDataContainer : NSObject



@property (nonatomic, strong) NSMutableArray *videosDic;
@property (nonatomic, strong) NSMutableArray *videos;

@property (nonatomic, strong) NSMutableArray *artListDic;

- (NSMutableArray *)getVideos;

+ (instancetype)sharedStore;

@end
