//
//  ViewController.h
//  demo
//
//  Created by Tang yuhua on 15/7/6.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHOrderMessageVC : UIViewController


@property (nonatomic,strong ) UILabel *orderMessageL;
@property (nonatomic,strong ) UILabel *recipientsL;
@property (nonatomic,strong ) UILabel *contactWayL;
@property (nonatomic,strong ) UILabel *receivingAddressL;
@property (nonatomic, strong) UILabel *protocolLabel;
@property (nonatomic, strong) UIView *protocolView;
@property (nonatomic,strong ) UIButton *submitB;
@property (nonatomic, strong) UIButton *confirmButton;


@property (nonatomic,strong ) UILabel *orderMessage;
@property (nonatomic,strong ) UITextField *recipients;
@property (nonatomic,strong ) UITextField *contactWay;
@property (nonatomic,strong ) UITextView *receivingAddress;

@property (nonatomic,strong ) NSString *orderMessageStr;
@property (nonatomic,strong ) NSString *workId;


@property (nonatomic, strong) id<SubmitOrderDelegate> delegate;

@end

