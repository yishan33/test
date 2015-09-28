//
//  SkimVC.h
//  Art
//
//  Created by Tang yuhua on 15/4/28.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface SkimVC : UIViewController <UIScrollViewDelegate,UITableViewDataSource, UITableViewDelegate, LoginAndRefresh, PushDescriptionView>


@property (strong, nonatomic) id<SkimViewDelegate>delegate;


@end
