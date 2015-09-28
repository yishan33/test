//
//  YHUserInformation.m
//  Art
//
//  Created by Tang yuhua on 15/6/30.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "YHUserInformation.h"
#import "YHUserInforModel.h"
#import "YHUserInfoCell.h"
#import "Common.h"
#import "YHChangePassword.h"
#import "YHChangeNickName.h"
#import "YHChangePhoneNumber.h"
#import "YHChangeUserName.h"
#import "AFHTTPRequestOperationManager.h"
#import "ForthonDataContainer.h"
#import "ForthonDataSpider.h"

@interface YHUserInformation ()

@property (nonatomic,strong) UIView *footView;
@property (nonatomic,strong) UIButton *logOutButton;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) UIActionSheet *sheet;
@property (nonatomic, strong) UIImage *image;

@end

@implementation YHUserInformation

- (void)viewDidLoad {
    [super viewDidLoad];
    UICommon *commonUI = [[UICommon alloc] init];
    UILabel *navTitle = (UILabel *) [commonUI navTitle:@"个人信息"];
    
    self.navigationItem.titleView = navTitle;
    
    self.navigationItem.backBarButtonItem = HiddenBack
    self.navigationController.navigationBar.tintColor = AppColor;
    self.delegate = [ForthonDataSpider sharedStore];

    self.tableView.bounces = NO;

    //退出账户的按钮
    _footView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 200)];
    _logOutButton  = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _logOutButton.frame = CGRectMake(20, 50, WIDTH-40, 40);
    _logOutButton.backgroundColor = AppColor;
    [_logOutButton.layer setCornerRadius:5.0f];
    [_logOutButton setTitle:@"退出" forState:UIControlStateNormal];
    [_logOutButton setTintColor:[UIColor whiteColor]];
    [_logOutButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    [_logOutButton addTarget:self action:@selector(logOut) forControlEvents:UIControlEventTouchUpInside];
    [_footView addSubview:_logOutButton];
    self.tableView.tableFooterView = _footView;
    self.logoutDelegate = [ForthonDataSpider sharedStore];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didLogout)
                                                 name:@"NotificationLogout"
                                               object:nil];

    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [[ForthonDataSpider sharedStore] addObserver:self forKeyPath:@"userNick" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];

    [[ForthonDataSpider sharedStore] addObserver:self forKeyPath:@"userName" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];

    [[ForthonDataSpider sharedStore] addObserver:self forKeyPath:@"phoneNumber" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"cell";
    YHUserInforModel *model = [[YHUserInforModel alloc]init];
    
    YHUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[YHUserInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [model title:indexPath.row];
    cell.messageLabel.text = [model message:indexPath.row];
    
    if (indexPath.row  == 4) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.row == 0) {

        NSLog(@"设置头像！");
        [cell loadWithImageRight];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%i",(int)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:

            [self UserImageClicked];
            break;
        case 1:

            [self pushChangenickNameView];            //修改昵称
            break;
        case 2:

            [self pushChangeUserNameView];      //修改用户名
            break;
        case 3:
            
            [self pushChangePhoneNumberView];  //修改手机号
            break;
   
        case 4:
            
            [self pushChangePasswordView];     //修改密码
            break;

        default:
            break;
    }

}

#pragma mark 推出修改个人信息视图

- (void)pushChangePasswordView
{
    YHChangePassword *changePassworkView = [[YHChangePassword alloc] init];
    changePassworkView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:changePassworkView animated:YES];
}

- (void)pushChangenickNameView
{
    YHChangeNickName *changeNickNameView = [[YHChangeNickName alloc] init];
    changeNickNameView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:changeNickNameView animated:YES];
}

- (void)pushChangePhoneNumberView
{
    YHChangePhoneNumber *changePhoneNumberView = [[YHChangePhoneNumber alloc] init];
    changePhoneNumberView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:changePhoneNumberView animated:YES];
}

- (void)pushChangeUserNameView
{
    YHChangeUserName *changeUserNameView = [[YHChangeUserName alloc] init];

    changeUserNameView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:changeUserNameView animated:YES];
}

- (void)UserImageClicked
{
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
        self.sheet  = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照", @"从相册选择", nil];
        }
    else {
        self.sheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
    }
    
    self.sheet.tag = 255;
    //[self.sheet showInView:self.view];
    
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    if ([window.subviews containsObject:self.view]) {
        [self.sheet showInView:self.view];
    } else {
        [self.sheet showInView:window];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    return;
                case 1: //相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 2: //相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    _image = info[@"UIImagePickerControllerOriginalImage"];

    NSIndexPath *imagePath = [NSIndexPath indexPathForRow:0 inSection:1];
    YHUserInfoCell *imageCell = (YHUserInfoCell *) [self.tableView cellForRowAtIndexPath:imagePath];
    [imageCell loadWithImage:_image];

    [self.delegate uploadPhotoWithImage:_image];
}



-(void)logOut{
    NSLog(@"退出账户");
    [self.logoutDelegate logOut];
    
}

- (void)didLogout {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"NotificationLogout"
                                                  object:nil]; 

    [[ForthonDataSpider sharedStore] removeObserver:self forKeyPath:@"userName"];
    [[ForthonDataSpider sharedStore] removeObserver:self forKeyPath:@"userNick"];
    [[ForthonDataSpider sharedStore] removeObserver:self forKeyPath:@"phoneNumber"];
    

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {


    if ([keyPath isEqualToString:@"userNick"]) {


        [self.tableView reloadData];
        NSLog(@"change the nickName");

    }
    if ([keyPath isEqualToString:@"userName"]) {
        [self.tableView reloadData];
    }

    if ([keyPath isEqualToString:@"phoneNumber"]) {
        [self.tableView reloadData];
    }

}


@end
