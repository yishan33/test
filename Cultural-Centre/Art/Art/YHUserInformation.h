//
//  YHUserInformation.h
//  Art
//
//  Created by Tang yuhua on 15/6/30.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol UpLoadImage <NSObject>

-(void)uploadPhotoWithImage:(UIImage *)image;

@end

@interface YHUserInformation : UITableViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) id <UpLoadImage> delegate;
@property (nonatomic, strong) id <Logout> logoutDelegate;

@end
