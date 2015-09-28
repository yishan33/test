//
//  RegisterCurtain.h
//  Login
//
//  Created by Liu fushan on 15/6/1.
//  Copyright (c) 2015年 culturalCenter. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface RegisterCurtain : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) id<Register> registerDelegate;
@property (nonatomic, strong) id<registerLogin> loginDelegate;

@end
