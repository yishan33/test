//
//  ForthonPerformViewCell.h
//  Login
//
//  Created by Liu fushan on 15/5/17.
//  Copyright (c) 2015年 culturalCenter. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol ForthonPushVideo <NSObject>

- (void)pushStart;

@end






@interface ForthonPerformViewCell : UITableViewCell

@property (nonatomic, strong) NSData *videoImageData;
@property (nonatomic, strong) UIImageView *videoImage;
@property (nonatomic, strong) UIButton *attentionButton;
@property (nonatomic, strong) NSData *headImageData;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) NSString *videoString;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) NSString *skimUrlString;
@property (nonatomic, strong) NSString *shareUrlString;
@property (nonatomic, strong) NSString *collectUrlString;
@property (nonatomic, strong) NSString *commentUrlString;

@property  int skimNumber;
@property  int shareNumber;
@property  int collectNumber;
@property  int commentNumber;

@property (nonatomic, strong) UIButton *skimButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *collectButton;
@property (nonatomic, strong) UIButton *commentButton;




+ (UITableViewCell *)loadDataWithHeadImage:(UIImage *)headImage
                                      Name:(NSString *)name
                                 Attention:(BOOL)attention
                                VideoImage:(UIImage *)videoImage
                                      Skim:(int)skimNumber
                                     Share:(int)shareNumber
                                   Collect:(BOOL)collect
                             CollectNumber:(int)collectNumber
                                   Comment:(int)commentNumber;

- (ForthonPerformViewCell *)load;


@end
