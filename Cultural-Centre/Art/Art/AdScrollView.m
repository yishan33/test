//
//  AdScrollView.m
//  广告循环滚动效果
//
//  Created by QzydeMac on 14/12/20.
//  Copyright (c) 2014年 Qzy. All rights reserved.
//

#import "AdScrollView.h"
#import "UIImageView+WebCache.h"
#import "NSString+imageUrlString.h"
#import "ForthonDataSpider.h"
#import "SVProgressHUD.h"



#define UISCREENWIDTH  self.bounds.size.width//广告的宽度
#define UISCREENHEIGHT  UISCREENWIDTH / 2 //广告的高度

#define BANNERHIGHT self.bounds.origin.y //由于_pageControl是添加进父视图的,所以实际位置要参考,滚动视图的y坐标

//static CGFloat const chageImageTime = 3.0;
//static NSUInteger currentImage = 1;//记录中间图片的下标,开始总是为1

@interface AdScrollView ()

{
    //广告的label
    UILabel * _adLabel;
    //循环滚动的三个视图
    UIImageView * _leftImageView;
    UIImageView * _centerImageView;
    UIImageView * _rightImageView;
    //循环滚动的周期时间
    NSTimer * _moveTime;
    //用于确定滚动式由人导致的还是计时器到了,系统帮我们滚动的,YES,则为系统滚动,NO则为客户滚动(ps.在客户端中客户滚动一个广告后,这个广告的计时器要归0并重新计时)
    BOOL _isTimeUp;
    //为每一个图片添加一个广告语(可选)
    UILabel * _leftAdLabel;
    UILabel * _centerAdLabel;
    UILabel * _rightAdLabel;
    
}

@property (nonatomic, copy) NSString *tapTargetId;

@property(nonatomic) NSUInteger currentImage;
@property (retain,nonatomic,readonly) UIImageView * leftImageView;
@property (retain,nonatomic,readonly) UIImageView * centerImageView;
@property (retain,nonatomic,readonly) UIImageView * rightImageView;

@end

@implementation AdScrollView

#pragma mark - 自由指定广告所占的frame
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bounces = NO;
        self.currentImage = 0;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.pagingEnabled = YES;
        self.contentOffset = CGPointMake(UISCREENWIDTH, 0);
        self.contentSize = CGSizeMake(UISCREENWIDTH * 3, UISCREENHEIGHT - 64);
        self.delegate = self;
//        self.backgroundColor = [UIColor redColor];

        _leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UISCREENWIDTH, UISCREENHEIGHT)];
        [self addSubview:_leftImageView];
        _centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(UISCREENWIDTH, 0, UISCREENWIDTH, UISCREENHEIGHT)];
        [self addSubview:_centerImageView];
        _rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(UISCREENWIDTH*2, 0, UISCREENWIDTH, UISCREENHEIGHT)];
        [self addSubview:_rightImageView];

        self.getDelegate = [ForthonDataSpider sharedStore];
        _moveTime = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(animalMoveImage) userInfo:nil repeats:YES];
        _isTimeUp = NO;

        NSLog(@"scroll.frame width = %f, height = %f, xPoint = %f, yPoint = %f ", self.frame.size.width, self.frame.size.height, self.frame.origin.x, self.frame.origin.y);
        
    }
    return self;
}

#pragma mark - 设置广告图片model

- (void)setImagesArray:(NSArray *)imagesArray {

    if (!_imagesArray) {

        _imagesArray = imagesArray;
        NSMutableArray *imagesUrlArray = [NSMutableArray new];
        for (NSDictionary *imageDic in _imagesArray) {

            NSString *url = [imageDic[@"picUrl"] changeToUrl];
            [imagesUrlArray addObject:url];
        }

        self.imageNameArray = imagesUrlArray;
     
    }
}


#pragma mark - 设置广告所使用的图片(名字)
- (void)setImageNameArray:(NSArray *)imageNameArray
{
    _imageNameArray = imageNameArray;

    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:_imageNameArray[2]] prune:YES withPercentage:2.0];
    [_centerImageView sd_setImageWithURL:[NSURL URLWithString:_imageNameArray[0]] prune:YES withPercentage:2.0];
    [_rightImageView sd_setImageWithURL:[NSURL URLWithString:_imageNameArray[1]] prune:YES withPercentage:2.0];

    _centerImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getArtData)];
    [_centerImageView addGestureRecognizer:tap];


}

