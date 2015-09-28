//
//  YHMyListControllers.m
//  Art
//
//  Created by Tang yuhua on 15/6/30.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "YHMyListControllers.h"

@implementation YHMyListControllers

-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(UIViewController *) viewController :(NSInteger) index
{
    if (index == 2) {
        
    }
    
    return [[YHSettingVC alloc]init];
}
@end
