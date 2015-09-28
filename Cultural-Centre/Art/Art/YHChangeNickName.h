//
//  ViewController.h
//  demo
//
//  Created by Tang yuhua on 15/7/6.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHChangeNickName : UITableViewController


@property (nonatomic, strong) id<ModifyUserNick> delegate;

@end

