//
//  ForthonMyFollowCell.h
//  Art
//
//  Created by Liu fushan on 15/7/5.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForthonSkimPersonCellMeasurement.h"


@interface ForthonMyFollowCell : UITableViewCell

@property (nonatomic, strong) id <CancelFollow> delegate;
@property (nonatomic, strong) id <UpdateTable> updateDelegate;
@property (nonatomic, strong) id <PushAuthorDelegate> authorDelegate;


- (void)loadWithData:(NSDictionary *)dic;

@end
