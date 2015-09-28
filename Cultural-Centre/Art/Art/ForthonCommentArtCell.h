//
//  ForthonCommentArtCell.h
//  Login
//
//  Created by Liu fushan on 15/5/21.
//  Copyright (c) 2015年 culturalCenter. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ForthonCommentArtCell : UITableViewCell


@property (strong, nonatomic) UILabel *commentNumberLabel;

@property int tinyTag;

- (void)loadView;
- (void)loadDataWithDic:(NSMutableDictionary *)dic;

@property (nonatomic, strong) id<addAndCancelFavor>favorDelegate;
@property (nonatomic, strong) id<LoginAndRefresh>loginDelegate;
@property (nonatomic, strong) id<pushPageDelegate>pushDelegate;

@end
