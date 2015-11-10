//
//  DataManager.h
//  MusicPlayer
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 刘迪. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Music;
typedef void (^UpdataUI)();

@interface DataManager : NSObject

@property (nonatomic, retain) NSMutableArray *musicArray;
@property (nonatomic, copy) UpdataUI myUpDataUI;

/**
 *  单例方法
 *
 *  @return 单例
 */
+ (DataManager *)sharedManager;

- (Music *)musicWithIndex:(NSInteger)index;

@end
