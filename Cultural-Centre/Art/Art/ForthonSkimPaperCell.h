//
//  ForthonSkimPaperCell.h
//  Art
//
//  Created by Liu fushan on 15/6/18.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForthonSkimPaperCellMeasurement.h"





@interface ForthonSkimPaperCell : UITableViewCell

- (ForthonSkimPaperCell *)initAndLoad;

- (void)loadCellView;
- (void)loadWithData:(NSDictionary *)dic;


@end
