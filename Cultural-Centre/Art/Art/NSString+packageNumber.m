//
//  NSString+packageNumber.m
//  Art
//
//  Created by Liu fushan on 15/7/12.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "NSString+packageNumber.h"

@implementation NSString (packageNumber)


- (NSString *)numberToString
{
    NSString *returnStr = self;
    
    if (returnStr.intValue >= 1000) {
        
        NSString *thousandStr = [NSString stringWithFormat:@"%i", returnStr.intValue / 1000];
        NSString *otherStr = [[NSString alloc] init];
        
        if ([thousandStr intValue] > 9) {
            
            thousandStr = [NSString stringWithFormat:@"%i", returnStr.intValue / 10000];
            if (returnStr.intValue % 10000 / 1000 != 0) {
                
                otherStr = [NSString stringWithFormat:@".%i", returnStr.intValue % 10000 / 1000];
            }
            returnStr = [NSString stringWithFormat:@"%@%@W", thousandStr, otherStr];
            
        } else {
            
            if (returnStr.intValue % 1000 / 100 != 0) {
                
                otherStr = [NSString stringWithFormat:@".%i", returnStr.intValue % 1000 / 100];
            }
            returnStr = [NSString stringWithFormat:@"%@%@K", thousandStr, otherStr];
        }
    }
        
    return returnStr;
}

@end
