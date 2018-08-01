//
//  TYDemoViewController.m
//  AVAudioPlayer-demo
//
//  Created by Maty on 2018/7/30.
//  Copyright © 2018年 kangarootec. All rights reserved.
//

#import "TYDemoViewController.h"
#import <AVFoundation/AVFoundation.h>

#define TYSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define TYSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface TYDemoViewController ()

@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *pauseButton;
@property (nonatomic, strong) UIButton *stopButton;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

/** 音量 **/
@property (nonatomic, strong) UILabel *volumeLabel;
@property (nonatomic, strong) UISlider *volumeSlider;

/** 立体声音播放 **/
@property (nonatomic, strong) UILabel *panLabel;
@property (nonatomic, strong) UISlider *panSlider;

/** 播放率 **/
@property (nonatomic, strong) UILabel *rateLabel;
@property (nonatomic, strong) UISlider *rateSlider;

// 无限循环
@property (nonatomic, strong) UILabel *infiniteLoopLabel;
@property (nonatomic, strong) UISwitch *infiniteLoopSwitch;

@end

@implementation TYDemoViewController {
    UILabel *_stereoSurround_LeftEar;   // 立体环绕-左耳
    UILabel *_stereoSurround_RightEar;  // 立体环绕-右耳
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
    /* You must set enableRate to YES for the rate property to take effect. You must set this before calling prepareToPlay. */
    // 必须设置这个为 YES, rate 操控时才能生效,否则没有作用
    // 必须在 prepareToPlay 方法前设置
    [self.audioPlayer setEnableRate:YES];
    
    // 如果返回一个有效的播放实例,建议调用 prepareToPlay 方法,这样做会取得需要的音频硬件并预加载 Audio Queue 的缓冲区
    // 调用 prepareToPlay 这个动作是可选的,当调用 play 方法时会隐藏性激活,不过在创建时准备播放器可以降低调用 play 方法和听到声音输出之间的延时.
    if (self.audioPlayer) {
        [self.audioPlayer prepareToPlay];
    }
    
    // 默认音量最大 1.0
    self.audioPlayer.volume = 1.0;
    self.volumeSlider.value = 1.0;
    
    // 默认 pan 居中 0.0(pan 立体声播放声音, -1.0~1.0. 0.0居中)
    self.audioPlayer.pan = 0.0;
    self.panSlider.value = 0.0;
    
    // 默认 rate 正常. 1.0
    self.audioPlayer.rate = 1.0;
    self.rateSlider.value = 1.0;
    
}
#pragma mark - Custom Method
// 播放
- (void)playButtonClick {
    [self.audioPlayer play];
}

// 暂停
- (void)pauseButtonClick {
    [self.audioPlayer pause];
}

// 停止
- (void)stopButtonClick {
    [self.audioPlayer stop];
}

// 修改音量
- (void)volumeSliderChanged:(UISlider *)slider {
    self.audioPlayer.volume = slider.value;
}

// pan 控制
- (void)panSliderChanged:(UISlider *)slider {
    self.audioPlayer.pan = slider.value;
}

// rate 播放率控制
- (void)rateSliderChanged:(UISlider *)slider {
    NSLog(@"%f",slider.value);

    self.audioPlayer.rate = slider.value;
}

// 无限循环
- (void)infiniteLoopSwitchValueChange:(UISwitch *)ss {
    if (ss.on) {
        // 设置 numberOfLoops 为 -1 时,会导致播放器无限循环
        [self.audioPlayer setNumberOfLoops:-1];
    } else {
        /// 设置 numberOfLoops 为一个大于0的数时,可以实现播放器 n 次循环播放
        [self.audioPlayer setNumberOfLoops:0];
    }
}

#pragma mark - UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 1.播放
    self.playButton.frame = CGRectMake(100, 100, TYSCREEN_WIDTH - 200, 40);
    [self.view addSubview:self.playButton];
    
    // 2.暂停
    self.pauseButton.frame = CGRectMake(100, 150, TYSCREEN_WIDTH - 200, 40);
    [self.view addSubview:self.pauseButton];

    // 3.停止播放
    self.stopButton.frame = CGRectMake(100, 200, TYSCREEN_WIDTH - 200, 40);
    [self.view addSubview:self.stopButton];
    
    // 4.音量控制
    self.volumeLabel.frame = CGRectMake(20, 300, 50, 30);
    [self.view addSubview:self.volumeLabel];
    
    self.volumeSlider.frame = CGRectMake(80, 300, TYSCREEN_WIDTH - 160, 30);
    [self.view addSubview:self.volumeSlider];
    
    // 5.立体声音控制
    self.panLabel.frame = CGRectMake(20, 360, 50, 30);
    [self.view addSubview:self.panLabel];
    
    self.panSlider.frame = CGRectMake(80, 360, TYSCREEN_WIDTH - 160, 30);
    [self.view addSubview:self.panSlider];
    
    _stereoSurround_LeftEar = [[UILabel alloc] init];
    _stereoSurround_LeftEar.textColor = [UIColor lightGrayColor];
    _stereoSurround_LeftEar.text = @"立体环绕-左耳";
    _stereoSurround_LeftEar.font = [UIFont systemFontOfSize:10];
    _stereoSurround_LeftEar.frame = CGRectMake(80, 350, 70, 20);
    [self.view addSubview:_stereoSurround_LeftEar];
    
    _stereoSurround_RightEar = [[UILabel alloc] init];
    _stereoSurround_RightEar.textColor = [UIColor lightGrayColor];
    _stereoSurround_RightEar.text = @"立体环绕-右耳";
    _stereoSurround_RightEar.font = [UIFont systemFontOfSize:10];
    _stereoSurround_RightEar.frame = CGRectMake(80 + (TYSCREEN_WIDTH - 160) - 70, 350, 70, 20);
    [self.view addSubview:_stereoSurround_RightEar];
    
    // 6.播放率控制
    self.rateLabel.frame = CGRectMake(20, 420, 50, 30);
    [self.view addSubview:self.rateLabel];
    self.rateSlider.frame = CGRectMake(80, 420, TYSCREEN_WIDTH - 160, 30);
    [self.view addSubview:self.rateSlider];
    
    // 7.循环播放
    self.infiniteLoopLabel.frame = CGRectMake(20, 480, 80, 30);
    [self.view addSubview:self.infiniteLoopLabel];
    self.infiniteLoopSwitch.frame = CGRectMake(100, 480, 50, 30);
    [self.view addSubview:self.infiniteLoopSwitch];
    
}

