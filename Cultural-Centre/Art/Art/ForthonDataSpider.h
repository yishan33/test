//
//  ForthonDataSpider.h
//  Login
//
//  Created by Liu fushan on 15/5/16.
//  Copyright (c) 2015年 culturalCenter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ForthonDataContainer.h"
#import "YHUserInformation.h"

@interface ForthonDataSpider : NSObject <SetAndCancelFollow, SendAndGetComment, ArtDescriptionSpiderDelegate, ResetPassword, Register, AppLogin, Logout, addAndCancelFavor, SpiderDelegate, SubmitOrderDelegate, AuthorDataDelegate, GetCommentContentData, pageSpiderDelegate, SkimViewDelegate, SearchDelegate, GetMyComment, GetMyPage, GetMyFollow, CancelFollow, GetMyWork, ModifyPassword, ModifyPhoneNumber, ModifyUserHeadImage, ModifyUserName, ModifyUserNick, GetMyFavor, ShareDelegate, GetVideoCommentDelegate, SetCommentRead, GetUnreadNumber, UpLoadImage, FeedBackDelegate, addPageNumbers, addArtNumgers, OrderProtocolDelegate, BannerDelegate, VersionDelegate>

@property (nonatomic, strong) NSString *userNick;
@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *phoneNumber;

@property (nonatomic, strong) NSString *shareUrl;


+ (ForthonDataSpider *)sharedStore;

@end
