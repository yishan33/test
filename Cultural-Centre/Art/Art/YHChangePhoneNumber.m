//
//  ViewController.m
//  demo
//
//  Created by Tang yuhua on 15/7/6.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "YHChangePhoneNumber.h"
#import "YHStyleCell.h"
#import "SVProgressHUD.h"
#import "ForthonDataSpider.h"
#import "UICommon.h"
#import "NSString+regular.h"

#define WIDTH self.view.frame.size.width
#define HEIGHT self.view.frame.size.height
static const float titleLabelHeight = 40;

@interface YHChangePhoneNumber ()

@property  int seconds;
@property (nonatomic, strong) UIButton *messageButton;
@property (nonatomic, strong) NSTimer *time;

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIView *footContainerView;
@property (nonatomic,strong) UIButton *submitButton;


@end

@implementation YHChangePhoneNumber

- (void)viewDidLoad {
    
    [super viewDidLoad];

    UICommon *commonUI = [[UICommon alloc] init];
    UILabel *navTitle = [commonUI navTitle:@"修改手机号"];
    self.navigationItem.titleView = navTitle;
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.scrollEnabled = NO;
    self.tableView.tableHeaderView = self.titleLabel;
    self.tableView.tableFooterView = self.footContainerView;
    

    self.delegate = [ForthonDataSpider sharedStore];
}

#pragma mark -- TableView DataSource delegete
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifer = @"ChangePhoneNumber";
    YHStyleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell ==nil) {
        cell = [[YHStyleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"新手机号:";
    }else{
        cell.textLabel.text = @"验证码:";
        [cell setStyleWithButton:YES];
        [cell.button addTarget:self action:@selector(getMessageCode:) forControlEvents:UIControlEventTouchUpInside];
    }
    [cell.textLabel setFont:[UIFont systemFontOfSize:14.0]];
    return cell;
}

#pragma mark --buttonMethon
-(void)getMessageCode:(UIButton *)sender {

    NSLog(@"getMessageCode");
    NSIndexPath *first = [NSIndexPath indexPathForRow:0 inSection:0];
    YHStyleCell *cell = (YHStyleCell *)[self.tableView cellForRowAtIndexPath:first];

    NSString *number = [cell getTextFieldText];
    _messageButton = sender;

    BOOL isValid = [number checkToMarkPhone];
    if (isValid) {

        [self.delegate sendIdentifyingCode:number];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readyToChangeButtonState:) name:@"NotificationCode" object:nil];

    } else {

        [SVProgressHUD showErrorWithStatus:@"手机号格式错误" maskType:SVProgressHUDMaskTypeBlack];
    }

}

- (void)readyToChangeButtonState:(NSNotification *)notification {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationCode" object:nil];

    if ([notification.userInfo[@"result"] boolValue]) {

        [self changeButtonState];
    } else {

        NSLog(@"error: %@", notification.userInfo[@"message"]);
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

-(void)submitMethod{
    NSLog(@"submitMethod");


    NSIndexPath *first = [NSIndexPath indexPathForRow:0 inSection:0];
    YHStyleCell *cell1 = (YHStyleCell *)[self.tableView cellForRowAtIndexPath:first];
    NSIndexPath *second = [NSIndexPath indexPathForRow:0 inSection:0];
    YHStyleCell *cell2 = (YHStyleCell *)[self.tableView cellForRowAtIndexPath:second];
    NSString *number = [cell1 getTextFieldText];
    NSString *messageCode = [cell2 getTextFieldText];
    [SVProgressHUD showWithStatus:@"绑定中..."];
    BOOL phoneValid = [number checkToMarkPhone];
    BOOL codeValid = [messageCode checkToMarkCode];

    if (phoneValid) {

        if (codeValid) {

            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(printResult:)
                                                         name:@"NotificationModifyPhone"
                                                       object:nil];
            [self.delegate bindPhoneToAppWithPhoneNumber:number identifyingCode:messageCode];

        } else {

            [SVProgressHUD showErrorWithStatus:@"二维码错误" maskType:SVProgressHUDMaskTypeBlack];
        }

    } else {

        [SVProgressHUD showErrorWithStatus:@"手机格式错误" maskType:SVProgressHUDMaskTypeBlack];
    }



}


- (void)printResult:(NSNotification *)notification {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationModifyPhone" object:nil];

    if ([notification.userInfo[@"result"] boolValue]) {

        NSLog(@"修改成功！！");
        [SVProgressHUD showSuccessWithStatus:@"绑定成功" maskType:SVProgressHUDMaskTypeBlack];

    } else {

        NSLog(@"修改失败: %@", notification.userInfo[@"message"]);
        [SVProgressHUD showErrorWithStatus:@"绑定失败" maskType:SVProgressHUDMaskTypeBlack];
    }
}



#pragma mark --init titleLabel
-(UILabel *)titleLabel{
    if (_titleLabel==nil) {
        _titleLabel = [[UILabel alloc]init];
        CGRect frame = CGRectMake(0, 64,WIDTH,titleLabelHeight);
        _titleLabel.frame = frame;
        _titleLabel.text = @"重新绑定后，之前绑定的手机号不能作为登录凭证";
        _titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = GrayColor;
        
        
    }
    return _titleLabel;
}

-(UIView *)footContainerView{
    if (_footContainerView ==nil) {
        _footContainerView = [[UIView alloc]init];
        _footContainerView.frame = CGRectMake(0, 0, WIDTH, 50);
        [_footContainerView addSubview:self.submitButton];
    }
    return _footContainerView;
}
-(UIButton *)submitButton{
    if (_submitButton ==nil) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_submitButton.layer setCornerRadius:5.0f];
        CGRect frame = CGRectMake(20, 20,WIDTH-40, 40);
        _submitButton.frame = frame;
        [_submitButton setTitle:@"绑定" forState:UIControlStateNormal];
        [_submitButton setTintColor:[UIColor whiteColor]];
        [_submitButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
        _submitButton.backgroundColor = AppColor;
        [_submitButton addTarget:self action:@selector(submitMethod) forControlEvents:UIControlEventTouchUpInside];
    
    }
    return _submitButton;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
