//
//  ForthonVastArtDescriptionView.m
//  Login
//
//  Created by Liu fushan on 15/5/23.
//  Copyright (c) 2015年 culturalCenter. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "ForthonVastArtDescriptionView.h"
#import "ForthonVideoCell.h"
#import "ForthonDataSpider.h"
#import "UIImageView+WebCache.h"
#import "YHOrderMessageVC.h"
#import "LoginCurtain.h"
#import "commentCell.h"
#import "ForthonInputTextField.h"
#import "commentCell.h"
#import "ForthonAllComments.h"
#import "NSString+imageUrlString.h"
#import "ForthonAuthorDescription.h"
#import "SVProgressHUD.h"
#import "NetErrorView.h"
#import "UICommon.h"

#define WIDTH self.view.frame.size.width
#define HEIGHT self.view.frame.size.height


#define WIDTHPERCENTAGE WIDTH / 320
#define HEIGHTPERCENTAGE HEIGHT / 480

#define SIDEINSET 10 * WIDTHPERCENTAGE

#define TOPINTERVAL 65 * HEIGHTPERCENTAGE
#define MIDDLEINTERVAL 5 * HEIGHTPERCENTAGE

#define LABELWIDTH 200 * WIDTHPERCENTAGE
#define LABELHEIGHT 18 * HEIGHTPERCENTAGE

#define VIDEOCELLHEIGHT (22 * HEIGHTPERCENTAGE + 70 * WIDTHPERCENTAGE + WIDTH / 2)

#define BUTTOMBACKVIEWWIDTH WIDTH + 2
#define BUTTOMBACKVIEWHEIGHT 48 * HEIGHTPERCENTAGE

#define KEYBOARDHEIGHT 250

#define OriginRect CGRectMake(0, 64 + 50 * WIDTHPERCENTAGE, WIDTH, WIDTH / 2)

@interface ForthonVastArtDescriptionView ()<UITextFieldDelegate, UIScrollViewDelegate>


@property BOOL isFirst;
@property BOOL isTrade;
@property BOOL canOrder;

@property CGFloat cellTotalHeight;
@property CGFloat tableTopInterval;
@property int commentNumber;

@property (nonatomic, strong) NSString *commentState;

@property (nonatomic, strong) NSString *orderMessageStr;
@property (nonatomic, strong) NSString *commentFartherId;
@property (nonatomic, strong) NSString *artImageUrl;

@property (nonatomic, strong) NSMutableArray *cellHeightArray;
@property (nonatomic, strong) NSArray *commentArray;


@property (nonatomic, strong) ForthonVideoCell *cell;
@property (nonatomic, strong) UILabel *communicationLabel;
@property (nonatomic, strong) UITableView *commentTable;
@property (nonatomic, strong) UIScrollView  *scroll;
@property (nonatomic, strong) ForthonInputTextField *myTextField;


@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) UIView *panelView;
@property (nonatomic, strong) UIScrollView *myScroll;
@property (nonatomic, strong) NSArray *imageViewArray;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSMutableArray *scrollViewArray;
@property (nonatomic, strong) UILabel *pageIndexLabel;


@property (nonatomic, strong) UIButton *loadButton;
@property (nonatomic, strong) UIImageView *loadImage;

@property (nonatomic, strong) NetErrorView *netErrorView;

@end

@implementation ForthonVastArtDescriptionView

