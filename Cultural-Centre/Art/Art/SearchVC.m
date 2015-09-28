//
//  SearchVC.m
//  Art
//
//  Created by Tang yuhua on 15/4/28.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "SearchVC.h"
#import "Common.h"
#import "ForthonDataSpider.h"

#import "pageWebViewController.h"
#import "ForthonVastArtDescriptionView.h"
#import "ForthonAuthorDescription.h"
#import "ForthonVideoDescription.h"
#import "ForthonMoreResult.h"

@interface SearchVC ()
<
UISearchControllerDelegate,
UITableViewDelegate,
UITableViewDataSource,
UISearchBarDelegate,
PushAuthorDelegate
>



@property (nonatomic, copy) NSString *searchStr;

@property (nonatomic, strong) NSMutableArray *visableArray;
@property (nonatomic, strong) NSMutableArray *filterArray;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, strong) NSMutableArray *resultArray;
@property (nonatomic, strong) NSMutableArray *sectionTitleArray;

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UISearchController *mySearchController;
@property (nonatomic, strong) UISearchBar *mySearchBar;

@property (nonatomic, strong) UITableViewCell *moreArtists;
@property (nonatomic, strong) UITableViewCell *moreVideos;
@property (nonatomic, strong) UITableViewCell *moreArts;
@property (nonatomic, strong) UITableViewCell *morePages;





@end

@implementation SearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UICommon *commonUI = [[UICommon alloc] init];
    UILabel *navTitle = [commonUI navTitle:@"搜索"];
    self.navigationItem.titleView = navTitle;
    self.navigationItem.backBarButtonItem = HiddenBack
    [self.navigationController.navigationBar setTintColor:AppColor];

    _resultDelegate = [ForthonDataSpider sharedStore];

    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initial];
    


}

- (void)initial{

    
    
   
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 115, WIDTH, HEIGHT- 115 ) style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_myTableView setBounces:NO];
    [self.view addSubview:_myTableView];
    
    _mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 75, WIDTH, 40)];
//    _mySearchBar.colo
    _mySearchBar.delegate = self;
    
    [_mySearchBar sizeToFit];
    [self.view addSubview:_mySearchBar];
    [self.myTableView.tableHeaderView setHidden:YES];

//    self.myTableView.tableHeaderView = _mySearchBar;
    
    
//    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 350, 100, 100)];
//    [cancelButton setBackgroundColor:[UIColor grayColor]];
//    
//    [cancelButton addTarget:self action:@selector(cancelSearch) forControlEvents:UIControlEventTouchUpInside];

}


#pragma mark TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int count = 0;
    for (int i = 0; i < 4; i++)
    {
        if ([_resultArray count]) {
            count++;
            }
    }
    NSLog(@"section: %i", [_resultArray count]);
    return [_resultArray count];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   

    if ([_resultArray[section] count] > 3) {

        return 4;

    } else {

        return [_resultArray[section] count] + 1;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {


    return 0.1;

}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 0.1;
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];
    int category = (int)indexPath.section;
    int row = (int)indexPath.row;
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identifier"];
    }

    if ([_resultArray count]) {

        _myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        NSString *resultString;
        NSMutableAttributedString *resultAttr;
        NSLog(@"in the array");

        int last = [_resultArray[category] count] > 3 ? 3 : [_resultArray[category] count];

        if (row == last) {

            resultString = [NSString stringWithFormat:@"更多%@", _sectionTitleArray[category]];
            resultAttr = [[NSMutableAttributedString alloc] initWithString:resultString];
            [resultAttr addAttribute:NSForegroundColorAttributeName value:AppColor range:NSMakeRange(0, [resultString length])];

        } else {

            if ([_sectionTitleArray[category] isEqualToString:@"艺术家"]) {

                resultString = [_resultArray[category][row] objectForKey:@"nickName"];
            } else {

                resultString = [_resultArray[category][row] objectForKey:@"title"];
            }
            resultAttr = [[NSMutableAttributedString alloc] initWithString:resultString];
            [resultAttr addAttribute:NSForegroundColorAttributeName value:AppColor range:[resultString rangeOfString:[_searchStr lowercaseString]]];
            [resultAttr addAttribute:NSForegroundColorAttributeName value:AppColor range:[resultString rangeOfString:[_searchStr uppercaseString]]];
        }


        [cell.textLabel setAttributedText:resultAttr];
        return cell;
        
    } else {
        return cell;
    }

}




- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  
    
    return _sectionTitleArray[section];
        
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *cellResultArray = [NSArray arrayWithArray:_resultArray];


    int row =  (int)indexPath.row ;
    int section = (int)indexPath.section;

    NSLog(@"section: %i index: %i", section, row);

    BOOL isMore = (row == 3) || (row >= [_resultArray[section] count]);

    if (isMore) {

        [self pushMoreWithCategory:section];

    } else {

        if ([_sectionTitleArray[section] isEqualToString:@"艺术家"]) {
            NSLog(@"作者详情页面跳转");

            NSMutableDictionary *authorDic = cellResultArray[section][row];
            [self pushAuthorDescriptionWitDic:authorDic];


        } else if ([_sectionTitleArray[section] isEqualToString:@"视频"]) {

            NSDictionary *videoDic = cellResultArray[section][row];

            [self pushVideoDescriptionWithDic:videoDic];

        } else if ([_sectionTitleArray[section] isEqualToString:@"艺术品"]) {

            NSDictionary *artDic = cellResultArray[section][row];
            [self pushArtDescriptionViewWithDic:artDic];

        } else {

            NSDictionary *dic = cellResultArray[section][row];
            [self pushPaperViewWithDic:dic];
        }
    }

}



#pragma mark -SearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"begin search");
    
