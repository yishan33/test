//
//  ForthonOrderProtocolView.h
//  Art
//
//  Created by Liu fushan on 15/8/17.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForthonOrderProtocolView : UIViewController <UIWebViewDelegate>

@property (nonatomic, assign) id <OrderProtocolDelegate> delegate;

@end
