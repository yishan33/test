//
//  YHUserInforModel.m
//  Art
//
//  Created by Tang yuhua on 15/6/30.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "YHUserInforModel.h"
#import "ForthonDataSpider.h"

@implementation YHUserInforModel

-(NSString *)title:(NSInteger )index
{
    NSString *title =[[NSString alloc]init];
  
    if (index == 0 ) {
        title = @"头像";
        
    }else if(index ==1){
        title = @"昵称";

    }else if(index ==2){
        title = @"用户名";

    }else if(index ==3){
        title = @"手机号码";

    }else if(index ==4){
        title = @"修改密码";
    }else{
        
    }
    return title;
}

- (NSString *)message:(NSInteger)index
{
    NSString *message = [[NSString alloc] init];

    if(index ==1){

        message = [[ForthonDataSpider sharedStore] valueForKey:@"userNick"];
//        NSLog(@"now nick: %@", message);
    }else if(index ==2){

        message = [[ForthonDataSpider sharedStore] valueForKey:@"userName"];
//        NSLog(@"now userName: %@", message);
    }else if(index ==3){
        
        
        message = [[ForthonDataSpider sharedStore] valueForKey:@"phoneNumber"];
//        NSLog(@"now phoneNumber: %@", message);
    }else if(index ==4){

    }else{
        
    }
    return message;
}

@end
