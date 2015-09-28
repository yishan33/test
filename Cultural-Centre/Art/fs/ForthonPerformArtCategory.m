//
//  testTableTableViewController.m
//  Login
//
//  Created by Liu fushan on 15/5/17.
//  Copyright (c) 2015年 culturalCenter. All rights reserved.
//

#import "ForthonPerformArtCategory.h"
#import "ForthonPerformViewCell.h"
#import "performMeasurement.h"
#import "ForthonDataContainer.h"
#import "ForthonTapGesture.h"
#import "ForthonDataSpider.h"

#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#define HOST @"http://art.uestcbmi.com"

@interface ForthonPerformArtCategory ()


@property BOOL *isOk;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) NSMutableArray *videoImageArray;


@end

@implementation ForthonPerformArtCategory

- (void)viewDidLoad {
    [super viewDidLoad];
    _isOk = YES;
    if (![[ForthonDataContainer sharedStore].videosDic[0] objectForKey:@"videoImage"]) {
        self.delegate = [ForthonDataSpider sharedStore];
        [_delegate getVideosByTypeid:_categoryIndex page:1];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(createThread)
                                                     name:@"NotificationA"
                                                   object:nil];

        _isOk = NO;
        
    }
   

    self.tableView.separatorStyle = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if (_isOk) {
        return 1;
    } else
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (_isOk) {
        return [[ForthonDataContainer sharedStore].videosDic count];
    } else
        return 1;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return BACKVIEWHEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_isOk) {
        int index = indexPath.row;
        NSLog(@"reload cellView");
        static NSString *cellIdentifier = @"cell";
        ForthonPerformViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[ForthonPerformViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            NSLog(@"new!");
           cell = [cell load];
            
        }
        ForthonTapGesture *tap = [[ForthonTapGesture alloc] initWithTarget:self action:@selector(beginPushView:)];
        tap.tag = index;
        NSString *name = [[ForthonDataContainer sharedStore].videosDic[index] objectForKey:@"userNickName"];
        [cell.nameLabel setText:name];
        NSData *headImageData = [[ForthonDataContainer sharedStore].videosDic[index] objectForKey:@"headImage"];
        [cell.headImageView setImage:[UIImage imageWithData:headImageData]];
        NSData *videoImageData = [[ForthonDataContainer sharedStore].videosDic[index] objectForKey:@"videoImage"];
        [cell.videoImage setImage:[UIImage imageWithData:videoImageData]];
        [cell.videoImage setTag:index];
        [cell.videoImage addGestureRecognizer:tap];
        cell.videoImage.userInteractionEnabled = YES;
      
        return cell;
    } else {
        
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        return cell;
    }
   
    
}


- (void)beginPushView:(ForthonTapGesture *)gesture
{
    
    NSLog(@"push!push!");
    NSString *videoStr = [[ForthonDataContainer sharedStore].videosDic[gesture.tag] objectForKey:@"videoUrl"];
    
    
    MPMoviePlayerViewController *playerViewController =[[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:videoStr]];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];    [self presentMoviePlayerViewControllerAnimated:playerViewController];
}

- (void)createThread
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(updateUI) object:nil];
    [thread start];
}

- (void)updateUI
{
//    [_delegate getVideosByTypeid:1 page:1]; 
//    if ([[ForthonDataContainer sharedStore].videos count]) {
    NSString *nameStr = [[ForthonDataContainer sharedStore].videosDic[0] objectForKey:@"userNickName"];
        NSLog(@"name: %@", nameStr);
        _videoImageArray = [[NSMutableArray alloc] init];
        NSMutableArray *headImageArray = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [[ForthonDataContainer sharedStore].videosDic count]; i++) {
            NSString *videoUrlStringBody = [[ForthonDataContainer sharedStore].videosDic[i] objectForKey:@"picUrl"];
            NSString *videoUrlString = [NSString stringWithFormat:@"%@%@", HOST, videoUrlStringBody];
            NSString *headUrlStringBody = [[ForthonDataContainer sharedStore].videosDic[i] objectForKey:@"userAvatarUrl"];
            NSString *headUrlString = [NSString stringWithFormat:@"%@%@", HOST, headUrlStringBody];
            headImageArray[i] = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:headUrlString]];
            _videoImageArray[i] = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:videoUrlString]];
            [[ForthonDataContainer sharedStore].videosDic[i] setObject:_videoImageArray[i] forKey:@"videoImage"];
            [[ForthonDataContainer sharedStore].videosDic[i] setObject:headImageArray[i] forKey:@"headImage"];

        }
    
            _isOk = YES;
            [self.tableView reloadData];
            NSLog(@"reloadData");
 
   

}


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
