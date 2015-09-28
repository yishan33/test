//
//  YHStyleCell.h
//  demo
//
//  Created by Tang yuhua on 15/7/8.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHStyleCell : UITableViewCell

-(void)setStyleWithButton:(BOOL)withButton;
-(void)addTarget:(id) target selector:(SEL)selector;

@property (nonatomic,strong)UITextField *inputTield;
@property (nonatomic,strong)UIButton *button;;

-(NSString *)getTextFieldText;
-(void)setTextFieldText:(NSString *)textStr;
-(void)setTextFieldSecurity;

@end
