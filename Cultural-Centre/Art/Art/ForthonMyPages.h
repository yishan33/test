//
//  ForthonMyPages.h
//  Art
//
//  Created by Liu fushan on 15/7/3.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ForthonMyPages : UIViewController <LoginAndRefresh, pushPageDelegate>

@property (nonatomic, strong) id <GetMyPage> delegate;

@end
