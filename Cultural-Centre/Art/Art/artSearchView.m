//
//  artSearchView.m
//  Art
//
//  Created by Liu fushan on 15/7/16.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "artSearchView.h"
#import "ForthonDataSpider.h"
#import "UICommon.h"
#import "RefreshControl.h"
#import "ForthonVastArtDescriptionView.h"

@interface artSearchView ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property BOOL isSearchBegin;
@property int pageNumber;
@property (nonatomic, copy) NSString *searchStr;
@property (nonatomic, strong) NSArray *resultArray;//用以存放搜索结果的数组

@property (nonatomic, strong) RefreshControl *myRefreshControl;
@property (nonatomic, strong) UITableView *myTableView;//用以显示搜索结果的table
@property (nonatomic, strong) UISearchBar *mySearchBar;//搜索框



@end

@implementation artSearchView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICommon *commonUI = [[UICommon alloc] init];
    UILabel *navTitle = [commonUI navTitle:_typeStr];
    self.navigationItem.titleView = navTitle;
    self.navigationItem.backBarButtonItem = HiddenBack
    self.automaticallyAdjustsScrollViewInsets = NO;       //取消自动适应scrollview
    
    [self createMySearchBar];
    [self createMyTableView];
    [self createMyRefreshControl];
    self.searchDelegate = [ForthonDataSpider sharedStore];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
}

#pragma mark - 搜索协议方法

//搜索开始，显示取消按键，设置取消按键的title为取消
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    NSArray *subViews;
    subViews = [searchBar.subviews[0] subviews];
    for (id view in subViews) {
        
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *cancelButton = (UIButton *)view;
            [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
            break;
        }
    }
    _isSearchBegin = YES;
    _myTableView.separatorStyle = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"text is change");
    
    if ([searchText length]) {
        NSLog(@"有内容");//lfs
        _searchStr = searchText;
        [self.searchDelegate seachArtByKeyword:searchText typeid:_typeId trade:_isTrade pageNumber:1];
        
    }
}


//取消按键按下后触发
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
    
    _resultArray = [[NSMutableArray alloc] init];
    _myTableView.separatorStyle = NO;
    [self.myTableView reloadData];
    _isSearchBegin = NO;
    
}

//键盘上的搜索键按下后触发
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"搜索键已按下");
}
//- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
//{
//    
//}


#pragma mark - TableView协议方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_resultArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = (int)indexPath.row;
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSDictionary *dic = _resultArray[index];
    NSString *resultString = [NSString stringWithFormat:@"%@:%@", [dic objectForKey:@"userNickName"], [dic objectForKey:@"title"]];

    NSMutableAttributedString *resultAttr = [[NSMutableAttributedString alloc] initWithString:resultString];
    UIColor *color = AppColor;
    NSLog(@"key: %@", _searchStr);
    [resultAttr addAttribute:NSForegroundColorAttributeName value:color range:[resultString rangeOfString:[_searchStr lowercaseString]]];
    [resultAttr addAttribute:NSForegroundColorAttributeName value:color range:[resultString rangeOfString:[_searchStr uppercaseString]]];
    
    [cell.textLabel setAttributedText:resultAttr];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = (int)indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    ForthonVastArtDescriptionView *description = [[ForthonVastArtDescriptionView alloc] init];
    description.modelDic = _resultArray[index];

    [self.navigationController pushViewController:description animated:YES];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [_mySearchBar resignFirstResponder];
}

#pragma mark - 下拉加载方法

- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction
{
    __weak typeof(self)weakSelf=self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf)strongSelf=weakSelf;
    
        NSLog(@"begin load more message:");
        _pageNumber++;
        if (direction == RefreshDirectionBottom) {
            
            [self.searchDelegate seachArtByKeyword:_searchStr typeid:_typeId trade:_isTrade pageNumber:_pageNumber];
        }
    });
}

#pragma mark - 搜索结果监听回掉

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"artSearchResultArray"]) {
        NSLog(@"array is ready");
        if (_isSearchBegin) {
            _resultArray = [NSArray arrayWithArray:[[ForthonDataContainer sharedStore] valueForKeyPath:keyPath]];
            if ([_resultArray count] * 44 < (HEIGHT - 115)) {
                
                [_myTableView setFrame:CGRectMake(0, 115, WIDTH, [_resultArray count] * 44)];

            } else{
                [_myTableView setFrame:CGRectMake(0, 115, WIDTH, HEIGHT - 115)];
            }
                [_myTableView reloadData];
            
            if (self.myRefreshControl.refreshingDirection == RefreshingDirectionBottom)
            {
                
                [self.myRefreshControl finishRefreshingDirection:RefreshDirectionBottom];
                
            }
        }
    } else {
        NSLog(@"只是监听到了哟");
    }
}

#pragma mark - 移除监听

- (void)viewWillDisappear:(BOOL)animated {
    
    [[ForthonDataContainer sharedStore] removeObserver:self forKeyPath:@"artSearchResultArray"];
    NSLog(@"移除监听！");
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [[ForthonDataContainer sharedStore] addObserver:self forKeyPath:@"artSearchResultArray" options:NSKeyValueObservingOptionInitial context:NULL];
}

#pragma mark - 创建视图

/**
 *  创建搜索框
 */
- (void)createMySearchBar {
    
    _mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 75, WIDTH, 40)];
    _mySearchBar.delegate = self;
//    [_mySearchBar sizeToFit];
    [self.view addSubview:_mySearchBar];
    
}

- (void)createMyTableView {
    
    _myTableView = [[UITableView alloc] init];
    _myTableView.delegate = self;
    _myTableView.dataSource= self;
   
    
    [self.view addSubview:_myTableView];
}

- (void)createMyRefreshControl {
    
    _pageNumber = 1;
    _myRefreshControl = [[RefreshControl alloc] initWithScrollView:_myTableView delegate:self];
    _myRefreshControl.bottomEnabled = YES;
    _myRefreshControl.topEnabled = NO;
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


@end
