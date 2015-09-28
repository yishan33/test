//
//  pageWebViewController.m
//  Login
//
//  Created by Liu fushan on 15/5/22.
//  Copyright (c) 2015年 culturalCenter. All rights reserved.
//

#import "pageWebViewController.h"
#import "ForthonDataSpider.h"
#import "ForthonDataContainer.h"
#import "commentCell.h"
#import "commentCellMeasurement.h"
#import "ForthonAllComments.h"
#import "InputTextFieldMeasurement.h"
#import "NSString+regular.h"
#import "UIImageView+WebCache.h"
#import "LoginCurtain.h"
#import "ForthonAuthorDescription.h"
#import "NSString+imageUrlString.h"
#import "SVProgressHUD.h"
#import "AFURLRequestSerialization.h"
#import "UICommon.h"
#import "NetErrorView.h"
#import "NSString+packageNumber.h"


#import <ShareSDK/ShareSDK.h>
#import <QZoneConnection/QZoneConnection.h>

//#define WIDTH self.view.bounds.size.width      //获取屏幕宽度
//#define HEIGHT self.view.bounds.size.height    //获取屏幕长度
//#define WIDTHPERCENTAGE WIDTH / 320.0  //获取横向比例，用屏幕宽度除以 iphone4的宽度
//#define HEIGHTPERCENTAGE HEIGHT / 480.0//获取纵向比例，用屏幕宽度除以 iphone4的高度
//
//#define BACKVIEWWIDTH WIDTH + 2
//#define BACKVIEWHEIGHT 48 * HEIGHTPERCENTAGE
//
//#define L_INTERVAL 20 * WIDTHPERCENTAGE
//#define B_INTERVAL 12 * HEIGHTPERCENTAGE
//
//#define SENDBUTTONSIDE 35 * WIDTHPERCENTAGE
//#define INTERVALRIGHT 20 * WIDTHPERCENTAGE
//
//#define TEXTWIDTH WIDTH - L_INTERVAL - SENDBUTTONSIDE - INTERVALRIGHT
//#define TEXTHEIGHT BACKVIEWHEIGHT - B_INTERVAL
//
//#define LINEINTERVAL 2 * WIDTHPERCENTAGE
//#define LINEHEIGHT 5 * HEIGHTPERCENTAGE
//
//#define LINEWIDTH 2
//
//#define KEYBOARDHEIGHT 250
//
//#define SIDEINTERVAL 15 * WIDTH / 480


@interface pageWebViewController ()

@property BOOL isFavor;
@property BOOL firstLoad;
@property BOOL toButtom;
@property CGFloat height;
@property CGFloat cellTotalHeight;


@property int favorMaxNumber;
@property int favorMinNumber;

@property (strong, nonatomic) NSArray *commentArray;
@property (strong, nonatomic) NSMutableArray *cellHeightArray;
@property (strong, nonatomic) NSString *commentFartherId;

@property (strong, nonatomic) UITextField *commentText;
@property (strong, nonatomic) UILabel *communicationLabel;
@property (strong, nonatomic) UIView *buttomView;
@property (strong, nonatomic) UIScrollView *scroll;
@property (strong, nonatomic) UIWebView *pageWeb;
@property (strong, nonatomic) UITableView *commentTable;

@property (strong, nonatomic) NetErrorView *netErrorView;

@property (nonatomic, strong) UILabel *skimNumberLabel;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UIImageView *collectImageView;
@property (nonatomic, strong) UIButton *collectButton;
@property (nonatomic, strong) UILabel *collectNumberLabel;


@end

