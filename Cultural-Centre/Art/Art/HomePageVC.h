//
//  HomePageVC.h
//  Art
//
//  Created by Tang yuhua on 15/4/28.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "YHAppreciateArtVC.h"
#import "YHArtTradeVC.h"

@interface HomePageVC : UIViewController <ForthonWorkCellDelegate, UIAlertViewDelegate>

@property (nonatomic, assign) id<BannerDelegate> delegate;

@end
