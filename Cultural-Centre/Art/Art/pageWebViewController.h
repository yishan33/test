//
//  pageWebViewController.h
//  Login
//
//  Created by Liu fushan on 15/5/22.
//  Copyright (c) 2015年 culturalCenter. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface pageWebViewController : UIViewController <UIWebViewDelegate, UITextFieldDelegate,  UIScrollViewDelegate, UIGestureRecognizerDelegate,UITableViewDataSource, UITableViewDelegate, PushAuthorDelegate>

@property int tinyTag;
@property (strong, nonatomic) NSString *pageWebHTMLData;
@property (strong, nonatomic) NSString *workId;
@property (strong, nonatomic) NSString *titleStr;
@property int commentNumber;
@property (nonatomic, strong) NSMutableDictionary *pageDic;



@property (assign, nonatomic) id<SendAndGetComment> delegate;
@property (assign, nonatomic) id<ShareDelegate> shareDelegate;
@property (assign, nonatomic) id<LoginAndRefresh> loginDelegate;
@property (assign, nonatomic) id<PushAuthorDelegate> authorDelegate;
@property (assign, nonatomic) id<addPageNumbers> numberDelegate;
@property (assign, nonatomic) id<addAndCancelFavor>favorDelegate;



@end