@implementation pageWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.backBarButtonItem = HiddenBack;

    UICommon *commonUI = [[UICommon alloc] init];
    UILabel *navTitle = (UILabel *) [commonUI navTitle:@"文章"];
    self.navigationItem.titleView = navTitle;


    _delegate = [ForthonDataSpider sharedStore];
    _loginDelegate = self;
    _numberDelegate = [ForthonDataSpider sharedStore];

    _pageWebHTMLData = _pageDic[@"content"];
    _workId = _pageDic[@"id"];
    _titleStr = _pageDic[@"title"];
    _commentNumber = [_pageDic[@"commentCnt"] intValue];

    if (self.tabBarController.tabBar.hidden == NO) {
         self.tabBarController.tabBar.hidden = YES;  //开始搜索，隐藏tabbar
        NSLog(@"隐藏");
    }

    [_numberDelegate getPageInfoById:_workId];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNumber:) name:@"NotificationCommentNumber" object:nil];
    
   
    if (![[ForthonDataContainer sharedStore].commentsDic[@"pagesComments"] objectForKey:_workId]) {
        [SVProgressHUD showWithStatus:@"加载中..."];
        _firstLoad = YES;
        [_delegate getCommentByTypeid:3 targetId:_workId page:1];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(viewDisplay)
                                                     name:@"NotificationA"
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netError) name:@"NotificationNetError" object:nil];

    } else {
        
        [self viewDisplay];
    }

    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewWillDisappear:(BOOL)animated {

    if ([SVProgressHUD isVisible]) {

        [SVProgressHUD dismiss];
    }
}

- (void)addNumber:(NSNotification *)notification {

    _commentNumber = [notification.userInfo[@"commentCnt"] intValue];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationCommentNumber" object:nil];
}

- (void)netError {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationNetError" object:nil];

    [SVProgressHUD showErrorWithStatus:@"加载失败" maskType:SVProgressHUDMaskTypeBlack];
    if (!_netErrorView) {

        _netErrorView = [[NetErrorView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, self.view.frame.size.height - 64)];
        [_netErrorView.loadButton addTarget:self action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];

    }
    _buttomView.hidden = YES;
    [self.view addSubview:_netErrorView];

}

- (void)reload {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationNetError" object:nil];

    [SVProgressHUD showWithStatus:@"加载中..."];

    [_delegate getCommentByTypeid:3 targetId:_workId page:1];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(viewDisplay)
                                                 name:@"NotificationA"
                                               object:nil];


    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(netError)
                                                 name:@"NotificationNetError"
                                               object:nil];


}



- (void)viewDisplay
{

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"NotificationA"
                                                  object:nil];
    self.shareDelegate = [ForthonDataSpider sharedStore];
    _commentArray = [[ForthonDataContainer sharedStore].commentsDic[@"pagesComments"] objectForKey:_workId];
    [self loadCellHeight];
    NSLog(@"begin viewDisplay");
    _pageWeb = [[UIWebView alloc] initWithFrame:CGRectMake(-3, 64, WIDTH, self.view.frame.size.height - 64)];
    [_pageWeb setDelegate:self];
    [_pageWeb.scrollView setDelegate:self];
    
    NSMutableString *HTMLData = [NSMutableString stringWithString:_pageWebHTMLData];
    
    NSRange rangeWidth = [HTMLData rangeOfString:@"width="];
    NSRange rangeHeight = [HTMLData rangeOfString:@"px;\"/"];
    
    int widthLocation = (int)rangeWidth.location;
    int heightLocation = (int)rangeHeight.location;
    int length = (int)(heightLocation - widthLocation + rangeHeight.length);

    if (length) {
        
        [HTMLData deleteCharactersInRange:rangeWidth];
    }

    [_pageWeb loadHTMLString:HTMLData baseURL:[NSURL URLWithString:@"http://120.26.222.176:8080"]];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
    [tap setDelegate:self];
    [_pageWeb.scrollView addGestureRecognizer:tap];
        _pageWeb.userInteractionEnabled = YES;
    
    _pageWeb.scrollView.bounces = NO;

    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 1)];
    [topLine setBackgroundColor:[UIColor grayColor]];
    
    _buttomView = [[UIView alloc] initWithFrame:CGRectMake(-1, self.view.frame.size.height + 1, BACKVIEWWIDTH, BACKVIEWHEIGHT)];
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


    [self.view addSubview:_pageWeb];
    [self.view addSubview:_buttomView];

}


- (void)loadCellHeight
{
    if ([_commentArray count])
        {
        
        _cellHeightArray = [[NSMutableArray alloc] init];
        NSString *text;
        for (int i = 0; i < 3; i++) {
            if ([_commentArray count] > i) {
                text = [_commentArray[i] objectForKey:@"content"];
               
            } else {
                 text = @"";
            }
            //                    NSString *text = ;
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0], NSParagraphStyleAttributeName:paragraphStyle.copy};
            
            CGSize size = CGSizeMake(250 * WIDTHPERCENTAGE, 1000);
            _cellTotalHeight += [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height;
            _cellTotalHeight += HEIGHTNOCONTENT;
            NSNumber *cellHeightNumber = [NSNumber numberWithFloat:[text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height + HEIGHTNOCONTENT];

            [_cellHeightArray addObject:cellHeightNumber];
        }
    }
}


