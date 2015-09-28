//
//  ForthonAuthorDescription.h
//  Art
//
//  Created by Liu fushan on 15/6/22.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ForthonAuthorDescription : UIViewController<LoginAndRefresh, ForthonWorkCellDelegate, pushPageDelegate>

@property (nonatomic, strong) id <AuthorDataDelegate> delegate;
@property (nonatomic, strong) id <SetAndCancelFollow> followDelegate;
@property (nonatomic, strong) NSMutableDictionary *authorDic;

@end
