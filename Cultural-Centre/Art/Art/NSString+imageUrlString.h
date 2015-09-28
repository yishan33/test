//
//  NSString+imageUrlString.h
//  Art
//
//  Created by Liu fushan on 15/7/13.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (imageUrlString)

- (NSString *)changeToUrl;
+ (NSString *)stringWithHTMLData:(NSString *)htmlStr;
+ (NSString *)imageUrlWithHTMLData:(NSString *)htmlStr;

@end