- (UILabel *)descriptionLabel
{
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] init];
    }
    return _descriptionLabel;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    UICommon *commonUI = [[UICommon alloc] init];
    NSString *videoTitle = _modelDic[@"title"];
    UILabel *navTitle = (UILabel *) [commonUI navTitle:videoTitle];
    self.navigationItem.titleView = navTitle;
    self.navigationItem.backBarButtonItem = HiddenBack;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if([_modelDic[@"tradeState"] boolValue]) {

        _isTrade = YES;
    }

    [SVProgressHUD showWithStatus:@"加载中..."];
    _isFirst = YES;
    self.commentDelegate = [ForthonDataSpider sharedStore];
    _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64 - 48 * HEIGHTPERCENTAGE)];
    _scroll.delegate = self;

    NSMutableDictionary *descriptionDic = _modelDic;
    NSLog(@"description: %@", descriptionDic);
    _workId = [descriptionDic objectForKey:@"id"];
    _name = [descriptionDic objectForKey:@"userNickName"];
    _descriptionText = [descriptionDic objectForKey:@"content"];
    
    NSString *pictureImageStringBody = [descriptionDic objectForKey:@"titleImg"];
    if ([pictureImageStringBody length]) {
        
        descriptionDic[@"picUrl"] = pictureImageStringBody;
        _artImageUrl = [descriptionDic[@"picUrl"] changeToUrl];
    }

    _cell = [[ForthonVideoCell alloc] init];
    [_cell setFrame:CGRectMake(0, 0, WIDTH, VIDEOCELLHEIGHT)];

    [_cell loadView];
    [_cell embarkWithDictionary:descriptionDic];
    _cell.typeId = 2;
    _cell.loginDelegate = self;
    _cell.pushDelegate = self;
    _cell.headImageView.userInteractionEnabled = YES;
    [_cell getFavorStatus];
    [_cell getFollowStatus];
    _cell.videoImage.userInteractionEnabled = YES;
    _cell.headImageView.userInteractionEnabled = YES;
    [_scroll addSubview:_cell];

    UILabel *categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIDEINSET, VIDEOCELLHEIGHT + MIDDLEINTERVAL + 10 * HEIGHTPERCENTAGE, LABELWIDTH, LABELHEIGHT)];
    [categoryLabel setText:descriptionDic[@"tradeDes"]];
    _orderMessageStr = descriptionDic[@"tradeDes"];
    [categoryLabel setFont:[UIFont systemFontOfSize:14.0]];


    _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(5 * WIDTHPERCENTAGE, VIDEOCELLHEIGHT + MIDDLEINTERVAL + 3 * LABELHEIGHT + 5 * HEIGHTPERCENTAGE, WIDTH - 10 * WIDTHPERCENTAGE, VIDEOCELLHEIGHT)];

    [_descriptionLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_descriptionLabel setNumberOfLines:10];
    

    _commentTable = [[UITableView alloc] init];


    [_scroll addSubview:_descriptionLabel];
    [_scroll addSubview:categoryLabel];
//    [_scroll addSubview:measurementLabel];
    [_scroll addSubview:_commentTable];

    _myTextField  = [[ForthonInputTextField alloc] init];
    [_myTextField loadView];
    [_myTextField setFrame:CGRectMake(0, HEIGHT - 48 * HEIGHTPERCENTAGE, WIDTH, 48 * HEIGHTPERCENTAGE)];
    [_myTextField.commentText setDelegate:self];
    [_myTextField.sendButton addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];


    [self.view addSubview:_scroll];
    [self.view addSubview:_myTextField];
    
    self.delegate = [ForthonDataSpider sharedStore];
    self.loginDelegate = self;
    self.numberDelegate = [ForthonDataSpider sharedStore];
    [self.numberDelegate addSkimNumber:_modelDic[@"id"] WithCategoryIndex:nil tinyTag:nil typeId:2];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addSkimNumber:) name:@"NotificationSkim" object:nil];
    if (![ForthonDataContainer sharedStore].artDescriptionDic[_workId]) {
        
        [self.delegate getArtDescriptionById:_workId];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateArtContent) name:@"NotificationArtContent"
                                                   object:nil];
    } else {

        [self updateArtContent];
    }
    
    if (![[ForthonDataContainer sharedStore].commentsDic[@"artsComments"] objectForKey:_workId]) {

        NSLog(@"开始获取评论");
        [self.commentDelegate getCommentByTypeid:2 targetId:_workId page:1];    //获取评论信息
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateComment)
                                                     name:@"NotificationA"
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(showLoadButton)
                                                     name:@"NotificationNetError"
                                                   object:nil];
    } else {

        [self updateComment];
    }



    [self.delegate getWorkTradeState:_workId];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateState:) name:@"NotificationTradeState" object:nil];



    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewWillDisappear:(BOOL)animated {

    [SVProgressHUD dismiss];
}
- (void)showLoadButton {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationNetError" object:nil];
    [SVProgressHUD showErrorWithStatus:@"加载失败" maskType:SVProgressHUDMaskTypeBlack]; if (!_netErrorView) {

        _netErrorView = [[NetErrorView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, self.view.frame.size.height - 64)];
        [_netErrorView.loadButton addTarget:self action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];

    }
    _myTextField.hidden = YES;
    [self.view addSubview:_netErrorView];
}

