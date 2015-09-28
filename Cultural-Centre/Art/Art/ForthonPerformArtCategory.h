//
//  testTableTableViewController.h
//  Login
//
//  Created by Liu fushan on 15/5/17.
//  Copyright (c) 2015年 culturalCenter. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ForthonPerformArtCategory : UIViewController <UITableViewDataSource, UITableViewDelegate, LoginAndRefresh >

@property (nonatomic, assign) id <SpiderDelegate> delegate;
@property int categoryIndex;

@end

