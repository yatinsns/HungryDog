//
//  SoundController.h
//  HungryDog
//
//  Created by Yatin on 23/05/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 This class handles sound within game.
 */
@interface SoundController : NSObject

@property (nonatomic, getter = isMuted) BOOL muted;

+ (SoundController *)sharedController;

- (void)playBackgroundMusic:(NSString *)backgroundMusic;

@end
