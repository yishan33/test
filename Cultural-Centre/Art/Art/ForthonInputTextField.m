//
//  ForthonInputTextField.m
//  Art
//
//  Created by Liu fushan on 15/7/14.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "ForthonInputTextField.h"
#import "InputTextFieldMeasurement.h"

@interface ForthonInputTextField ()

@property (nonatomic, strong) UIView *buttomView;


@end

@implementation ForthonInputTextField


- (void)loadView {
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 1)];
    [topLine setBackgroundColor:[UIColor grayColor]];
    
    _buttomView = [[UIView alloc] initWithFrame:CGRectMake(-1, 0, BACKVIEWWIDTH, BACKVIEWHEIGHT)];
    //    [_buttomView.layer setBorderWidth:1.0];
    //    [_buttomView.layer setBorderColor:[UIColor grayColor].CGColor];
    [_buttomView setBackgroundColor:[UIColor whiteColor]];
    
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(L_INTERVAL - LINEINTERVAL, TEXTHEIGHT  - LINEHEIGHT, LINEWIDTH, LINEHEIGHT)];
    [leftLine setBackgroundColor:[UIColor grayColor]];
    
    
    _commentText = [[UITextField alloc] initWithFrame:CGRectMake(L_INTERVAL, 0, TEXTWIDTH, TEXTHEIGHT)];
    [_commentText setPlaceholder:@"我想说两句"];
    [_commentText setDelegate:self];
    [_commentText setKeyboardType:UIKeyboardTypeDefault];
    
    UIView *buttomLine = [[UIView alloc] initWithFrame:CGRectMake(L_INTERVAL - LINEINTERVAL, TEXTHEIGHT, TEXTWIDTH + 2 * LINEINTERVAL, LINEWIDTH)];
    [buttomLine setBackgroundColor:[UIColor grayColor]];
    
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(L_INTERVAL + TEXTWIDTH + LINEINTERVAL - LINEWIDTH, TEXTHEIGHT - LINEHEIGHT , LINEWIDTH, LINEHEIGHT)];
    [rightLine setBackgroundColor:[UIColor grayColor]];
    
    _sendButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - SENDBUTTONSIDE - INTERVALRIGHT / 2, (BACKVIEWHEIGHT - SENDBUTTONSIDE) / 2, SENDBUTTONSIDE, SENDBUTTONSIDE)];
    [_sendButton setBackgroundImage:[UIImage imageNamed:@"comment_btn_normal.png"] forState:UIControlStateNormal];
    [_sendButton setBackgroundImage:[UIImage imageNamed:@"comment_btn_selected.png"] forState:UIControlStateSelected];

    [_buttomView addSubview:topLine];
    [_buttomView addSubview:_sendButton];
    [_buttomView addSubview:rightLine];
    [_buttomView addSubview:leftLine];
    [_buttomView addSubview:buttomLine];
    [_buttomView addSubview:_commentText];
    
    NSLog(@"load Inputview");
    [self addSubview:_buttomView];
    
}




@end
