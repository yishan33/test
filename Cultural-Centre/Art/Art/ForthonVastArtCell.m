//
//  ForthonVastArtCell.m
//  Login
//
//  Created by Liu fushan on 15/5/20.
//  Copyright (c) 2015年 culturalCenter. All rights reserved.
//

#import "ForthonVastArtCell.h"

#define MoreGrayColor [UIColor colorWithRed:204.0 / 255.0 green:204.0 / 255.0 blue:204.0 / 255.0 alpha:1.0]


@implementation ForthonVastArtCell


- (ForthonVastArtCell *)load
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BACKVIEWWIDTH, BACKVIEWHEIGHT)];
//    [backView setBackgroundColor:[UIColor blackColor]];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake((BACKVIEWWIDTH / 2 - VIEWWIDTH) / 3 * 2, (BACKVIEWHEIGHT - VIEWHEIGHT) / 2, VIEWWIDTH, VIEWHEIGHT   )];
    [leftView setBackgroundColor:GrayColor];
    [leftView.layer setCornerRadius:8.0];
    
    _leftHeadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(INTERVAL, VIEWHEIGHT / 2 - HEADIMAGESIDE / 2 - 15 * HEIGHTPERCENTAGE, HEADIMAGESIDE, HEADIMAGESIDE)];
//    [headImageView setBackgroundColor:[UIColor yellowColor]];
    [_leftHeadImageView setImage:[UIImage imageNamed:@"glass.jpg"]];
    [_leftHeadImageView.layer setCornerRadius:_leftHeadImageView.frame.size.width / 2];
    [_leftHeadImageView.layer setBorderWidth:2.0];
    [_leftHeadImageView.layer setBorderColor:AppColor.CGColor];
    [_leftHeadImageView setClipsToBounds:YES];
//    [_leftHeadImageView addGestureRecognizer:tapHead];

    
    _leftNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, VIEWHEIGHT / 2 + HEADIMAGESIDE / 2 , HEADIMAGESIDE + 2 * INTERVAL , 20 * HEIGHTPERCENTAGE)];

    [_leftNameLabel setTextAlignment:NSTextAlignmentCenter];
    [_leftNameLabel setFont:[UIFont systemFontOfSize:10.0]];
    [_leftNameLabel setTextColor:AppColor];
    

    _leftPictureView = [[UIImageView alloc] initWithFrame:CGRectMake(INTERVAL * 2 + HEADIMAGESIDE, (VIEWHEIGHT - PICTUREHEIGHT) / 2, PICTUREWIDTH, PICTUREHEIGHT)];
    _leftPictureView.backgroundColor = MoreGrayColor;
//    [_leftPictureView setImage:[UIImage imageNamed:@"spiderMan.jpg"] ];
//    [_leftHeadImageView addGestureRecognizer:tapPicture];

    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(BACKVIEWWIDTH / 2 + (BACKVIEWWIDTH / 2 - VIEWWIDTH) / 3 , (BACKVIEWHEIGHT - VIEWHEIGHT) / 2, VIEWWIDTH, VIEWHEIGHT)];
    [rightView setBackgroundColor:GrayColor];
    [rightView.layer setCornerRadius:8.0];
    
    _rightHeadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(INTERVAL, VIEWHEIGHT / 2 - HEADIMAGESIDE / 2 - 15 * HEIGHTPERCENTAGE, HEADIMAGESIDE, HEADIMAGESIDE)];
    //    [headImageView setBackgroundColor:[UIColor yellowColor]];
    [_rightHeadImageView setImage:[UIImage imageNamed:@"glass.jpg"]];
    [_rightHeadImageView.layer setCornerRadius:_leftHeadImageView.frame.size.width / 2];
    [_rightHeadImageView.layer setBorderWidth:2.0];
    [_rightHeadImageView.layer setBorderColor:AppColor.CGColor];
    [_rightHeadImageView setClipsToBounds:YES];
//    [_rightHeadImageView addGestureRecognizer:tapHead];
//    
    _rightNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, VIEWHEIGHT / 2 + HEADIMAGESIDE / 2 , HEADIMAGESIDE + 2 * INTERVAL , 20 * HEIGHTPERCENTAGE)];

    [_rightNameLabel setTextAlignment:NSTextAlignmentCenter];
    [_rightNameLabel setFont:[UIFont systemFontOfSize:10.0]];
    [_rightNameLabel setTextColor:AppColor];
    
    
    _rightPictureView = [[UIImageView alloc] initWithFrame:CGRectMake(INTERVAL * 2 + HEADIMAGESIDE, (VIEWHEIGHT - PICTUREHEIGHT) / 2, PICTUREWIDTH, PICTUREHEIGHT)];
    _rightPictureView.backgroundColor = MoreGrayColor;
//    [_rightPictureView setImage:[UIImage imageNamed:@"spiderMan.jpg"] ];
//    [_rightPictureView addGestureRecognizer:tapPicture];

    [rightView addSubview:_rightHeadImageView];
    [rightView addSubview:_rightPictureView];
    [rightView addSubview:_rightNameLabel];
    
    [leftView addSubview:_leftNameLabel];
    [leftView addSubview:_leftPictureView];
    [leftView addSubview:_leftHeadImageView];
    
    [backView addSubview:rightView];
    [backView addSubview:leftView];
    [self addSubview:backView];
    
    return  self;
}

- (void)tapHead
{
    [_delegate tapHeadImage];
}
     
- (void)tapPicture
{
    [_delegate tapPictureImage];
}

                                          
                                          
@end
