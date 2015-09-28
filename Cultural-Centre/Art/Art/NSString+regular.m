//
//  NSString+regular.m
//  macSpider
//
//  Created by Liu fushan on 15/5/22.
//  Copyright (c) 2015年 culturalCenter. All rights reserved.
//

#import "NSString+regular.h"

@implementation NSString (regular)


- (NSMutableArray *)substringArrayByRegular:(NSString *)regular
{
    NSString *reg = regular;
    NSRange range = [self rangeOfString:reg options:NSRegularExpressionSearch];
    NSMutableArray *arr = [NSMutableArray array];
    if (range.length != NSNotFound && range.length != 0) {
        int i = 0;
        while (range.length != NSNotFound && range.length != 0) {
            //            NSLog(@"index = %i regIndex = %i loc = %i", (++i), range.length, range.location);
            NSString *substr = [self substringWithRange:range];
            //            NSLog(@"substr = %@", substr);
            [arr addObject:substr];
            NSRange start = NSMakeRange((range.location + range.length), ([self length] - range.location - range.length));
            range = [self rangeOfString:reg options:NSRegularExpressionSearch range:start];
            
        }
    }
    return arr;
}

- (NSString *)substringByRegular:(NSString *)regular
{
    NSString *reg = regular;
    NSRange range = [self rangeOfString:reg options:NSRegularExpressionSearch];
    
    NSString *substr = [self substringWithRange:range];
    return substr;
}


- (BOOL)checkToMarkPhone {

    NSString *regular = @"(^(13\\d|14[57]|15[^4,\\D]|17[678]|18\\d)\\d{8}|170[059]\\d{7})$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regular];
    BOOL isValid = [predicate evaluateWithObject:self];

    return isValid;
}

- (BOOL)checkToMarkPassword {

    NSString *regular = @"^[a-zA-Z0-9]{6,16}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regular];
    BOOL isValid = [predicate evaluateWithObject:self];

    return isValid;

}

- (BOOL)checkToMarkUserName {

    NSString *regular = @"^[a-zA-Z0-9_]{6,30}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regular];
    BOOL isValid = [predicate evaluateWithObject:self];

    return isValid;
}

- (BOOL)checkToMarkNick {

    NSString *regular = @"^\\S{4,30}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regular];
    BOOL isValid = [predicate evaluateWithObject:self];

    return isValid;
}

- (BOOL)checkToMarkCode {

    NSString *regular = @"^[0-9]{6}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regular];
    BOOL isValid = [predicate evaluateWithObject:self];

    return isValid;
}


@end
