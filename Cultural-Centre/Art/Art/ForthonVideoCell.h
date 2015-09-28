//
//  ForthonVideoCellBeta.h
//  Art
//
//  Created by Liu fushan on 15/7/13.
//  Copyright (c) 2015年 test. All rights reserved.
//



//
//  ForthonPerformViewCell.h
//  Login
//
//  Created by Liu fushan on 15/5/17.
//  Copyright (c) 2015年 culturalCenter. All rights reserved.
//




#import <UIKit/UIKit.h>


@interface ForthonVideoCell : UITableViewCell



@property (nonatomic, strong) UIImageView *videoImage;
@property (nonatomic, strong) UIButton *attentionButton;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) NSString *videoString;
@property (nonatomic, strong) UILabel *commentNumberLabel;
@property (nonatomic, strong) UILabel *shareNumberLabel;


@property int tinyTag;
@property int categoryIndex;
@property int typeId;
@property (nonatomic, strong) NSString *keyPath;
@property int pushType;

@property BOOL isFollow;
@property BOOL isFavor;
@property BOOL isPlay;


@property (nonatomic, copy) NSString *shareStr;

@property (nonatomic, assign) id<PushDescriptionView> pushDelegate;
@property (nonatomic, assign) id<addVideoNumbers> numberDelegate;
@property (nonatomic, assign) id<SetAndCancelFollow> followDelegate;
@property (nonatomic, assign) id<addAndCancelFavor> favorDelegate;
@property (nonatomic, assign) id<LoginAndRefresh> loginDelegate;
@property (nonatomic, assign) id<ShareDelegate> shareDelegate;
@property (nonatomic, assign) id<CancelTextFieldDelegate> textFieldDelegate;

@property  (nonatomic, weak) UILabel *skimNumberLabel;

- (void)loadView;
- (void)embarkWithDictionary:(NSDictionary *)dic;

- (void)getFollowStatus;
- (void)getFavorStatus;



@end