#pragma mark - 设置每个对应广告对应的广告语
- (void)setAdTitleArray:(NSArray *)adTitleArray withShowStyle:(AdTitleShowStyle)adTitleStyle
{
    _adTitleArray = adTitleArray;
    
    if(adTitleStyle == AdTitleShowStyleNone)
    {
        return;
    }

    _leftAdLabel = [[UILabel alloc]init];
    _centerAdLabel = [[UILabel alloc]init];
    _rightAdLabel = [[UILabel alloc]init];
    
    
    _leftAdLabel.frame = CGRectMake(10, UISCREENHEIGHT - 40, UISCREENWIDTH, 20);
    [_leftImageView addSubview:_leftAdLabel];
    _centerAdLabel.frame = CGRectMake(10, UISCREENHEIGHT - 40, UISCREENWIDTH, 20);
    [_centerImageView addSubview:_centerAdLabel];
    _rightAdLabel.frame = CGRectMake(10, UISCREENHEIGHT - 40, UISCREENWIDTH, 20);
    [_rightImageView addSubview:_rightAdLabel];
    
    if (adTitleStyle == AdTitleShowStyleLeft) {
        _leftAdLabel.textAlignment = NSTextAlignmentLeft;
        _centerAdLabel.textAlignment = NSTextAlignmentLeft;
        _rightAdLabel.textAlignment = NSTextAlignmentLeft;
    }
    else if (adTitleStyle == AdTitleShowStyleCenter)
    {
        _leftAdLabel.textAlignment = NSTextAlignmentCenter;
        _centerAdLabel.textAlignment = NSTextAlignmentCenter;
        _rightAdLabel.textAlignment = NSTextAlignmentCenter;
    }
    else
    {
        _leftAdLabel.textAlignment = NSTextAlignmentRight;
        _centerAdLabel.textAlignment = NSTextAlignmentRight;
        _rightAdLabel.textAlignment = NSTextAlignmentRight;
    }
    
    
    _leftAdLabel.text = _adTitleArray[0];
    _centerAdLabel.text = _adTitleArray[1];
    _rightAdLabel.text = _adTitleArray[2];
    
}


#pragma mark - 创建pageControl,指定其显示样式
- (void)setPageControlShowStyle:(UIPageControlShowStyle)PageControlShowStyle
{
    if (PageControlShowStyle == UIPageControlShowStyleNone) {
        return;
    }
    _pageControl = [[UIPageControl alloc]init];
    _pageControl.numberOfPages = _imageNameArray.count;
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    _pageControl.currentPageIndicatorTintColor = AppColor;
    
    if (PageControlShowStyle == UIPageControlShowStyleLeft)
    {
        _pageControl.frame = CGRectMake(10, BANNERHIGHT+UISCREENHEIGHT - 20, 20*_pageControl.numberOfPages, 20);
    }
    else if (PageControlShowStyle == UIPageControlShowStyleCenter)
    {
        _pageControl.frame = CGRectMake(0, 0, 20*_pageControl.numberOfPages, 20);
        _pageControl.center = CGPointMake(UISCREENWIDTH/2.0, BANNERHIGHT+UISCREENHEIGHT - 10);
    }
    else
    {
        _pageControl.frame = CGRectMake( UISCREENWIDTH - 20*_pageControl.numberOfPages, BANNERHIGHT + UISCREENHEIGHT - 20, 20*_pageControl.numberOfPages, 20);
        NSLog(@"banner: %f, uiscreen: %f", BANNERHIGHT, UISCREENHEIGHT);
    }
    _pageControl.currentPage = 0;
    _pageControl.enabled = NO;

    [self performSelector:@selector(addPageControl) withObject:nil afterDelay:0.1f];
}
//由于PageControl这个空间必须要添加在滚动视图的父视图上(添加在滚动视图上的话会随着图片滚动,而达不到效果)
- (void)addPageControl
{
    [[self superview] addSubview:_pageControl];
}

