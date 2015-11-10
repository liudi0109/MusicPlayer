//
//  MusicCell.h
//  MusicPlayer
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 刘迪. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Music;

@interface MusicCell : UITableViewCell

@property (nonatomic, retain) Music *music;

@property (strong, nonatomic) IBOutlet UIImageView *imgView;

@property (strong, nonatomic) IBOutlet UILabel *musicLabel;

@property (strong, nonatomic) IBOutlet UILabel *singerLabel;


@end
