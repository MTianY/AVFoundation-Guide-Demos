//
//  TYAudioLooperViewController.m
//  AudioLooperDemo
//
//  Created by Maty on 2018/7/31.
//  Copyright © 2018年 kangarootec. All rights reserved.
//

#import "TYAudioLooperViewController.h"
#import "TYPlayer.h"

#define TYSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define TYSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define kMargin_Horizontal 80
#define kMargin_Vertical 50

@interface TYAudioLooperViewController ()

@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UISlider *rateSlider;

@property (nonatomic, strong) UILabel *guitarLabel;
@property (nonatomic, strong) UISlider *panSlider_Guitar;
@property (nonatomic, strong) UISlider *volumeSlider_Guitar;

@property (nonatomic, strong) UILabel *bassLabel;
@property (nonatomic, strong) UISlider *panSlider_Bass;
@property (nonatomic, strong) UISlider *volumeSlider_Bass;

@property (nonatomic, strong) UILabel *drumLabel;
@property (nonatomic, strong) UISlider *panSlider_Drum;
@property (nonatomic, strong) UISlider *volumeSlider_Drum;

@end

@implementation TYAudioLooperViewController {
    UILabel *_panLabel_guitar;
    UILabel *_volumrLabel_guitar;
    
    UILabel *_panLabel_bass;
    UILabel *_volumrLabel_bass;
    
    UILabel *_panLabel_drum;
    UILabel *_volumrLabel_drum;
    
    UILabel *_rateLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupNavigationBar];
    
    // 默认正常值
    self.rateSlider.value = 1.0f;
    self.panSlider_Guitar.value = 0.0f;
    self.panSlider_Bass.value = 0.0f;
    self.panSlider_Drum.value = 0.0f;
    
    self.volumeSlider_Guitar.value = 1.0f;
    self.volumeSlider_Bass.value = 1.0f;
    self.volumeSlider_Drum.value = 1.0f;
    
}

#pragma mark - Custom Method
- (void)playButtonClick:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        [[TYPlayer shareInstance] play];
        [self.playButton setTitle:@"Stop" forState:UIControlStateNormal];
    } else {
        [[TYPlayer shareInstance] stop];
        [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
    }
}

- (void)sliderMethod:(UISlider *)slider {
    // rate
    if (slider.tag == 10) {
        NSLog(@"rate");
        [[TYPlayer shareInstance] adjustRate:slider.value];
    }
    
    // guitar Pan
    if (slider.tag == 20) {
        [[TYPlayer shareInstance] adjustPan:slider.value forPlayerAtIndex:0];
    }
    
    // guitar Volume
    if (slider.tag == 21) {
        [[TYPlayer shareInstance] adjustVolume:slider.value forPlayerAtIndex:0];
    }
    
    // bass Pan
    if (slider.tag == 30) {
        [[TYPlayer shareInstance] adjustPan:slider.value forPlayerAtIndex:1];
    }
    
    // bass Volume
    if (slider.tag == 31) {
        [[TYPlayer shareInstance] adjustVolume:slider.value forPlayerAtIndex:1];
    }
    
    // drum Pan
    if (slider.tag == 40) {
        [[TYPlayer shareInstance] adjustPan:slider.value forPlayerAtIndex:2];
    }
    
    // drum Volume
    if (slider.tag == 41) {
        [[TYPlayer shareInstance] adjustVolume:slider.value forPlayerAtIndex:2];
    }
}

// 创建公共 Label
- (UILabel *)createCommonInfoLabel {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    return label;
}