#pragma mark - 计时器到时,系统滚动图片
- (void)animalMoveImage
{
    
    [self setContentOffset:CGPointMake(UISCREENWIDTH * 2, 0) animated:YES];
    _isTimeUp = YES;
    [NSTimer scheduledTimerWithTimeInterval:0.4f target:self selector:@selector(scrollViewDidEndDecelerating:) userInfo:nil repeats:NO];
}

#pragma mark - 图片停止时,调用该函数使得滚动视图复用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if (self.contentOffset.x == 0)
    {
        if (self.currentImage == 0) {

            self.currentImage = _imageNameArray.count - 1;
            _pageControl.currentPage = _imageNameArray.count - 1;
        } else {

            self.currentImage = (self.currentImage - 1) % _imageNameArray.count;
            _pageControl.currentPage = (_pageControl.currentPage - 1)%_imageNameArray.count;
        }

    }
    else if(self.contentOffset.x == UISCREENWIDTH * 2)
    {
        
       self.currentImage = (self.currentImage + 1) % _imageNameArray.count;
       _pageControl.currentPage = (_pageControl.currentPage + 1)%_imageNameArray.count;

    
    }
    else
    {
        return;

    }

    int leftCount = (self.currentImage - 1) % _imageNameArray.count;
    int centerCount = self.currentImage % _imageNameArray.count;
    int rightCount = (self.currentImage + 1) % _imageNameArray.count;

    if (centerCount == 0) {

        leftCount = _imageNameArray.count - 1;
    }

    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:_imageNameArray[leftCount]] prune:YES withPercentage:2.0];
    [_centerImageView sd_setImageWithURL:[NSURL URLWithString:_imageNameArray[centerCount]] prune:YES withPercentage:2.0];
    [_rightImageView sd_setImageWithURL:[NSURL URLWithString:_imageNameArray[rightCount]] prune:YES withPercentage:2.0];


    self.contentOffset = CGPointMake(UISCREENWIDTH, 0);

    //手动控制图片滚动应该取消那个三秒的计时器
    if (!_isTimeUp) {
        [_moveTime setFireDate:[NSDate dateWithTimeIntervalSinceNow:3.0]];
    }
    _isTimeUp = NO;
}

- (void)getArtData {

//    [SVProgressHUD showWithStatus:@"加载中..."];
    int index = self.currentImage % _imageNameArray.count;
    int typeId = [_imagesArray[index][@"typeId"] intValue];
    _tapTargetId = _imagesArray[index][@"targetId"];

    NSLog(@"点击轮播图");

    if (typeId == 1) {

        NSLog(@"获取视屏详情");
        [self.getDelegate getVideoDescriptionById:_tapTargetId];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(pushVideoDescription:)
                                                     name:@"NotificationVideoDescription"
                                                   object:nil];


    } else if (typeId == 2) {

        NSLog(@"获取艺术品详情");
        [self.getDelegate getArtDescriptionById:_tapTargetId];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(pushArtDescription)
                                                     name:@"NotificationArtContent"
                                                   object:nil];

    } else {

        NSLog(@"获取文章详情");
        [self.getDelegate getPageById:_tapTargetId];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(pushPageDescription:)
                                                     name:@"NotificationPageDescription"
                                                   object:nil];
    }


    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(netError)
                                                 name:@"NotificationNetError"
                                               object:nil];


}

- (void)netError {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationNetError" object:nil];
    [SVProgressHUD showErrorWithStatus:@"网络异常" maskType:SVProgressHUDMaskTypeBlack];

}



- (void)pushVideoDescription:(NSNotification *)notification {

    [SVProgressHUD dismiss];
    NSLog(@"ready to push video");
    NSDictionary *dic = notification.userInfo;
    [self.pushDelegate pushVideoDescriptionWithDic:dic];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationVideoDescription" object:nil];


}

- (void)pushArtDescription {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationArtContent" object:nil];

    int index = self.currentImage % _imageNameArray.count;;

    NSDictionary *dic = [ForthonDataContainer sharedStore].artDescriptionDic[_tapTargetId];

    [self.pushDelegate pushArtDescriptionWithDic:dic];
}

- (void)pushPageDescription:(NSNotification *)notification {

    NSDictionary *dic = notification.userInfo;
    [self.pushDelegate pushPaperViewWithDic:dic];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationPageDescription" object:nil];
}

@end

