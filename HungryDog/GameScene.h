//
//  GameScene.h
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/6/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class GamePlay;

/**
 This class represents scene for presenting game.
 */
@interface GameScene : SKScene

- (id)initWithSize:(CGSize)size gamePlay:(GamePlay *)gamePlay;

@end
