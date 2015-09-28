//
//  ForthonOrderProtocolView.m
//  Art
//
//  Created by Liu fushan on 15/8/17.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "ForthonOrderProtocolView.h"
#import "UICommon.h"
#import "ForthonDataSpider.h"

@interface ForthonOrderProtocolView ()

@property (nonatomic, strong) UIWebView *protocolView;

@end

@implementation ForthonOrderProtocolView

- (void)viewDidLoad {
    [super viewDidLoad];

    UICommon *commonUI = [[UICommon alloc] init];
    NSString *videoTitle = @"《艺术品订购协议》";
    UILabel *navTitle = (UILabel *) [commonUI navTitle:videoTitle];
    self.navigationItem.titleView = navTitle;
    self.navigationItem.backBarButtonItem = HiddenBack;

    self.delegate = [ForthonDataSpider sharedStore];
    [self.delegate getOrderProtocol];

    [[ForthonDataContainer sharedStore] addObserver:self
                                         forKeyPath:@"orderProtocol"
                                            options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                            context:NULL];

    _protocolView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _protocolView.scrollView.bounces = NO;
    _protocolView.scrollView.showsHorizontalScrollIndicator = NO;
    _protocolView.delegate = self;
    [self.view addSubview:_protocolView];

    self.view.backgroundColor = [UIColor whiteColor];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    if ([keyPath isEqualToString:@"orderProtocol"]) {

        [_protocolView loadHTMLString:[[ForthonDataContainer sharedStore] valueForKey:@"orderProtocol"] baseURL:[NSURL URLWithString:@"http://120.26.222.176:8080"]];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '90%'"];
    CGSize contentSize =  _protocolView.scrollView.contentSize;
    contentSize.width = self.view.frame.size.width;
    _protocolView.scrollView.contentSize = contentSize;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
