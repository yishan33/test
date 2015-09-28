//
//  SearchVC.h
//  Art
//
//  Created by Tang yuhua on 15/4/28.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface SearchVC : UIViewController

@property (nonatomic, strong) id <SearchDelegate> resultDelegate;

@end
