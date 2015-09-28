//
//  ViewController.m
//  demo
//
//  Created by Tang yuhua on 15/7/6.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "YHOrderMessageVC.h"
#import "ForthonDataSpider.h"
#import "SVProgressHUD.h"
#import "ForthonOrderProtocolView.h"
#import "UICommon.h"

#define WIDTH self.view.frame.size.width
#define HEIGTH self.view.frame.size.height

// label 的前端离屏幕左边的距离 leadingspace
#define LeadingSpace 19
// label 的高度
#define LabelHeight 30
// label 的宽度
#define LabelWidth 100
// label 的字体大小
#define LabelFont [UIFont systemFontOfSize:12.0f]
// label 的字体颜色
#define LabelColor AppColor
// textfiled 的高度
#define textFieldHeigth 30
// textfiled 的宽度
#define textFieldWidth (WIDTH-2*LeadingSpace)


// 订单 texfiled y 坐标
#define orderMessage_y (64+ LabelHeight)


// 收件人label y坐标 nav +status +
#define recipientsL_y (64+ LabelHeight + textFieldHeigth)
// 收件人 textfiled y坐标
#define recipients_y  (recipientsL_y + LabelHeight)

// 联系方式 label y坐标
#define contactWayL_y (recipients_y + textFieldHeigth)
// 联系方式 textfiled y坐标
#define contactWay_y (contactWayL_y + LabelHeight)

// 收货地址 label y 坐标
#define receivingAddressL_y (contactWay_y + textFieldHeigth)
// 收货地址的 textView y坐标
#define receivingAddress_y (receivingAddressL_y + LabelHeight)

// 收货地址的宽度
#define TextViewWidth (WIDTH-2*LeadingSpace)
// 收货地址的高度
#define TextViewHeight 100

// 提交按钮的 y 坐标
#define Submit_y (receivingAddress_y + TextViewHeight+20)
// 提交按钮的高度
#define SubmitHeight 30
// 提交按钮的宽度
#define SubmitWidth (WIDTH-2*LeadingSpace)






@interface YHOrderMessageVC ()
<
UITextFieldDelegate,
UITextViewDelegate
>

@property BOOL isAgree;

@property (nonatomic, strong) UIButton *submitButton;

@end

@implementation YHOrderMessageVC

#pragma mark - life Circle

- (void)viewDidLoad {
    [super viewDidLoad];

    UICommon *commonUI = [[UICommon alloc] init];
    NSString *videoTitle = @"订购信息";
    UILabel *navTitle = (UILabel *) [commonUI navTitle:videoTitle];
    self.navigationItem.titleView = navTitle;
    self.navigationItem.backBarButtonItem = HiddenBack;

    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.orderMessageL];
    [self.view addSubview:self.recipientsL];
    [self.view addSubview:self.contactWayL];
    [self.view addSubview:self.receivingAddressL];
    [self.view addSubview:self.protocolLabel];
    [self.view addSubview:self.protocolView];
    [self.view addSubview:self.submitB];

    
    [self.view addSubview:self.orderMessage];
    [self.view addSubview:self.recipients];
    [self.view addSubview:self.contactWay];
    [self.view addSubview:self.receivingAddress];
    self.delegate = [ForthonDataSpider sharedStore];
    
}






#pragma mark -- 退出键盘

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_orderMessage resignFirstResponder];
    [_recipients resignFirstResponder];
    [_contactWay resignFirstResponder];
    [_receivingAddress resignFirstResponder];

    [UIView animateWithDuration:0.3 animations:^{

        self.view.center = CGPointMake(WIDTH / 2, HEIGTH / 2);

    }];
}

#pragma mark -- 提交----------
-(void)submit{


    [SVProgressHUD showWithStatus:@"订单提交中..." maskType:SVProgressHUDMaskTypeBlack];
    NSLog(@"%s",__func__);

    NSLog(@"_orderMessage = %@",_orderMessage.text);
    NSLog(@"_recipients =%@",_recipients.text);
    NSLog(@"_contactWay =%@",_contactWay.text);
    NSLog(@"_receivingAddress =%@",_receivingAddress.text);

    if (_isAgree) {

        if ([_contactWay.text length] && [_recipients.text length] && [_receivingAddress.text length]) {

            [self.delegate submitOrderWithWorkId:_workId
                                       recipient:_recipients.text
                                     phoneNumber:_contactWay.text
                                         address:_receivingAddress.text];

            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(printResult:) name:@"NotificationOrderResult" object:nil];
        } else {

            [SVProgressHUD showErrorWithStatus:@"订单信息缺失" maskType:SVProgressHUDMaskTypeBlack];
        }

    } else {

        [SVProgressHUD showErrorWithStatus:@"请阅读并同意艺术品订购协议后购买" maskType:SVProgressHUDMaskTypeBlack];
    }


}