- (void)reload {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationNetError" object:nil];

    [SVProgressHUD showWithStatus:@"加载中..."];

    [self.delegate getArtDescriptionById:_workId];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateArtContent) name:@"NotificationArtContent"
                                               object:nil];

    [self.commentDelegate getCommentByTypeid:2 targetId:_workId page:1];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateComment)
                                                 name:@"NotificationA"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showLoadButton)
                                                 name:@"NotificationNetError"
                                               object:nil];


}

- (void)addSkimNumber:(NSNotification *)notification {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationSkim" object:nil];
    _cell.skimNumberLabel.text = notification.userInfo[@"clickNumber"];
}

- (void)viewDidAppear:(BOOL)animated {


    if (_isFirst) {

        _isFirst = NO;
//        [_commentTable reloadData];
    }

}

- (void)updateState:(NSNotification *)notification {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationTradeState" object:nil];
    int stateCode = [notification.userInfo[@"tradeState"] intValue];
    UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIDEINSET, VIDEOCELLHEIGHT + MIDDLEINTERVAL + 2 * LABELHEIGHT, 100 * WIDTHPERCENTAGE, LABELHEIGHT)];
    NSString *stateStr = [[NSString alloc] init];
    if (_isTrade) {

        NSLog(@"这个作品是可以交易滴!!");

        if (stateCode == 1) {
            stateStr = @"待售(待租)";
        } else if (stateCode == 2){
            stateStr = @"交易中";
        } else if (stateCode == 3) {
            stateStr = @"已售(已租)";
        }

        UIButton *orderButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - SIDEINSET - 70 * WIDTHPERCENTAGE, VIDEOCELLHEIGHT + MIDDLEINTERVAL + 3 * LABELHEIGHT - 20 * HEIGHTPERCENTAGE, 70 * WIDTHPERCENTAGE, 20 * HEIGHTPERCENTAGE)];
        [orderButton setTitle:@"订购/租赁" forState:UIControlStateNormal];
        [orderButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [orderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [orderButton.layer setBorderColor:AppColor.CGColor];
        [orderButton.layer setBorderWidth:1.0];
        [orderButton addTarget:self action:@selector(readyToPushOrder) forControlEvents:UIControlEventTouchUpInside];
        [_scroll addSubview:orderButton];

        if (stateCode > 1) {

            orderButton.hidden = YES;
        }

    } else {

        stateStr = @"非卖";
    }
    [stateLabel setText:stateStr];
    [stateLabel setFont:[UIFont systemFontOfSize:14.0]];
    [stateLabel setTextColor:AppColor];
    [_scroll addSubview:stateLabel];

}

#pragma mark - TableView

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = (int)indexPath.row;
    if ([_cellHeightArray count])
        {
        NSLog(@"cell in web : %f", [_cellHeightArray[index] floatValue]);
        return [_cellHeightArray[index] floatValue];
        } else
            return 76;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{


    int index = (int)indexPath.row;
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

    
    [_myTextField.commentText setPlaceholder:[NSString stringWithFormat:@"回复%@", fName]];
    [_myTextField.commentText becomeFirstResponder];
    
    
    
}


#pragma mark - 加载艺术简介

