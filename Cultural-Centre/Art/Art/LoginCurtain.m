//
//  LoginCurtain.m
//  Login
//
//  Created by Liu fushan on 15/4/28.
//  Copyright (c) 2015年 culturalCenter. All rights reserved.
//

#import "LoginCurtain.h"

#import "LoginMeasurement.h"
#import "ForthonDataSpider.h"
#import "RegisterCurtain.h"
#import "MainTabBarViewController.h"
#import "ForthonPasswordReset.h"
#import "UICommon.h"
#import "SVProgressHUD.h"
#import "NSString+regular.h"


@interface



LoginCurtain ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UITextField *userNameText;
@property (nonatomic, strong) UITextField *passWordText;
@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UINavigationController *nav;
@end

@implementation LoginCurtain


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"view did load in login\n");

    self.navigationItem.backBarButtonItem = HiddenBack;
//    UICommon *commonUI = [[UICommon alloc] init];
//    UILabel *navTitle = [commonUI navTitle:@"登录"];
//    [navTitle setTextColor:[UIColor whiteColor]];
//    self.navigationItem.titleView = navTitle;
//
//    UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg.png"]];
//    self.navigationController.navigationBar.barTintColor = color;
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"x" style:UIBarButtonItemStylePlain target:self action:@selector(abandonLogin)];

    UIButton *abandonButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 45, 28, 28)];
    [abandonButton setBackgroundImage:[UIImage imageNamed:@"movie_detail_score_close_press副本 copy.png"] forState:UIControlStateNormal];
    [abandonButton addTarget:self action:@selector(abandonLogin) forControlEvents:UIControlEventTouchUpInside];
//    abandonButton.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:abandonButton];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchView)];

    [self.view addGestureRecognizer:tap];
    self.delegate = [ForthonDataSpider sharedStore];

    
    
    
    [self createBackView];
    

    //    [self.view setBackgroundColor:[UIColor grayColor]];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg"]]];
//    [self.view setFrame:CGRectMake(0, 64, WIDTH, self.view.frame.size.height - 64)];
//    _nav = [[UINavigationController alloc] initWithRootViewController:self];
    
    
}

//创建小视图，在小视图中创建控件。