- (void)printResult:(NSNotification *)notification {

    NSLog(@"result : %@, ", notification.userInfo);
    if ([notification.userInfo[@"result"] boolValue]) {

        [SVProgressHUD showSuccessWithStatus:@"提交成功" maskType:SVProgressHUDMaskTypeBlack];
        _submitB.enabled = NO;
    } else {

        [SVProgressHUD showErrorWithStatus:@"提交失败" maskType:SVProgressHUDMaskTypeBlack];
    }

    [[NSNotificationCenter defaultCenter] removeObserver:self  name:@"NotificationOrderResult" object:nil];

}

#pragma mark --init 订单 view；

-(UILabel *)orderMessageL{
    if (_orderMessageL ==nil) {
        _orderMessageL = [[UILabel alloc]init];
        CGRect frame = CGRectMake(LeadingSpace, 64, LabelWidth, LabelHeight);
        _orderMessageL.frame = frame;
        _orderMessageL.text = @"订单信息";
        _orderMessageL.textColor = LabelColor;
        _orderMessageL.font = LabelFont;
    }
    return _orderMessageL;
}

-(UILabel *)orderMessage{
    if (_orderMessage ==nil) {
        _orderMessage = [[UILabel alloc]init];
        CGRect frame = CGRectMake(LeadingSpace, orderMessage_y, textFieldWidth, textFieldHeigth);
        _orderMessage.frame = frame;
        _orderMessage.layer.cornerRadius = 10.0f;
        _orderMessage.layer.borderColor = [UIColor grayColor].CGColor;
        _orderMessage.layer.borderWidth = 1.0f;
        [_orderMessage setText:_orderMessageStr];
        
    }
    return _orderMessage;
    
}

#pragma mark -- 收件人 initview

-(UILabel *)recipientsL{
    if (_recipientsL ==nil) {
        _recipientsL = [[UILabel alloc]init];
        CGRect frame = CGRectMake(LeadingSpace, recipientsL_y, LabelWidth, LabelHeight);
        _recipientsL.frame = frame;
        _recipientsL.text = @"收件人";
        _recipientsL.textColor = LabelColor;
        _recipientsL.font = LabelFont;
    }
    return _recipientsL;
}

-(UITextField *)recipients{
    if (_recipients ==nil) {
        _recipients = [[UITextField alloc]init];
        CGRect frame = CGRectMake(LeadingSpace,recipients_y,textFieldWidth , textFieldHeigth);
        _recipients.frame = frame;
        _recipients.layer.cornerRadius = 10.0f;
        _recipients.layer.borderColor = [UIColor grayColor].CGColor;
        [_recipients setFont:[UIFont systemFontOfSize:14.0]];
        _recipients.layer.borderWidth = 1.0f;
        _recipients.delegate = self;
    
    }
    return _recipients;
    
}
#pragma mark -- 联系方式 initView
-(UILabel *)contactWayL{
    if (_contactWayL ==nil) {
        _contactWayL = [[UILabel alloc]init];
        CGRect frame = CGRectMake(LeadingSpace, contactWayL_y, LabelWidth, LabelHeight);
        _contactWayL.frame = frame;
        _contactWayL.text = @"联系方式";
        _contactWayL.textColor = LabelColor;
        _contactWayL.font = LabelFont;
    }
    return _contactWayL;
}

-(UITextField *)contactWay{
    if (_contactWay ==nil) {
        _contactWay = [[UITextField alloc]init];
        CGRect frame = CGRectMake(LeadingSpace, contactWay_y, textFieldWidth, textFieldHeigth);
        _contactWay.frame = frame;
        _contactWay.layer.cornerRadius = 10.0f;
        _contactWay.layer.borderColor = [UIColor grayColor].CGColor;
        _contactWay.layer.borderWidth = 1.0f;
        [_contactWay setFont:[UIFont systemFontOfSize:14.0]];
        _contactWay.delegate = self;
        
    }
    return _contactWay;
}

#pragma mark --收货地址 initView
-(UILabel *)receivingAddressL{
    if (_receivingAddressL ==nil) {
        _receivingAddressL = [[UILabel alloc]init];
        CGRect frame = CGRectMake(LeadingSpace, receivingAddressL_y, LabelWidth, LabelHeight);
        _receivingAddressL.frame = frame;
        _receivingAddressL.text = @"收货地址";
        _receivingAddressL.textColor = LabelColor;
        _receivingAddressL.font = LabelFont;
    }
    return _receivingAddressL;
}
- (UITextView *)receivingAddress{
    if (_receivingAddress ==nil) {
        _receivingAddress = [[UITextView alloc]init];
        CGRect frame = CGRectMake(LeadingSpace, receivingAddress_y, TextViewWidth, TextViewHeight);
        _receivingAddress.frame = frame;
        _receivingAddress.layer.cornerRadius = 10.0f;
        _receivingAddress.layer.borderColor = [UIColor grayColor].CGColor;
        _receivingAddress.layer.borderWidth = 1.0f;
        _receivingAddress.delegate = self;
    
    }
    return _receivingAddress;
}