//    if (self.tabBarController.tabBar.hidden == YES) {
//        
//        self.tabBarController.tabBar.hidden = NO;  //转到搜索页面 显示tabbar
//
//    }
    
    searchBar.showsCancelButton = YES;
    NSArray *subViews;
    subViews = [searchBar.subviews[0] subviews];
    for (id view in subViews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton* cancelbutton = (UIButton* )view;
            [cancelbutton setTitle:@"取消" forState:UIControlStateNormal];
            cancelbutton.tintColor = AppColor;
            break;
        }
    }
    
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"beginLoad:");

    
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{//取消按钮被按下时触发
    
    //重置
    searchBar.text=@"";

    //输入框清空
    NSLog(@"cancel search");
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton = NO;
//    [UIView animateWithDuration:0.5 animations:^{
//        [_myTableView setFrame:CGRectMake(0, 30, WIDTH, HEIGHT - 30)];
//    }];
     self.tabBarController.tabBar.hidden = NO;  //取消搜索 显示tabbar
    _resultArray = [[NSMutableArray alloc] init];
    [self.myTableView reloadData];
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"search begin");

    if ([searchText length]) {
        _searchStr = searchText;
        NSLog(@"search with text");
        [_resultDelegate getResultBySearchKeyword:searchText];

        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateUI)
                                                     name:@"NotificationA"
                                                   object:nil];
        
        
        
        
        
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    NSLog(@"end search!");
//    [_resultDelegate getResultBySearchKeyword:@"s"];

//    _resultArray = [[NSMutableArray alloc] init];
    
}

- (void)updateUI
{
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationA" object:nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Do time-consuming task in background thread
        // Return back to main thread to update UI
        dispatch_sync(dispatch_get_main_queue(), ^{
    
    NSMutableDictionary *dic = [ForthonDataContainer sharedStore].searchResultDic;
    _resultArray = [[NSMutableArray alloc] init];
    _sectionTitleArray = [[NSMutableArray alloc] init];

    if ([dic[@"user"] count]) {
        [_resultArray addObject:dic[@"user"]];
        [_sectionTitleArray addObject:@"艺术家"];
        
    }
    if ([dic[@"video"] count]) {
        [_resultArray addObject:dic[@"video"]];
         [_sectionTitleArray addObject:@"视频"];
    }
    if ([dic[@"art"] count]) {
        [_resultArray addObject:dic[@"art"]];
         [_sectionTitleArray addObject:@"艺术品"];
    }
    if ([dic[@"page"] count]  ) {
        [_resultArray addObject:dic[@"page"]];
         [_sectionTitleArray addObject:@"文章"];
    }

    NSLog(@"x: %f y: %f", self.myTableView.frame.origin.x, self.myTableView.frame.origin.y);
    //    self.myTableView.frame
    [self.myTableView reloadData];
        });
    });
    
}


-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
//    [searchBar setFrame:CGRectMake(0, 30, WIDTH, 40)];
//
//    [UIView animateWithDuration:0.5 animations:^{
//        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, WIDTH, 20)];
//        [whiteView setBackgroundColor:[UIColor whiteColor]];
//        
//        [self.view addSubview:whiteView];
//     
//    }];
    NSLog(@"just begin!");
    self.tabBarController.tabBar.hidden = YES;  //开始搜索，隐藏tabbar.
    return YES;
}


#pragma mark - 滚动协议方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (_mySearchBar.isFirstResponder) {
        [_mySearchBar resignFirstResponder];
        NSLog(@"放弃第一响应者");
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark 选中cell实现跳转

- (void)pushVideoDescriptionWithDic:(NSMutableDictionary *)dic
{
    ForthonVideoDescription *videoDescription = [[ForthonVideoDescription alloc] init];
    NSString *category = [NSString stringWithFormat:@"%@", [dic objectForKey:@"typeId"]];
    NSMutableDictionary *objectDic = [[NSMutableDictionary alloc] init];
    
    [objectDic setObject:category forKey:@"category"];
    [objectDic setObject:@"0" forKey:@"favor"];
    [objectDic setObject:@"0" forKey:@"follow"];
    [objectDic setObject:@"10000000" forKey:@"tinyTag"];
    [objectDic setObject:dic forKey:@"modelDic"];
    videoDescription.videoModelDic = objectDic;
    
    [self.navigationController pushViewController:videoDescription animated:YES];
}

- (void)pushPaperViewWithDic:(NSDictionary *)dic
{
    
    
    pageWebViewController *pageView = [[pageWebViewController alloc] init];
    [pageView setPageDic:dic];

    [self.navigationController pushViewController:pageView  animated:YES];
    
}

- (void)pushArtDescriptionViewWithDic:(NSDictionary *)dic
{

    ForthonVastArtDescriptionView *descriptionView = [[ForthonVastArtDescriptionView alloc] init];
    descriptionView.modelDic = dic;
    [self.navigationController pushViewController:descriptionView animated:YES];
    
    
}

- (void)pushAuthorDescriptionWitDic:(NSMutableDictionary *)dic {


    ForthonAuthorDescription *authorDescriptionView = [[ForthonAuthorDescription alloc] init];

    authorDescriptionView.authorDic = dic;
    [self.navigationController pushViewController:authorDescriptionView animated:YES];
}

#pragma mark - 推出更多视图

- (void)pushMoreWithCategory:(int)category {

    NSArray *resultArray = _resultArray[category];
    NSString *resultTitle = _sectionTitleArray[category];

    ForthonMoreResult *resultView = [ForthonMoreResult new];
    resultView.resultTitle = resultTitle;
    resultView.resultsArray = resultArray;

    [self.navigationController pushViewController:resultView animated:YES];

}



- (void)cancelSearch
{
    NSLog(@"cancelSearch!");
    [self searchBarCancelButtonClicked:_mySearchBar];
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