#pragma mark - 移动输入框


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //开始输入时，小视图上移80，加了动画效果，时常0.3 s
    if (self.view.center.y == self.view.frame.size.height / 2) {
    
        [UIView animateWithDuration:0.3 animations:^{
            
            [self.view setCenter:CGPointMake(self.view.center.x, self.view.center.y - KEYBOARDHEIGHT)];
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
        
        [self.view setCenter:CGPointMake(self.view.center.x, self.view.frame.size.height / 2 - KEYBOARDHEIGHT + moveHeight)];
        [_buttomView setCenter:CGPointMake(_buttomView.center.x, self.view.frame.size.height - (BACKVIEWHEIGHT / 2) - moveHeight)];
        
    }];

}



- (void)endInput
{
    //触碰视图，则输入结束，小视图回到原位
    NSLog(@"tap view");
    if (self.view.center.y < HEIGHT / 2) {
        [UIView animateWithDuration:0.3 animations:^{
            
            [self.view setCenter:CGPointMake(self.view.center.x, self.view.frame.size.height / 2)];
            [_buttomView setCenter:CGPointMake(_buttomView.center.x, self.view.frame.size.height - BACKVIEWHEIGHT / 2)];
        }];
        [_commentText resignFirstResponder];
    }
       [_commentText setPlaceholder:@"我想说两句"];
    
}


#pragma mark - 收发评论

- (void)sendComment
{
    NSLog(@"send !");
    NSString *commentString = _commentText.text;

    [_commentText setText:@""];
    NSLog(@"fatherID is--------------------------\n%@\n", _commentFartherId);
    [_delegate sendCommentsByTypeid:3 targetId:_workId fatherId:_commentFartherId content:commentString];
    //spider中添加发送评论的接口，参数为 作品种类 、Id  和  commentString
    //让spider 把 commentString 发出去
    //添加通知，当服务器添加评论成功，立马刷新出新的评论。
    _commentFartherId = 0;
    
    if ([[[ForthonDataContainer sharedStore] valueForKey:@"appIsLogin"] boolValue]) {
        
        if ([[[ForthonDataContainer sharedStore] valueForKey:@"appIsLogin"] boolValue]) {
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(addComment)
                                                         name:@"NotificationA"
                                                       object:nil];
        }

    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(LoginPlease) name:@"NotificationUserError"
                                               object:nil];
    
    [self endInput];
    
    
    
}



- (void)addComment
{
    NSLog(@"i receive new comment");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationA" object:nil];
    
    _commentArray = [[[ForthonDataContainer sharedStore].commentsDic objectForKey:@"pagesComments"]objectForKey:_workId];
    _commentNumber++;
    [_communicationLabel setText:[NSString stringWithFormat:@"一起交流(%i)", _commentNumber]];
    _commentLabel.text = [NSString stringWithFormat:@"%i", _commentNumber];
    _pageDic[@"commentCnt"] = @(_commentNumber);
    NSLog(@"count: %i", (int)[_commentArray count]);
    [self loadCellHeight];
    
    
    [_commentTable reloadData];
}


#pragma mark - 手势判别

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
//    NSLog(@"识别手势！");
    NSLog(@"view: %@", [touch.view class]);
    if ([[NSString stringWithFormat:@"%@",[touch.view class]] isEqualToString:@"UIWebBrowserView"]) {
        NSLog(@"放下textField");
        [self endInput];
     
        [_commentTable deselectRowAtIndexPath:[_commentTable indexPathForSelectedRow] animated:YES];
        return YES;
    } else {
        NSLog(@"回复");
        return NO;
    }
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 评论TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = indexPath.row;
    if ([_cellHeightArray count])
    {
        NSLog(@"cell in web : %f", [_cellHeightArray[index] floatValue]);
        return [_cellHeightArray[index] floatValue];
    } else return 76;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_commentArray count] < 3) {
        
        return [_commentArray count];
    } else {
        
        return 3;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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


    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = (int)indexPath.row;
 
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *fName = [[NSString alloc] init];
    NSDictionary *dic = _commentArray[index];
    _commentFartherId = dic[@"id"];

    if ([dic[@"userNickName"] length]) {

        fName = dic[@"userNickName"];
    } else {

        fName = dic[@"userName"];
    }

    
    [_commentText setPlaceholder:[NSString stringWithFormat:@"回复%@", fName]];
    CGFloat cutNumber = 0;
    for (int i = 2 ; i > index; i--)
    {
        cutNumber += [_cellHeightArray[i] floatValue];
    }
    [self commentReplyWithHeight:cutNumber];
    [_commentText becomeFirstResponder];

    
    
}

