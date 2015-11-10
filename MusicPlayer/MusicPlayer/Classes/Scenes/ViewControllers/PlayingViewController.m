//
//  PlayingViewController.m
//  MusicPlayer
//
//  Created by lanou3g on 15/11/5.
//  Copyright © 2015年 刘迪. All rights reserved.
//

#import "PlayingViewController.h"
#import "PlayerManager.h"
#import "DataManager.h"
#import "Music.h"
#import "LyricManager.h"
#import "Lyric.h"

@interface PlayingViewController ()<PlayerManagerDelegate,UITableViewDataSource,UITableViewDelegate>

// tableView ---> playingViewController  设置代理和数据源


// 记录一下当前播放音乐的索引
@property (nonatomic, assign) NSInteger currentIndex;

// 记录当前正在播放的音乐
@property (nonatomic, retain) Music *currentMusic;

@property (strong, nonatomic) IBOutlet UILabel *musicLabel;
@property (strong, nonatomic) IBOutlet UILabel *singerLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *playTime;
@property (strong, nonatomic) IBOutlet UILabel *lastTime;
@property (strong, nonatomic) IBOutlet UISlider *timeSlider;
@property (strong, nonatomic) IBOutlet UISlider *valumeSlider;
@property (strong, nonatomic) IBOutlet UIButton *btn4PlayOrPause;
@property (strong, nonatomic) IBOutlet UITableView *tableView4Lyric;
@property (strong, nonatomic) IBOutlet UIImageView *imgView11;

@end

static PlayingViewController *playingVC = nil;

@implementation PlayingViewController

+ (instancetype)sharedPlayingPVC {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 拿到main storyBoard
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        // 在main storyBoard 拿到我们要用的视图控制器
        playingVC = [sb instantiateViewControllerWithIdentifier:@"playingVC"];
        
    });
    return playingVC;
}

// 播放事件
- (void)startPlay {
    [[PlayerManager sharedManager] playWithUrlString:self.currentMusic.mp3Url];
    [self buildUI];
    
}
#pragma mark ---set方法
- (void)buildUI {
    // 赋值(_不走get方法，此处用self)-----------------------------
    _musicLabel.text = self.currentMusic.name;
    _singerLabel.text = self.currentMusic.singer;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:self.currentMusic.picUrl] placeholderImage:[UIImage imageNamed:@"1.gif"]];
    [_imgView11 sd_setImageWithURL:[NSURL URLWithString:self.currentMusic.blurPicUrl] placeholderImage:[UIImage imageNamed:@"1.gif"]];
    
    // 更改button的text
    [self.btn4PlayOrPause setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
    
    // 改变进度条的最大值
    self.timeSlider.maximumValue = [self.currentMusic.duration integerValue] / 1000; // duration属性单位是ms
    
    // 播放下一首时进度条置为0
    self.timeSlider.value = 0;
    
    // 改变最大音量
    self.valumeSlider.maximumValue = 10;
    
    // 更改旋转的角度,图片归位（角度：0）
    self.imgView.transform = CGAffineTransformMakeRotation(0);
    
    // 调用歌词解析
    [[LyricManager sharedManager] loadLyricWith:self.currentMusic.lyric];
    [self.tableView4Lyric reloadData];  // 刷新
    
    
    
}
// 上一首
- (IBAction)action4Prev:(UIButton *)sender {
    _currentIndex--;
    if (_currentIndex == -1) {
        _currentIndex =[DataManager sharedManager].musicArray.count-1;
    }
    [self startPlay];
}
// 暂停或播放事件
- (IBAction)action4PlayOrPause:(UIButton *)sender {
    // 判断是否正在播放
    if ([PlayerManager sharedManager].isPlaying) {
        // 如果正在播放，就暂停，同时改变text
        [[PlayerManager sharedManager] pause];
        [sender setImage:[UIImage imageNamed:@"播放"] forState:(UIControlStateNormal)];
    } else {
        [[PlayerManager sharedManager] play];
        [sender setImage:[UIImage imageNamed:@"暂停"] forState:(UIControlStateNormal)];
    }
}
// 下一首
- (IBAction)action4Next:(UIButton *)sender {
    // 先让上一首停下来，不然再播下一首时存在多个NSTimer,速度会加快
    [[PlayerManager sharedManager] pause];
    
    _currentIndex++;
    if (_currentIndex == [DataManager sharedManager].musicArray.count) {
        _currentIndex = 0;
    }
    [self startPlay];
}
// 时间滑块
- (IBAction)time:(UISlider *)sender {
    UISlider *slider = sender;
    // 调用接口
    [[PlayerManager sharedManager] seekToTime:slider.value];
    
}
// 音量滑块
- (IBAction)valume:(UISlider *)sender {
    UISlider *slider = sender;
    [[PlayerManager sharedManager] seekToValume:slider.value];
}

#pragma mark ---get方法
- (Music *)currentMusic {
    // 取到要播放的model
    Music *music = [[DataManager sharedManager] musicWithIndex:self.currentIndex];
    return music;
}

// 判断（当前音乐与要播放的音乐）
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 如果要播放的音乐和当前的音乐一样，什么也不做
    if (_index == _currentIndex) {
        return;
    }
    // 如果不相同，当前播放的音乐变成要播放的音乐
    _currentIndex = _index;
    
    [self startPlay];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentIndex = -1;  // 列表从0开始，不能播放
    
    [self.tableView4Lyric registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    _imgView.layer.masksToBounds = YES;
    _imgView.layer.cornerRadius = _imgView.frame.size.width / 2;
    
    // 设置代理(自己是代理，帮播放器做事)
    [PlayerManager sharedManager].delegate = self;
    // 让时间
    self.valumeSlider.value = [PlayerManager sharedManager].volume;
    
}
#pragma mark ----delegate
// 播放器播放结束了，开始播放下一首
- (void)playerDidPlayEnd {
    [self action4Next:nil];  // 触发事件
}
// 播放器每0.1秒会让代理（也就是这个页面）执行此事件
- (void)playerPlayingWithTime:(NSTimeInterval)time {
    self.timeSlider.value = time;
    self.playTime.text = [self stringWithTime:time];  // 播放时间
    // 剩余时间
    NSTimeInterval lastTime1 = [self.currentMusic.duration integerValue] / 1000 - time;
    self.lastTime.text = [self stringWithTime:lastTime1];
    // 每0.1秒旋转一度
    self.imgView.transform = CGAffineTransformRotate(self.imgView.transform, M_PI / 180);
    // 根据 当前播放的时间获取到应该播放的那句歌词
    NSInteger index = [[LyricManager sharedManager] indexWith:time];
    NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
    // 让tableView选中我们找到的歌词
    [self.tableView4Lyric selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionBottom];
    
}
// 根据时间获取到字符串
- (NSString *)stringWithTime:(NSTimeInterval)time {
    NSInteger minute = time / 60;
    NSInteger seconds = (int)time % 60;
    return [NSString stringWithFormat:@"%.2ld:%.2ld",minute,seconds];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 返回按钮
- (IBAction)back:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [LyricManager sharedManager].allLyric.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    // 取到对应的model
    Lyric *lyric = [LyricManager sharedManager].allLyric[indexPath.row];
    // cell内容
    cell.textLabel.text = lyric.lyricContext;
    // cell背景设为透明
    cell.backgroundColor = [UIColor clearColor];
    // 居中
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
