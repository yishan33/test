//
//  YHStyleCell.m
//  demo
//
//  Created by Tang yuhua on 15/7/8.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "YHStyleCell.h"

#define Height self.frame.size.height
#define  Width  self.frame.size.width

// textfile’s frame
#define TextFieldHeight 40
#define TextFieldWidth (Width-100)
#define TextFieldLeadingSpace 100

// button‘s frame
#define buttonWidth  100
#define buttonTailingSace 10
#define buttonLeadingSpace ([UIScreen mainScreen].applicationFrame.size.width - buttonWidth -buttonTailingSace)
#define buttonHeight 30


@interface YHStyleCell ()





@end

@implementation YHStyleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self addSubview:self.inputTield];
    
        self.selectionStyle =UITableViewCellSelectionStyleNone;
        
    }
    
    return self;
}



#pragma mark -- setStyle
-(void)setStyleWithButton:(BOOL)withButton
{
    if (withButton) {
        [self addSubview:self.button];
//        NSLog(@"buttonLeadingSpace: %f,    cellViewWidth: %f", buttonLeadingSpace, self.frame.size.width);

        CGFloat width = [UIScreen mainScreen].applicationFrame.size.width;
//        NSLog(@"screenWidth: %f", width);

    }
}

-(void)setTextFieldText:(NSString *)textStr
{
    [self.inputTield setText:textStr];
}

-(void)setTextFieldSecurity{
    self.inputTield.secureTextEntry =YES;
}

#pragma mark -- getDataFromView
-(NSString *)getTextFieldText{
    
    return self.inputTield.text;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark -- init addtional view
-(UITextField *)inputTield{
    if (_inputTield == nil) {
        _inputTield = [[UITextField alloc]init];
        CGRect frame = CGRectMake(TextFieldLeadingSpace, 0, TextFieldWidth, TextFieldHeight);
        _inputTield.frame = frame;
        
    }
    return _inputTield;
}
-(UIButton *)button{
    
    if (_button ==nil) {
        // 添加了按钮后需要改变texfiled 的宽度
        _inputTield.frame = CGRectMake(TextFieldLeadingSpace, 0, TextFieldWidth-buttonWidth-buttonTailingSace, TextFieldHeight);
        
        _button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_button.layer setCornerRadius:5.0f];
        _button.backgroundColor = [UIColor grayColor];
        [_button setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        CGRect frame = CGRectMake(buttonLeadingSpace, 10, buttonWidth, buttonHeight);
        _button.frame =frame;
        [_button.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        NSLog(@"%@",_button.titleLabel.text);

        NSLog(@"%s",__func__);

    }
    return _button;
}



-(void)addTarget:(id) target selector:(SEL)selector{

    [_button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];

}







@end
