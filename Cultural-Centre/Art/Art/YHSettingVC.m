//
//  YHSettingVC.m
//  Art
//
//  Created by Tang yuhua on 15/6/30.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "YHSettingVC.h"
#import "Common.h"
#import "YHAdviceVC.h"
#import "YHAboutUSVC.h"
#import "SVProgressHUD.h"

@interface YHSettingVC ()<UIAlertViewDelegate>

@end

@implementation YHSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICommon *commonUI = [[UICommon alloc] init];
    UILabel *navTitle = [commonUI navTitle:@"设置"];
    self.navigationItem.titleView = navTitle;
    self.navigationItem.backBarButtonItem = HiddenBack;
    self.navigationItem.backBarButtonItem.tintColor = AppColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.row ==0) {
        cell.textLabel.text = @"关于我们";

    }else if(indexPath.row == 1){
        cell.textLabel.text = @"清除缓存";

    }else if(indexPath.row == 2) {
        cell.textLabel.text = @"意见与反馈";

    } else {
        cell.textLabel.text = @"更新版本";
    }
    
    cell.textLabel.textColor = AppColor;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == 0) {

        [self pushAboutUsView];

    } else if (indexPath.row == 1) {

        [self clearCache];

    } else if (indexPath.row == 2) {

        [self pushAdviseView];
    } else {

        NSLog(@"已经是最新版本了～亲！");
    }
}

#pragma mark - 意见与反馈

- (void)pushAdviseView {

    NSLog(@"意见与反馈");
    YHAdviceVC *adviceVC = [YHAdviceVC new];
    [self.navigationController pushViewController:adviceVC animated:YES];
}


#pragma mark - 清除缓存

- (void)clearCache {

    NSLog(@"清除缓存");
    UIAlertView *alert;
    alert = [[UIAlertView alloc]initWithTitle:@"缓存"
                                      message:@"是否清空缓存"
                                     delegate:self
                            cancelButtonTitle:@"取消"
                            otherButtonTitles:@"确定", nil];
    [alert show];
}

#pragma mark - 关于我们

- (void)pushAboutUsView {

    NSLog(@"关于我们");
    YHAboutUSVC *aboutUSVC = [YHAboutUSVC new];
    [self.navigationController pushViewController:aboutUSVC animated:YES];
}

#pragma mark - 版本更新

- (void)versionUpdate {

    NSLog(@"版本更新");

}

#pragma mark - AlertView协议方法

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 0) {

        NSLog(@"cancel button");
    } else {

        NSLog(@"confirm button");
        NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = documents[0];
        NSLog(@"path : %@", docDir);
        NSArray *plistNameArray = @[@"videos.plist",
                                    @"artList.plist",
                                    @"artTradeList.plist",
                                    @"pages.plist",
                                    @"commentTop.plist",
                                    @"skimTop.plist",
                                    @"newsTop.plist"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *err = [NSError new];
        for (NSString *plistName in plistNameArray) {

            NSString *path = [docDir stringByAppendingPathComponent:plistName];
            BOOL fileExist = [fileManager fileExistsAtPath:path];
            if (fileExist) {
                NSLog(@"文件存在.立即删除!!!");
                [fileManager removeItemAtPath:path error:&err];
            }
        }
        [SVProgressHUD showSuccessWithStatus:@"删除成功"];
    }
}


@end
