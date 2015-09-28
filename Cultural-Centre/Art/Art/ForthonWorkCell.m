//
//  ForthonWorkCell.m
//  Art
//
//  Created by Liu fushan on 15/6/22.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "ForthonWorkCell.h"
#import "UIImageView+WebCache.h"
#import "UILabel+autoSizeToFit.h"
#import "ForthonTapGesture.h"
#import "NSString+imageUrlString.h"

#define WIDTH [UIScreen mainScreen].applicationFrame.size.width
#define HEIGHT [UIScreen mainScreen].applicationFrame.size.height

#define WIDTHPERCENTAGE WIDTH / 320 
#define HEIGHTPERCENTAGE HEIGHT / 480

#define _backViewWIDTH WIDTH
#define _backViewHEIGHT 110 * HEIGHTPERCENTAGE

#define TOPINTERVAL 5 * HEIGHTPERCENTAGE

#define SIDEINTERVAL 5 * WIDTHPERCENTAGE

#define LABELWIDTH WIDTH
#define LABELHEIGHT 20 * HEIGHTPERCENTAGE

#define IMAGEWIDTH IMAGEHEIGHT * 1.2
#define IMAGEHEIGHT 80 * HEIGHTPERCENTAGE

#define IMAGEINTERVAL 3 * WIDTHPERCENTAGE


@interface ForthonWorkCell ()

@property (nonatomic, strong) NSMutableDictionary *dicData;


@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) UILabel *descriptionLabel;



@end


@implementation ForthonWorkCell



- (void)loadView {

    _backView = [[UIView alloc] init];

    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, TOPINTERVAL, LABELWIDTH, LABELHEIGHT)];
    [_titleLabel setTextColor:[UIColor blackColor]];
    [_titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    
    _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TOPINTERVAL + LABELHEIGHT, WIDTH, IMAGEHEIGHT)];
    _scroll.bounces = NO;

    _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIDEINTERVAL, 2 * TOPINTERVAL + LABELHEIGHT + IMAGEHEIGHT, WIDTH - 2 * SIDEINTERVAL, 0)];
    [_descriptionLabel setNumberOfLines:100];

    [_backView addSubview:_titleLabel];
    [_backView addSubview:_scroll];
    [_backView addSubview:_descriptionLabel];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self addSubview:_backView];
    
}


- (void)loadDataWithDic:(NSDictionary *)dic

{
    
    _dicData = dic;
    [_titleLabel setText:[dic[@"group"] objectForKey:@"name"]];
    [_titleLabel setTextColor:[UIColor blackColor]];
    [_titleLabel setFont:[UIFont systemFontOfSize:16.0]];

    for (int i = 0; i < [dic[@"cnt"] intValue]; i++)
    {
    
        NSString *imageUrlBody = [dic[@"artList"][i] objectForKey:@"titleImg"];
        NSString *imageUrlString = [imageUrlBody changeToUrl];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * (IMAGEWIDTH + IMAGEINTERVAL), 0, IMAGEWIDTH, IMAGEHEIGHT)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString] prune:YES withPercentage:IMAGEWIDTH / IMAGEHEIGHT];

        ForthonTapGesture *tapPicture = [[ForthonTapGesture alloc] initWithTarget:self action:@selector(pushArtDescription:)];
        tapPicture.tag = i;
        [imageView addGestureRecognizer:tapPicture];
        imageView.userInteractionEnabled = YES;

        [_scroll addSubview:imageView];

    }
    
    [_scroll setContentSize:CGSizeMake([dic[@"cnt"] intValue] * IMAGEWIDTH, IMAGEHEIGHT)];

    NSString *descriptionText = [dic[@"group"] objectForKey:@"des"];
    NSLog(@"descriptionText: %@", descriptionText);
    [_descriptionLabel labelAutoCalculateRectWith:descriptionText FontSize:14.0 MaxSize:CGSizeMake(WIDTH - 2 * SIDEINTERVAL, 1000)];

    [_backView setFrame:CGRectMake(0, 0, WIDTH, _backViewHEIGHT + _descriptionLabel.frame.size.height)];
//    [self addSubview:_backView];

}

- (void)pushArtDescription:(ForthonTapGesture *)tap {

    NSMutableDictionary *dic = _dicData[@"artList"][tap.tag];
    [self.delegate pushArtDescriptionWithDic:dic];
}



@end
