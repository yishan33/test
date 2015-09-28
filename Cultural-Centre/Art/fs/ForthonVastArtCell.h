//
//  ForthonVastArtCell.h
//  Login
//
//  Created by Liu fushan on 15/5/20.
//  Copyright (c) 2015年 culturalCenter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForthonVastArtCell : UITableViewCell


- (ForthonVastArtCell *)load;

@property (strong, nonatomic) UIButton *leftHeadImageView;
@property (strong, nonatomic) UIButton *leftPictureView;
@property (strong, nonatomic) UILabel *leftNameLabel;

@property (strong, nonatomic) UIButton *rightHeadImageView;
@property (strong, nonatomic) UIButton *rightPictureView;
@property (strong, nonatomic) UILabel *rightNameLabel;

@end
