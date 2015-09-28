//
//  LoginMeasurement.h
//  Login
//
//  Created by Liu fushan on 15/6/1.
//  Copyright (c) 2015年 culturalCenter. All rights reserved.
//

#ifndef Login_LoginMeasurement_h
#define Login_LoginMeasurement_h


#endif

//  数字均代表iphone4中的具体大小，具体大小乘以比例即自动匹配不同尺寸屏幕

#define WIDTH self.view.bounds.size.width      //获取屏幕宽度
#define HEIGHT self.view.bounds.size.height    //获取屏幕长度
#define WIDTHPERCENTAGE WIDTH / 320.0  //获取横向比例，用屏幕宽度除以 iphone4的宽度
#define HEIGHTPERCENTAGE HEIGHT / 480.0//获取纵向比例，用屏幕宽度除以 iphone4的高度

#define BACKVIEWWIDTH WIDTHPERCENTAGE * 220  //一个小视图，小视图中放控件。小视图的宽度在iphone4中为220
#define BACKVIEWHEIGHT HEIGHTPERCENTAGE * 296                       //小视图的高度再iphone4中为296

#define IMAGEWIDTH WIDTHPERCENTAGE * 90      //登录页面的logo放在小视图中，logo在iphone4中长宽均为90

#define TEXTFIELDWIDTH BACKVIEWWIDTH        //输入框的宽度等同小视图。
#define TEXTFIELDHEIGHT HEIGHTPERCENTAGE * 30

#define BUTTONWIDTH BACKVIEWWIDTH          //登录按键的宽度等同小视图。
#define BUTTONHEIGHT HEIGHTPERCENTAGE * 35

#define LABELWIDTH WIDTHPERCENTAGE * 70   //快速注册，忘记密码 宽度为70
#define LABELHEIGHT HEIGHTPERCENTAGE * 20

#define INTERVAL HEIGHTPERCENTAGE * 13   //登录页面，帐号输入框与密码输入框之间的间隔，密码输入框与登录按键的间隔，登录按键与之下的白线的间隔，间隔数值在iphone中为13

