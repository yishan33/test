//
//  ForthonAllComments.m
//  Art
//
//  Created by Liu fushan on 15/6/16.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "ForthonAllComments.h"
#import "commentCell.h"
#import "ForthonDataContainer.h"
#import "ForthonDataSpider.h"
#include "InputTextFieldMeasurement.h"
#import "RefreshControl.h"
#import "LoginCurtain.h"
#import "RefreshControl.h"
#import "SVProgressHUD.h"
#import "UICommon.h"

typedef enum {
    LoadTypeRefresh,
    LoadTypeLoadMore
}LoadType;


@interface ForthonAllComments ()

@property int page;
@property int endIndex;

@property (nonatomic, strong) UITableView *myTable;
@property (nonatomic,strong) RefreshControl * myRefreshControl;
@property (nonatomic, strong) NSArray *commentArray;

@property (nonatomic, strong) UITextField *commentText;
@property (nonatomic, strong) UIView *buttomView;
@property (strong, nonatomic) NSString *commentFartherId;
@property (nonatomic, strong) NSMutableArray *cellHeightArray;
@property float currentCellHeight;

@property (nonatomic, strong) UIButton *loadButton;
@property (nonatomic, strong) UIImageView *loadImage;


@end

@implementation ForthonAllComments

- (void)viewDidLoad {
    [super viewDidLoad];

    UICommon *commonUI = [[UICommon alloc] init];
    UILabel *navTitle = (UILabel *) [commonUI navTitle:@"全部评论"];
    self.navigationItem.titleView = navTitle;

    _page = 1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _delegate = [ForthonDataSpider sharedStore];
    _loginDelegate = self;
    _commentArray = [[NSArray alloc] init];

    if (_typeId == 3) {
        
        _commentArray = [[ForthonDataContainer sharedStore].commentsDic[@"pagesComments"] objectForKey:_workId];
    } else if (_typeId == 1) {
        _commentArray = [[ForthonDataContainer sharedStore].commentsDic[@"videosComments"] objectForKey:_workId];
    } else if (_typeId == 2) {
        _commentArray = [[ForthonDataContainer sharedStore].commentsDic[@"artsComments"] objectForKey:_workId];
    }
    
    [self loadCellHeight];
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 1)];
    [topLine setBackgroundColor:[UIColor grayColor]];
    
    _buttomView = [[UIView alloc] initWithFrame:CGRectMake(-1, self.view.frame.size.height - BACKVIEWHEIGHT , BACKVIEWWIDTH, BACKVIEWHEIGHT)];
    //    [_buttomView.layer setBorderWidth:1.0];
    //    [_buttomView.layer setBorderColor:[UIColor grayColor].CGColor];
    [_buttomView setBackgroundColor:[UIColor whiteColor]];
    
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(L_INTERVAL - LINEINTERVAL, TEXTHEIGHT  - LINEHEIGHT, LINEWIDTH, LINEHEIGHT)];
    [leftLine setBackgroundColor:[UIColor grayColor]];
    
    
    _commentText = [[UITextField alloc] initWithFrame:CGRectMake(L_INTERVAL, 0, TEXTWIDTH, TEXTHEIGHT)];
    [_commentText setPlaceholder:@"我想说两句"];
    [_commentText setDelegate:self];
    [_commentText setKeyboardType:UIKeyboardTypeDefault];
    
    UIView *buttomLine = [[UIView alloc] initWithFrame:CGRectMake(L_INTERVAL - LINEINTERVAL, TEXTHEIGHT, TEXTWIDTH + 2 * LINEINTERVAL, LINEWIDTH)];
    [buttomLine setBackgroundColor:[UIColor grayColor]];
    
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(L_INTERVAL + TEXTWIDTH + LINEINTERVAL - LINEWIDTH, TEXTHEIGHT - LINEHEIGHT , LINEWIDTH, LINEHEIGHT)];
    [rightLine setBackgroundColor:[UIColor grayColor]];
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - SENDBUTTONSIDE - INTERVALRIGHT / 2, (BACKVIEWHEIGHT - SENDBUTTONSIDE) / 2, SENDBUTTONSIDE, SENDBUTTONSIDE)];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"comment_btn_normal.png"] forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"comment_btn_selected.png"] forState:UIControlStateSelected];
    [sendButton addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
    
    [_buttomView addSubview:topLine];
    [_buttomView addSubview:sendButton];
    [_buttomView addSubview:rightLine];
    [_buttomView addSubview:leftLine];
    [_buttomView addSubview:buttomLine];
    [_buttomView addSubview:_commentText];
    
    _myTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, self.view.frame.size.height - BACKVIEWHEIGHT - 64)];


    _loadButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [_loadButton setCenter:CGPointMake(self.view.center.x, 2 * (self.view.frame.size.height - 64) / 3)];
    _loadButton.backgroundColor = [UIColor blackColor];
    [_loadButton setTitle:@"点击重试" forState:UIControlStateNormal];
    [_loadButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_loadButton addTarget:self action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    [_myTable addSubview:_loadButton];
    _loadButton.hidden = YES;

    _loadImage = [[UIImageView alloc] init];
    _loadImage.frame = CGRectMake(0, 0, 100 * WIDTH / 320.0, 80 * WIDTH / 320.0);
    _loadImage.center = CGPointMake(self.view.center.x, (self.view.frame.size.height - 64) / 2);
    _loadImage.image = [UIImage imageNamed:@"ic_error_page"];
    [_myTable addSubview:_loadImage];

    [_myTable setDelegate:self];
    [_myTable setDataSource:self];

    _loadImage.hidden = YES;

    _myRefreshControl = [[RefreshControl alloc] initWithScrollView:_myTable delegate:self];
    _myRefreshControl.topEnabled = YES;

    if ([_commentArray count] < 10) {

        _myRefreshControl.bottomEnabled = NO;
    } else {

        _myRefreshControl.bottomEnabled = YES;
    }
    
    [self.view addSubview:_myTable];
    [self.view addSubview:_buttomView];


}


- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction
{
    
    
    __weak typeof(self)weakSelf=self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf)strongSelf=weakSelf;

        if (direction == RefreshDirectionTop) {

            [strongSelf reloadDataWithType:LoadTypeRefresh];

    
        } else {

            [strongSelf reloadDataWithType:LoadTypeLoadMore];
            
        }
        
        
    });
    
}

#pragma mark - 加载.刷新
-(void)reloadDataWithType:(LoadType)type
{
    if (type == LoadTypeRefresh) {
        
        [_delegate getCommentByTypeid:_typeId targetId:_workId page:1];
        _page = 1;
        
    } else {
        
        NSLog(@"begin load more message:");
        _page++;
        [_delegate getCommentByTypeid:_typeId targetId:_workId page:_page];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUI)
                                                 name:@"NotificationA"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showLoadButton)
                                                 name:@"NotificationNetError"
                                               object:nil];
    
    
}


- (void)showLoadButton {

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"NotificationNetError"
                                                  object:nil];

    [SVProgressHUD showErrorWithStatus:@"加载失败" maskType:SVProgressHUDMaskTypeBlack];
    _loadButton.hidden = NO;
    _loadImage.hidden = NO;

};


- (void)reload {

    [SVProgressHUD showWithStatus:@"加载中..."];
    [_delegate getCommentByTypeid:_typeId targetId:_workId page:1];
    _page = 1;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUI)
                                                 name:@"NotificationA"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showLoadButton)
                                                 name:@"NotificationNetError"
                                               object:nil];
}


- (void)viewDidAppear:(BOOL)animated  {




}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_commentArray count]) {
        
         return [_commentArray count];
    } else
        return 0;
   
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_commentArray count]) {
        int i = indexPath.row;
       
        return [_cellHeightArray[i] floatValue];
    }
    else return 76;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = (int)indexPath.row;
    NSLog(@"index %i", index);
    
    NSDictionary *dic = _commentArray[index];

    static NSString *cellIdentifier = @"cell";
    commentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {

        cell = [[commentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell load];


    }

    [cell resetContentLabeWithDic:dic];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = (int)indexPath.row;
    
     NSLog(@"%i",(int)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    NSString *fName = [[NSString alloc] init];
    NSDictionary *dic = _commentArray[index];
    _commentFartherId = [dic objectForKey:@"id"];
    if ([dic[@"userNickName"] length]) {

        fName = dic[@"userNickName"];
    } else {

        fName = dic[@"userName"];
    }
    
    [_commentText setPlaceholder:[NSString stringWithFormat:@"回复%@", fName]];
    CGFloat cutNumber = 0;
    
    
    for (int i = 0 ; i < index; i++)
        {
            cutNumber += [_cellHeightArray[i] floatValue];
        
        }
    cutNumber = 64 + (int)cutNumber  % (int)(HEIGHT - 64);
//    NSLog(@"cutNmuber: %f", cutNumber);
    if ( cutNumber > KEYBOARDHEIGHT) {
//        NSLog(@"i should move");
        [self commentReplyWithHeight:cutNumber - KEYBOARDHEIGHT];
    }
    
    [_commentText becomeFirstResponder];
    
}


#pragma mark ScrollView Move

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (_buttomView.center.y == self.view.frame.size.height - _buttomView.frame.size.height / 2) {
//        NSLog(@"无所谓");
    } else {
    
        [self endInput];
    }
    
}


#pragma mark -TextField Move

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //开始输入时，小视图上移80，加了动画效果，时常0.3 s
    
    NSLog(@"begin move");
    if (_buttomView.center.y == self.view.frame.size.height - _buttomView.frame.size.height / 2) {
//
        [UIView animateWithDuration:0.3 animations:^{
            [_buttomView setCenter:CGPointMake(_buttomView.center.x, _buttomView.center.y - KEYBOARDHEIGHT )];
//            [_buttomView setCenter:CGPointMake(_buttomView.center.x, 150 )];
            
        }];
       
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endInput];
    
    return YES;
}



