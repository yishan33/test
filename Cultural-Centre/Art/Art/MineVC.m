//
//  MineVC.m
//  Art
//
//  Created by Tang yuhua on 15/4/28.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "MineVC.h"
#import "Common.h"
#import "MineListCell.h"
#import "YHMyListControllers.h"
#import "YHUserInformation.h"
#import "ForthonDataSpider.h"
#import "UIImageView+WebCache.h"
#import "LoginCurtain.h"

#import "ForthonMyFavors.h"
#import "ForthonMyFollows.h"
#import "ForthonMyComments.h"
#import "ForthonMyPages.h"
#import "ForthonMyWorks.h"
#import "YHSettingVC.h"
#import "SVProgressHUD.h"

//#import "pageWebViewController.h"


@interface MineVC ()

@property BOOL isLogin;
@property (nonatomic, strong) NSTimer *time;

@property (nonatomic, strong) UILabel *redPoint;
@property (nonatomic, strong) UIImageView *headImage;


@end

@implementation MineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UICommon *commonUI = [[UICommon alloc] init];
    UILabel *navTitle = [commonUI navTitle:@"我的"];
    
    self.navigationItem.titleView = navTitle;
    
    self.navigationItem.backBarButtonItem = HiddenBack
    self.navigationController.navigationBar.tintColor = AppColor;
    
//    [self.tableView setFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64 - 140)];
    self.tableView.scrollEnabled = YES;
    self.tableView.bounces = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    UIView *footView = [[UIView alloc] init];
    self.tableView.tableFooterView = footView;

    // 头像背景
    UIImageView *headBackgroundImage = [[UIImageView alloc] init];
    headBackgroundImage.frame = CGRectMake(0, 0, WIDTH, 0.4*WIDTH);
    NSLog(@"self.view.frame.size.width = %f",self.view.frame.size.width);
    headBackgroundImage.image = [UIImage imageNamed:@"profile_avatar_bg"];
    headBackgroundImage.userInteractionEnabled = YES;

    CGRect headImageBound= headBackgroundImage.bounds;

    UIImageView *headImageDefaut = [UIImageView new];
    headImageDefaut.frame = CGRectMake(headImageBound.size.width / 2 - headImageBound.size.height / 4, headImageBound.size.height / 4, headImageBound.size.height / 2, headImageBound.size.height / 2);
    headImageDefaut.image = [UIImage imageNamed:@"profile_avatar_default"];
    headImageDefaut.layer.masksToBounds = YES;
    headImageDefaut.layer.cornerRadius = headImageBound.size.height / 4.0;
    headImageDefaut.layer.borderColor = [AppColor CGColor];
    headImageDefaut.layer.borderWidth = 2.0;
    [headBackgroundImage addSubview:headImageDefaut];               //头像与头像背景之间加了一个默认头像视图。当获取到的url为空不必特定设置头像是默认的，url为空直接显示默认头像视图
    headImageDefaut.userInteractionEnabled = YES;

        //头像
    _headImage = [[UIImageView alloc] init];
    _headImage.frame = CGRectMake(0, 0, headImageBound.size.height/2, headImageBound.size.height/2);
    _headImage.image = [UIImage imageNamed:@"profile_avatar_default"];
            //设置圆形边框
    _headImage.layer.masksToBounds = YES;
    _headImage.layer.cornerRadius = headImageBound.size.height/4.0;
    _headImage.layer.borderColor = [AppColor CGColor];
    _headImage.layer.borderWidth = 2.0;
    //添加点击事件

    _time = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(getMyCommentsNumber) userInfo:nil repeats:YES];
    _headImage.userInteractionEnabled = YES;

    self.unReadDelegate = [ForthonDataSpider sharedStore];
    self.tableView.tableHeaderView = headBackgroundImage;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(enterUserInfo)];
    [_headImage addGestureRecognizer:singleTap];
    [headImageDefaut addSubview:_headImage];


}

#pragma mark - 不断发送请求

