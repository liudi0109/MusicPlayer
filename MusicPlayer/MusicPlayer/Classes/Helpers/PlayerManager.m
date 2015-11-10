//
//  PlayerManager.m
//  MusicPlayer
//
//  Created by lanou3g on 15/11/5.
//  Copyright © 2015年 刘迪. All rights reserved.
//

#import "PlayerManager.h"
#import <AVFoundation/AVFoundation.h>

@interface PlayerManager()
// 播放器 -> 全局唯一 ->，因为如果有两个AVPlayer，就会同时播放两个音乐
@property (nonatomic, retain) AVPlayer *player;
// 计数器
@property (nonatomic, retain) NSTimer *timer;

@end


@implementation PlayerManager

//- (void)dealloc {
//    // 移除观察者
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
//}

// 单例方法
static PlayerManager *manager = nil;
+ (instancetype) sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [PlayerManager new];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        // 添加通知中心，当self发出AVPlayerItemDidPlayToEndTimeNotification时，触发playerDidPlayEnd事件（一首歌播放结束时发送通知，处理事件）
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidPlayEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}
// 通知方法
- (void)playerDidPlayEnd:(NSNotification *)not {
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerDidPlayEnd)]) {  // 有代理并且代理有方法
        // 接收到item播放结束后，让代理去干一件事情，代理会怎么干，播放器不需要知道
        [self.delegate playerDidPlayEnd];
    }
}

- (void)playWithUrlString:(NSString *)urlStr {
    // 如果是切换歌曲，要先把正在播放的观察者移除
    if (self.player.currentItem) {
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    }
    // 创建一个item
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:urlStr]];
    
    // 对item 添加观察者（判断网址是否正确）
    // 观察item 的状态
    [item addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew) context:nil];
    
    // 替换当前正在播放的音乐
    [self.player replaceCurrentItemWithPlayerItem:item];
    
}

// 播放
- (void)play {
    // 如果正在播放，就不播放啦，直接返回
//    if (_isPlaying) {
//        return;
//    }
    
    [self.player play];
    _isPlaying = YES;  // 开始播放后标记一下

    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playingWithSeconds) userInfo:nil repeats:YES];
    
}
// 播放秒数
- (void)playingWithSeconds {
//    NSLog(@"%lld",self.player.currentTime.value / self.player.currentTime.timescale);
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerPlayingWithTime:)]) {
        // 计算播放器现在播放的秒数
        NSTimeInterval time = self.player.currentTime.value / self.player.currentTime.timescale;
        [self.delegate playerPlayingWithTime:time];
    }
}


// 暂停
- (void)pause {
    [self.player pause];
    [self.timer invalidate];  // -------------------------------
    _isPlaying = NO;  // 暂停播放后设为NO
}
// time时间
- (void)seekToTime:(NSTimeInterval)time {
    // 先暂停
    [self pause];
    [self.player seekToTime:CMTimeMakeWithSeconds(time, self.player.currentTime.timescale) completionHandler:^(BOOL finished) {
//        value / timescale = seconds;
        if (finished) {
            // 拖拽成功再播放
            [self play];
        }
    }];
}
// valume音量
- (void)seekToValume:(float)volume {
    [self.player setVolume:volume];
//    self.player.volume = volume;
}
// 用来访问AVPlayer的音量
- (CGFloat)volume {
    return self.player.volume;
}

// 懒加载
- (AVPlayer *)player {
    if (!_player) {
        _player = [AVPlayer new];
    }
    return _player;
}
#pragma mark - 观察响应
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    NSLog(@"%@",keyPath);
    NSLog(@"%@",change);
    // 枚举本身是int类型，change是id类型
    AVPlayerStatus status = [change[@"new"]integerValue];
    // 状态变化后的新值
    switch (status) {
        case AVPlayerStatusFailed:
            NSLog(@"加载失败");
            break;
        case AVPlayerStatusUnknown:
            NSLog(@"资源不对");
            break;
        case AVPlayerStatusReadyToPlay:
            NSLog(@"加载结束，可以播放");
            // 开始播放
            // 先暂停，将NSTimer销毁，然后再播放，创建NSTimer
            [self pause];
            [self play];
            break;
        default:
            break;
    }
    
}

@end
