//
//  ForthonDataSpider.h
//  Login
//
//  Created by Liu fushan on 15/5/16.
//  Copyright (c) 2015年 culturalCenter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ForthonDataContainer.h"

@interface ForthonDataSpider : NSObject

- (NSMutableArray *)getVideos;

+ (instancetype)sharedStore;

@end
