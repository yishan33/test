//
//  ForthonMyCommentCell.h
//  Art
//
//  Created by Liu fushan on 15/7/3.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCommentCellMeasurement.h"



@interface ForthonMyCommentCell : UITableViewCell


@property (nonatomic, strong) NSString *pageId;
@property (nonatomic, strong) id <GetCommentContentData> delegate;
@property (nonatomic, assign) id <myCommentPushDescription> pushDelegate;
@property (nonatomic, assign) id<SetCommentRead> readDelegate;


@property (nonatomic, strong) id mySuperView;

- (void)loadView;
- (void)embarkWithData:(NSDictionary *)dic;


@end
