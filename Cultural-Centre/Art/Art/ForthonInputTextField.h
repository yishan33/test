//
//  ForthonInputTextField.h
//  Art
//
//  Created by Liu fushan on 15/7/14.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForthonInputTextField : UIView


- (void)loadView;

@property (nonatomic, strong) UITextField *commentText;
@property (nonatomic, strong) UIButton *sendButton;

@end
