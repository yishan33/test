//
//  MineListCell.h
//  Art
//
//  Created by Tang yuhua on 15/6/26.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineListCell : UITableViewCell
@property (nonatomic,strong) UIImageView *ImageView;

-(void)cellInListAt :(NSInteger)index;
@end
