//
//  YHSettingListControllers.m
//  Art
//
//  Created by Tang yuhua on 15/6/30.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "YHSettingListControllers.h"

@interface YHSettingListControllers ()<UIAlertViewDelegate>




@end

@implementation YHSettingListControllers


-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(id) viewController :(NSInteger) index
{
    if (index ==0) {
        return [[YHAboutUSVC alloc]init];

    }else{
        return [[YHAdviceVC alloc]init];
    }
    
    
}

-(void)clearCache{
    UIAlertView *alert;
    alert = [[UIAlertView alloc]initWithTitle:@""
                                      message:@" 是否清空缓存"
                                     delegate:self
                            cancelButtonTitle:@"取消"
                            otherButtonTitles:@"确定", nil];
    [alert show];
    
}
@end

#pragma mark - Alert协议方法

















