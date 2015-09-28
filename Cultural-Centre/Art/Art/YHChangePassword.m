//
//  ViewController.m
//  demo
//
//  Created by Tang yuhua on 15/7/6.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "YHChangePassword.h"
#import "SVProgressHUD.h"
#import "YHStyleCell.h"
#import "ForthonDataSpider.h"
#import "LoginCurtain.h"
#import "UICommon.h"

@interface YHChangePassword ()
@property (nonatomic,strong) UIBarButtonItem *confirmButton;
@property (nonatomic,strong) UILabel *footLable;

@end

@implementation YHChangePassword

#pragma mark -- lifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.scrollEnabled = NO;

    UICommon *commonUI = [[UICommon alloc] init];
    UILabel *navTitle = [commonUI navTitle:@"修改密码"];
    self.navigationItem.titleView = navTitle;
    self.navigationItem.rightBarButtonItem = self.confirmButton;
    self.tableView.tableFooterView = self.footLable;
    
    self.delegate = [ForthonDataSpider sharedStore];
    self.loginDelegate = [ForthonDataSpider sharedStore];
}


#pragma mark --submitMetod
-(void)submit{
    NSLog(@"submit");
    NSIndexPath *first = [NSIndexPath indexPathForRow:0 inSection:0];
    YHStyleCell *cell1 = (YHStyleCell *)[self.tableView cellForRowAtIndexPath:first];
    
    NSIndexPath *second = [NSIndexPath indexPathForRow:1 inSection:0];
    YHStyleCell *cell2 = (YHStyleCell *)[self.tableView cellForRowAtIndexPath:second];
    
    NSIndexPath *third = [NSIndexPath indexPathForRow:2 inSection:0];
    YHStyleCell *cell3 = (YHStyleCell *)[self.tableView cellForRowAtIndexPath:third];
    
    NSString *oldPassword = [cell1 getTextFieldText];
    NSString *newPassword = [cell2 getTextFieldText];
    NSString *passwordRe  = [cell3 getTextFieldText];

    NSString *nickRegular = @"^[a-zA-Z0-9]{6,16}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nickRegular];
    BOOL oldValid = [predicate evaluateWithObject:oldPassword];
    BOOL newValid = [predicate evaluateWithObject:newPassword];
    BOOL reValid = [predicate evaluateWithObject:passwordRe];

    if (oldPassword && newPassword && reValid) {

        if ([newPassword isEqualToString:passwordRe]) {

            [self.delegate modifyPasswordWithOldPassword:oldPassword To:newPassword];
            [SVProgressHUD showWithStatus:@"密码修改中..."];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readyToLogin:) name:@"NotificationPassword" object:nil];
        } else {

            [SVProgressHUD showErrorWithStatus:@"两次密码输入不一致" maskType:SVProgressHUDMaskTypeBlack];
        }
    } else {

        [SVProgressHUD showErrorWithStatus:@"密码格式错误" maskType:SVProgressHUDMaskTypeBlack];
    }

    [cell3.inputTield resignFirstResponder];
    NSLog(@"oldPassword = %@ newPassword = %@ passwordRe = %@",oldPassword,newPassword,passwordRe);

}

- (void)readyToLogin:(NSNotification *)notification {

    if ([notification.userInfo[@"result"] boolValue]) {

        [SVProgressHUD showSuccessWithStatus:@"修改成功" maskType:SVProgressHUDMaskTypeBlack];
        [self pushLoginCurtain];
    } else {

        [SVProgressHUD showErrorWithStatus:@"修改失败" maskType:SVProgressHUDMaskTypeBlack];
    }
}

#pragma mark -- TableView DataSource delegete
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifer = @"ChangePassWord";
    YHStyleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell ==nil) {
        cell = [[YHStyleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"旧密码:";
    }else if(indexPath.row == 1){
        cell.textLabel.text = @"新密码:";
        [cell setTextFieldSecurity];
    }else{
        cell.textLabel.text = @"确认新密码:";
        [cell setTextFieldSecurity];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    return cell;
}

#pragma mark --init UIBarButtonItem 
-(UIBarButtonItem *)confirmButton{
    if (_confirmButton == nil) {
        _confirmButton = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                          style:UIBarButtonSystemItemDone
                                                         target:self
                                                         action:@selector(submit)];
        _confirmButton.tintColor = AppColor;
        
    }
    return _confirmButton;
}

-(UILabel *)footLable{
    if (_footLable ==nil) {
        _footLable = [[UILabel alloc]init];
        _footLable.text = @"密码长度至少6个字符,最多16个字符";
        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
        _footLable.frame = frame;
        _footLable.textAlignment = NSTextAlignmentCenter;
        _footLable.font = [UIFont systemFontOfSize:12.0f];
        _footLable.backgroundColor = GrayColor;
    }
    return _footLable;
}


- (void)pushLoginCurtain
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationPassword" object:nil];
    
    LoginCurtain *loginView = [[LoginCurtain alloc] init];
    loginView.refreshDelegate = self;

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginView];

    [self presentViewController:nav animated:YES completion:nil];

}

- (void)refresh
{
    NSLog(@"refresh!!!");
}

#pragma mark -- memoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
