//
//  Music.m
//  MusicPlayer
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 刘迪. All rights reserved.
//

#import "Music.h"

@implementation Music

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        _ID = value;
    } else {
        NSLog(@"error key:%@",value);
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@--%@",_name,_singer];
}

@end
