//
//  ForthonVastArtTable.m
//  Login
//
//  Created by Liu fushan on 15/5/20.
//  Copyright (c) 2015年 culturalCenter. All rights reserved.
//

#import "ForthonVastArtTable.h"
#import "ForthonVastArtCell.h"
#import "vastMeasurement.h"
#import "ForthonDataSpider.h"

#define HOST @"http://art.uestcbmi.com"



@interface ForthonVastArtTable ()

@property BOOL isOk;
@property (strong, nonatomic) NSMutableArray *artImageArray;
@end

@implementation ForthonVastArtTable

- (void)viewDidLoad {
    [super viewDidLoad];
    _isOk = YES;
    if (![[ForthonDataContainer sharedStore].artListDic[0] objectForKey:@"artImage"]) {
       
        _delegate = [ForthonDataSpider sharedStore];
        [_delegate  getArtListByTypeid:_categoryIndex trade:NO page:1];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(createThread)
                                                     name:@"NotificationA"
                                                   object:nil];
        _isOk = NO;
    }
    
    
    
    [self.tableView setSeparatorStyle:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    if (_isOk) {
        return [[ForthonDataContainer sharedStore].artListDic count] / 2;
    } else {
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_isOk) {
        
        int index = indexPath.row;
        ForthonVastArtCell *cell  = [[ForthonVastArtCell alloc] init];
        cell = [cell load];
        
        for (int i = 0; i < 2; i++)
        {
            NSString *Name = [[ForthonDataContainer sharedStore].artListDic[index * 2 + i] objectForKey:@"userNickName"];
            NSData *headImageData = [[ForthonDataContainer sharedStore].artListDic[index * 2 + i] objectForKey:@"headImage"];
            NSData *artImageData = [[ForthonDataContainer sharedStore].artListDic[index * 2 + i] objectForKey:@"artImage"];
        
            if (i == 0) {
                
                [cell.leftNameLabel setText:Name];
                [cell.leftHeadImageView setImage:[UIImage imageWithData:headImageData] forState:UIControlStateNormal];
                [cell.leftPictureView setImage:[UIImage imageWithData:artImageData] forState:UIControlStateNormal];
            } else {
                
                [cell.rightNameLabel setText:Name];
                [cell.rightHeadImageView setImage:[UIImage imageWithData:headImageData] forState:UIControlStateNormal];
                [cell.rightPictureView setImage:[UIImage imageWithData:artImageData] forState:UIControlStateNormal];
            }
        
        }
       
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        return cell;
    }
   
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return BACKVIEWHEIGHT;
}

- (void)createThread
{
    
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(updateUI) object:nil];
    [thread start];
}

- (void)updateUI
{
    
    NSString *nameStr = [[ForthonDataContainer sharedStore].artListDic[0] objectForKey:@"userNickName"];
    NSLog(@"name: %@", nameStr);
    _artImageArray = [[NSMutableArray alloc] init];
    NSMutableArray *headImageArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [[ForthonDataContainer sharedStore].artListDic count]; i++) {
        NSString *artUrlStringBody = [[ForthonDataContainer sharedStore].artListDic[i] objectForKey:@"titleImg"];
        NSString *artUrlString = [NSString stringWithFormat:@"%@%@", HOST, artUrlStringBody];
        NSString *headUrlStringBody = [[ForthonDataContainer sharedStore].artListDic[i] objectForKey:@"userAvatarUrl"];
        NSString *headUrlString = [NSString stringWithFormat:@"%@%@", HOST, headUrlStringBody];
        headImageArray[i] = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:headUrlString]];
        _artImageArray[i] = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:artUrlString]];
        [[ForthonDataContainer sharedStore].artListDic[i] setObject:_artImageArray[i] forKey:@"artImage"];
        [[ForthonDataContainer sharedStore].artListDic[i] setObject:headImageArray[i] forKey:@"headImage"];
        
    }
    
    _isOk = YES;
    [self.tableView reloadData];
    NSLog(@"reloadData");
    
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
