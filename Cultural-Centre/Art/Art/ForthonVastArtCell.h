//
//  ForthonVastArtCell.h
//  Login
//
//  Created by Liu fushan on 15/5/20.
//  Copyright (c) 2015年 culturalCenter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "vastMeasurement.h"



@interface ForthonVastArtCell : UITableViewCell


- (ForthonVastArtCell *)load;

@property (strong, nonatomic) UIImageView *leftHeadImageView;
@property (strong, nonatomic) UIImageView *leftPictureView;
@property (strong, nonatomic) UILabel *leftNameLabel;

@property (strong, nonatomic) UIImageView *rightHeadImageView;
@property (strong, nonatomic) UIImageView *rightPictureView;
@property (strong, nonatomic) UILabel *rightNameLabel;

@property int categoryIndex;
@property int tinyTag;

@property (strong, nonatomic) id<pushDescription> delegate;

@end
