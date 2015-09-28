//
//  ForthonSkimPersonCellMeasurement.h
//  Art
//
//  Created by Liu fushan on 15/6/19.
//  Copyright (c) 2015年 test. All rights reserved.
//

#ifndef Art_ForthonSkimPersonCellMeasurement_h
#define Art_ForthonSkimPersonCellMeasurement_h


#endif


#define WIDTH [UIScreen mainScreen].applicationFrame.size.width
#define HEIGHT [UIScreen mainScreen].applicationFrame.size.height

#define PERSONWIDTHPERCENTAGE WIDTH / 720
#define PERSONHEIGHTPERCENTAGE HEIGHT / 1250


#define PERSON_L_INTERVAL 80 * PERSONWIDTHPERCENTAGE  //距离屏幕左右间隔
#define PERSON_R_INTERVAL 45 * PERSONWIDTHPERCENTAGE

#define PERSONBACKVIEWWIDTH WIDTH
#define PERSONBACKVIEWHEIGHT 160 * PERSONHEIGHTPERCENTAGE   //CELL视图长宽

#define PERSONIMAGESIDE 110 * PERSONWIDTHPERCENTAGE     //图片直径

#define PERSON_M_INTERVAL 35 * PERSONWIDTHPERCENTAGE // 图片与名字中间间隔

#define PERSONNAMEWIDTH 250 * PERSONWIDTHPERCENTAGE     //名字Label  长宽
#define PERSONNAMEHEIGHT 40 * PERSONHEIGHTPERCENTAGE

#define PERSONFANSWIDTH 150 * PERSONWIDTHPERCENTAGE
#define PERSONFANSHEIGHT 35 * PERSONHEIGHTPERCENTAGE   //粉丝数Label  长宽

#define PERSONATTENTIONWIDTH 50 * WIDTH / 320
#define PERSONATTENTIONHEIGHT 20 * HEIGHT / 480    // 关注按钮长宽