#pragma mark - Lazy Load
- (UIButton *)playButton {
    if (nil == _playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setTitle:@"Play" forState:UIControlStateNormal];
        [_playButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_playButton setBackgroundColor:[UIColor orangeColor]];
        [_playButton addTarget:self action:@selector(playButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _playButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _playButton;
}

- (UIButton *)pauseButton {
    if (nil == _pauseButton) {
        _pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pauseButton setTitle:@"Pause" forState:UIControlStateNormal];
        [_pauseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_pauseButton setBackgroundColor:[UIColor orangeColor]];
        [_pauseButton addTarget:self action:@selector(pauseButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _pauseButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _pauseButton;
}

- (UIButton *)stopButton {
    if (nil == _stopButton) {
        _stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_stopButton setTitle:@"Stop" forState:UIControlStateNormal];
        [_stopButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_stopButton setBackgroundColor:[UIColor orangeColor]];
        [_stopButton addTarget:self action:@selector(stopButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _stopButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _stopButton;
}

- (AVAudioPlayer *)audioPlayer {
    if (nil == _audioPlayer) {

        NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"1" withExtension:@"mp3"];
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:nil];
        
    }
    return _audioPlayer;
}

- (UILabel *)volumeLabel {
    if (nil == _volumeLabel) {
        _volumeLabel = [[UILabel alloc] init];
        _volumeLabel.textColor = [UIColor lightGrayColor];
        _volumeLabel.font = [UIFont systemFontOfSize:14];
        _volumeLabel.textAlignment = NSTextAlignmentCenter;
        _volumeLabel.text = @"音量";
    }
    return _volumeLabel;
}

- (UISlider *)volumeSlider {
    if (nil == _volumeSlider) {
        _volumeSlider = [[UISlider alloc] init];
        _volumeSlider.minimumValue = 0.0;
        _volumeSlider.maximumValue = 1.0;
        [_volumeSlider addTarget:self action:@selector(volumeSliderChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _volumeSlider;
}

- (UILabel *)panLabel {
    if (nil == _panLabel) {
        _panLabel = [[UILabel alloc] init];
        _panLabel.textColor = [UIColor lightGrayColor];
        _panLabel.font = [UIFont systemFontOfSize:14];
        _panLabel.textAlignment = NSTextAlignmentCenter;
        _panLabel.text = @"Pan";
    }
    return _panLabel;
}

- (UISlider *)panSlider {
    if (nil == _panSlider) {
        _panSlider = [[UISlider alloc] init];
        _panSlider.minimumValue = -1.0;
        _panSlider.maximumValue = 1.0;
        [_panSlider addTarget:self action:@selector(panSliderChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _panSlider;
}

- (UILabel *)rateLabel {
    if (nil == _rateLabel) {
        _rateLabel = [[UILabel alloc] init];
        _rateLabel.textColor = [UIColor lightGrayColor];
        _rateLabel.font = [UIFont systemFontOfSize:14];
        _rateLabel.text = @"Rate";
        _rateLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rateLabel;
}

- (UISlider *)rateSlider {
    if (nil == _rateSlider) {
        _rateSlider = [[UISlider alloc] init];
        _rateSlider.minimumValue = 0.5;
        _rateSlider.maximumValue = 2.0;
        [_rateSlider addTarget:self action:@selector(rateSliderChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _rateSlider;
}

- (UILabel *)infiniteLoopLabel {
    if (nil == _infiniteLoopLabel) {
        _infiniteLoopLabel = [[UILabel alloc] init];
        _infiniteLoopLabel.textColor = [UIColor lightGrayColor];
        _infiniteLoopLabel.text = @"无限循环";
        _infiniteLoopLabel.textAlignment = NSTextAlignmentCenter;
        _infiniteLoopLabel.font = [UIFont systemFontOfSize:14];
    }
    return _infiniteLoopLabel;
}

- (UISwitch *)infiniteLoopSwitch {
    if (nil == _infiniteLoopSwitch) {
        _infiniteLoopSwitch = [[UISwitch alloc] init];
        [_infiniteLoopSwitch setTintColor:[UIColor orangeColor]];
        [_infiniteLoopSwitch setOnTintColor:[UIColor orangeColor]];
        [_infiniteLoopSwitch addTarget:self action:@selector(infiniteLoopSwitchValueChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _infiniteLoopSwitch;
}

@end
