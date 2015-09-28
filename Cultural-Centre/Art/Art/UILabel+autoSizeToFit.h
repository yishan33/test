//
//  UILabel+autoSizeToFit.h
//  Art
//
//  Created by Liu fushan on 15/7/28.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (autoSizeToFit)

- (void)labelAutoCalculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize;

@end