- (UILabel *)protocolLabel {

    if (_protocolLabel == nil) {

        _protocolLabel = [UILabel new];
        CGRect frame = CGRectMake(LeadingSpace, receivingAddress_y + TextViewHeight, LabelWidth, LabelHeight);
        _protocolLabel.frame = frame;
        _protocolLabel.text = @"网签协议";
        _protocolLabel.textColor = LabelColor;
        _protocolLabel.font = LabelFont;
    }
    return _protocolLabel;
}

- (UIView *)protocolView {

    if (_protocolView == nil) {

        _protocolView = [UILabel new];
        CGRect frame = CGRectMake(LeadingSpace, receivingAddress_y + TextViewHeight + LabelHeight, WIDTH - LeadingSpace, LabelHeight);
        _protocolView.frame = frame;

        UIButton *_confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(0, (LabelHeight - 15) / 2, 15, 15)];
        _confirmButton.layer.borderWidth = 1.0;
        _confirmButton.layer.borderColor = AppColor.CGColor;
        [_confirmButton addTarget:self action:@selector(changeState:) forControlEvents:UIControlEventTouchUpInside];
        _confirmButton.backgroundColor = [UIColor whiteColor];
        [_protocolView addSubview:_confirmButton];
        _protocolView.userInteractionEnabled = YES;

        UILabel *confirmLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 100, LabelHeight)];
        confirmLabel.text = @"我已阅读并同意 ";
        confirmLabel.textColor = [UIColor blackColor];
        confirmLabel.font = [UIFont systemFontOfSize:14.0];
        [_protocolView addSubview:confirmLabel];

        UIButton *protocolButton = [[UIButton alloc] initWithFrame:CGRectMake(110, 0, 150, LabelHeight)];
        [protocolButton setTitleColor:AppColor forState:UIControlStateNormal];
        [protocolButton setTitle:@"《艺术品订购协议》" forState:UIControlStateNormal];
        protocolButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [protocolButton addTarget:self action:@selector(pushProtocol) forControlEvents:UIControlEventTouchUpInside];
        [_protocolView addSubview:protocolButton];

    }

    return _protocolView;
}


- (void)pushProtocol {

    NSLog(@"protocol");
    ForthonOrderProtocolView *orderProtocolView = [ForthonOrderProtocolView new];
    [self.navigationController pushViewController:orderProtocolView animated:YES];
}

- (void)changeState:(UIButton *)button {

    NSLog(@"touch!");
    if (button.backgroundColor == [UIColor whiteColor]) {

        button.backgroundColor = AppColor;
        _isAgree = YES;
    } else {

        button.backgroundColor = [UIColor whiteColor];
        _isAgree = NO;
    }

}

#pragma mark -- init Button View 
-(UIButton *)submitB{
    if (_submitB == nil) {
        _submitB = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        CGRect frame = CGRectMake(20, 20 + receivingAddress_y + TextViewHeight + textFieldHeigth + LabelHeight, WIDTH - 40, 40);
        _submitB.frame = frame;
        _submitB.backgroundColor = AppColor;
        _submitB.layer.cornerRadius =5.0f;
        [_submitB setTitle:@"提交" forState:UIControlStateNormal];
        [_submitB.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
        [_submitB setTintColor:[UIColor whiteColor]];
        [_submitB addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];

        
    }
    return _submitB;
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {


    NSLog(@"textField is respond");

    [textField.layer setBorderColor:AppColor.CGColor];

    if (textField == _contactWay) {

        NSLog(@"contant is respond");
        [UIView animateWithDuration:0.3 animations:^{

            NSLog(@"contant up");
            self.view.center = CGPointMake(WIDTH / 2, HEIGTH / 2 - (LabelHeight + textFieldHeigth) * 2);
        }];

    } else {

    [UIView animateWithDuration:0.3 animations:^{

        NSLog(@"recipit up");
        NSLog(@"recipit is respond");
        self.view.center = CGPointMake(WIDTH / 2, HEIGTH / 2 - (LabelHeight + textFieldHeigth));

    }];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {

    NSLog(@"textfield end");
    [textField.layer setBorderColor:[UIColor grayColor].CGColor];

}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {

    [textView.layer setBorderColor:AppColor.CGColor];
    [UIView animateWithDuration:0.3 animations:^{

        self.view.center = CGPointMake(WIDTH / 2, HEIGTH / 2 - (LabelHeight + textFieldHeigth) * 3);

    }];

    return YES;
}


- (BOOL)textViewShouldEndEditing:(UITextView *)textView {

    [textView.layer setBorderColor:[UIColor grayColor].CGColor];
    [UIView animateWithDuration:0.3 animations:^{

        self.view.center = CGPointMake(WIDTH / 2, HEIGTH / 2);

    }];

    return YES;
}


#pragma mark -- memoryWarning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
