//
//  MusicCell.m
//  MusicPlayer
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 刘迪. All rights reserved.
//

#import "MusicCell.h"
#import "Music.h"

@implementation MusicCell

- (void)setMusic:(Music *)music {
    _music = music;  // 接收
    _musicLabel.text = music.name;
    _singerLabel.text = music.singer;
    // 此处打断点，下面控制台：po model.name
    [_imgView sd_setImageWithURL:[NSURL URLWithString:music.picUrl] placeholderImage:[UIImage imageNamed:@"1.gif"]];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
