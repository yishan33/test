//
//  ForthonPasswordReset.m
//  Art
//
//  Created by Liu fushan on 15/7/25.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "ForthonPasswordReset.h"
#import "UICommon.h"
#import "ForthonDataSpider.h"
#import "ForthonDataContainer.h"
#import "YHStyleCell.h"
#import "SVProgressHUD.h"
#import "NSString+regular.h"

@interface ForthonPasswordReset ()

@property int seconds;
@property (nonatomic, strong) NSTimer *time;

@property BOOL isReadyToResetPassword;

@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *passwordNew;
@property (nonatomic, strong) NSString *confirmPassword;
@property (nonatomic, strong) NSString *confirmCode;

@property (nonatomic, strong) NSArray *textArray;
@property (nonatomic, strong) NSMutableArray *cellArray;

@property (nonatomic, strong) UIButton *messageButton;

@end

@implementation ForthonPasswordReset


- (void)viewDidLoad {
    [super viewDidLoad];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(giveupFirst)];
    [self.view addGestureRecognizer:tap];

    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    [tipLabel setBackgroundColor:GrayColor];
    [tipLabel setFont:[UIFont systemFontOfSize:12.0]];
    [tipLabel setTextAlignment:NSTextAlignmentCenter];
    [tipLabel setText:@"请输入与之前账号绑定的手机号码"];
    [self.view addSubview:tipLabel];

    _textArray = @[@"手机号", @"新密码", @"确认密码", @"验证码"];
    _cellArray = [NSMutableArray new];
    self.tableView.scrollEnabled = NO;
    self.tableView.tableFooterView = self.footContainerView;
    self.tableView.tableHeaderView = tipLabel;
    UICommon *commonUI = [[UICommon alloc] init];
    UILabel *navTitle = (UILabel *) [commonUI navTitle:@"重置密码"];


    self.navigationItem.titleView = navTitle;
    self.navigationItem.backBarButtonItem = HiddenBack
    self.navigationController.navigationBar.tintColor = AppColor;
    self.navigationController.navigationBarHidden = NO;
    self.delegate = [ForthonDataSpider sharedStore];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellIdentifier = @"cell";

    YHStyleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {

        cell = [[YHStyleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSString *text = _textArray[indexPath.row];
    cell.textLabel.text = text;

    if (indexPath.row == 1 || indexPath.row == 2) {

        [cell setTextFieldSecurity];
        cell.inputTield.clearsOnBeginEditing = NO;
    }

    if (indexPath.row == 3) {

        [cell setStyleWithButton:YES];
        [cell addTarget:self selector:@selector(readyToConfirmPhoneNumberExist)];

        _messageButton = cell.button;
    }
    [cell.textLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_cellArray addObject:cell];

    return cell;

}



#pragma mark - 更改按钮

- (UIButton *)changeButton {

    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button.layer setCornerRadius:5.0];
    [button setFrame:CGRectMake(20, 50, WIDTH - 40, 40)];
    [button setBackgroundColor:AppColor];
    [button setTitle:@"更改" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    [button addTarget:self action:@selector(confirmNumberAndCode) forControlEvents:UIControlEventTouchUpInside];

    return button;
}

- (UIView *)footContainerView {

    UIView *footView = [UIView new];
    [footView setFrame:CGRectMake(0, 0, WIDTH, 140)];
    [footView addSubview:self.changeButton];

    return footView;
}


#pragma mark - 获取验证码之前验证手机号是否存在

- (void)readyToConfirmPhoneNumberExist {

    YHStyleCell *phoneCell = _cellArray[0];
    _phoneNumber = [phoneCell getTextFieldText];

    YHStyleCell *newPasswordCell = _cellArray[1];
    _passwordNew = [newPasswordCell getTextFieldText];

    YHStyleCell *confirmPasswordCell = _cellArray[2];
    _confirmPassword = [confirmPasswordCell getTextFieldText];


    BOOL isValid = [_phoneNumber checkToMarkPhone];

    if (isValid) {

        [self.delegate confirmUserExistByUserName:nil phoneNumber:_phoneNumber];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(getMessageCode:)
                                                     name:@"NotificationNumberConfirm"
                                                   object:nil];
    } else {

        [SVProgressHUD showErrorWithStatus:@"手机号格式错误" maskType:SVProgressHUDMaskTypeBlack];
    }

}


#pragma mark - 请求获取验证码

- (void)getMessageCode:(NSNotification *)nsnotification {

    NSLog(@"getMessageCode");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationNumberConfirm" object:nil];


    BOOL phoneValid = [_phoneNumber checkToMarkPhone];
    BOOL passwordValid = [_passwordNew checkToMarkPassword];
    BOOL passwordConfirmValid = [_confirmPassword checkToMarkPassword];


    if ([nsnotification.userInfo[@"result"] boolValue]) {

        if (phoneValid) {

            if (passwordValid && passwordConfirmValid) {

                if ([_passwordNew isEqualToString:_confirmPassword]) {

                    _isReadyToResetPassword = YES;
                    [self.delegate sendIdentifyingCode:_phoneNumber];
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readyToChangeButtonState:) name:@"NotificationCode" object:nil];

                } else {

                    [SVProgressHUD showErrorWithStatus:@"两次输入密码不一致" maskType:SVProgressHUDMaskTypeBlack];
                }

            } else {

                [SVProgressHUD showErrorWithStatus:@"密码格式错误" maskType:SVProgressHUDMaskTypeBlack];
            }

        } else {

            [SVProgressHUD showErrorWithStatus:@"手机号格式错误" maskType:SVProgressHUDMaskTypeBlack];
        }

    } else {

        [SVProgressHUD showErrorWithStatus:@"手机号不存在" maskType:SVProgressHUDMaskTypeBlack];
    }

}

