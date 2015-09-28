//
//  commentCell.m
//  Art
//
//  Created by Liu fushan on 15/6/7.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "commentCell.h"
#import "NSString+imageUrlString.h"
#import "ProtocolBox.pch"
#import "UIImageView+WebCache.h"

@interface commentCell ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end


@implementation commentCell

- (void)load
{
    _backView = [[UIView alloc] init];
    
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CELLSIDEINTERVAL, CELLSIDEINTERVAL, IMAGESIDE, IMAGESIDE)];
    [_headImageView.layer setBorderColor:AppColor.CGColor];
    [_headImageView.layer setBorderWidth:2.0];
    [_headImageView.layer setCornerRadius:IMAGESIDE / 2];
    _headImageView.clipsToBounds = YES;
    
//    [headImageView setBackgroundColor:[UIColor redColor]];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(2 * CELLSIDEINTERVAL + IMAGESIDE, CELLSIDEINTERVAL, NAMELABELWIDTH, NAMELABELHEIGHT)];
//    [_nameLabel setTextColor:[UIColor redColor]];
    [_nameLabel setFont:[UIFont systemFontOfSize:14.0]];

    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(2 * CELLSIDEINTERVAL + IMAGESIDE, 2 *CELLSIDEINTERVAL + NAMELABELHEIGHT, CONTENTLABELWIDTH , 0)];
    [_contentLabel setTextColor:[UIColor blackColor]];
    [_contentLabel setFont:[UIFont systemFontOfSize:14.0]];

    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(2 * CELLSIDEINTERVAL + IMAGESIDE, 2 *CELLSIDEINTERVAL + NAMELABELHEIGHT, TIMELABELWIDTH, TIMELABELHEIGHT)];
    [_timeLabel setFont:[UIFont systemFontOfSize:12.0]];
    [_timeLabel setTextColor:[UIColor grayColor]];
    
    
    [_backView addSubview:_headImageView];
    [_backView addSubview:_nameLabel];
    [_backView addSubview:_contentLabel];
    [_backView addSubview:_timeLabel];
    
    self.frame = _backView.frame;
    [self addSubview:_backView];

    
    
    self.selectionStyle = UITableViewCellSelectionStyleBlue;

    
}


- (void)resetContentLabeWithDic:(NSDictionary *)dic {
    
        NSString *content = [[NSString alloc] init];
        NSString *time = [[NSString alloc] init];
        NSMutableAttributedString  *name;
        NSString *headImageUrlBody = [[NSString alloc] init];
        NSString *headImageUrl = [[NSString alloc] init];
        NSLog(@"begin: --- ");
        content = [dic objectForKey:@"content"];
        if ([content length] > 300) {

            content = [content substringWithRange:NSMakeRange(0, 300)];
        }
         time = dic[@"createTime"];
         NSString *nameString;
        if ([dic[@"userNickName"] length]) {

            nameString = dic[@"userNickName"];
        } else if ([dic[@"userName"] length]) {

            nameString = dic[@"userName"];
        } else {

            nameString = @"无用户名";
        }
        NSLog(@"before bug");
        name = [[NSMutableAttributedString alloc] initWithString:nameString];
        NSLog(@"name: %@", name.string);
        [name addAttribute:NSForegroundColorAttributeName value:AppColor range:NSMakeRange(0, [nameString length])];
        
        if ([dic[@"fatherId"] boolValue] && ([dic[@"replyUserId"] intValue] != [dic[@"userId"] intValue])) {
            
            NSMutableAttributedString *HF = [[NSMutableAttributedString alloc] initWithString:@"回复"];
            [HF addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 2)];
            [name appendAttributedString:HF];
            if ([dic[@"replyNickName"] length]) {

                NSLog(@"replyNick: %@", dic[@"replyNickName"]);
                NSMutableAttributedString *replyName = [[NSMutableAttributedString alloc] initWithString:dic[@"replyNickName"]];
                [replyName addAttribute:NSForegroundColorAttributeName value:AppColor range:NSMakeRange(0, [dic[@"replyNickName"] length])];
                [name appendAttributedString:replyName];
            } else if ([dic[@"replyUserName"] length]){
                
                NSMutableAttributedString *replyName = [[NSMutableAttributedString alloc] initWithString:dic[@"replyUserName"]];
                [replyName addAttribute:NSForegroundColorAttributeName value:AppColor range:NSMakeRange(0, [dic[@"replyUserName"] length])];
                [name appendAttributedString:replyName];
            }
            
            [name addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(0, [name length])];
        }
        headImageUrlBody = dic[@"userAvatarUrl"];
        headImageUrl = [headImageUrlBody changeToUrl];

    [_nameLabel setAttributedText:name];
    [_timeLabel setText:[self rightDateIntervalFromNow:time]];

    if (headImageUrlBody) {

        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:headImageUrl]];
    } else {

        [self.headImageView setImage:[UIImage imageNamed:@"profile_avatar_default.png"]];
    }

    
    [_contentLabel setNumberOfLines:10];
    CGSize size = CGSizeMake(CONTENTLABELWIDTH, 1000);
    [_contentLabel setText:content];
    //
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:_contentLabel.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize contentLabelSize = [content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    _contentLabel.frame = CGRectMake(2 * CELLSIDEINTERVAL + IMAGESIDE, 2 * CELLSIDEINTERVAL + NAMELABELHEIGHT + TIMELABELHEIGHT + CELLSIDEINTERVAL, contentLabelSize.width, contentLabelSize.height);
    
    [_backView setFrame:CGRectMake(0, 0, CELLBACKVIEWWIDTH, CELLBACKVIEWHEIGHT)];

}



- (NSString *)rightDateIntervalFromNow:(NSString *)timeStr {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *nowDate = [NSDate date];
    NSString *nowDateStr = [dateFormat stringFromDate:nowDate];
    NSString *nowDateHead = [nowDateStr componentsSeparatedByString:@" "][0];
    NSString *todayInit = [NSString stringWithFormat:@"%@ 00:00:00", nowDateHead];
    NSDate *todayInitDate = [dateFormat dateFromString:todayInit];
    NSTimeInterval toMorningInterval = [nowDate timeIntervalSinceDate:todayInitDate];
    
    
    NSDate *targetDate = [dateFormat dateFromString:timeStr];
    NSTimeInterval timeInterval = [nowDate timeIntervalSinceDate:targetDate];
    
    NSString *returnStr;
    if (timeInterval > toMorningInterval) {

        int day = (int)((timeInterval - toMorningInterval) / 86400) + 1;
        if (day == 1) {

            returnStr = @"昨天";

        } else if (day == 2) {

            returnStr = @"前天";

        } else if ((day <= 7) && (day >= 3)) {

            returnStr = [NSString stringWithFormat:@"%i天前", day];

        } else {

            returnStr = timeStr;
        }

    } else {


        NSArray *numArray = @[@"3600", @"60", @"1"];
        NSArray *strArray = @[@"小时前", @"分钟前", @"刚刚"];
        
        for (int i = 0; i < 3; i++) {
            NSString *interval = numArray[i];
            int number = (int)(timeInterval / [interval floatValue]);
            NSLog(@"numberrrr: %i", number);
            if (number < 1) {
                
                continue;
                
            } else {

              if (((i == 1) && (number <= 5)) || (i == 2)) {

                  returnStr = @"刚刚";
                  break;

              }
              else {

                  returnStr = [NSString stringWithFormat:@"%i%@", number, strArray[i]];
                  break;
              }

            }
        }
    }
    
    return returnStr;
}



@end
