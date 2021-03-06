//
//  Catcher.h
//  HungryDog
//
//  Created by Yatin Sarbalia on 5/1/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class CatcherMovementPattern, CatcherHandler;

@interface Catcher : SKSpriteNode

@property (nonatomic, weak) CatcherHandler *catcherHandler;

@property (nonatomic) BOOL enableCatching;
@property (nonatomic) BOOL shouldLeave;
@property (nonatomic) BOOL isMoving;

@property (nonatomic) CGFloat movementSpeed;
@property (nonatomic) CGFloat rotationSpeed;
@property (nonatomic) CGFloat radarRadius;

@property (nonatomic) NSTimeInterval patternRotationInterval;
@property (nonatomic) NSTimeInterval patternMovementInterval;

@property (nonatomic) NSUInteger aggressiveness;

- (void)start;

- (void)stop;

- (void)startMovementPattern:(CatcherMovementPattern *)movementPattern;

@end
