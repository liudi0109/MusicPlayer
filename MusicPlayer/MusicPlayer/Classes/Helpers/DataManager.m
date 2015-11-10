//
//  DataManager.m
//  MusicPlayer
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 刘迪. All rights reserved.
//

#import "DataManager.h"
#import "Music.h"

@implementation DataManager

// command + ctrl + ⬆️ + ⬇️ 切换 .h .m
static DataManager *manager = nil;
+ (DataManager *)sharedManager {
    // GCD 提供的一种单例方法
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [DataManager new];
        [manager requestData];
    });
    return manager;
}

// 请求网址
- (void)requestData {
    // 在子线程中请求数据，防止假死（让tableView不受子线程影响）
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 数据连接
        NSURL *url = [NSURL URLWithString:kMusicListURL];
        // 请求数据
        NSArray *array = [NSArray arrayWithContentsOfURL:url];
        
        for (NSMutableDictionary *dic in array) {
            Music *music = [Music new];
            [music setValuesForKeysWithDictionary:dic];
            [_musicArray addObject:music];
        }
        for (Music *music in _musicArray) {
            NSLog(@"%@",music);
        }
        // 返回主线程更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!self.myUpDataUI) {
                NSLog(@"block 没有代码");
            } else {
                self.myUpDataUI();
            }
        });
    });
}

- (Music *)musicWithIndex:(NSInteger)index {
    return self.musicArray[index];
}

#pragma mark -- lazy load

- (NSMutableArray *)musicArray {
    if (!_musicArray) {
        _musicArray = [NSMutableArray array];
    }
    return _musicArray;
}


@end
