//
//  RegisterCurtain.m
//  Login
//
//  Created by Liu fushan on 15/6/1.
//  Copyright (c) 2015年 culturalCenter. All rights reserved.
//

#import "RegisterCurtain.h"
#import "LoginMeasurement.h"
#import "ForthonDataSpider.h"
#import "LoginCurtain.h"
#import "NSString+regular.h"
#import "SVProgressHUD.h"



// 480 - 296 / 2 注册的上方边缘长度
// 296 + 13 + 30 注册的height

@interface RegisterCurtain ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UITextField *userNameText;
@property (nonatomic, strong) UITextField *passWordText;
@property (nonatomic, strong) UITextField *identifyText;
@property (nonatomic, strong) UIView *alertView;

@property BOOL canLogin;
@end

@implementation RegisterCurtain

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchView)];
    [self.view addGestureRecognizer:tap];
    
    self.registerDelegate = [ForthonDataSpider sharedStore];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setLogin)
                                                 name:@"NotificationD"
                                               object:nil];

    
    [self createBackView];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg"]]];

//    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 50, 50, 50)];
//    backButton.backgroundColor = [UIColor purpleColor];
//    [backButton addTarget:self action:@selector(testLogin) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:backButton];

}

//- (void)removeView {
//
//    [[ForthonDataSpider sharedStore] loginWithIdstr:@"15928580434" passWord:@"1234567"];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)createBackView
{
    //_backView 即为小视图
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake((WIDTH - BACKVIEWWIDTH) / 2,(HEIGHT - BACKVIEWHEIGHT) / 2, BACKVIEWWIDTH, BACKVIEWHEIGHT + 43 * HEIGHTPERCENTAGE)];
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake((BACKVIEWWIDTH - IMAGEWIDTH) / 2, 0, IMAGEWIDTH, IMAGEWIDTH)];
    [image setImage:[UIImage imageNamed:@"login_logo.png"]];
    
    _userNameText = [[UITextField alloc] initWithFrame:CGRectMake(0, BACKVIEWHEIGHT / 2 - TEXTFIELDHEIGHT, TEXTFIELDWIDTH, TEXTFIELDHEIGHT)];
    [_userNameText setPlaceholder:@"手机号"];
    [_userNameText setBackgroundColor:[UIColor whiteColor]];
    [_userNameText.layer setCornerRadius:4.0];
    [_userNameText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_userNameText setDelegate:self];
    //    [userNameText.layer setBorderWidth:2.0];
    //    [userNameText.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    _passWordText = [[UITextField alloc] initWithFrame:CGRectMake(0, BACKVIEWHEIGHT / 2 + INTERVAL, TEXTFIELDWIDTH, TEXTFIELDHEIGHT)];
    [_passWordText setPlaceholder:@"密码"];
    [_passWordText setBackgroundColor:[UIColor whiteColor]];
    [_passWordText.layer setCornerRadius:4.0];
    [_passWordText setClearButtonMode:UITextFieldViewModeWhileEditing];
    _passWordText.secureTextEntry = YES;
    [_passWordText setDelegate:self];
    
    _identifyText = [[UITextField alloc] initWithFrame:CGRectMake(0, BACKVIEWHEIGHT / 2 + 2 * INTERVAL + TEXTFIELDHEIGHT, TEXTFIELDWIDTH, TEXTFIELDHEIGHT)];
    [_identifyText setPlaceholder:@"验证码"];
    [_identifyText setBackgroundColor:[UIColor whiteColor]];
    [_identifyText.layer setCornerRadius:4.0];
//    [_identifyText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_identifyText setDelegate:self];

    UIButton *codeButton = [[UIButton alloc] initWithFrame:CGRectMake(2 * TEXTFIELDWIDTH / 3, 0, TEXTFIELDWIDTH / 3, TEXTFIELDHEIGHT)];
    [codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [codeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    codeButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [codeButton addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
    [_identifyText addSubview:codeButton];


    UIButton *registerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, BACKVIEWHEIGHT / 2 + 3 * INTERVAL + TEXTFIELDHEIGHT * 2, BUTTONWIDTH, BUTTONHEIGHT)];
    [registerButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20.0]];
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    
    [registerButton setBackgroundImage:[UIImage imageNamed:@"login_login_bg_pressed"] forState:UIControlStateHighlighted];
    [registerButton setBackgroundImage:[UIImage imageNamed:@"login_login_bg"] forState:UIControlStateNormal];
    [registerButton.layer setCornerRadius:5.0];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(registerNow) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, BACKVIEWHEIGHT / 2 + 4 * INTERVAL + TEXTFIELDHEIGHT * 2 + BUTTONHEIGHT, BACKVIEWWIDTH, 1)];
    [lineView setBackgroundColor:[UIColor whiteColor]];
    
