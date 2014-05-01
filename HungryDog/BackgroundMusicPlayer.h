//
//  BackgroundMusicPlayer.h
//  HungryDog
//
//  Created by Yatin Sarbalia on 5/1/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BackgroundMusicPlayer : NSObject

+ (BackgroundMusicPlayer *)sharedPlayer;

- (void)playBackgroundMusic:(NSString *)filename;

- (void)play;

- (void)pause;

- (void)stop;

@end
