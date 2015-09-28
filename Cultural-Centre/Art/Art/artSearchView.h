//
//  artSearchView.h
//  Art
//
//  Created by Liu fushan on 15/7/16.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface artSearchView : UIViewController

/**
 *  默认不判别是否可交易
 */

@property BOOL isTrade;
@property int typeId;
@property (nonatomic, copy) NSString *typeStr;

@property (nonatomic, assign) id<ArtSearchDelegate> searchDelegate;


@end
