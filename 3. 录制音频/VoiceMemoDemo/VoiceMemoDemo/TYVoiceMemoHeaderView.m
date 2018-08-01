//
//  TYVoiceMemoHeaderView.m
//  VoiceMemoDemo
//
//  Created by Maty on 2018/8/1.
//  Copyright © 2018年 kangarootec. All rights reserved.
//

#import "TYVoiceMemoHeaderView.h"

#define TYSCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define TYSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface TYVoiceMemoHeaderView ()

@property (nonatomic, strong) UIButton *playAndPauseButton;
@property (nonatomic, strong) UIButton *stopButton;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation TYVoiceMemoHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - Button Method
- (void)playAndPauseButtonClick:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        
    } else {
        
    }
}

- (void)stopButtonClick:(UIButton *)button {
    
}

#pragma mark - UI
- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    
    self.playAndPauseButton.frame = CGRectMake(TYSCREEN_WIDTH * 0.5 - 100-10, 100, 80, 80);
    [self addSubview:self.playAndPauseButton];
    
    self.stopButton.frame = CGRectMake(TYSCREEN_WIDTH * 0.5 + 100-10-60, 100, 80, 80);
    [self addSubview:self.stopButton];
    
    self.timeLabel.frame = CGRectMake(TYSCREEN_WIDTH * 0.5-100, 40, 200, 40);
    [self addSubview:self.timeLabel];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.frame = CGRectMake(0, 249, TYSCREEN_WIDTH, 1);
    [self addSubview:lineView];
    
}

#pragma mark - Lazy Load
- (UIButton *)playAndPauseButton {
    if (nil == _playAndPauseButton) {
        _playAndPauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playAndPauseButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [_playAndPauseButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
        [_playAndPauseButton addTarget:self action:@selector(playAndPauseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playAndPauseButton;
}

- (UIButton *)stopButton {
    if (nil == _stopButton) {
        _stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_stopButton setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
        [_stopButton addTarget:self action:@selector(stopButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stopButton;
}

- (UILabel *)timeLabel {
    if (nil == _timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.font = [UIFont systemFontOfSize:30];
        _timeLabel.text = @"00:00:00";
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

@end
