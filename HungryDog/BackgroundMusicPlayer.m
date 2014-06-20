//
//  BackgroundMusicPlayer.m
//  HungryDog
//
//  Created by Yatin Sarbalia on 5/1/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import "BackgroundMusicPlayer.h"

@import AVFoundation;

@interface BackgroundMusicPlayer ()

@property (nonatomic) AVAudioPlayer *backgroundMusicPlayer;

@end

@implementation BackgroundMusicPlayer

+ (BackgroundMusicPlayer *)sharedPlayer {
  static BackgroundMusicPlayer *musicPlayer;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    musicPlayer = [[BackgroundMusicPlayer alloc] init];
  });
  return musicPlayer;
}

- (void)setBackgroundMusic:(NSString *)filename {
  NSError *error;
  NSURL *backgroundMusicURL =
  [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
  self.backgroundMusicPlayer = [[AVAudioPlayer alloc]
                            initWithContentsOfURL:backgroundMusicURL error:&error];
  self.backgroundMusicPlayer.numberOfLoops = -1;
}

- (void)play {
  [self.backgroundMusicPlayer play];
}

- (void)pause {
  [self.backgroundMusicPlayer pause];
}

- (void)stop {
  [self.backgroundMusicPlayer stop];
}

@end
