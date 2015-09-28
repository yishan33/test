//
//  ForthonMyFollows.h
//  Art
//
//  Created by Liu fushan on 15/7/3.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ForthonMyFollows : UIViewController <LoginAndRefresh>

@property (strong, nonatomic) id <GetMyFollow> delegate;



@end
