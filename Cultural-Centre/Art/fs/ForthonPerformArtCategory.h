//
//  testTableTableViewController.h
//  Login
//
//  Created by Liu fushan on 15/5/17.
//  Copyright (c) 2015年 culturalCenter. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol SpiderDelegate <NSObject>

- (NSString *)startCaptureData;
- (NSData *)captureImage;
- (void)getVideosByTypeid:(int)typeid page:(int)page;
@end


@interface ForthonPerformArtCategory : UITableViewController

@property (nonatomic, retain) id <SpiderDelegate> delegate;
@property int categoryIndex;
@end
