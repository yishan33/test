//
//  YHAppreciateArtVc.m
//  Art
//
//  Created by Tang yuhua on 15/5/18.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "YHAppreciateArtVC.h"
#import "YHShowArtVC.h"
#import "YHLearnedArtVC.h"
#import "YHCommentVC.h"
#import "Common.h"
#import "ForthonCommentArtTable.h"
#import "SVProgressHUD.h"

@interface YHAppreciateArtVC ()

@end

@implementation YHAppreciateArtVC

-(instancetype)init{
    
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    UICommon *commonUI = [[UICommon alloc] init];
    UILabel *navTitle = [commonUI navTitle:@"赏艺"];
    
    self.navigationItem.titleView = navTitle;
    self.navigationItem.backBarButtonItem = HiddenBack;
    
    
    // log
    UIView *logview = [[UIView alloc]init];
    logview.frame = CGRectMake(0, 64, WIDTH, (HEIGHT-64)/4);
    logview.backgroundColor = [UIColor whiteColor];
    UIImageView *log = [[UIImageView alloc] init];
    log.frame = CGRectMake((WIDTH-80)/2, 20, 80, (HEIGHT-64)/4-40);
    log.image = [UIImage imageNamed:@"shangyi_logo"];

    [logview addSubview:log];
    [self.view addSubview:logview];
    
    // 演艺
    
    UIImageView *show = [[UIImageView alloc] init];
    show.frame = CGRectMake(0, (HEIGHT-64)/4+64, WIDTH, (HEIGHT-64)/4);
    show.image = [UIImage imageNamed:@"shangyi_yanyi_background"];
    show.userInteractionEnabled = YES;
    
    UILabel *showButton = [UILabel new];
    showButton.frame = CGRectMake((show.frame.size.width-100)/2, (show.frame.size.height-40)/2, 100, 40);
    [showButton setFont:[UIFont systemFontOfSize:16.0]];
    showButton.text = @"演艺";
    showButton.textAlignment = NSTextAlignmentCenter;
    showButton.textColor = AppColor;
    showButton.backgroundColor = ButtonColor;
    showButton.layer.borderColor = [UIColor clearColor].CGColor;
    showButton.layer.borderWidth = 1.0;
    showButton.clipsToBounds = YES;
    [showButton.layer setCornerRadius:10.0f];
    UITapGestureRecognizer *showComment = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMethod)];
    [show addGestureRecognizer:showComment];
//    [showButton addTarget:self action:@selector(showMethod) forControlEvents:UIControlEventTouchUpInside];
    [show addSubview:showButton];
    
    [self.view addSubview:show];
    
    // 博艺
    
    UIImageView *learned = [[UIImageView alloc] init];
    learned.frame = CGRectMake(0, 2*(HEIGHT-64)/4+64, WIDTH, (HEIGHT-64)/4);
    learned.image = [UIImage imageNamed:@"shangyi_boyi_background"];
    learned.userInteractionEnabled = YES;
    
    UILabel *learnedButton = [UILabel new];
    learnedButton.frame = CGRectMake((learned.frame.size.width-100)/2, (learned.frame.size.height-40)/2, 100, 40);
    learnedButton.text = @"博艺";
    learnedButton.textAlignment = NSTextAlignmentCenter;
    learnedButton.font = [UIFont systemFontOfSize:16.0];
    learnedButton.textColor = AppColor;
    learnedButton.backgroundColor = ButtonColor;
    learnedButton.layer.borderColor = [UIColor clearColor].CGColor;
    learnedButton.layer.borderWidth = 1.0;
    learnedButton.clipsToBounds = YES;
    [learnedButton.layer setCornerRadius:10.0f];
    UITapGestureRecognizer *LearnComment = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(learnedMethod)];
    [learned addGestureRecognizer:LearnComment];
//    [learnedButton addTarget:self action:@selector(learnedMethod) forControlEvents:UIControlEventTouchUpInside];
    
    [learned addSubview:learnedButton];
    
    
    [self.view addSubview:learned];
    
    // 论艺
    UIImageView *comment = [[UIImageView alloc] init];
    comment.frame = CGRectMake(0, 3*(HEIGHT-64)/4+64, WIDTH, (HEIGHT-64)/4);
    comment.image = [UIImage imageNamed:@"shangyi_lunyi_background"];
    comment.userInteractionEnabled = YES;
    
    UILabel *commentButton = [[UILabel alloc]init];
    commentButton.frame = CGRectMake((comment.frame.size.width-100)/2, (comment.frame.size.height-40)/2, 100, 40);
    commentButton.text = @"论艺";
    commentButton.textAlignment = NSTextAlignmentCenter;
    commentButton.font = [UIFont systemFontOfSize:16.0];
    commentButton.textColor = AppColor;
    commentButton.backgroundColor = ButtonColor;
    commentButton.layer.borderColor = [UIColor clearColor].CGColor;
    commentButton.layer.borderWidth = 1.0;
    commentButton.clipsToBounds = YES;
    [commentButton.layer setCornerRadius:10.0f];

    UITapGestureRecognizer *tapComment = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentMethod)];
    [comment addGestureRecognizer:tapComment];

//    [commentButton addTarget:self action:@selector(commentMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:comment];
    [comment addSubview:commentButton];

    
    
    
    
    
    // Do any additional setup after loading the view from its nib.
    
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Method 
-(void)showMethod{
    WHERE;
    YHShowArtVC *show = [[YHShowArtVC alloc]init];
    [self.navigationController pushViewController:show animated:YES];
 
}

-(void)learnedMethod{
    WHERE;
    YHLearnedArtVC *learned = [[YHLearnedArtVC alloc]init];
    [self.navigationController pushViewController:learned animated:YES];
}

-(void)commentMethod{
    ForthonCommentArtTable *comment = [[ForthonCommentArtTable alloc] init];
    [self.navigationController pushViewController:comment animated:YES];
}



- (void)viewWillAppear:(BOOL)animated {

    if ([SVProgressHUD isVisible]) {

        [SVProgressHUD dismiss];
    }
}



@end
