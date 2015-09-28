//
//  ForthonDataContainer.h
//  Login
//
//  Created by Liu fushan on 15/5/18.
//  Copyright (c) 2015年 culturalCenter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ForthonDataContainer : NSObject

@property (nonatomic, strong) NSArray *imagesArray;
@property (nonatomic, strong) NSArray *tradeImagesArray;

@property (nonatomic, strong) NSMutableArray *videosDic;
@property (nonatomic, strong) NSMutableArray *artListDic;
@property (nonatomic, strong) NSMutableArray *artTradeListDic;

@property (nonatomic, strong) NSMutableDictionary *artDescriptionDic;
@property (nonatomic, strong) NSMutableArray *pagesDic;
@property (nonatomic, strong) NSMutableDictionary *commentsDic;



@property (nonatomic, strong) NSMutableDictionary *skimsDic;    //点击排行
@property (nonatomic, strong) NSArray *commentTop;
@property (nonatomic, strong) NSArray *skimTop;
@property (nonatomic, strong) NSArray *newsTop;


@property (nonatomic, strong) NSMutableArray *artSearchResultArray;   //艺术品搜索结果

@property (nonatomic, strong) NSMutableDictionary *searchResultDic;
@property (nonatomic, strong) NSMutableArray *authorArtGroup;


@property (nonatomic, strong) NSMutableDictionary *pageDic;
@property (nonatomic, strong) NSMutableDictionary *followDic;

@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, strong) NSString *userNickName; //个人信息
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *phoneNumber;

#pragma mark MY!

@property (nonatomic, strong) NSMutableArray *myPages;
@property (nonatomic, strong) NSMutableArray *myFollows;
@property (nonatomic, strong) NSMutableArray *myFavors;
@property (nonatomic, strong) NSMutableArray *myComments;
@property (nonatomic, strong) NSNumber *unReadCommentsNumber;
@property (nonatomic, strong) NSMutableArray *myWorks;


@property (nonatomic, strong) NSMutableDictionary *userInfo; //作者详情
@property (nonatomic, strong) NSString *appIsLogin;

@property (nonatomic, copy) NSString *orderProtocol;

+ (instancetype)sharedStore;

@end
