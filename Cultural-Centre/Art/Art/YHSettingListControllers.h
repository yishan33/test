//
//  YHSettingListControllers.h
//  Art
//
//  Created by Tang yuhua on 15/6/30.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YHAboutUSVC.h"
#import "YHAdviceVC.h"

@interface YHSettingListControllers : NSObject

-(id) viewController :(NSInteger) index;
-(void) clearCache;

@end
