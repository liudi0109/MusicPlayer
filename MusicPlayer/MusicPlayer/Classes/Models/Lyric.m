//
//  Lyric.m
//  MusicPlayer
//
//  Created by lanou3g on 15/11/10.
//  Copyright © 2015年 刘迪. All rights reserved.
//

#import "Lyric.h"

@implementation Lyric

- (instancetype)initWithTime:(NSTimeInterval)time
                lyricContext:(NSString *)lyric {
    if (self = [super init]) {
        _time = time;
        _lyricContext = lyric;
    }
    return self;
}

@end