- (void)updateArtContent {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationArtContent" object:nil];
    [SVProgressHUD showSuccessWithStatus:@"加载成功" maskType:SVProgressHUDMaskTypeBlack];
    NSDictionary *descriptionDic = [ForthonDataContainer sharedStore].artDescriptionDic[_workId];
    _imageViewArray = descriptionDic[@"imgList"];
    _cell.commentNumberLabel.text = [NSString stringWithFormat:@"%@", descriptionDic[@"commentCnt"]];
    _cell.skimNumberLabel.text = [NSString stringWithFormat:@"%@", descriptionDic[@"click"]];
    if (![_artImageUrl length]) {
        
        NSLog(@"没有画面");
        if ([descriptionDic[@"imgList"] count]) {

            if ([descriptionDic[@"imgList"][0] objectForKey:@"url"]) {

                _artImageUrl = [[[descriptionDic objectForKey:@"imgList"][0] objectForKey:@"url"] changeToUrl];
                 NSLog(@"url: %@", _artImageUrl);
                [_cell.videoImage sd_setImageWithURL:[NSURL URLWithString:_artImageUrl]];
            }

        } else {

            [_cell.videoImage setBackgroundColor:GrayColor];
        }


    }
   
    NSString *contentText = [descriptionDic objectForKey:@"content"];
    _cell.shareStr = descriptionDic[@"content"];
    [_descriptionLabel setText:contentText];
    
    CGSize size = [self labelAutoCalculateRectWith:contentText FontSize:14.0 MaxSize:CGSizeMake(WIDTH -  SIDEINSET, 1000)];
    [_descriptionLabel setFrame:CGRectMake(5 * WIDTHPERCENTAGE, VIDEOCELLHEIGHT + MIDDLEINTERVAL + 3 * LABELHEIGHT + 5 * HEIGHTPERCENTAGE, size.width, size.height)];
    
    UIView *moreView = [[UIView alloc] initWithFrame:CGRectMake(0, VIDEOCELLHEIGHT + MIDDLEINTERVAL + 3 * LABELHEIGHT + size.height + 10 * HEIGHTPERCENTAGE, WIDTH, 20 * HEIGHTPERCENTAGE)];
    _communicationLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIDEINSET, 0, 180 * WIDTHPERCENTAGE, 20 * HEIGHTPERCENTAGE)];
     _commentNumber = [[descriptionDic objectForKey:@"commentCnt"] intValue];
    [_communicationLabel setText:[NSString stringWithFormat:@"一起交流(%i)", _commentNumber]];
    _cell.commentNumberLabel.text = [NSString stringWithFormat:@"%i", _commentNumber];
    _cell.shareNumberLabel.text = [descriptionDic[@"share"] stringValue];
    UIButton *checkMoreButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - SIDEINSET - 60 * WIDTHPERCENTAGE, 0, 60 * WIDTHPERCENTAGE, 20 * HEIGHTPERCENTAGE)];
    [checkMoreButton setTitle:@"查看全部" forState:UIControlStateNormal];
    [checkMoreButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [checkMoreButton addTarget:self action:@selector(checkMoreComments) forControlEvents:UIControlEventTouchUpInside];
    [checkMoreButton setTitleColor:AppColor forState:UIControlStateNormal];

    [moreView addSubview:_communicationLabel];
    [moreView addSubview:checkMoreButton];
    [_scroll addSubview:moreView];
    
    _tableTopInterval = VIDEOCELLHEIGHT + 3 * MIDDLEINTERVAL + 3 * LABELHEIGHT + size.height + 25 * HEIGHTPERCENTAGE;

    [_commentTable setDelegate:self];
    [_commentTable setDataSource:self];

    [_commentTable setFrame:CGRectMake(0, _tableTopInterval, WIDTH, _cellTotalHeight)];
    if ([_commentArray count]) {
        [_commentTable reloadData];
        _commentState = @"2";
        NSLog(@"reloadTable");
    } else {

        _commentState = @"1";
    }

    [_scroll setContentSize:CGSizeMake(WIDTH, _tableTopInterval + _cellTotalHeight)];
    
}



#pragma mark - 推出订购页面

- (void)readyToPushOrder
{
    if ([[[ForthonDataContainer sharedStore] valueForKey:@"appIsLogin"] boolValue]) {

        [self.delegate getWorkTradeState:_workId];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(pushOrderView:) name:@"NotificationTradeState"
                                                   object:nil];
    } else {

        [self pushLoginCurtain];
    }

}

- (void)pushOrderView:(NSNotification *)notification {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"NotificationTradeState"
                                                  object:nil];
    NSString *tradeState = [notification.userInfo objectForKey:@"tradeState"];
    NSLog(@"state: %@", tradeState);
    if ([tradeState intValue] == 1) {
        
        NSLog(@"push OrderView");
        YHOrderMessageVC *orderView = [[YHOrderMessageVC alloc] init];
        orderView.workId = _workId;
        orderView.orderMessageStr = _orderMessageStr;
        [self.navigationController pushViewController:orderView animated:YES];
    }
    else {
        NSLog(@"不可交易");
    }
    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = documents[0];
    NSLog(@"path: %@", docDir);

    
 
    
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
    [_cell getFavorStatus];
    [_cell getFollowStatus];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - 输入框协议方法

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [_myTextField setCenter:CGPointMake(_myTextField.center.x, _myTextField.center.y - KEYBOARDHEIGHT)];
    }];
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endInput];
    
    return YES;
}

- (void)endInput
{
    //触碰视图，则输入结束，小视图回到原位
    NSLog(@"tap view");
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [_myTextField setCenter:CGPointMake(_myTextField.center.x, HEIGHT - 48 * HEIGHTPERCENTAGE / 2)];
    }];
    [_myTextField.commentText resignFirstResponder];
    [_myTextField.commentText setPlaceholder:@"我想说两句"];
    
}