#pragma mark - 滚动方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView1
{
    CGPoint offset = scrollView1.contentOffset;
    CGRect bounds = scrollView1.bounds;
    CGSize size = scrollView1.contentSize;
    UIEdgeInsets inset = scrollView1.contentInset;
    
    CGFloat currentOffset = offset.y + bounds.size.height - inset.bottom;
    
    CGFloat maximumOffset = size.height;
    
    NSLog(@"maximumoffset: %f \n currentoffset: %f", maximumOffset, currentOffset);
    
    NSLog(@"scrollview 1 class is : %@",[scrollView1 class]);
    
    NSLog(@"scrollbegin");
    
    if (_buttomView.center.y != self.view.frame.size.height - _buttomView.frame.size.height / 2) {
        NSLog(@"下移");
        [self endInput];
    }
    
    
    //当currentOffset与maximumOffset的值相等时，说明scrollview已经滑到底部了。也可以根据这两个值的差来让他做点其他的什么事情
    
    if ((maximumOffset - currentOffset) > (200 + BACKVIEWHEIGHT)) {

        [UIView animateWithDuration:0.3 animations:^{
            
            CGPoint center = _buttomView.center;
            center.y -= BACKVIEWHEIGHT;
            [_buttomView setFrame:CGRectMake(-1, self.view.frame.size.height + 1, BACKVIEWWIDTH, BACKVIEWHEIGHT)];

            NSLog(@"buttomview move!!");
        }];
    }
    
    if((maximumOffset - currentOffset) < (200 + BACKVIEWHEIGHT))
        {
        if (_communicationLabel) {
            NSLog(@"-----我要刷新数据-----");
            [UIView animateWithDuration:0.3 animations:^{
                
                CGPoint center = _buttomView.center;
                center.y -= BACKVIEWHEIGHT;
                [_buttomView setFrame:CGRectMake(-1, self.view.frame.size.height - BACKVIEWHEIGHT + 1, BACKVIEWWIDTH, BACKVIEWHEIGHT)];
            }];

        }
    }
}

#pragma mark - webView视图优化

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *meta = [NSString stringWithFormat:@"document.getElementsByTagName('video')[0].width = \"%f\"", WIDTH];
    [webView stringByEvaluatingJavaScriptFromString:meta];


    NSString *calibrateStr = [NSString stringWithFormat:
                              @"var script = document.createElement('script');"
                              "script.type = 'text/javascript';"
                              "script.text = \"function ResizeImages() { "
                              "var myimg,oldwidth;"
                              "var maxwidth = %f;" // UIWebView中显示的图片宽度
                              "for(i=0;i <document.images.length;i++){"
                              "myimg = document.images[i];"
                              "if(myimg.width > maxwidth){"
                              "oldwidth = myimg.width;"
                              "myimg.width = maxwidth;"
                              "}"
                              "}"
                              "}\";"
                              "document.getElementsByTagName('head')[0].appendChild(script);", WIDTH - 3];

    [webView stringByEvaluatingJavaScriptFromString:calibrateStr];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];

    
    _height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue] + 30;
    NSLog(@"优化!!!");

    UIView *whiteBack = [[UIView alloc] initWithFrame:CGRectMake(0, _height - 15, WIDTH, 40)];
    whiteBack.backgroundColor = [UIColor whiteColor];
    [_pageWeb.scrollView addSubview:whiteBack];


    UIView *numberBack = [[UIView alloc] initWithFrame:CGRectMake(0, _height - 45, WIDTH, 25)];
