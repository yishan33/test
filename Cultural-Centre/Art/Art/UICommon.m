//
//  UICommon.m
//  Art
//
//  Created by Tang yuhua on 15/5/13.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "UICommon.h"
#import "ForthonTapGesture.h"

@implementation UICommon

-(UIView *)navTitle: (NSString *)title{
    NSLog(@"navTitle");
    
    UILabel *titleLable = [[UILabel alloc]init];
    titleLable.frame = CGRectMake(0, 0,self.window.frame.size.width , 44);
    titleLable.font = [UIFont boldSystemFontOfSize:17.0];
    titleLable.text = title;
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.textColor = AppColor;

    return titleLable;
}

-(UIImageView *) imageName:(NSString *) name
                     frame:(CGRect )frame
                       tag:(NSInteger )tag
               buttonTitle:(NSString *)title
                  delegate:(id)targ
        
{
    UIImageView *temp = [[UIImageView alloc]init];
    temp.frame = frame;
    temp.image = [UIImage imageNamed:name];
    temp.userInteractionEnabled = YES;
   
    
    UILabel *label = [UILabel new];
    label.frame = CGRectMake((temp.frame.size.width-100)/2, (temp.frame.size.height-40)/2, 100, 40);
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = AppColor;
    label.backgroundColor = ButtonColor;
    [label.layer setCornerRadius:10.0f];
    label.layer.borderColor = [UIColor clearColor].CGColor;
    label.layer.borderWidth = 1.0;
    label.clipsToBounds = YES;

    ForthonTapGesture *tap = [[ForthonTapGesture alloc] initWithTarget:targ action:@selector(onClickButton:)];
    tap.tag = tag;
    [temp addGestureRecognizer:tap];
//    label.tag = tag;
//    NSLog(@"tag: %ld", button.tag);
    [temp addSubview:label];
    return temp;
}

- (void)onClickButton:(id)sender
{
    NSLog(@"i am button");
}

@end
