//
//  YHUserInfoCell.h
//  Art
//
//  Created by Tang yuhua on 15/6/30.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHUserInfoCell : UITableViewCell

@property (nonatomic, strong) UILabel *messageLabel;

- (void)loadWithImageRight;
- (void)loadWithImage:(UIImage *)image;

@end
