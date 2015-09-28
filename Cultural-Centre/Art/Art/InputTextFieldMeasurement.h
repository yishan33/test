//
//  InputTextFieldMeasurement.h
//  Art
//
//  Created by Liu fushan on 15/6/18.
//  Copyright (c) 2015年 test. All rights reserved.
//

#ifndef Art_InputTextFieldMeasurement_h
#define Art_InputTextFieldMeasurement_h


#endif


#define WIDTH [UIScreen mainScreen].applicationFrame.size.width      //获取屏幕宽度
#define HEIGHT [UIScreen mainScreen].applicationFrame.size.height//获取屏幕长度

#define WIDTHPERCENTAGE WIDTH / 320.0  //获取横向比例，用屏幕宽度除以 iphone4的宽度
#define HEIGHTPERCENTAGE HEIGHT / 480.0//获取纵向比例，用屏幕宽度除以 iphone4的高度

#define BACKVIEWWIDTH WIDTH + 2
#define BACKVIEWHEIGHT 48 * HEIGHTPERCENTAGE

#define L_INTERVAL 20 * WIDTHPERCENTAGE
#define B_INTERVAL 12 * HEIGHTPERCENTAGE

#define SENDBUTTONSIDE 30 * WIDTHPERCENTAGE
#define INTERVALRIGHT 20 * WIDTHPERCENTAGE

#define TEXTWIDTH WIDTH - L_INTERVAL - SENDBUTTONSIDE - INTERVALRIGHT
#define TEXTHEIGHT BACKVIEWHEIGHT - B_INTERVAL

#define LINEINTERVAL 2 * WIDTHPERCENTAGE
#define LINEHEIGHT 5 * HEIGHTPERCENTAGE

#define LINEWIDTH 2

#define KEYBOARDHEIGHT 250

#define SIDEINTERVAL 15 * WIDTH / 480