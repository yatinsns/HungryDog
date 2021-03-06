//
//  GameSceneSpritesProvider.h
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/9/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "ButtonNode.h"
#import "PowerType.h"
#import "Catcher.h"

@interface GameSceneSpritesProvider : NSObject

- (SKLabelNode *)score;

- (SKSpriteNode *)energyBarWithSize:(CGSize)size
                             border:(CGFloat)border
                             status:(NSUInteger)status;

- (SKSpriteNode *)bone;

- (SKSpriteNode *)dog;

- (Catcher *)catcher;

- (SKSpriteNode *)hole;

- (SKSpriteNode *)tunnel;

- (ButtonNode *)pauseButtonWithPausedState:(BOOL)pausedState;

- (SKSpriteNode *)powerWithType:(PowerType)powerType;

- (SKLabelNode *)notificationWithText:(NSString *)text;

- (SKSpriteNode *)poop;

@end
