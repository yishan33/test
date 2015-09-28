//
//  UICommon.h
//  Art
//
//  Created by Tang yuhua on 15/5/13.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Common.h"

@interface UICommon : UIView

-(UIView *)navTitle: (NSString *)title;
-(UIImageView *) imageName:(NSString *) name
                     frame:(CGRect )frame
                       tag:(NSInteger )tag
               buttonTitle:(NSString *)title
                  delegate:(id)targ  ;


@end