//    numberBack.backgroundColor = [UIColor grayColor];
    [_pageWeb.scrollView addSubview:numberBack];


    NSArray *titleArray = @[@"  阅读", @"    评论", @"    收藏"];
    NSArray *imageArray = @[@"skimm", @"comment", @"collect"];
    self.favorDelegate = [ForthonDataSpider sharedStore];
    for (int i = 0; i < 3; i++) {

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (22 * HEIGHTPERCENTAGE - 10) / 2, 10, 10)];
        imageView.image = [UIImage imageNamed:imageArray[i]];

        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20 * WIDTHPERCENTAGE + i * ((WIDTH - (2* 20 * WIDTHPERCENTAGE) - 165) / 2 + 55), 0, 55, 22 * HEIGHTPERCENTAGE)];
        button.titleLabel.font = [UIFont systemFontOfSize:11.0];
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [button setTitleColor:AppColor forState:UIControlStateNormal];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];

        UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 30, 22 * HEIGHTPERCENTAGE)];
        numberLabel.font = [UIFont systemFontOfSize:12.0];
        numberLabel.textColor = [UIColor grayColor];

        if (i == 0) {

            numberLabel.text = [_pageDic[@"click"] stringValue];
            numberLabel.frame = CGRectMake(35, 0, 30, 22 * HEIGHTPERCENTAGE);
//            [button addTarget:self action:@selector(addSkimNumber) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            _skimNumberLabel = numberLabel;
        } else if (i == 1) {
            
            numberLabel.text = [_pageDic[@"commentCnt"] stringValue];
            [button addTarget:self action:@selector(addCommentNumber) forControlEvents:UIControlEventTouchUpInside];
            _commentLabel = numberLabel;
        } else {
            
            numberLabel.text = [_pageDic[@"favorCnt"] stringValue];
            [button addTarget:self action:@selector(setAndCancelFavor) forControlEvents:UIControlEventTouchUpInside];
            _collectButton = button;
            _collectImageView = imageView;
            _collectNumberLabel = numberLabel;
        }

        [button addSubview:imageView];
        [button addSubview:numberLabel];

        [numberBack addSubview:button];
    }

    [self getFavorStatus];

    _communicationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * WIDTHPERCENTAGE, _height - 15, 150 * WIDTHPERCENTAGE, 40)];
    [_communicationLabel setText:[NSString stringWithFormat:@"一起交流(%i)", _commentNumber]];
    [_communicationLabel setTextColor:[UIColor blackColor]];
    //    [communicationLabel setBackgroundColor:[UIColor purpleColor]];
    
    UIButton *moreComments = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 100 * WIDTHPERCENTAGE, _height - 15, 90 * WIDTHPERCENTAGE, 40)];
    [moreComments setTitle:@"查看全部" forState:UIControlStateNormal];
    [moreComments setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [moreComments setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [moreComments.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [moreComments addTarget:self action:@selector(checkMoreComments) forControlEvents:UIControlEventTouchUpInside];



    _commentTable = [[UITableView alloc] initWithFrame:CGRectMake(0, _height + 25, WIDTH, _cellTotalHeight)];
    [_commentTable setDataSource:self];
    [_commentTable setDelegate:self];

    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, _height + 25 + _cellTotalHeight, WIDTH, BACKVIEWHEIGHT)];
    [whiteView setBackgroundColor:[UIColor whiteColor]];
    NSLog(@"cellTotal :%f", _cellTotalHeight);


    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0,- 95 * HEIGHTPERCENTAGE, WIDTH, 95 * HEIGHTPERCENTAGE)]; //lfs
    UILabel *timeLabel = [UILabel new];
    timeLabel.text = _pageDic[@"createTime"];
    timeLabel.font = [UIFont systemFontOfSize:12.0];

    UIButton *authorButton = [UIButton new];
    NSString *name;
    if ([_pageDic[@"userNickName"] length]) {

        name = _pageDic[@"userNickName"];
    } else {

        name = _pageDic[@"userName"];
    }
    [authorButton setTitle:name forState:UIControlStateNormal];
    [authorButton setTitleColor:AppColor forState:UIControlStateNormal];
    [authorButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [authorButton.titleLabel setFont:[UIFont systemFontOfSize:18.0]];


    UILabel *titleLabel = [UILabel new];
    [titleLabel setText:_pageDic[@"title"]];
    [titleLabel setTextColor:[UIColor blackColor]];
    [titleLabel setFont:[UIFont systemFontOfSize:18.0]];
    [titleLabel setNumberOfLines:2];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];

    timeLabel.frame = CGRectMake(10 * WIDTHPERCENTAGE, 5 * HEIGHTPERCENTAGE, WIDTH - 20 * WIDTHPERCENTAGE, 20 * HEIGHTPERCENTAGE);
    [authorButton setFrame:CGRectMake(10 * WIDTHPERCENTAGE, 25 * HEIGHTPERCENTAGE, WIDTH - 20 * WIDTHPERCENTAGE, 20 * HEIGHTPERCENTAGE)];
    [titleLabel setFrame:CGRectMake(10 * WIDTHPERCENTAGE, 45 * HEIGHTPERCENTAGE, WIDTH - 20 * WIDTHPERCENTAGE, 50 * HEIGHTPERCENTAGE)];

    [topView addSubview:timeLabel];
    [topView addSubview:authorButton];
    [topView addSubview:titleLabel];
    [topView setBackgroundColor:[UIColor whiteColor]];
    self.authorDelegate = self;
    [authorButton addTarget:self action:@selector(readyToPushAuthor) forControlEvents:UIControlEventTouchUpInside];

    _pageWeb.scrollView.contentInset = UIEdgeInsetsMake( 95 * HEIGHTPERCENTAGE, 0, _cellTotalHeight + BACKVIEWHEIGHT, 0);
    CGSize originScrollContent = _pageWeb.scrollView.contentSize;
    originScrollContent.width = WIDTH;
    originScrollContent.height += 30;
    _pageWeb.scrollView.contentSize = originScrollContent;
    [_pageWeb.scrollView addSubview:topView];
    [_pageWeb.scrollView addSubview:_communicationLabel];
    [_pageWeb.scrollView addSubview:moreComments];



    [_pageWeb.scrollView addSubview:whiteView];
    [_pageWeb.scrollView addSubview:_commentTable];

    UIView *blackLine = [[UIView alloc] initWithFrame:CGRectMake(0, _height + 24, WIDTH, 1)];
    blackLine.backgroundColor = [UIColor grayColor];
    [_pageWeb.scrollView addSubview:blackLine];

    [_pageWeb.scrollView setContentOffset:CGPointMake(0, -95 * HEIGHTPERCENTAGE)];

    if (_firstLoad) {

        [SVProgressHUD showSuccessWithStatus:@"加载成功" maskType:SVProgressHUDMaskTypeBlack];
    }

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:self action:@selector(sharePage:)];

    [self.numberDelegate addSkimNumber:_workId WithCategoryIndex:nil tinyTag:_tinyTag typeId:3];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addSkimNumber:) name:@"NotificationSkim" object:nil];
}


