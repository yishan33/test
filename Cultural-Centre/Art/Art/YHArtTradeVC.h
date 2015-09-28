//
//  YHArtTradeVC.h
//  Art
//
//  Created by Tang yuhua on 15/5/17.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AdScrollView;
@interface YHArtTradeVC : UIViewController
{

    __weak IBOutlet UIButton *tradeOfArt;
    __weak IBOutlet UIButton *joinOfArt;
    __weak IBOutlet UIView *contentView;
    
    UIViewController *currentViewController;
}

-(IBAction)onClickbutton:(id)sender;

@end