#pragma mark - UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 1.play
    self.playButton.frame = CGRectMake(TYSCREEN_WIDTH - 50 - 64, 50, 64, 64);
    [self.view addSubview:self.playButton];
    
    // 2.rate
    self.rateSlider.frame = CGRectMake(TYSCREEN_WIDTH - 50 - 64, TYSCREEN_HEIGHT - 50 -64, 64, 64);
    [self.view addSubview:self.rateSlider];
    
    _rateLabel = [self createCommonInfoLabel];
    _rateLabel.text = @"Rate";
    _rateLabel.frame = CGRectMake(TYSCREEN_WIDTH - 50 - 64, TYSCREEN_HEIGHT - 50 -14, 60, 30);
    [self.view addSubview:_rateLabel];
    
    // 3.guitar
    self.guitarLabel.frame = CGRectMake(50, 50, 80, 30);
    [self.view addSubview:self.guitarLabel];
    self.panSlider_Guitar.frame = CGRectMake(20, 50 + 30 + kMargin_Vertical, 100, 30);
    [self.view addSubview:self.panSlider_Guitar];
    self.volumeSlider_Guitar.frame = CGRectMake(20, 50+30+kMargin_Vertical + 100+50, 100, 30);
    [self.view addSubview:self.volumeSlider_Guitar];
    
    _panLabel_guitar = [self createCommonInfoLabel];
    _panLabel_guitar.text = @"Pan";
    _panLabel_guitar.frame = CGRectMake(40, 50 + 30 + kMargin_Vertical+30, 60, 30);
    [self.view addSubview:_panLabel_guitar];
    
    _volumrLabel_guitar = [self createCommonInfoLabel];
    _volumrLabel_guitar.text = @"Volume";
    _volumrLabel_guitar.frame = CGRectMake(40, 50+30+kMargin_Vertical + 100+50 + 30, 60, 30);
    [self.view addSubview:_volumrLabel_guitar];
    
    // 4.bass
    self.bassLabel.frame = CGRectMake(50 + kMargin_Horizontal + 80, 50, 80, 30);
    [self.view addSubview:self.bassLabel];
    self.panSlider_Bass.frame = CGRectMake(20 + 80 + kMargin_Horizontal, 50 + 30 + kMargin_Vertical, 100, 30);
    [self.view addSubview:self.panSlider_Bass];
    self.volumeSlider_Bass.frame = CGRectMake(20 + 80 + kMargin_Horizontal, 50+30+kMargin_Vertical + 100+50, 100, 30);
    [self.view addSubview:self.volumeSlider_Bass];
    
    _panLabel_bass = [self createCommonInfoLabel];
    _panLabel_bass.text = @"Pan";
    _panLabel_bass.frame = CGRectMake(20 + 80 + kMargin_Horizontal+20, 50 + 30 + kMargin_Vertical+30, 60, 30);
    [self.view addSubview:_panLabel_bass];
    
    _volumrLabel_bass = [self createCommonInfoLabel];
    _volumrLabel_bass.text = @"Volume";
    _volumrLabel_bass.frame = CGRectMake(20 + 80 + kMargin_Horizontal+20, 50+30+kMargin_Vertical + 100+50 + 30, 60, 30);
    [self.view addSubview:_volumrLabel_bass];
    
    // 5.drum
    self.drumLabel.frame = CGRectMake(50 + 80 + kMargin_Horizontal + 80 + kMargin_Horizontal, 50, 80, 30);
    [self.view addSubview:self.drumLabel];

    self.panSlider_Drum.frame = CGRectMake(20 + 150 + kMargin_Horizontal + kMargin_Horizontal, 50 + 30 + kMargin_Vertical, 100, 30);
    [self.view addSubview:self.panSlider_Drum];
    self.volumeSlider_Drum.frame = CGRectMake(20 + 150 + kMargin_Horizontal + kMargin_Horizontal, 50 + 30 + kMargin_Vertical + 100+50, 100, 30);
    [self.view addSubview:self.volumeSlider_Drum];
    
    _panLabel_drum = [self createCommonInfoLabel];
    _panLabel_drum.text = @"Pan";
    _panLabel_drum.frame = CGRectMake(20 +80 + kMargin_Horizontal + 80 + kMargin_Horizontal + 20, 50 + 30 + kMargin_Vertical+30, 60, 30);
    [self.view addSubview:_panLabel_drum];
    
    _volumrLabel_drum = [self createCommonInfoLabel];
    _volumrLabel_drum.text = @"Drum";
    _volumrLabel_drum.frame = CGRectMake(20 + 80 + kMargin_Horizontal + 80 + kMargin_Horizontal + 20, 50+30+kMargin_Vertical + 100+50 + 30, 60, 30);
    [self.view addSubview:_volumrLabel_drum];
    
}

- (void)setupNavigationBar {
    self.navigationItem.title = @"AudioLooperDemo";
}

#pragma mark - Lazy Load
- (UIButton *)playButton {
    if (nil == _playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_playButton setTitle:@"Play" forState:UIControlStateNormal];
        [_playButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _playButton.titleLabel.font = [UIFont systemFontOfSize:20];
    }
    return _playButton;
}

