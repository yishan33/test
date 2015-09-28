//
//  ViewController.m
//  demo
//
//  Created by Tang yuhua on 15/7/6.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "YHChangeUserName.h"
#import "YHStyleCell.h"
#import "SVProgressHUD.h"
#import "ForthonDataSpider.h"
#import "ForthonDataContainer.h"
#import "UICommon.h"
#import "NSString+regular.h"

@interface YHChangeUserName ()

@property (nonatomic, strong) UIBarButtonItem *confirmButton;
@property (nonatomic, strong) UILabel *footLable;
@property (nonatomic, strong) NSString *oldName;
@property (nonatomic, strong) NSString *myNewName;

@end

@implementation YHChangeUserName


#pragma mark -- life Circle
- (void)viewDidLoad {
    [super viewDidLoad];

    UICommon *commonUI = [[UICommon alloc] init];
    UILabel *navTitle = [commonUI navTitle:@"修改用户名"];
    self.navigationItem.titleView = navTitle;

    self.tableView.scrollEnabled = NO;
    self.navigationItem.rightBarButtonItem = self.confirmButton;
    self.tableView.tableFooterView = self.footLable;
    
    _oldName = [[ForthonDataSpider sharedStore] valueForKey:@"userName"];


    self.delegate = [ForthonDataSpider sharedStore ];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    if ([keyPath isEqualToString:@"userName"]) {

        if ([[[ForthonDataSpider sharedStore] valueForKey:@"userName"] isEqualToString:_myNewName]) {

            [[ForthonDataSpider sharedStore] removeObserver:self forKeyPath:@"userName"];
            [SVProgressHUD showSuccessWithStatus:@"修改成功" maskType:SVProgressHUDMaskTypeBlack];
        }
    }
}



#pragma mark --submitMetod
-(void)submit{


    NSLog(@"submit");
    NSIndexPath *first = [NSIndexPath indexPathForRow:0 inSection:0];
    YHStyleCell *cell1 = (YHStyleCell *)[self.tableView cellForRowAtIndexPath:first];
  // YHDEUG 需要传入的参数。apikey authkey name
    NSString *name = [cell1 getTextFieldText];
    _myNewName = name;

    BOOL isValid = [_myNewName checkToMarkUserName];

    if (isValid) {

        if ([_oldName isEqualToString:_myNewName]) {

            [SVProgressHUD showErrorWithStatus:@"该用户名已存在"];

        } else {

            [self.delegate modifyUserNameWithName:name];
            [SVProgressHUD showWithStatus:@"修改用户名..." maskType:SVProgressHUDMaskTypeBlack];
            [[ForthonDataSpider sharedStore] addObserver:self
                                              forKeyPath:@"userName"
                                                 options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                                 context:NULL];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNetError) name:@"NotificationNetError" object:nil];

        }
    } else {

        [SVProgressHUD showErrorWithStatus:@"用户名格式错误" maskType:SVProgressHUDMaskTypeBlack];
    }

    [cell1.inputTield resignFirstResponder];
}


- (void)showNetError {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationNetError" object:nil];
    [SVProgressHUD showErrorWithStatus:@"加载失败" maskType:SVProgressHUDMaskTypeBlack];
}


#pragma mark -- TableView DataSource delegete
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifer = @"ChangeUserName";
    YHStyleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell ==nil) {
        cell = [[YHStyleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
 // YHDEBUG  修改那个用户名，需要提示之前的用户名是多少。
    cell.textLabel.text = @"用户名字";
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    [cell setTextFieldText:_oldName];
    return cell;
}

#pragma mark --init UIBarButtonItem
-(UIBarButtonItem *)confirmButton{
    if (_confirmButton ==nil) {
        _confirmButton = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                          style:UIBarButtonSystemItemDone
                                                         target:self
                                                         action:@selector(submit)];
        _confirmButton.tintColor = AppColor;
        
    }
    return _confirmButton;
}

#pragma mark -- initView

-(UILabel *)footLable{
    if (_footLable ==nil) {
        _footLable = [[UILabel alloc]init];
        _footLable.text = @"可填写中英文、数字、下划线或者连接符号，限6-30个字符";
        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
        _footLable.frame = frame;
        _footLable.textAlignment = NSTextAlignmentCenter;
        _footLable.font = [UIFont systemFontOfSize:12.0f];
        _footLable.backgroundColor = GrayColor;
    }
    return _footLable;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
