//
//  TYPlayer.m
//  AudioLooperDemo
//
//  Created by Maty on 2018/7/31.
//  Copyright © 2018年 kangarootec. All rights reserved.
//

#import "TYPlayer.h"
#import <AVFoundation/AVFoundation.h>

static TYPlayer *instancePlayer = nil;

@interface TYPlayer()

@property (nonatomic, strong) NSArray *players;

@property (nonatomic, strong) AVAudioPlayer *guitarPlayer;
@property (nonatomic, strong) AVAudioPlayer *bassPlayer;
@property (nonatomic, strong) AVAudioPlayer *drumPlayer;

@end

@implementation TYPlayer

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instancePlayer = [[self alloc] init];
    });
    return instancePlayer;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instancePlayer = [super allocWithZone:zone];
    });
    return instancePlayer;
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return instancePlayer;
}

- (instancetype)init {
    if (self = [super init]) {
        self.players = @[self.guitarPlayer, self.bassPlayer, self.drumPlayer];
        
        // 注册音频中断通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterruption:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
        
    }
    return self;
}

#pragma mark - Method
// 注册音频中断通知
- (void)handleInterruption:(NSNotification *)notif {
    // 1.通过 AVAudioSessionInterruptionTypeKey 的值确定中断类型(type).返回值是 AVAudioSessionInterruptionType, 这是用来表示中断开始或结束的枚举类型
    NSDictionary *info = notif.userInfo;
    AVAudioSessionInterruptionType type = [info[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    if (type == AVAudioSessionInterruptionTypeBegan) {
        // Handle AVAudioSessionInterruptionTypeBegan
    } else {
        // Handle AvAudioSessionInterruptionTypeEnded
    }
}

// 要对三个播放器实例的播放进行同步,需要捕捉当前设备时间并添加一个小延时,这样就会具有一个从开始播放时间计算的参照时间.
// 通过对每个实例调用 playAtTime: 方法并传递延时参照时间,遍历播放器数组并开始播放.
// 这样就保证了这些播放器在音频播放时始终保持紧密同步.
- (void)play {
    if (!self.playing) {
        NSTimeInterval delayTime = [self.players[0] deviceCurrentTime] + 0.01;
        for (AVAudioPlayer *player in self.players) {
            [player playAtTime:delayTime];
        }
        self.playing = YES;
    }
}

// 设置 currentTime 为0.0f, 这样做会让播放进度回到音频文件的原点.
- (void)stop {
    if (self.playing) {
        for (AVAudioPlayer *player in self.players) {
            [player stop];
            player.currentTime = 0.0f;
        }
        self.playing = NO;
    }
}

- (void)adjustRate:(float)rate {
    for (AVAudioPlayer *player in self.players) {
        player.rate = rate;
    }
}

- (void)adjustPan:(float)pan forPlayerAtIndex:(NSUInteger)index {
    if ([self isValidIndex:index]) {
        AVAudioPlayer *player = self.players[index];
        player.pan = pan;
    }
}

- (void)adjustVolume:(float)volume forPlayerAtIndex:(NSUInteger)index {
    if ([self isValidIndex:index]) {
        AVAudioPlayer *player = self.players[index];
        player.volume = volume;
    }
}

- (BOOL)isValidIndex:(NSUInteger)index {
    return index == 0 || index < self.players.count;
}

#pragma mark - Lazy Load
- (AVAudioPlayer *)guitarPlayer {
    if (nil == _guitarPlayer) {
        NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"guitar" withExtension:@"mp3"];
        NSError *error;
        _guitarPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:&error];
        if (nil == error) {
            _guitarPlayer.numberOfLoops = -1;
            _guitarPlayer.enableRate = YES;
            [_guitarPlayer prepareToPlay];
        } else {
            NSLog(@"error: %@",[error localizedDescription]);
        }
    }
    return _guitarPlayer;
}

- (AVAudioPlayer *)bassPlayer {
    if (nil == _bassPlayer) {
        NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"bass" withExtension:@"mp3"];
        NSError *error;
        _bassPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:&error];
        if (nil == error) {
            _bassPlayer.numberOfLoops = -1;
            _bassPlayer.enableRate = YES;
            [_bassPlayer prepareToPlay];
        } else {
            NSLog(@"error: %@",[error localizedDescription]);
        }
    }
    return _bassPlayer;
}

- (AVAudioPlayer *)drumPlayer {
    if (nil == _drumPlayer) {
        NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"drum" withExtension:@"mp3"];
        NSError *error;
        _drumPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:&error];
        if (nil == error) {
            _drumPlayer.numberOfLoops = -1;
            _drumPlayer.enableRate = YES;
            [_drumPlayer prepareToPlay];
        } else {
            NSLog(@"error: %@",[error localizedDescription]);
        }
    }
    return _drumPlayer;
}

@end