- (void)addSkimNumber:(NSNotification *)notification {

    _skimNumberLabel.text = notification.userInfo[@"clickNumber"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationSkim" object:nil];
}


- (void)addCommentNumber {

    NSLog(@"评论");
}

- (void)addCollectNumber {

    NSLog(@"收藏");
}

#pragma mark 获取收藏状态

- (void)getFavorStatus
{
    NSString *typeid = [NSString stringWithFormat:@"%i", 3];
    [self.favorDelegate getFaovrStatusByTypeid:typeid TargetId:_workId];

    NSLog(@"获取收藏状态");

    NSString *notificationName = [NSString stringWithFormat:@"NotificationId%@Favor",  _workId];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeFavorStatus:)
                                                 name:notificationName
                                               object:nil];
}

#pragma mark 收藏回调

- (void)changeFavorStatus:(NSNotification *)notification
{
    NSLog(@"dic: %@", notification.userInfo);
    NSString *notificationName = [NSString stringWithFormat:@"NotificationId%@Favor", _workId];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:notificationName
                                                  object:nil];
    if ([notification.userInfo[@"result"] boolValue]) {
        [self buttonDoFavor];
    } else {
        [self buttonCancelFavor];
    }

}


#pragma mark 添加/取消 收藏

- (void)setAndCancelFavor
{
    if (!_isFavor) {

        [self.favorDelegate setFavorWithTypeid:3 TargetId:_workId];

    }

    if (_isFavor) {
        [self.favorDelegate cancelFavorWithTypeid:3 TargetId:_workId];

    }
    NSString *notificationName = [NSString stringWithFormat:@"NotificationId%@Favor",  _workId];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeFavorStatus:)
                                                 name:notificationName
                                               object:nil];


    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(LoginPlease) name:@"NotificationUserError"
                                               object:nil];


}

