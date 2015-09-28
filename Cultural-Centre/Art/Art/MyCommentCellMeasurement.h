//
//  MyCommentCellMeasurement.h
//  Art
//
//  Created by Liu fushan on 15/7/3.
//  Copyright (c) 2015年 test. All rights reserved.
//

#ifndef Art_MyCommentCellMeasurement_h
#define Art_MyCommentCellMeasurement_h


#endif

#define WIDTH [UIScreen mainScreen].applicationFrame.size.width
#define HEIGHT [UIScreen mainScreen].applicationFrame.size.height


#define WIDTHPERCENTAGE WIDTH / 720
#define HEIGHTPERCENTAGE HEIGHT / 1250  //我的评论Cell视图分上中下三个视图构成

#define BACKVIEWWIDTH WIDTH
#define BACKVIEWHEIGHT 365 * HEIGHTPERCENTAGE + replyLabelSize.height   //整个CELL高度为400

#define SIDEINTERVAL 40 * WIDTHPERCENTAGE//整体视图距离左右边缘的间隔为 40

#define TOPINTERVAL 15 * HEIGHTPERCENTAGE//顶部视图距离CELL上边缘的间隔为 15

#define TOPVIEWWIDTH WIDTH
#define TOPVIEWHEIGHT 110 * HEIGHTPERCENTAGE    //顶部视图的高度为 110

#define HEADIMAGESIDE 110 * HEIGHTPERCENTAGE //头像边长为 110

#define N_TOP_INTERVAL 15 * HEIGHTPERCENTAGE //名字Label与TOPVIEW顶部的间隔为 15

#define I_N_INTERVAL 40 * WIDTHPERCENTAGE     //头像与名字Label之间间隔为 25

#define NAMELABELWIDTH 300 * WIDTHPERCENTAGE   //名字Label宽度为 300
#define NAMELABELHEIGHT 45 * HEIGHTPERCENTAGE //名字Label高度为 45

#define N_T_INTERVAL 10 * HEIGHTPERCENTAGE //名字Label与时间Label之间的间隔为 10

#define TIMELABELWIDTH 300 * WIDTHPERCENTAGE //时间Label宽度为 300
#define TIMELABELHEIGHT 30 * HEIGHTPERCENTAGE //时间Label高度为 30

#define T_M_INTERVAL 15 * HEIGHTPERCENTAGE //顶部视图与中间视图之间的间隔为 15

#define MIDDLEVIEWWIDTH WIDTH
#define MIDDLEVIEWHEIGHT replyLabelSize.height   //中间视图高度为 40

#define REPLYLABELWIDTH 480 * WIDTHPERCENTAGE    //回复内容Label的宽度为 480
#define REPLYLABELHEIGHT 40 * HEIGHTPERCENTAGE  //回复内容Label的高度为 40

#define REPLYBUTTONWIDTH 95 * WIDTHPERCENTAGE   //回复按键的宽度为  95
#define REPLYBUTTONHEIGHT 40 * HEIGHTPERCENTAGE //回复按键的高度为  40

#define M_B_INTERVAL 10 * HEIGHTPERCENTAGE      //中间视图与底部视图之间的间隔为 10

#define BUTTOMVIEWWIDTH WIDTH - 2 * SIDEINTERVAL
#define BUTTOMVIEWHEIGTH 175 * HEIGHTPERCENTAGE  //底部视图高度为 175



#define PICTUREHEIGHT 175 * HEIGHTPERCENTAGE
#define PICTUREWIDTH PICTUREHEIGHT * (23.0 / 20.0)

#define P_N_INTERVAL 30 * WIDTHPERCENTAGE //回复中的图片与名字Label之间的间隔  30

#define N_INTERVAL 10 * HEIGHTPERCENTAGE    //回复中被评论者名字Label距离BUTTOMVIEW上边缘的间隔为   10

#define REPLYCONTENTNAMELABELWIDTH  (WIDTH - 2 * SIDEINTERVAL - PICTUREWIDTH - 2 * P_N_INTERVAL)   //回复内容中被评论者名字Label宽度为   300
#define REPLYCONTENTNAMELABELHEIGHT 40 * HEIGHTPERCENTAGE//回复内容中被评论者名字Label高度为   40

#define N_D_INTERVAL 10 * HEIGHTPERCENTAGE//回复内容中被评论者名字Label与详情Label之间的间隔为 10

#define REPLYDESCRIPTIONWIDTH (WIDTH - 2 * SIDEINTERVAL - PICTUREWIDTH - P_N_INTERVAL)   //回复中被评论作品详情Label宽度为 300
#define REPLYDESCRIPTIONHEIGHT 20    //回复中被评论作品详情Label高度为 30

#define BUTTOMINTERVAL 30 * HEIGHTPERCENTAGE//底部视图距离CELL下边缘的间隔为 30