//
//  commentCell.h
//  Art
//
//  Created by Liu fushan on 15/6/7.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "commentCellMeasurement.h"

@interface commentCell : UITableViewCell



@property (nonatomic, strong) UIImageView *headImageView;





- (void)load;
- (void)resetContentLabeWithDic:(NSDictionary *)dic;




@end
