//
//  ViewController.h
//  demo
//
//  Created by Tang yuhua on 15/7/6.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHChangePassword : UITableViewController <LoginAndRefresh, RefreshView>


@property (nonatomic, strong) id<ModifyPassword> delegate;
@property (nonatomic, strong) id<LoginAndRefresh>loginDelegate;

@end

