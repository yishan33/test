//
//  ViewController.m
//  demo
//
//  Created by Tang yuhua on 15/7/6.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "YHChangeNickName.h"
#import "YHStyleCell.h"
#import "SVProgressHUD.h"
#import "ForthonDataSpider.h"
#import "UICommon.h"
#import "NSString+regular.h"

@interface YHChangeNickName ()

@property (nonatomic,strong) UIBarButtonItem *confirmButton;
@property (nonatomic,strong) UILabel *footLable;
@property (nonatomic,strong) NSString *oldName;
@property (nonatomic,strong) NSString *myNewName;

@end

@implementation YHChangeNickName

#pragma mark -- life Circle
- (void)viewDidLoad {

    UICommon *commonUI = [[UICommon alloc] init];
    UILabel *navTitle = [commonUI navTitle:@"修改昵称"];
    self.navigationItem.titleView = navTitle;

    [super viewDidLoad];
    self.tableView.scrollEnabled = NO;
    self.navigationItem.rightBarButtonItem = self.confirmButton;
    self.tableView.tableFooterView = self.footLable;
    
    _oldName = [[ForthonDataSpider sharedStore] valueForKey:@"userNick"];
    self.delegate = [ForthonDataSpider sharedStore];




}

#pragma mark --submitMetod
-(void)submit{
    NSLog(@"submit");

    NSIndexPath *first = [NSIndexPath indexPathForRow:0 inSection:0];
    YHStyleCell *cell1 = (YHStyleCell *)[self.tableView cellForRowAtIndexPath:first];
    NSString *name = [cell1 getTextFieldText];
    _myNewName = name;

    BOOL isValid = [_myNewName checkToMarkNick];

    if (isValid) {

        if ([_myNewName isEqualToString:_oldName]) {

            [SVProgressHUD showErrorWithStatus:@"该昵称已存在" maskType:SVProgressHUDMaskTypeBlack];



        } else {

            [self.delegate modifyNickNameWithName:name];
            [[ForthonDataSpider sharedStore] addObserver:self
                                              forKeyPath:@"userNick"
                                                 options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                                 context:NULL];
            [SVProgressHUD showWithStatus:@"昵称修改中..." maskType:SVProgressHUDMaskTypeBlack];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNetError) name:@"NotificationNetError" object:nil];

        }

    } else {

        [SVProgressHUD showErrorWithStatus:@"昵称格式错误"];
    }

    [cell1.inputTield resignFirstResponder];

}

- (void)showNetError {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationNetError" object:nil];
    [SVProgressHUD showErrorWithStatus:@"加载失败" maskType:SVProgressHUDMaskTypeBlack];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    if ([keyPath isEqualToString:@"userNick"]) {

        if ([_myNewName isEqualToString:[[ForthonDataSpider sharedStore] valueForKey:@"userNick"]]) {

            [[ForthonDataSpider sharedStore] removeObserver:self forKeyPath:@"userNick"];
            [SVProgressHUD showSuccessWithStatus:@"修改成功" maskType:SVProgressHUDMaskTypeBlack];


        }
    }
}

#pragma mark -- TableView DataSource delegete
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifer = @"ChangeNickName";
    YHStyleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell ==nil) {
        cell = [[YHStyleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    // YHDEBUG  修改那个用户名，需要提示之前的nickname多少。
    cell.textLabel.text = @"用户昵称";
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
        _footLable.text = @"可填写中英文、数字、下划线或者连接符号，限4-30个字符";
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
