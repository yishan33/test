//
//  NSString+regular.h
//  macSpider
//
//  Created by Liu fushan on 15/5/22.
//  Copyright (c) 2015年 culturalCenter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (regular)

- (NSMutableArray *)substringArrayByRegular:(NSString *)regular;

- (NSString *)substringByRegular:(NSString *)regular;
- (BOOL)checkToMarkPhone;
- (BOOL)checkToMarkPassword;
- (BOOL)checkToMarkUserName;
- (BOOL)checkToMarkNick;
- (BOOL)checkToMarkCode;

@end
