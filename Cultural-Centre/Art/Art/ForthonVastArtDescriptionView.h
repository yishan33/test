//
//  ForthonVastArtDescriptionView.h
//  Login
//
//  Created by Liu fushan on 15/5/23.
//  Copyright (c) 2015年 culturalCenter. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface ForthonVastArtDescriptionView : UIViewController <UITableViewDelegate, UITableViewDataSource, LoginAndRefresh, Login, PushDescriptionView>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *descriptionText;
@property (strong, nonatomic) NSMutableDictionary *modelDic;
@property (strong, nonatomic) NSString *workId;

@property (strong, nonatomic) UIImage *headImage;
@property (strong, nonatomic) UIImage *pictureImage;
@property (strong, nonatomic) UILabel *descriptionLabel;

@property (strong, nonatomic) id <ArtDescriptionSpiderDelegate> delegate;
@property (assign, nonatomic) id <ShareDelegate> shareDelegate;
@property (assign, nonatomic) id <SendAndGetComment> commentDelegate;
@property (assign, nonatomic) id <Login> loginDelegate;
@property (assign, nonatomic) id <addArtNumgers> numberDelegate;

@end
