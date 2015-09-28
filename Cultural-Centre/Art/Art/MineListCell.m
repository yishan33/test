//
//  MineListCell.m
//  Art
//
//  Created by Tang yuhua on 15/6/26.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "MineListCell.h"

@implementation MineListCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 10 , 20, 20)];

        [self addSubview:_ImageView];
    }
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)cellInListAt :(NSInteger)index{
    if (index ==0) {
        self.ImageView.image = [UIImage imageNamed:@"profile_favor_icon"];
        self.textLabel.text = @"我的收藏";
        
    }else if(index ==1){
        self.ImageView.image = [UIImage imageNamed:@"profile_favor_icon"];
        self.textLabel.text = @"我关注的";
    }else if(index ==2){
        self.ImageView.image = [UIImage imageNamed:@"profile_comment_icon"];
        self.textLabel.text = @"我的评论";
    }else if(index ==3){
        self.ImageView.image = nil;
        self.textLabel.text = @"我的作品";
    }else if(index ==4){
        self.ImageView.image = nil;
        self.textLabel.text = @"我的文章";
    }else if(index ==5){
        self.ImageView.image = nil;
        self.textLabel.text = @"商店";
    }else if(index ==6){
        self.ImageView.image = nil;
        self.textLabel.text = @"设置";
    }
    self.textLabel.textColor = AppColor;
    self.textLabel.font = [UIFont boldSystemFontOfSize:17.0];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}
@end