- (void)readyToChangeButtonState:(NSNotification *)notification {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationCode" object:nil];

    if ([notification.userInfo[@"result"] boolValue]) {

        [self changeButtonState];
    } else {

        NSLog(@"back code error: %@", notification.userInfo[@"message"]);
//        [SVProgressHUD showErrorWithStatus:<#(NSString *)string#> maskType:<#(SVProgressHUDMaskType)maskType#>];
    }

}

- (void)changeButtonState {

    _seconds = 60;
    NSLog(@"change button status");
    _messageButton.enabled = NO;
    [_messageButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    _time = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(secondsCut) userInfo:nil repeats:YES];
    [_time fire];
}

- (void)secondsCut {

    NSLog(@"还剩: %i", _seconds);
    _seconds--;

    [_messageButton setTitle:[NSString stringWithFormat:@"%i", _seconds] forState:UIControlStateNormal];
    [_messageButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];

    if (_seconds == 0) {

        _messageButton.enabled = YES;
        [_messageButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_time invalidate];
        _seconds = 60;
    }
}
#pragma mark - 发送重置密码请求

- (void)confirmNumberAndCode {

    YHStyleCell *cell = _cellArray[3];
    _confirmCode = [cell getTextFieldText];
    if ([_confirmCode checkToMarkCode]) {

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(changePassword:)
                                                     name:@"NotificationConfirmCode"
                                                   object:nil];

//        YHStyleCell *confirmCodeCell = _cellArray[3];
//        _confirmPassword = [confirmCodeCell getTextFieldText];
        [self.delegate confirmPhone:_phoneNumber WithCode:_confirmCode];

    } else {

        [SVProgressHUD showErrorWithStatus:@"验证码错误" maskType:SVProgressHUDMaskTypeBlack];
    }



}

- (void)changePassword:(NSNotification *)notification {

    if (_isReadyToResetPassword) {

        if ([notification.userInfo[@"returnResult"] boolValue]) {

            NSLog(@"change password");
            [self.delegate resetPasswordByPhoneNumber:_phoneNumber password:_passwordNew];

        } else {

            NSLog(@"无效的验证码");
        }

    } else {

        NSLog(@"手机号或密码错误");
    }

}

- (void)giveupFirst {

    for (int i = 0; i < 4; i++) {

        YHStyleCell *cell = _cellArray[i];
        [cell.inputTield resignFirstResponder];
        NSLog(@"putdown");
    }

    NSLog(@"putdown");

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    for (int i = 0; i < 4; i++) {

        YHStyleCell *cell = _cellArray[i];
        [cell.inputTield resignFirstResponder];
        NSLog(@"putdown");
    }

    NSLog(@"putdown");
}

- (void)viewDidAppear:(BOOL)animated {


}

@end