- (UISlider *)rateSlider {
    if (nil == _rateSlider) {
        _rateSlider = [[UISlider alloc] init];
        _rateSlider.tag = 10;
        [_rateSlider addTarget:self action:@selector(sliderMethod:) forControlEvents:UIControlEventValueChanged];
        _rateSlider.minimumValue = 0.5;
        _rateSlider.maximumValue = 2.0;
    }
    return _rateSlider;
}

- (UILabel *)guitarLabel {
    if (nil == _guitarLabel) {
        _guitarLabel = [[UILabel alloc] init];
        _guitarLabel.text = @"吉他";
        _guitarLabel.textColor = [UIColor lightGrayColor];
        _guitarLabel.font = [UIFont systemFontOfSize:14];
    }
    return _guitarLabel;
}

- (UISlider *)panSlider_Guitar {
    if (nil == _panSlider_Guitar) {
        _panSlider_Guitar = [[UISlider alloc] init];
        _panSlider_Guitar.tag = 20;
        [_panSlider_Guitar addTarget:self action:@selector(sliderMethod:) forControlEvents:UIControlEventValueChanged];
        _panSlider_Guitar.minimumValue = -1.0;
        _panSlider_Guitar.maximumValue = 1.0;
    }
    return _panSlider_Guitar;
}

- (UISlider *)volumeSlider_Guitar {
    if (nil == _volumeSlider_Guitar) {
        _volumeSlider_Guitar = [[UISlider alloc] init];
        _volumeSlider_Guitar.tag = 21;
        [_volumeSlider_Guitar addTarget:self action:@selector(sliderMethod:) forControlEvents:UIControlEventValueChanged];
        _volumeSlider_Guitar.minimumValue = 0.0;
        _volumeSlider_Guitar.maximumValue = 1.0;
    }
    return _volumeSlider_Guitar;
}

- (UILabel *)bassLabel {
    if (nil == _bassLabel) {
        _bassLabel = [[UILabel alloc] init];
        _bassLabel.text = @"贝斯";
        _bassLabel.textColor = [UIColor lightGrayColor];
        _bassLabel.font = [UIFont systemFontOfSize:14];
    }
    return _bassLabel;
}

- (UISlider *)panSlider_Bass {
    if (nil == _panSlider_Bass) {
        _panSlider_Bass = [[UISlider alloc] init];
        _panSlider_Bass.tag = 30;
        [_panSlider_Bass addTarget:self action:@selector(sliderMethod:) forControlEvents:UIControlEventValueChanged];
        _panSlider_Bass.minimumValue = -1.0;
        _panSlider_Bass.maximumValue = 1.0;
    }
    return _panSlider_Bass;
}

- (UISlider *)volumeSlider_Bass {
    if (nil == _volumeSlider_Bass) {
        _volumeSlider_Bass = [[UISlider alloc] init];
        _volumeSlider_Bass.tag = 31;
        [_volumeSlider_Bass addTarget:self action:@selector(sliderMethod:) forControlEvents:UIControlEventValueChanged];
        _volumeSlider_Bass.minimumValue = 0.0;
        _volumeSlider_Bass.maximumValue = 1.0;
    }
    return _volumeSlider_Bass;
}

- (UILabel *)drumLabel {
    if (nil == _drumLabel) {
        _drumLabel = [[UILabel alloc] init];
        _drumLabel.text = @"鼓";
        _drumLabel.textColor = [UIColor lightGrayColor];
        _drumLabel.font = [UIFont systemFontOfSize:14];
    }
    return _drumLabel;
}

- (UISlider *)panSlider_Drum {
    if (nil == _panSlider_Drum) {
        _panSlider_Drum = [[UISlider alloc] init];
        _panSlider_Drum.tag = 40;
        [_panSlider_Drum addTarget:self action:@selector(sliderMethod:) forControlEvents:UIControlEventValueChanged];
        _panSlider_Drum.minimumValue = -1.0;
        _panSlider_Drum.maximumValue = 1.0;
    }
    return _panSlider_Drum;
}

- (UISlider *)volumeSlider_Drum {
    if (nil == _volumeSlider_Drum) {
        _volumeSlider_Drum = [[UISlider alloc] init];
        _volumeSlider_Drum.tag = 41;
        [_volumeSlider_Drum addTarget:self action:@selector(sliderMethod:) forControlEvents:UIControlEventValueChanged];
        _volumeSlider_Drum.minimumValue = 0.0;
        _volumeSlider_Drum.maximumValue = 1.0;
    }
    return _volumeSlider_Drum;
}
@end
