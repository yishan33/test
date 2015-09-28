//
//  ForthonMoreResult.m
//  Art
//
//  Created by Liu fushan on 15/7/31.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "ForthonMoreResult.h"
#import "UICommon.h"
#import "ForthonAuthorDescription.h"
#import "ForthonVastArtDescriptionView.h"
#import "ForthonVideoDescription.h"
#import "pageWebViewController.h"

@interface ForthonMoreResult ()

@end

@implementation ForthonMoreResult

- (void)viewDidLoad {
    [super viewDidLoad];


    UICommon *commonUI = [[UICommon alloc] init];
    NSString *title = [NSString stringWithFormat:@"更多%@", _resultTitle];
    UILabel *navTitle = [commonUI navTitle:title];
    self.navigationItem.titleView = navTitle;
    self.navigationItem.backBarButtonItem = HiddenBack
    [self.navigationController.navigationBar setTintColor:AppColor];

    self.tableView.bounces = NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    
    return [_resultsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellIdentifier = @"cellIdentifier";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {

        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    NSString *text = @"test";

    if ([_resultTitle isEqualToString:@"艺术家"]) {

        text = [_resultsArray[indexPath.row] objectForKey:@"nickName"];
    } else {

        text = [_resultsArray[indexPath.row] objectForKey:@"title"];
    }
    [cell.textLabel setText:text];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if ([_resultTitle isEqualToString:@"艺术家"]) {

        [self pushAuthorDescriptionWitDic:_resultsArray[indexPath.row]];

    } else if ([_resultTitle isEqualToString:@"视频"]) {

        [self pushVideoDescriptionWithDic:_resultsArray[indexPath.row]];

    } else if ([_resultTitle isEqualToString:@"艺术品"]) {

        [self pushArtDescriptionViewWithDic:_resultsArray[indexPath.row]];

    } else {

        [self pushPaperViewWithDic:_resultsArray[indexPath.row]];
    }


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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
