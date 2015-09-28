//
//  ForthonVastArtCell.m
//  Login
//
//  Created by Liu fushan on 15/5/20.
//  Copyright (c) 2015年 culturalCenter. All rights reserved.
//

#import "ForthonVastArtCell.h"
#import "vastMeasurement.h"



@implementation ForthonVastArtCell


- (ForthonVastArtCell *)load
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BACKVIEWWIDTH, BACKVIEWHEIGHT)];
//    [backView setBackgroundColor:[UIColor blackColor]];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake((BACKVIEWWIDTH / 2 - VIEWWIDTH) / 3 * 2, (BACKVIEWHEIGHT - VIEWHEIGHT) / 2, VIEWWIDTH, VIEWHEIGHT   )];
    [leftView setBackgroundColor:[UIColor grayColor]];
    [leftView.layer setCornerRadius:8.0];
    
    _leftHeadImageView = [[UIButton alloc] initWithFrame:CGRectMake(INTERVAL, VIEWHEIGHT / 2 - HEADIMAGESIDE / 2 - 15 * HEIGHTPERCENTAGE, HEADIMAGESIDE, HEADIMAGESIDE)];
//    [headImageView setBackgroundColor:[UIColor yellowColor]];
    [_leftHeadImageView setBackgroundImage:[UIImage imageNamed:@"glass.jpg"] forState:UIControlStateNormal];
    [_leftHeadImageView.layer setCornerRadius:_leftHeadImageView.frame.size.width / 2];
    [_leftHeadImageView.layer setBorderWidth:2.0];
    [_leftHeadImageView.layer setBorderColor:[UIColor redColor].CGColor];
    [_leftHeadImageView setClipsToBounds:YES];
    [_leftHeadImageView addTarget:self action:@selector(tapHeadImage) forControlEvents:UIControlEventTouchUpInside];
    
    _leftNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, VIEWHEIGHT / 2 + HEADIMAGESIDE / 2 , HEADIMAGESIDE + 2 * INTERVAL , 15 * HEIGHTPERCENTAGE)];
//    [_leftNameLabel setText:@"张成栗子"];
    [_leftNameLabel setTextAlignment:NSTextAlignmentCenter];
    [_leftNameLabel setFont:[UIFont systemFontOfSize:10.0]];
    [_leftNameLabel setTextColor:[UIColor redColor]];
    
    
    _leftPictureView = [[UIButton alloc] initWithFrame:CGRectMake(INTERVAL * 2 + HEADIMAGESIDE, (VIEWHEIGHT - PICTUREHEIGHT) / 2, PICTUREWIDTH, PICTUREHEIGHT)];
    [_leftPictureView setBackgroundImage:[UIImage imageNamed:@"spiderMan.jpg"] forState:UIControlStateNormal];
    [_leftPictureView addTarget:self action:@selector(tapPicture) forControlEvents:UIControlEventTouchUpInside];
//    [pictureView setBackgroundColor:[UIColor purpleColor]];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(BACKVIEWWIDTH / 2 + (BACKVIEWWIDTH / 2 - VIEWWIDTH) / 3 , (BACKVIEWHEIGHT - VIEWHEIGHT) / 2, VIEWWIDTH, VIEWHEIGHT)];
    [rightView setBackgroundColor:[UIColor grayColor]];
    [rightView.layer setCornerRadius:8.0];
    
    _rightHeadImageView = [[UIButton alloc] initWithFrame:CGRectMake(INTERVAL, VIEWHEIGHT / 2 - HEADIMAGESIDE / 2 - 15 * HEIGHTPERCENTAGE, HEADIMAGESIDE, HEADIMAGESIDE)];
    //    [headImageView setBackgroundColor:[UIColor yellowColor]];
    [_rightHeadImageView setBackgroundImage:[UIImage imageNamed:@"glass.jpg"] forState:UIControlStateNormal];
    [_rightHeadImageView.layer setCornerRadius:_leftHeadImageView.frame.size.width / 2];
    [_rightHeadImageView.layer setBorderWidth:2.0];
    [_rightHeadImageView.layer setBorderColor:[UIColor redColor].CGColor];
    [_rightHeadImageView setClipsToBounds:YES];
    [_rightHeadImageView addTarget:self action:@selector(tapHeadImage) forControlEvents:UIControlEventTouchUpInside];
    
    _rightNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, VIEWHEIGHT / 2 + HEADIMAGESIDE / 2 , HEADIMAGESIDE + 2 * INTERVAL , 15 * HEIGHTPERCENTAGE)];
//    [_rightNameLabel setText:@"张成栗子"];
    [_rightNameLabel setTextAlignment:NSTextAlignmentCenter];
    [_rightNameLabel setFont:[UIFont systemFontOfSize:10.0]];
    [_rightNameLabel setTextColor:[UIColor redColor]];
    
    
    _rightPictureView = [[UIButton alloc] initWithFrame:CGRectMake(INTERVAL * 2 + HEADIMAGESIDE, (VIEWHEIGHT - PICTUREHEIGHT) / 2, PICTUREWIDTH, PICTUREHEIGHT)];
    [_rightPictureView setBackgroundImage:[UIImage imageNamed:@"spiderMan.jpg"] forState:UIControlStateNormal];
    [_rightPictureView addTarget:self action:@selector(tapPicture) forControlEvents:UIControlEventTouchUpInside];
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

- (void)tapHeadImage
{
    NSLog(@"SB , is the name");
}

- (void)tapPicture
{
    NSLog(@"image");
}
@end
