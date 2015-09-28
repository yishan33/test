//
//  NSString+imageUrlString.m
//  Art
//
//  Created by Liu fushan on 15/7/13.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "NSString+imageUrlString.h"
#import "NSString+regular.h"

@implementation NSString (imageUrlString)


- (NSString *)changeToUrl {
    
    NSString *urlStr = [NSString stringWithFormat:@"http://120.26.222.176:8080%@", self];
    return urlStr;
}

+ (NSString *)stringWithHTMLData:(NSString *)htmlStr {

    NSString *responseString = htmlStr;
    NSString *regstr1 = @"\\d*[\u4e00-\u9fa5]+[^<]+";
    NSArray *responseTextArray = [responseString substringArrayByRegular:regstr1];
    NSMutableString *resultString = [[NSMutableString alloc] init];

    for (int j = 0; j < responseTextArray.count; j++) {

        [resultString appendString:responseTextArray[j]];
    }

    return resultString;
}

+ (NSString *)imageUrlWithHTMLData:(NSString *)htmlStr {

    NSString *responseString = htmlStr;
    NSString *imageRegular = @"/up\\S+png";
    NSString *imageUrlStringBody;
    if ([[responseString substringArrayByRegular:imageRegular] count]) {
        imageUrlStringBody = [responseString substringArrayByRegular:imageRegular][0];
    } else {
        imageUrlStringBody = @"";
    }

    return [imageUrlStringBody changeToUrl];
}

@end
