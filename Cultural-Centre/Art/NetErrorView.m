//
//  NetErrorView.m
//  Art
//
//  Created by Liu fushan on 15/8/11.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "NetErrorView.h"

@implementation NetErrorView


- (id)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];

    if (self) {

        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;

        UIImageView *loadImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100 * width / 320, 80 * height / 480)];
        loadImage.center = CGPointMake(self.center.x, height / 2);
        loadImage.image = [UIImage imageNamed:@"ic_error_page.png"];

        _loadButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
        _loadButton.center = CGPointMake(self.center.x, height / 2 + 40 * height / 480 + 25);
        _loadButton.backgroundColor = [UIColor blackColor];
        [_loadButton setTitle:@"点击重试" forState:UIControlStateNormal];
        [_loadButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];

        [self addSubview:loadImage];
        [self addSubview:_loadButton];
        self.backgroundColor = [UIColor whiteColor];
    }

    return  self;
}



@end