#pragma mark  查看更多评论

- (void)checkMoreComments {
    
    ForthonAllComments *commentsView = [[ForthonAllComments alloc] init];
    commentsView.workId = _workId;
    commentsView.typeId = 2;
    [self.navigationController pushViewController:commentsView animated:YES];
    
    
}

#pragma mark - 发表评论

- (void)sendComment
{
    NSLog(@"send !");
    NSString *commentString = _myTextField.commentText.text;

    [_myTextField.commentText setText:@""];
    NSLog(@"fatherID is--------------------------\n%@\n", _commentFartherId);
    [_commentDelegate sendCommentsByTypeid:2 targetId:_workId fatherId:_commentFartherId content:commentString];
    //spider中添加发送评论的接口，参数为 作品种类 、Id  和  commentString
    //让spider 把 commentString 发出去
    //添加通知，当服务器添加评论成功，立马刷新出新的评论。
    _commentFartherId = 0;
    
    if ([[[ForthonDataContainer sharedStore] valueForKey:@"appIsLogin"] boolValue]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(addComment)
                                                     name:@"NotificationA"
                                                   object:nil];
    }

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(LoginPlease) name:@"NotificationUserError"
                                               object:nil];
    [self endInput];
}

- (void)loadCellHeight
{
    NSLog(@"loadHeight");
    
    if ([[[[ForthonDataContainer sharedStore].commentsDic objectForKey:@"artsComments"]objectForKey:_workId] count])
        {
        NSLog(@"though spider get data");
        _commentArray = [[ForthonDataContainer sharedStore].commentsDic[@"artsComments"] objectForKey:_workId];
        
        _cellHeightArray = [[NSMutableArray alloc] init];
        _cellTotalHeight = 0;
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
            NSLog(@"the %i cellNoContent: %f",i, [NSNumber numberWithFloat:[text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height].floatValue);
            [_cellHeightArray addObject:cellHeightNumber];
        }
        
        }
}

- (void)updateComment
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationA" object:nil];

    if (_netErrorView) {

        [_netErrorView removeFromSuperview];

    }
    if (_myTextField.hidden) {

        _myTextField.hidden = NO;
    }

    [self loadCellHeight];    //加载评论cell的高度
    [_commentTable setFrame:CGRectMake(0, _tableTopInterval, WIDTH, _cellTotalHeight)];
    NSLog(@"comment come");
    if ([_commentState intValue] == 1) {
      
        [_commentTable reloadData];
        NSLog(@"commentTable reload");
    }

    NSLog(@"totalHeight: %f", _cellTotalHeight);
    [_scroll setContentSize:CGSizeMake(WIDTH, _tableTopInterval + _cellTotalHeight)];

    NSLog(@"数据获取成功");
}

    
- (void)addComment
{
    NSLog(@"i receive new comment");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationA" object:nil];
    
    _commentArray = [[[ForthonDataContainer sharedStore].commentsDic objectForKey:@"artsComments"]objectForKey:_workId];
    _commentNumber++;
    [_communicationLabel setText:[NSString stringWithFormat:@"一起交流(%i)", _commentNumber]];
    _cell.commentNumberLabel.text = [NSString stringWithFormat:@"%i", _commentNumber];

    [[ForthonDataContainer sharedStore].artDescriptionDic[_workId] setObject:@(_commentNumber) forKey:@"commentCnt"];

    [self loadCellHeight];
    [_commentTable setFrame:CGRectMake(0, _tableTopInterval, WIDTH, _cellTotalHeight)];
    [_scroll setContentSize:CGSizeMake(WIDTH, _tableTopInterval + _cellTotalHeight)];
    [_commentTable reloadData];
}

#pragma mark - LabelFrame自动适配文字内容

- (CGSize)labelAutoCalculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize

{
    //随内容变换Label长度
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    NSDictionary* attributes =@{
                                NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName:paragraphStyle.copy
                                };
    
    CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    labelSize.height= (CGFloat) ceil(labelSize.height);
    labelSize.width= (CGFloat) ceil(labelSize.width);
    return labelSize;
}

