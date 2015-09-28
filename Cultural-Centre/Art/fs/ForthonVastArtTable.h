//
//  ForthonVastArtTable.h
//  Login
//
//  Created by Liu fushan on 15/5/20.
//  Copyright (c) 2015年 culturalCenter. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SpiderDelegate <NSObject>

- (void)getArtListByTypeid:(int)typeid trade:(BOOL)trade page:(int)page;

@end


@interface ForthonVastArtTable : UITableViewController

@property int categoryIndex;

@property (retain, nonatomic) id<SpiderDelegate> delegate;

@end
