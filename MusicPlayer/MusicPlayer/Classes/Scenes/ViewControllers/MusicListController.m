//
//  MusicListController.m
//  MusicPlayer
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 刘迪. All rights reserved.
//

#import "MusicListController.h"
#import "MusicCell.h"
#import "DataManager.h"
#import "Music.h"
#import "PlayerManager.h"
#import "PlayingViewController.h"

@interface MusicListController ()

@end

@implementation MusicListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 自定义注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MusicCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"customCell"];
    
    // 引用
    [DataManager sharedManager].myUpDataUI = ^() {
        [self.tableView reloadData];
    };
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([DataManager sharedManager].musicArray.count != 0) {
        return [DataManager sharedManager].musicArray.count;
    }
    return 10;
}
- (IBAction)toPlay:(UIButton *)sender {
    PlayingViewController *playingVC = [PlayingViewController sharedPlayingPVC];
    [self presentViewController:playingVC animated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MusicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"customCell" forIndexPath:indexPath];
    // cell内容
    if ([DataManager sharedManager].musicArray.count != 0) {
        Music *music = [[DataManager sharedManager] musicWithIndex:indexPath.row];
        cell.music = music;
       
    }
    
    // 无选中灰色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 正在点击的cell
//    MusicCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    NSLog(@"@%@",cell.music);
    
    // 模态到playing
    PlayingViewController *playingVC = [PlayingViewController sharedPlayingPVC];
    playingVC.index = indexPath.row;  // 下标
    [self presentViewController:playingVC animated:YES completion:nil];
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
