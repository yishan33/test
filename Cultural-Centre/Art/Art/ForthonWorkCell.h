//
//  ForthonWorkCell.h
//  Art
//
//  Created by Liu fushan on 15/6/22.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForthonWorkCell : UITableViewCell

- (void)loadView;
- (void)loadDataWithDic:(NSDictionary *)dic;

@property (nonatomic, assign) id <ForthonWorkCellDelegate>delegate;

@end
