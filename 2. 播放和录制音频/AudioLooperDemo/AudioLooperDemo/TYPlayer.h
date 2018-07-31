//
//  TYPlayer.h
//  AudioLooperDemo
//
//  Created by Maty on 2018/7/31.
//  Copyright © 2018年 kangarootec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYPlayer : NSObject

@property (nonatomic, assign, getter=isPlaying) BOOL playing;

+ (instancetype)shareInstance;
- (void)play;
- (void)stop;
- (void)adjustRate:(float)rate;
- (void)adjustPan:(float)pan forPlayerAtIndex:(NSUInteger)index;
- (void)adjustVolume:(float)volume forPlayerAtIndex:(NSUInteger)index;

@end
