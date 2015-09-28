//
//  MineVC.h
//  Art
//
//  Created by Tang yuhua on 15/4/28.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface MineVC : UITableViewController<LoginAndRefresh>

@property (nonatomic, strong) id<GetUnreadNumber> unReadDelegate;


@end
