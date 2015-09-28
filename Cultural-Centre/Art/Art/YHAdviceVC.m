//
//  YHAdviceVC.m
//  Art
//
//  Created by Tang yuhua on 15/6/30.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "YHAdviceVC.h"
#import "Common.h"
#import "ForthonDataSpider.h"
#import "SVProgressHUD.h"

#define WIDTHPERCENTAGE WIDTH / 320
#define HEIGHTPERCENTAGE HEIGHT / 480

#define SIDEINTERVAL 25 * WIDTHPERCENTAGE
#define MIDDLEINTERVAL 10 * HEIGHTPERCENTAGE

#define LabelWidth WIDTH - 2 * SIDEINTERVAL
#define LabelHeight 20 * HEIGHTPERCENTAGE

#define TextViewWidth WIDTH - 2 * SIDEINTERVAL
#define TextViewHeight 100 * HEIGHTPERCENTAGE

#define BackViewWidth WIDTH - 2 * SIDEINTERVAL
#define BackViewHeight LabelHeight * 3 + TextViewHeight

@interface YHAdviceVC ()<UITextFieldDelegate, UITextViewDelegate>


@property (nonatomic,strong) UILabel *promptLab;
@property (nonatomic,strong) UITextView *feedBackText;
@property (nonatomic,strong) UITextField *textFieldConnection;
@property (nonatomic,strong) UIButton *submitButton;

@property (nonatomic, assign) id<FeedBackDelegate>delegate;


@end

@implementation YHAdviceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航栏
    UICommon *commonUI = [[UICommon alloc] init];
    UILabel *navTitle = [commonUI navTitle:@"意见与反馈"];
    self.navigationItem.titleView = navTitle;
    self.navigationItem.backBarButtonItem = HiddenBack
    self.navigationController.navigationBar.tintColor = AppColor;
    
    //
    self.delegate = [ForthonDataSpider sharedStore];
    [self.view addSubview:self.promptLab];
    [self.view addSubview:self.backView];
    [self.view addSubview:self.submitButton];


    [self.view setBackgroundColor:[UIColor whiteColor]];

}

#pragma mark -- init subview

- (UILabel *)promptLab{
    if (_promptLab ==nil) {
        _promptLab = [[UILabel alloc]init];
        _promptLab.frame = CGRectMake(SIDEINTERVAL, 64, WIDTH - 2 * SIDEINTERVAL, 50);
        _promptLab.text = @"如果你在使用的过程中,有任何问题和建议,请给我们留言,并留下下联系方式。";
        _promptLab.font = [UIFont systemFontOfSize:14.0f];
        _promptLab.textColor = [UIColor grayColor];
        _promptLab.numberOfLines = 2;
    }
    return _promptLab;
}

- (UIView *)backView {                  //用小视图装载反馈内容，联系方式等视图

    UIView *backView = [UIView new];

    UILabel *feedBackLabel = [self createLabelWithText:@" 反馈内容"];

    _feedBackText = [UITextView new];
    [_feedBackText.layer setBorderColor:[UIColor grayColor].CGColor];
    [_feedBackText.layer setBorderWidth:1.0];
    [_feedBackText.layer setCornerRadius:5.0];
    [_feedBackText setDelegate:self];
    [_feedBackText setTintColor:AppColor];

    UILabel *connectionLabel = [self createLabelWithText:@" 联系方式"];

    _textFieldConnection = [UITextField new];
    [_textFieldConnection setPlaceholder:@"手机号/QQ/微博"];
    [_textFieldConnection setFont:[UIFont systemFontOfSize:14.0]];
    [_textFieldConnection.layer setCornerRadius:5.0];
    [_textFieldConnection.layer setBorderColor:[UIColor grayColor].CGColor];
    [_textFieldConnection.layer setBorderWidth:1.0];
    [_textFieldConnection setDelegate:self];
    [_textFieldConnection setTintColor:AppColor];


    [feedBackLabel setFrame:CGRectMake(0, 0, LabelWidth, LabelHeight)];
    [_feedBackText setFrame:CGRectMake(0, LabelHeight, TextViewWidth, TextViewHeight)];
    [connectionLabel setFrame:CGRectMake(0, LabelHeight + TextViewHeight, LabelWidth, LabelHeight)];
    [_textFieldConnection setFrame:CGRectMake(0, LabelHeight * 2 + TextViewHeight, LabelWidth, LabelHeight)];

    [backView addSubview:feedBackLabel];
    [backView addSubview:_feedBackText];
    [backView addSubview:connectionLabel];
    [backView addSubview:_textFieldConnection];

    [backView setFrame:CGRectMake(SIDEINTERVAL, 64 + 50, BackViewWidth, BackViewHeight)];
    return backView;
}

- (UILabel *)createLabelWithText:(NSString *)text {

    UILabel *label = [UILabel new];
    [label setText:text];
    [label setFont:[UIFont systemFontOfSize:14.0]];
    [label setTextColor:AppColor];

    return label;
}

- (UIButton *)submitButton {

    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button.layer setCornerRadius:5.0];
    [button setBackgroundColor:AppColor];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    [button addTarget:self action:@selector(submitFeedBack) forControlEvents:UIControlEventTouchUpInside];

    [button setFrame:CGRectMake(20, 64 + BackViewHeight + 100, WIDTH - 40, 40)];
    return button;
}

#pragma mark - 文字输入协议方法

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    [textField.layer setBorderColor:AppColor.CGColor];
    [UIView animateWithDuration:0.3 animations:^{

        self.view.center = CGPointMake(WIDTH / 2, self.view.center.y - 50);

    }];
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {

    [textView.layer setBorderColor:AppColor.CGColor];
    [UIView animateWithDuration:0.3 animations:^{

        self.view.center = CGPointMake(WIDTH / 2, self.view.center.y - 50);

    }];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {

    [textField.layer setBorderColor:[UIColor grayColor].CGColor];
    [UIView animateWithDuration:0.3 animations:^{

        self.view.center = CGPointMake(WIDTH / 2, self.view.center.y + 50);

    }];
}

- (void)textViewDidEndEditing:(UITextView *)textView {

    [textView.layer setBorderColor:[UIColor grayColor].CGColor];
    [UIView animateWithDuration:0.3 animations:^{

        self.view.center = CGPointMake(WIDTH / 2, self.view.center.y + 50);

    }];
}

#pragma mark 键盘升降

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    [_textFieldConnection resignFirstResponder];
    [_feedBackText resignFirstResponder];
}

- (void)submitFeedBack {

    [self.delegate sendSuggestWithContent:_feedBackText.text contact:_textFieldConnection.text];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(printResult:) name:@"NotificationAdvice" object:nil];
}

- (void)printResult:(NSNotification *)notification {


    if([notification.userInfo[@"result"] boolValue]) {

        [SVProgressHUD showSuccessWithStatus:@"提交成功" maskType:SVProgressHUDMaskTypeBlack];
    } else {

        [SVProgressHUD showErrorWithStatus:@"提交失败" maskType:SVProgressHUDMaskTypeBlack];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationAdvice" object:nil];

}


#pragma mark -- memoryWarning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
