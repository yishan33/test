//
//  ForthSkimPersonCell.h
//  Art
//
//  Created by Liu fushan on 15/6/18.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForthonVideoCell.h"
#import "ForthonSkimPersonCellMeasurement.h"



//@protocol <#protocol name#> <NSObject>
//
//<#methods#>
//
//@end


@interface ForthSkimPersonCell : UITableViewCell<LoginAndRefresh>



@property (nonatomic, strong) UIButton *attentionButton;
@property (nonatomic, strong) UIImageView *headImageView;

- (void)loadCellView;
- (void)loadWithData:(NSDictionary *)dic;
- (void)getFollowStatus;

@property (nonatomic, strong) id <SetAndCancelFollow> delegate;
@property (nonatomic, assign) id <LoginAndRefresh> loginDelegate;
@property (nonatomic, assign) id <PushDescriptionView> pushDelegate;

@end