#pragma mark - 滚动方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView1
{
    if (scrollView1 == _scroll) {

        [self endInput];
    } else {

        if (scrollView1.contentOffset.x >= WIDTH) {

            int index = (int) (scrollView1.contentOffset.x / WIDTH);
            _pageIndexLabel.text = [NSString stringWithFormat:@"%i/%i", index + 1, [_imageViewArray count]];

        } else if(scrollView1.contentOffset.x == 0) {

            _pageIndexLabel.text = [NSString stringWithFormat:@"1/%i", [_imageViewArray count]];
        }
    }
}



- (void)pushAuthorDescriptionWitDic:(NSMutableDictionary *)dic {

    NSLog(@"push author description view");

    ForthonAuthorDescription *authorView = [[ForthonAuthorDescription alloc] init];
    authorView.authorDic = dic;
    [self.navigationController pushViewController:authorView animated:YES];

}

#pragma mark - 放大图片

- (void)beginPushViewWithDic:(NSMutableDictionary *)dic {

    NSLog(@"放大图片");
    self.navigationController.navigationBarHidden = YES;
    _blackView = [[UIView alloc] initWithFrame:self.view.bounds];
    _blackView.backgroundColor = [UIColor blackColor];
    _panelView = [[UIView alloc] initWithFrame:self.view.bounds];
    _panelView.backgroundColor = [UIColor clearColor];

    [self.view addSubview:_blackView];
    [self.view addSubview:_panelView];

    _myScroll = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _myScroll.delegate = self;

    UITapGestureRecognizer *tapScroll = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBack)];
    [_myScroll addGestureRecognizer:tapScroll];

    [_myScroll setContentSize:CGSizeMake(WIDTH * [_imageViewArray count], self.view.frame.size.height)];
    _myScroll.pagingEnabled = YES;
    [_panelView addSubview:_myScroll];

    if (!_scrollViewArray) {
        _scrollViewArray = [[NSMutableArray alloc] init];
    }
    for (int i = 0 ; i < [_imageViewArray count]; i++) {

        UIImageView *imageView1 = [[UIImageView alloc] init];
        imageView1.frame = OriginRect;
        imageView1.contentMode = UIViewContentModeScaleAspectFit;
        [imageView1 sd_setImageWithURL:[NSURL URLWithString:[_imageViewArray[i][@"url"] changeToUrl]]];
        imageView1.frame = CGRectMake(0, 0, WIDTH, self.view.frame.size.height - 64);
        imageView1.center = CGPointMake(self.view.center.x, self.view.center.y);
        [_scrollViewArray addObject:imageView1];



        UIScrollView *scrollView1 = [[UIScrollView alloc] initWithFrame:CGRectMake(i * WIDTH, 0, WIDTH, self.view.frame.size.height)];
        [scrollView1 addSubview:imageView1];
        scrollView1.maximumZoomScale = 5.0;
        scrollView1.minimumZoomScale = 1.0;
        scrollView1.delegate = self;


        [_myScroll addSubview:scrollView1];
    }

    _pageIndexLabel = [[UILabel alloc] initWithFrame:CGRectMake((WIDTH - 100) / 2, HEIGHT - 40, 100, 20)];
    _pageIndexLabel.text = [NSString stringWithFormat:@"1/%i", [_imageViewArray count]];
    _pageIndexLabel.textColor = [UIColor whiteColor];
    _pageIndexLabel.textAlignment = NSTextAlignmentCenter;

    [_panelView addSubview:_pageIndexLabel];

}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {

    NSLog(@"ready to zooming");
    UIView *subView = _scrollViewArray[(int)(_myScroll.contentOffset.x / WIDTH)];

    return subView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{

    CGSize boundsSize = scrollView.bounds.size;
    UIView *imgView = _scrollViewArray[(int)(_myScroll.contentOffset.x / WIDTH)];
    CGRect imgFrame = imgView.frame;
    CGSize contentSize = scrollView.contentSize;

    CGPoint centerPoint = CGPointMake(contentSize.width/2, contentSize.height/2);

    // center horizontally
    if (imgFrame.size.width <= boundsSize.width)
    {
        centerPoint.x = boundsSize.width/2;
    }

    // center vertically
    if (imgFrame.size.height <= boundsSize.height)
    {
        centerPoint.y = boundsSize.height/2;
    }

    imgView.center = centerPoint;
    NSLog(@"xiha");
}


- (void)tapBack {

    NSLog(@"tapBack");
    self.navigationController.navigationBarHidden = NO;
    [_panelView removeFromSuperview];
    [_blackView removeFromSuperview];

}


@end
