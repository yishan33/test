//
//  ForhonCommentArtTable.h
//  Login
//
//  Created by Liu fushan on 15/5/21.
//  Copyright (c) 2015年 culturalCenter. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface ForthonCommentArtTable : UIViewController <UITableViewDelegate, UITableViewDataSource, LoginAndRefresh, RefreshView, pushPageDelegate>

@property (nonatomic, strong) id<pageSpiderDelegate> delegate;




@end
