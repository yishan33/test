//
//  AuthorDescriptionMeasurement.h
//  Art
//
//  Created by Liu fushan on 15/6/22.
//  Copyright (c) 2015年 test. All rights reserved.
//

#ifndef Art_AuthorDescriptionMeasurement_h
#define Art_AuthorDescriptionMeasurement_h



#define WIDTH [UIScreen mainScreen].applicationFrame.size.width
#define HEIGHT [UIScreen mainScreen].applicationFrame.size.height  //屏幕长宽高

#define WIDTHPERCENTAGE WIDTH / 320
#define HEIGHTPERCENTAGE HEIGHT / 480

#define SIDEINTERVAL 15 * WIDTHPERCENTAGE  //离屏幕左右间距

#define TOPINTERVAL (10 * HEIGHTPERCENTAGE + 64)

#define IMAGESIDE  50 * WIDTHPERCENTAGE    //头像图片直径

#define NAMELABELWIDTH 100 * WIDTHPERCENTAGE
#define NAMELABELHEIGHT 20 * HEIGHTPERCENTAGE


#define ATTENTIONBUTTONWIDTH 50 * WIDTHPERCENTAGE   //关注按键长宽
#define ATTENTIONBUTTONHEIGHT 20 * HEIGHTPERCENTAGE

#define MIDINTERVAL 10 * HEIGHTPERCENTAGE  //头像与详情的jianju

#define DESCRIPTIONTEXTWIDTH  WIDTH - 3 * SIDEINTERVAL - IMAGESIDE
#define DESCRIPTIONTEXTHEIGHT IMAGESIDE + ATTENTIONBUTTONHEIGHT + 5 * HEIGHTPERCENTAGE    //详情介绍    暂定长度100  应视返回内容而定。

#define BUTTOMINTERVAL 10 * HEIGHTPERCENTAGE

#define CATEGORYBUTTONWIDTH  WIDTH / 2 
#define CATEGORYBUTTONHEIGHT 20 * HEIGHTPERCENTAGE

#define BACKVIEWWIDTH WIDTH
#define BACKVIEWHEIGHT (IMAGESIDE + 2 * MIDINTERVAL + ATTENTIONBUTTONHEIGHT + CATEGORYBUTTONHEIGHT)    //顶部视图的长,为图片，间距，详情，按键的长加起来.



#endif
