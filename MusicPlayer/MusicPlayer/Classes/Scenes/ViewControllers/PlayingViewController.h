//
//  PlayingViewController.h
//  MusicPlayer
//
//  Created by lanou3g on 15/11/5.
//  Copyright © 2015年 刘迪. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Music;

@interface PlayingViewController : UIViewController

+ (instancetype)sharedPlayingPVC;

// 要播放第几首
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, retain) Music *music;


@end
