//
//  ForthonSkimPaperCell.m
//  Art
//
//  Created by Liu fushan on 15/6/18.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "ForthonSkimPaperCell.h"
#import "UIImageView+WebCache.h"
#import "NSString+regular.h"
#import "NSString+imageUrlString.h"




@interface ForthonSkimPaperCell()

@property (nonatomic, strong) UIImageView *pictureView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;

@end


@implementation ForthonSkimPaperCell


- (void)loadCellView
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PAPERBACKVIEWWIDTH, PAPERBACKVIEWHEIGHT)];
    
    
    _pictureView = [[UIImageView alloc] initWithFrame:CGRectMake(PAPERSIDEINTERVAL, TBINTERVAL, IMAGEWIDTH, IMAGEHEIGHT)];
    //    [imageView setBackgroundColor:[UIColor purpleColor]];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - PAPERSIDEINTERVAL - TITLEWIDTH, 0, TITLEWIDTH, TITLEHEIGHT)];
    [_titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    //    [titleLabel sizeToFit];
    [_titleLabel setNumberOfLines:2];
    //    [titleLabel setBackgroundColor:[UIColor grayColor]];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - PAPERSIDEINTERVAL - TITLEWIDTH, TITLEHEIGHT - TDINTERVAL, DESCRIPTIONWIDTH, DESCRIPTIONHEIGHT)];
    [_descriptionLabel setNumberOfLines:4];
    //    [descriptionLabel setBackgroundColor:[UIColor greenColor]];
    [_descriptionLabel setFont:[UIFont systemFontOfSize:12.0]];
    [_descriptionLabel setTextColor:[UIColor grayColor]];

    [backView addSubview:_pictureView];
    [backView addSubview:_titleLabel];
    [backView addSubview:_descriptionLabel];
//    [backView addSubview:bottomLine];

    [self addSubview:backView];
}

- (void)loadWithData:(NSDictionary *)dic
{
    
    NSNumber *type = [dic objectForKey:@"type"];
    if (!type) {
        type = [dic objectForKey:@"typeId"];
    }
    NSMutableDictionary *tinyDic = dic[@"obj"];
    if (!tinyDic) {

        tinyDic = dic;
    }
    
    NSString *imageUrlStringBody = [[NSString alloc] init];
    switch (type.intValue) {
        case 1:
            [_titleLabel setText:[tinyDic objectForKey:@"title"]];
            [_descriptionLabel setText:[tinyDic objectForKey:@"description"]];
            imageUrlStringBody = [tinyDic objectForKey:@"picUrl"];
            break;
        case 2:
            [_titleLabel setText:[tinyDic objectForKey:@"title"]];
            [_descriptionLabel setText:tinyDic[@"content"]];
            imageUrlStringBody = tinyDic[@"titleImg"];


            break;
        case 3:
            [_titleLabel setText:[tinyDic objectForKey:@"title"]];
            NSString *responseString = [tinyDic objectForKey:@"content"];
            
            NSString *imageRegular = @"/up\\S+png";
            if ([[responseString substringArrayByRegular:imageRegular] count]) {
    
                imageUrlStringBody = [responseString substringArrayByRegular:imageRegular][0];
            }
            
            NSString *regstr1 = @"\\d*[\u4e00-\u9fa5]+[^<]+";
            NSArray *responseTextArray = [responseString substringArrayByRegular:regstr1];
            NSMutableString *resultString = [[NSMutableString alloc] init];
            
            for (int j = 0; j < responseTextArray.count; j++) {
                
                [resultString appendString:responseTextArray[j]];
            }
            [_descriptionLabel setText:resultString];
            break;

    }

    [_pictureView sd_setImageWithURL:[NSURL URLWithString:[imageUrlStringBody changeToUrl]] prune:YES withPercentage:23.0/20.0];
    
}


@end