//    UIButton *registerButton = [[UIButton alloc] initWithFrame:CGRectMake(-10, BACKVIEWHEIGHT - LABELHEIGHT - 8 * HEIGHTPERCENTAGE, LABELWIDTH, LABELHEIGHT)];
//    [registerButton setTitle:@"快速注册" forState:UIControlStateNormal];
//    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [registerButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
//    [registerButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
//    [registerButton addTarget:self action:@selector(fastRegister) forControlEvents:UIControlEventTouchUpInside];
//    
    UIButton *fastLoginButton = [[UIButton alloc] initWithFrame:CGRectMake(BACKVIEWWIDTH - LABELWIDTH - 5 * WIDTHPERCENTAGE , BACKVIEWHEIGHT + 43 * HEIGHTPERCENTAGE - LABELHEIGHT - 8 * HEIGHTPERCENTAGE, LABELWIDTH + 20, LABELHEIGHT)];
    [fastLoginButton setTitle:@"立即登录" forState:UIControlStateNormal];
    [fastLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [fastLoginButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [fastLoginButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [fastLoginButton addTarget:self action:@selector(fastLogin) forControlEvents:UIControlEventTouchUpInside];
    
    [_backView addSubview:image];
    [_backView addSubview:_userNameText];
    [_backView addSubview:_passWordText];
    [_backView addSubview:_identifyText];
    [_backView addSubview:registerButton];
    [_backView addSubview:lineView];
//    [_backView addSubview:registerButton];
    [_backView addSubview:fastLoginButton];
    
    //    [_backView setBackgroundColor:[UIColor grayColor]];
    [_backView setCenter:self.view.center];
    [self.view addSubview:_backView];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //开始输入时，小视图上移80，加了动画效果，时常0.3 s
    [UIView animateWithDuration:0.3 animations:^{
        [_backView setCenter:CGPointMake(self.view.center.x, self.view.center.y - 80)];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        [_backView setCenter:self.view.center];
    }];
    
    return YES;
}

- (void)touchView
{
    //触碰视图，则输入结束，小视图回到原位
    
    [_userNameText resignFirstResponder];
    [_passWordText resignFirstResponder];
    [_identifyText resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        [_backView setCenter:self.view.center];
    }];
}


- (void)fastLogin
{

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)registerNow
{
    if ([_userNameText.text length]) {

        if([_userNameText.text checkToMarkPhone]) {

            if ([_passWordText.text length]) {

                if ([_passWordText.text checkToMarkPassword]) {

                    if ([_identifyText.text length]) {

                        if ([_identifyText.text checkToMarkCode]) {

                            [SVProgressHUD showWithStatus:@"注册中..." maskType:SVProgressHUDMaskTypeBlack];
                            [self.registerDelegate confirmPhone:_userNameText.text WithCode:_identifyText.text];
                            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readyToRegister:) name:@"NotificationConfirmCode" object:nil];



                        } else {

                            [SVProgressHUD showErrorWithStatus:@"验证码格式错误" maskType:SVProgressHUDMaskTypeBlack];
                        }


                    } else {

                        [SVProgressHUD showErrorWithStatus:@"验证码不能为空" maskType:SVProgressHUDMaskTypeBlack];
                    }


                } else {

                    [SVProgressHUD showErrorWithStatus:@"密码格式错误" maskType:SVProgressHUDMaskTypeBlack];
                }

            } else {

                [SVProgressHUD showErrorWithStatus:@"密码不能为空" maskType:SVProgressHUDMaskTypeBlack];
            }



        } else {

            [SVProgressHUD showErrorWithStatus:@"手机号格式错误" maskType:SVProgressHUDMaskTypeBlack];
        }

    } else {

        [SVProgressHUD showErrorWithStatus:@"手机号不能为空" maskType:SVProgressHUDMaskTypeBlack];

    }


    
}

- (void)readyToRegister:(NSNotification *)notification {

    if([notification.userInfo[@"returnResult"] boolValue]) {

        [_registerDelegate registerUserWithName:@"" passWord:_passWordText.text phoneNumber:_userNameText.text];
    } else {

        [SVProgressHUD showErrorWithStatus:@"验证码与手机号不匹配" maskType:SVProgressHUDMaskTypeBlack];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationConfirmCode" object:nil];

}

- (void)setLogin
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationD" object:nil];
    [self dismissViewControllerAnimated:YES completion:^(){

        [self.loginDelegate fastLoginWithUserName:_userNameText.text password:_passWordText.text];
    }];

}

- (void)getCode {

    NSString *number = _userNameText.text;
    if([number length]) {
        if ([number checkToMarkPhone]) {

            [self.registerDelegate sendIdentifyingCode:number];

        } else {
            [SVProgressHUD showErrorWithStatus:@"手机号格式错误" maskType:SVProgressHUDMaskTypeBlack];
        }
    } else {

        [SVProgressHUD showErrorWithStatus:@"手机号不能为空" maskType:SVProgressHUDMaskTypeBlack];
    }
}


//- (void)testLogin {
//
//    [self dismissViewControllerAnimated:YES completion:^(){
//
//        [self.loginDelegate fastLoginWithUserName:@"15928580434" password:@"1234567"];
//    }];
//
//}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
