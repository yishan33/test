//
//  measurement.h
//  Login
//
//  Created by Liu fushan on 15/5/18.
//  Copyright (c) 2015年 culturalCenter. All rights reserved.
//

#ifndef Login_measurement_h
#define Login_measurement_h


#endif

#define WIDTH [UIScreen mainScreen].applicationFrame.size.width     //获取屏幕宽度
#define HEIGHT [UIScreen mainScreen].applicationFrame.size.height    //获取屏幕长度
#define WIDTHPERCENTAGE WIDTH / 320.0  //获取横向比例，用屏幕宽度除以 iphone4的宽度
#define HEIGHTPERCENTAGE HEIGHT / 480.0//获取纵向比例，用屏幕宽度除以 iphone4的高度

#define BACKVIEWWIDTH WIDTH  //小视图中放控件。小视图的宽度为屏幕的宽度
#define BACKVIEWHEIGHT (TOPVIEWHEIGHT + IMAGEVIEWHEIGHT +BUTTOMVIEWHEIGHT)  //小视图的高度在iphone4中为190

#define TOPINSET 10 * HEIGHTPERCENTAGE //顶部控件离上边缘的间距
#define SIDEINSET 10 * WIDTHPERCENTAGE //两边控件离左右边缘的间距

#define TOPVIEWHEIGHT WIDTHPERCENTAGE * 50 //顶部视图的高度
#define HEADIMAGESIDE WIDTHPERCENTAGE * 35 //头像的边长，头像的边长和昵称的高度一样

#define IMAGEVIEWHEIGHT WIDTH / 2

#define BUTTOMVIEWHEIGHT 22 * HEIGHTPERCENTAGE
#define BUTTOMVIEWINTERVAL (WIDTH - 260 - 2 * SIDEINSET) / 3