#pragma mark 设置收藏、取消收藏

- (void)buttonDoFavor
{
    NSLog(@"收藏");
    [_collectButton setTitle:@"    已收藏" forState:UIControlStateNormal];
    [_collectImageView setImage:[UIImage imageNamed:@"collected.png"]];

    NSString *collectNumberStr = _collectNumberLabel.text;

    if (!_favorMaxNumber) {

        _favorMaxNumber = [collectNumberStr intValue];
        _favorMinNumber = [collectNumberStr intValue] - 1;
    }



    [_collectNumberLabel setText:[[NSString stringWithFormat:@"%i", _favorMaxNumber] numberToString]];
    [_collectNumberLabel setFrame:CGRectMake(50, 0, 30, 22 * HEIGHTPERCENTAGE)];

    _isFavor = YES;
}

- (void)buttonCancelFavor
{
    NSLog(@"取消收藏");
    [_collectButton setTitle:@"    收藏" forState:UIControlStateNormal];
    [_collectImageView setImage:[UIImage imageNamed:@"collect"]];

    NSString *collectNumberStr = _collectNumberLabel.text;

    if (!_favorMaxNumber) {
        _favorMaxNumber = [collectNumberStr intValue] + 1;
        _favorMinNumber = [collectNumberStr intValue];

    }

    [_collectNumberLabel setText:[[NSString stringWithFormat:@"%i", _favorMinNumber] numberToString]];
    [_collectNumberLabel setFrame:CGRectMake(40, 0, 30, 22 * HEIGHTPERCENTAGE)];

    _isFavor = NO;
}



#pragma mark 分享文章

- (void)sharePage:(UIBarButtonItem *)sender
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(justShare:)
                                                 name:@"NotificationUrl"
                                               object:nil];

    
    [self.shareDelegate getShareUrlWithTypeid:3 TargetId:_workId];
    NSLog(@"开始分享");
    
}

- (void)justShare:(NSNotification *)notification {
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationUrl" object:nil];
    NSString *url = [notification.userInfo objectForKey:@"shareUrl"];
    
    NSLog(@"begin to share%@", url);
    
    NSString *responseString = _pageWebHTMLData;
    
    NSString *imageRegular = @"/up\\S+png";
    NSString *imageUrlStringBody;
    
    
    NSString *regstr1 = @"\\d*[\u4e00-\u9fa5]+[^<]+";
    NSArray *responseTextArray = [responseString substringArrayByRegular:regstr1];
    NSMutableString *resultString = [[NSMutableString alloc] init];
    
    for (int j = 0; j < [responseTextArray count]; j++) {
        
        [resultString appendString:responseTextArray[j]];
    }

    resultString = [resultString substringToIndex:50];

    if ([[responseString substringArrayByRegular:imageRegular] count]) {
        imageUrlStringBody = [responseString substringArrayByRegular:imageRegular][0];
    } else {
        imageUrlStringBody = @"";
    }
    NSString *imageUrlString = [imageUrlStringBody changeToUrl];
    //    NSData *shareImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrlString]];

    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"qqTest"
                                       defaultContent:@"测试一下"
                                                image:[ShareSDK imageWithUrl:imageUrlString]
                                                title:_titleStr
                                                  url:url
                                          description:resultString
                                            mediaType:SSPublishContentMediaTypeNews];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    //    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                    {
                                         NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));

                                    }
                                else if (state == SSResponseStateFail)
                                    {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                    }
                            }];

}

#pragma mark -MoreComments

- (void)checkMoreComments {
    
    NSLog(@"checkMore");
    ForthonAllComments *commentsView = [[ForthonAllComments alloc] init];
    commentsView.workId = self.workId;
    commentsView.typeId = 3;
    [self.navigationController pushViewController:commentsView animated:YES];
    
}

#pragma mark - 弹出登录界面
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
   [self getFavorStatus];
}


- (void)readyToPushAuthor {

    NSMutableDictionary *dic = _pageDic;
    [self pushAuthorDescriptionWitDic:dic];
}


- (void)pushAuthorDescriptionWitDic:(NSMutableDictionary *)dic {

    ForthonAuthorDescription *authorDescription = [ForthonAuthorDescription new];
    authorDescription.authorDic = dic;

    [self.navigationController pushViewController:authorDescription animated:YES];
}





@end
