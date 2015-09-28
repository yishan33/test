//
//  ForthonVideoDescription.h
//  Art
//
//  Created by Liu fushan on 15/7/6.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ForthonVideoDescription : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate,  Login, PushDescriptionView, RefreshView>

@property int categoryIndex;

@property (nonatomic, strong) NSMutableDictionary *videoModelDic;
@property (nonatomic, strong) NSString *skimNumberStr;

@property (nonatomic, assign) id<VideoAddSkim> addSkimNumberDelegate;

@end
