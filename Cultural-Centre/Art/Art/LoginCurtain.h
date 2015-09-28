//
//  LoginCurtain.h
//  Login
//
//  Created by Liu fushan on 15/4/28.
//  Copyright (c) 2015年 culturalCenter. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface LoginCurtain : UIViewController <UITextFieldDelegate, registerLogin>

@property (nonatomic, strong) id<AppLogin>delegate;
@property (nonatomic, strong) id<RefreshView> refreshDelegate;

@end