- (void)commentReplyWithHeight:(CGFloat)moveHeight
{
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self.view setCenter:CGPointMake(self.view.center.x, self.view.frame.size.height / 2 - moveHeight)];
        [_buttomView setCenter:CGPointMake(_buttomView.center.x, self.view.frame.size.height - (BACKVIEWHEIGHT / 2) - KEYBOARDHEIGHT+ moveHeight)];
        
    }];
    
}



- (void)endInput
{
    //触碰视图，则输入结束，小视图回到原位
    if (_commentText.isFirstResponder ) {
    
        [UIView animateWithDuration:0.3 animations:^{
            
            [self.view setCenter:CGPointMake(self.view.center.x, self.view.frame.size.height / 2)];
            [_buttomView setCenter:CGPointMake(_buttomView.center.x, self.view.frame.size.height - BACKVIEWHEIGHT / 2)];
        }];
        [_commentText resignFirstResponder];
        [_commentText setPlaceholder:@"我想说两句"];
    }
   
    
    
}


#pragma mark LoadCommentCellTotalHeight

- (void)loadCellHeight
{
    NSArray *testCommentArray;
    if (_typeId == 1) {
        
        testCommentArray = [[[ForthonDataContainer sharedStore].commentsDic objectForKey:@"videosComments"]objectForKey:_workId];
                                      
    } else if (_typeId == 3){
        
        testCommentArray = [[[ForthonDataContainer sharedStore].commentsDic objectForKey:@"pagesComments"]objectForKey:_workId];
    } else if (_typeId == 2) {
        
        testCommentArray = [[[ForthonDataContainer sharedStore].commentsDic objectForKey:@"artsComments"]objectForKey:_workId];
    }
    CGFloat viewHeight;
    if ([testCommentArray count])
        {

        _commentArray = testCommentArray;
        _cellHeightArray = [[NSMutableArray alloc] init];
        NSString *text;
        for (int i = 0; i < [_commentArray count]; i++) {
            if ([_commentArray count] > i + 1) {
                text = [_commentArray[i] objectForKey:@"content"];
                
            } else {
                text = @"";
            }
            //                    NSString *text = ;
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0], NSParagraphStyleAttributeName:paragraphStyle.copy};
            
            CGSize size = CGSizeMake(250 * WIDTHPERCENTAGE, 1000);

            NSNumber *cellHeightNumber = [NSNumber numberWithFloat:[text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height + HEIGHTNOCONTENT];
            NSLog(@"the %i cellNoContent: %f",i, [NSNumber numberWithFloat:[text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height].floatValue);
            [_cellHeightArray addObject:cellHeightNumber];
            viewHeight += cellHeightNumber.floatValue;


            if (!_endIndex) {

                if (viewHeight >= (self.view.frame.size.height - 64)) {

                    _endIndex = i;
                }
            }

        }

        if (viewHeight > self.view.frame.size.height - 64 - BACKVIEWHEIGHT) {

            _myTable.frame = CGRectMake(0, 64, WIDTH, self.view.frame.size.height - 64 - BACKVIEWHEIGHT);
            if ([_commentArray count] >= 10) {

                _myRefreshControl.bottomEnabled = YES;
            } else {

                _myRefreshControl.bottomEnabled = NO;
            }
        }
        
    }
}

#pragma mark - 刷新.加载后刷新视图

- (void)updateUI {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotifiacationA" object:nil];
    [self loadCellHeight];

    [_myTable reloadData];


    if (self.myRefreshControl.refreshingDirection == RefreshingDirectionTop)
    {
        [self.myRefreshControl finishRefreshingDirection:RefreshDirectionTop];
    }
    else if (self.myRefreshControl.refreshingDirection == RefreshingDirectionBottom)
    {

        [self.myRefreshControl finishRefreshingDirection:RefreshDirectionBottom];

    }
}


#pragma mark - get&sendComment

- (void)sendComment
{
    NSLog(@"send !");
    NSString *commentString = _commentText.text;

    [_commentText setText:@""];
    NSLog(@"fatherID is--------------------------\n%@\n", _commentFartherId);
    [_delegate sendCommentsByTypeid:_typeId targetId:_workId fatherId:_commentFartherId content:commentString];
    
    //spider中添加发送评论的接口，参数为 作品种类 、Id  和  commentString
    //让spider 把 commentString 发出去
    //添加通知，当服务器添加评论成功，立马刷新出新的评论。
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addComment)
                                                 name:@"NotificationA"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(LoginPlease) name:@"NotificationUserError"
                                               object:nil];
    
    [self endInput];
    
    
    
}

- (void)addComment
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationA" object:nil];
    if (_typeId == 3) {
        _commentArray = [[[ForthonDataContainer sharedStore].commentsDic objectForKey:@"pagesComments"]objectForKey:_workId];
    } else if (_typeId == 1) {
        
        _commentArray = [[[ForthonDataContainer sharedStore].commentsDic objectForKey:@"pagesComments"]objectForKey:_workId];
    }
    
    [self loadCellHeight];
    [_myTable reloadData];
}


#pragma mark - 登陆

- (void)LoginPlease
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationUserError" object:nil];
    [self.loginDelegate pushLoginCurtain];
    
}

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
    NSLog(@"refresh");
}


@end
