//
//  GameScene.h
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/6/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class GamePlay;

@protocol GameSceneDelegate;

/**
 This class represents scene for presenting game.
 */
@interface GameScene : SKScene

@property (nonatomic, weak) id<GameSceneDelegate> delegate;

- (id)initWithSize:(CGSize)size gamePlay:(GamePlay *)gamePlay;

@end

@protocol GameSceneDelegate <NSObject>

- (void)gameSceneDidEndGame:(GameScene *)gameScene;

@end