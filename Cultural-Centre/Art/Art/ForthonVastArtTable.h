//
//  ForthonVastArtTable.h
//  Login
//
//  Created by Liu fushan on 15/5/20.
//  Copyright (c) 2015年 culturalCenter. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface ForthonVastArtTable : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property int categoryIndex;
@property BOOL canTrady;
@property (nonatomic, strong) NSString *typeStr;

@property (retain, nonatomic) id<SpiderDelegate> delegate;



@end
