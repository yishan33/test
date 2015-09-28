//
//  commentCellMeasurement.h
//  Art
//
//  Created by Liu fushan on 15/6/7.
//  Copyright (c) 2015年 test. All rights reserved.
//

#ifndef Art_commentCellMeasurement_h
#define Art_commentCellMeasurement_h


#endif






#define CELLWIDTH [UIScreen mainScreen].applicationFrame.size.width
#define CELLHEIGHT [UIScreen mainScreen].applicationFrame.size.height

#define CELLWIDTHPERCENTAGE CELLWIDTH / 320
#define CELLHEIGHTPERCENTAGE CELLHEIGHT / 480

#define CELLBACKVIEWWIDTH CELLWIDTH
#define CELLBACKVIEWHEIGHT contentLabelSize.height + NAMELABELHEIGHT + TIMELABELHEIGHT + 4 * CELLSIDEINTERVAL

#define CELLSIDEINTERVAL 10

#define IMAGESIDE 30

#define NAMELABELWIDTH CELLWIDTH - (2 * CELLSIDEINTERVAL + IMAGESIDE)
#define NAMELABELHEIGHT 15

#define CONTENTLABELWIDTH 250 * CELLWIDTHPERCENTAGE
#define CONTENTLABELHEIGHT 10

#define TIMELABELWIDTH 200
#define TIMELABELHEIGHT 10

#define HEIGHTNOCONTENT  (NAMELABELHEIGHT + TIMELABELHEIGHT + 4 * CELLSIDEINTERVAL)  //cell高度减去content的高度



//2015-06-07 14:57:06.366 Art[8732:119053] cell height: 76.702000
//2015-06-07 14:57:06.386 Art[8732:119053] index 2
//2015-06-07 14:57:06.386 Art[8732:119053] cellNoContentHeight: 66.807999
//2015-06-07 14:57:06.387 Art[8732:119053] name: 生命壹号
//2015-06-07 14:57:06.387 Art[8732:119053] cell height: 76.702000