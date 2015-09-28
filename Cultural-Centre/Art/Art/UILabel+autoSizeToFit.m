//
//  UILabel+autoSizeToFit.m
//  Art
//
//  Created by Liu fushan on 15/7/28.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "UILabel+autoSizeToFit.h"

@implementation UILabel (autoSizeToFit)


- (void)labelAutoCalculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize

{
    
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    
    NSDictionary* attributes =@{
                                NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName:paragraphStyle.copy
                                };
    
    CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    
    labelSize.height = (CGFloat) ceil(labelSize.height);
    labelSize.width = (CGFloat) ceil(labelSize.width);
    
    CGRect frame = self.frame;
    frame.size.width = labelSize.width;
    frame.size.height = labelSize.height;
    [self setText:text];
    [self setFont:[UIFont systemFontOfSize:fontSize]];
    self.frame = frame;
}


@end