- (void)createBackView
{
    //_backView 即为小视图
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (CGFloat) (BACKVIEWWIDTH), BACKVIEWHEIGHT)];
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake((BACKVIEWWIDTH - IMAGEWIDTH) / 2, 0, IMAGEWIDTH, IMAGEWIDTH)];
    [image setImage:[UIImage imageNamed:@"login_logo.png"]];
    
    _userNameText = [[UITextField alloc] initWithFrame:CGRectMake(0, BACKVIEWHEIGHT / 2 - TEXTFIELDHEIGHT, TEXTFIELDWIDTH, TEXTFIELDHEIGHT)];
    [_userNameText setPlaceholder:@"手机号/用户名"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    [_userNameText setText:[user objectForKey:@"phoneNumber"]];
    [_userNameText setBackgroundColor:[UIColor whiteColor]];
    [_userNameText.layer setCornerRadius:4.0];
    [_userNameText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_userNameText setDelegate:self];
    
    _passWordText = [[UITextField alloc] initWithFrame:CGRectMake(0, BACKVIEWHEIGHT / 2 + INTERVAL, TEXTFIELDWIDTH, TEXTFIELDHEIGHT)];
    [_passWordText setPlaceholder:@"密码"];
    [_passWordText setBackgroundColor:[UIColor whiteColor]];
    [_passWordText.layer setCornerRadius:4.0];
    [_passWordText setClearButtonMode:UITextFieldViewModeWhileEditing];
    _passWordText.secureTextEntry = YES;
    [_passWordText setDelegate:self];
    
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, BACKVIEWHEIGHT / 2 + 2 * INTERVAL + TEXTFIELDHEIGHT, BUTTONWIDTH, BUTTONHEIGHT)];
    [loginButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20.0]];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    
    [loginButton setBackgroundImage:[UIImage imageNamed:@"login_login_bg_pressed"] forState:UIControlStateHighlighted];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"login_login_bg"] forState:UIControlStateNormal];
    [loginButton.layer setCornerRadius:5.0];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(load) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, BACKVIEWHEIGHT / 2 + 3 * INTERVAL + TEXTFIELDHEIGHT + BUTTONHEIGHT, BACKVIEWWIDTH, 1)];
    [lineView setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *registerButton = [[UIButton alloc] initWithFrame:CGRectMake(-10, BACKVIEWHEIGHT - LABELHEIGHT - 8 * HEIGHTPERCENTAGE, LABELWIDTH, LABELHEIGHT)];
    [registerButton setTitle:@"快速注册" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [registerButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [registerButton addTarget:self action:@selector(fastRegister) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *forgetPasswordButton = [[UIButton alloc] initWithFrame:CGRectMake(BACKVIEWWIDTH - LABELWIDTH - 5 * WIDTHPERCENTAGE , BACKVIEWHEIGHT - LABELHEIGHT - 8 * HEIGHTPERCENTAGE, LABELWIDTH + 20, LABELHEIGHT)];
    [forgetPasswordButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetPasswordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [forgetPasswordButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [forgetPasswordButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [forgetPasswordButton addTarget:self action:@selector(forgetPassword) forControlEvents:UIControlEventTouchUpInside];
    
    [_backView addSubview:image];
    [_backView addSubview:_userNameText];
    [_backView addSubview:_passWordText];
    [_backView addSubview:loginButton];
    [_backView addSubview:lineView];
    [_backView addSubview:registerButton];
    [_backView addSubview:forgetPasswordButton];
    
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
    [UIView animateWithDuration:0.3 animations:^{
        [_backView setCenter:self.view.center];
    }];
}

- (void)load
{
    //点击登录，则输入结束，小视图回到原位
    
    [_userNameText resignFirstResponder];
    [_passWordText resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        [_backView setCenter:self.view.center];
    }];
    
//    需加一个功能：当帐号或密码为空，则弹出警告。
    
    if (([_userNameText.text checkToMarkUserName] || [_userNameText.text checkToMarkPhone]) && [_passWordText.text checkToMarkPassword]) {

        NSLog(@"ready to load");
        _alertView = [[UIView alloc] initWithFrame:self.view.frame];
        UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH - 60, 100)];
        [buttonView setCenter:self.view.center];
        [buttonView.layer setCornerRadius:5.0];
        [buttonView setAlpha:1];
        [buttonView setBackgroundColor:[UIColor whiteColor]];

        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
        [indicator setFrame:CGRectMake(30, 20, 60, 60)];
        [indicator setColor:[UIColor grayColor]];
        [indicator startAnimating];
        [buttonView addSubview:indicator];

        [SVProgressHUD showWithStatus:@"登录中..." maskType:SVProgressHUDMaskTypeBlack];
        [_delegate loginWithIdstr:_userNameText.text passWord:_passWordText.text];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(login)
                                                     name:@"NotificationA"
                                                   object:nil];

    } else {

        [SVProgressHUD showErrorWithStatus:@"账户名或密码格式错误" maskType:SVProgressHUDMaskTypeBlack];
    }

}

- (void)createPlist
{
    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = documents[0];
    NSString *videosPath = [docDir stringByAppendingPathComponent:@"videos.plist"];
    NSMutableDictionary *videosDic = [[NSMutableDictionary alloc] init];
    [videosDic writeToFile:videosPath atomically:YES];
}

- (void)fastRegister
{
    RegisterCurtain *Curtain = [[RegisterCurtain alloc] init];
    Curtain.loginDelegate = self;
    [self presentViewController:Curtain animated:YES completion:^{}];
    
}

- (void)forgetPassword
{
    NSLog(@"忘记密码");
    ForthonPasswordReset *resetView = [[ForthonPasswordReset alloc] init];
//    resetView.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:resetView animated:YES];

}

//点击登录中...视图，则将登录中...视图从父视图中移除，创建视图并加载进NavigationViewController, TabbarViewController，然后跳到主界面。


- (void)login
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationA" object:nil];
    NSLog(@"ready to pop");
    [SVProgressHUD showSuccessWithStatus:@"登录成功" maskType:SVProgressHUDMaskTypeBlack];
    [self.navigationController dismissViewControllerAnimated:YES completion:^(){

        [self.refreshDelegate refresh];
    }];

}

- (void)abandonLogin {

    NSLog(@"放弃登陆");
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)fastLoginWithUserName:(NSString *)userName password:(NSString *)password {

    [_userNameText resignFirstResponder];
    [_passWordText resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        [_backView setCenter:self.view.center];
    }];

//    需加一个功能：当帐号或密码为空，则弹出警告。

        NSLog(@"ready to load");
        _alertView = [[UIView alloc] initWithFrame:self.view.frame];
        UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH - 60, 100)];
        [buttonView setCenter:self.view.center];
        [buttonView.layer setCornerRadius:5.0];
        [buttonView setAlpha:1];
        [buttonView setBackgroundColor:[UIColor whiteColor]];

        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
        [indicator setFrame:CGRectMake(30, 20, 60, 60)];
        [indicator setColor:[UIColor grayColor]];
        [indicator startAnimating];
        [buttonView addSubview:indicator];

        [SVProgressHUD showWithStatus:@"登录中..." maskType:SVProgressHUDMaskTypeBlack];
        [_delegate loginWithIdstr:userName passWord:password];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(login)
                                                     name:@"NotificationA"
                                                   object:nil];

}


- (void)viewWillAppear:(BOOL)animated {

    self.navigationController.navigationBarHidden = YES;
}


- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
}

@end
