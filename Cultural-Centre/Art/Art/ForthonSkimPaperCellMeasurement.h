//
//  ForthonSkimPaperCellMeasurement.h
//  Art
//
//  Created by Liu fushan on 15/6/18.
//  Copyright (c) 2015年 test. All rights reserved.
//

#ifndef Art_ForthonSkimPaperCellMeasurement_h
#define Art_ForthonSkimPaperCellMeasurement_h


#endif


#define WIDTH [UIScreen mainScreen].applicationFrame.size.width
#define HEIGHT [UIScreen mainScreen].applicationFrame.size.height

#define PAPERWIDTHPERCENTAGE WIDTH / 720
#define PAPERHEIGHTPERCENTAGE HEIGHT / 1250


#define PAPERBACKVIEWWIDTH WIDTH
#define PAPERBACKVIEWHEIGHT 240 * PAPERHEIGHTPERCENTAGE  //cell视图的长宽

#define PAPERSIDEINTERVAL 35 * PAPERWIDTHPERCENTAGE    //与屏幕两侧间隔     美工原图：45

#define TBINTERVAL 20 * PAPERHEIGHTPERCENTAGE    //顶、底部间隔

#define TDINTERVAL 10     //标题和详情间隔


#define IMAGEWIDTH 230 * PAPERWIDTHPERCENTAGE    //图片的长宽比例
#define IMAGEHEIGHT 200 * PAPERHEIGHTPERCENTAGE 

#define TITLEWIDTH 380 * PAPERWIDTHPERCENTAGE      //标题的长宽       美工原图：360
#define TITLEHEIGHT 130 * PAPERHEIGHTPERCENTAGE

#define DESCRIPTIONWIDTH 380 * PAPERWIDTHPERCENTAGE
#define DESCRIPTIONHEIGHT 140 * PAPERHEIGHTPERCENTAGE - TDINTERVAL   //文字详情长宽




