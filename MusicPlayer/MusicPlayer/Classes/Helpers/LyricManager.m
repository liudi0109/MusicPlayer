//
//  LyricManager.m
//  MusicPlayer
//
//  Created by lanou3g on 15/11/10.
//  Copyright © 2015年 刘迪. All rights reserved.
//

#import "LyricManager.h"
#import "Lyric.h"

@interface LyricManager()

// 用来存放歌词
@property (nonatomic, retain) NSMutableArray *lyricArray;

@end

@implementation LyricManager


static LyricManager *manager = nil;
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [LyricManager new];
    });
    return manager;
}

- (void)loadLyricWith:(NSString *)lyricStr {
    // 1.分行
    NSMutableArray *lyricStringArray = [[lyricStr componentsSeparatedByString:@"\n"] mutableCopy];
    /**
     * str = [00:51.530]Little love and little sympathy
     * 最后一行也有换行符,所以取最后一行时，会取一个空进去，此时可以做两个操作
     * 1.[lyricStringArray removeLastObject];
     * 2.if ([str isEqualToString:@""]) {
     continue;
     }
     */
    [lyricStringArray removeLastObject];
    
    // 先将之前歌曲歌词移除
    [self.lyricArray removeAllObjects];
    
    for (NSString *str in lyricStringArray) {
//        if ([str isEqualToString:@""]) {
//            continue;
//        }
        // 2.分开时间和歌词
        NSArray *timeAndLyric = [str componentsSeparatedByString:@"]"];
        /**
         *  有些歌词前面很多介绍，没有时间，这样在取的时候数组中只有一个元素，所以判断一下，数组元素是否为2，不然会崩
         */
        if (timeAndLyric.count != 2) {
            continue;
        }
        // 3.去掉时间左边的“[”
        NSString *time = [timeAndLyric[0] substringFromIndex:1];
        // time = 00:51.530
        // 4.截取时间（获取分和秒）
        NSArray *minuteAndSecond = [time componentsSeparatedByString:@":"];
        // 分
        NSInteger minute = [minuteAndSecond[0] integerValue];
        // 秒
        double second = [minuteAndSecond[1] doubleValue];
        // 5.封装成model
        Lyric *model = [[Lyric alloc] initWithTime:(minute * 60 + second) lyricContext:timeAndLyric[1]];
        // 6.添加到数组
        [self.lyricArray addObject:model];
   }
}

- (NSInteger)indexWith:(NSTimeInterval)time {
    NSInteger index = 0;
    // 遍历数组，找到还没有播放的那句歌词
    for (int i = 0; i < self.lyricArray.count; i++) {
        Lyric *model = self.lyricArray[i];
        if (model.time > time) {
            // 注意：如果是第0个元素，而且元素时间要比播放的时间大，i- 1就会<0,这样tableView就会crash
            index = (i - 1 > 0) ? i - 1 : 0;
            break;  // 假如11>10,下一次循环12>10,会一直找到最后一行，此处只要model.time > time就停止
        }
    }
    return index;
}

// 懒加载
- (NSMutableArray *)lyricArray {
    if (!_lyricArray) {
        _lyricArray = [NSMutableArray new];
    }
    return _lyricArray;
}

// get方法(此处NSArray是不可变的，外界只能访问，保证安全)
- (NSArray *)allLyric {
    return self.lyricArray;
}



@end
