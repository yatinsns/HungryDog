//
//  SoundController.m
//  HungryDog
//
//  Created by Yatin on 23/05/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import "SoundController.h"

static NSString *const NSUserDefaultsMuteKey = @"NSUserDefaultsMuteKey";

@implementation SoundController

+ (SoundController *)sharedController {
  static SoundController *soundController;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    soundController = [[SoundController alloc] init];
  });
  return soundController;
}

- (void)setMuted:(BOOL)muted {
  [[NSUserDefaults standardUserDefaults] setBool:muted forKey:NSUserDefaultsMuteKey];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isMuted {
  return [[NSUserDefaults standardUserDefaults] boolForKey:NSUserDefaultsMuteKey];
}

@end