- (void)viewWillAppear:(BOOL)animated
{
    [[ForthonDataContainer sharedStore] addObserver:self
                                         forKeyPath:@"appIsLogin"
                                            options:NSKeyValueObservingOptionInitial
                                            context:NULL];

    [[ForthonDataContainer sharedStore] addObserver:self
                                         forKeyPath:@"unReadCommentsNumber"
                                            options:NSKeyValueObservingOptionInitial
                                            context:NULL];

    [_time setFireDate:[NSDate distantPast]];
    NSLog(@"view Appear");
    if ([SVProgressHUD isVisible]) {

        [SVProgressHUD dismiss];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [[ForthonDataContainer sharedStore] removeObserver:self forKeyPath:@"appIsLogin"];
    [[ForthonDataContainer sharedStore] removeObserver:self forKeyPath:@"unReadCommentsNumber"];
    NSLog(@"disappear: %@", [[ForthonDataContainer sharedStore] valueForKey:@"appIsLogin"]);
    
    [_time setFireDate:[NSDate distantFuture]];
}

#pragma mark - 监听回调 - App退出登录后头像变成默认的

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    
    if ([keyPath isEqualToString:@"unReadCommentsNumber"]) {
        
//        NSLog(@"调用了一次");
        NSNumber *unRead = [[ForthonDataContainer sharedStore] valueForKey:@"unReadCommentsNumber"];
        
        if ([unRead intValue] >= 1) {

            _redPoint.hidden = NO;
            [_redPoint setText:[NSString stringWithFormat:@" %@ ", unRead]];
            CGSize labelSize = [self labelAutoCalculateRectWith:_redPoint.text FontSize:16.0 MaxSize:CGSizeMake(100, 60)];
            [_redPoint setFrame:CGRectMake(WIDTH - labelSize.width - 10, (44 - labelSize.height) / 2, labelSize.width, labelSize.height)];
            [_redPoint.layer setCornerRadius:labelSize.height / 2];
            [_redPoint setClipsToBounds:YES];

        } else {

            _redPoint.hidden = YES;

        }
        
    }
    
    if ([keyPath isEqualToString:@"appIsLogin"]) {

        NSLog(@"appIsLogin : %@", [[ForthonDataContainer sharedStore] valueForKey:keyPath]);

        if ([[[ForthonDataContainer sharedStore] valueForKey:keyPath] length]) {

            if ([[[ForthonDataContainer sharedStore] valueForKey:keyPath] isEqualToString:@"out"]) {

                NSLog(@"木的头像");
                _isLogin = NO;

            } else {

                NSLog(@"有头像");
                _isLogin = YES;

            }

            [_headImage  sd_setImageWithURL:[NSURL URLWithString:[ForthonDataSpider sharedStore].avatarUrl]];
            NSLog(@"imageUrl: %@", [ForthonDataSpider sharedStore].avatarUrl);
        } else {

            NSLog(@"木的头像");
            _isLogin = NO;
        }


    }

}


#pragma mark -- dataDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"cell";
    MineListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[MineListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell cellInListAt:indexPath.row];
    if (indexPath.row == 2) {
        NSLog(@"我的评论");
        _redPoint = [[UILabel alloc] init];
//        NSString *numberStr = @" 1 ";
//        [_redPoint setText:numberStr];
        [_redPoint setBackgroundColor:AppColor];
        [_redPoint setTextColor:[UIColor whiteColor]];
        [_redPoint setFont:[UIFont systemFontOfSize:16.0]];
        [_redPoint setTextAlignment:NSTextAlignmentNatural];
       
        
        [cell addSubview:_redPoint];

    }

    return cell;
}

- (CGSize)labelAutoCalculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize

{
    
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    
    NSDictionary* attributes =@{
                                NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName:paragraphStyle.copy
                                };
    
    CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    
    labelSize.height = (CGFloat) ceil(labelSize.height);
    labelSize.width = (CGFloat) ceil(labelSize.width);
    return labelSize;
    
}


#pragma mark --viewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int row = (int)indexPath.row;

    if (row == 5) {

        NSLog(@"商店");
        [SVProgressHUD showImage:nil  status:@"敬请期待" maskType:SVProgressHUDMaskTypeBlack];


    } else if (row == 6) {

        NSLog(@"设置");
        [self pushSettingView];

    } else {

        if (_isLogin) {

            switch (row) {
                case 0:
                    //我的收藏

                    [self pushMyFavorView];

                    break;
                case 1:
                    //我的关注

                    [self pushMyFollowView];

                    break;
                case 2:
                    //我的评论

                    [self pushMyCommentView];

                    break;
                case 3:
                    //我的作品
                    [self pushMyWorkView];

                    break;
                case 4:
                    //我的文章

                    [self pushMyPageView];
                    break;

            }

        } else {

            NSLog(@"弹出登陆节目");
            [self pushLoginCurtain];

        }
    }


}

#pragma mark -- gestureMethod 

-(void)enterUserInfo{
    NSLog(@"heheda");
    
    if (_isLogin) {

        NSLog(@"already Login");
        YHUserInformation *info =[[YHUserInformation alloc]init];
        [self.navigationController pushViewController:info animated:YES];
    }
    else {

        [self pushLoginCurtain];
    }
   
}



#pragma mark 推出登录界面

- (void)pushLoginCurtain
{
    NSLog(@"请登录...");
    LoginCurtain *loginView = [[LoginCurtain alloc] init];
    loginView.refreshDelegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginView];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)refresh
{
    _isLogin = YES;
}


#pragma mark -- PushView

- (void)pushMyFavorView
{

    ForthonMyFavors *myFavorsView = [[ForthonMyFavors alloc] init];
    myFavorsView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myFavorsView animated:YES];
}

- (void)pushMyFollowView
{

    ForthonMyFollows *myFollowsView = [[ForthonMyFollows alloc] init];
    myFollowsView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myFollowsView animated:YES];
}

- (void)pushMyCommentView
{

    ForthonMyComments *myCommentsView = [[ForthonMyComments alloc] init];
    myCommentsView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myCommentsView animated:YES];
}

- (void)pushMyPageView
{
    ForthonMyPages *myPagesView = [[ForthonMyPages alloc] init];
    myPagesView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myPagesView animated:YES];
}


- (void)pushMyWorkView
{

    ForthonMyWorks *myWorksView = [[ForthonMyWorks alloc] init];
    myWorksView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myWorksView animated:YES];
}

- (void)pushSettingView {

    NSLog(@"设置");
    YHSettingVC *settingVC = [YHSettingVC new];
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)getMyCommentsNumber {
    
//    NSLog(@"begin to get number");
    [self.unReadDelegate getMyCommentsNoRead];
    
}


#pragma mark -- lackMemoryWarning


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
   
}



@end
