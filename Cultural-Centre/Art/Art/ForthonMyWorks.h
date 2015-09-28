//
//  ForthonMyWorks.h
//  Art
//
//  Created by Liu fushan on 15/7/3.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshControl.h"


@interface ForthonMyWorks : UIViewController <RefreshControlDelegate>

@property (strong, nonatomic) id <GetMyWork> delegate;

@end
