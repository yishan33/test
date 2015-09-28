//
//  ForthonAllComments.h
//  Art
//
//  Created by Liu fushan on 15/6/16.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <UIKit/UIKit.h>







@interface ForthonAllComments : UIViewController <UITableViewDataSource, UITableViewDelegate, LoginAndRefresh>

@property (nonatomic, strong) NSString *workId;
@property int typeId;

@property (strong, nonatomic) id<SendAndGetComment> delegate;
@property (strong, nonatomic) id<LoginAndRefresh> loginDelegate;


@end
