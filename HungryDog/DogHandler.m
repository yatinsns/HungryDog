//
//  DogHandler.m
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/11/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import "DogHandler.h"
#import <SpriteKit/SpriteKit.h>
#import "VectorUtils.h"

@interface DogHandler ()

@property (nonatomic) NSTimeInterval lastUpdateTime;
@property (nonatomic) NSTimeInterval dt;
@property (nonatomic) CGPoint lastTouchLocation;

@property (nonatomic) CGFloat speed;
@property (nonatomic) CGFloat rotationSpeed;
@property (nonatomic) CGPoint velocity;

@end

@implementation DogHandler

- (instancetype)initWithSpeed:(CGFloat)speed
                rotationSpeed:(CGFloat)rotationSpeed {
  self = [super init];
  if (self) {
    _speed = speed;
    _rotationSpeed = rotationSpeed;
  }
  return self;
}

- (void)update:(NSTimeInterval)currentTime {
  if (self.lastUpdateTime) {
    self.dt = currentTime - self.lastUpdateTime;
  } else {
    self.dt = 0;
  }
  
  self.lastUpdateTime = currentTime;
  if (![self isLastTouchLocationNil]) {
    CGPoint offset = CGPointSubtract(self.lastTouchLocation, self.dog.position);
    CGFloat length = CGPointLength(offset);
    if (length >= (self.speed * self.dt)) {
      [self moveSprite:self.dog velocity:self.velocity];
      [self rotateSprite:self.dog
                  toFace:self.velocity
     rotateRadiansPerSec:self.rotationSpeed];
    } else {
      self.velocity = CGPointZero;
    }
  } else {
    // No need to stop as it won't be rotated if shortestAngle is zero.
    [self rotateSprite:self.dog
                toFace:self.velocity
   rotateRadiansPerSec:self.rotationSpeed];
  }
}

- (void)moveSprite:(SKSpriteNode *)sprite velocity:(CGPoint)velocity {
  CGPoint amountToMove = CGPointMake(velocity.x * self.dt,
                                     velocity.y * self.dt);
  sprite.position = CGPointAdd(sprite.position, amountToMove);
}

- (void)moveTowardsLocation:(CGPoint)location {
  self.lastTouchLocation = location;
  CGPoint offset = CGPointSubtract(location, self.dog.position);
  CGPoint direction = CGPointNormalize(offset);
  self.velocity = CGPointMultiplyScalar(direction, self.speed);
}

- (void)rotateSprite:(SKSpriteNode *)sprite
              toFace:(CGPoint)velocity
 rotateRadiansPerSec:(CGFloat)rotateRadiansPerSec {
  CGFloat targetAngle = CGPointToAngle(velocity);
  CGFloat shortestAngle = ScalarShortestAngleBetween(sprite.zRotation, targetAngle);
  CGFloat amountToRotate = rotateRadiansPerSec * _dt;
  CGFloat rotationAngle = amountToRotate;
  if (ABS(shortestAngle) < amountToRotate) {
    rotationAngle = ABS(shortestAngle);
  }
  sprite.zRotation += ScalarSign(shortestAngle) * rotationAngle;
}

- (void)stop {
  self.lastTouchLocation = [self lastTouchLocationNilValue];
}

- (CGPoint)lastTouchLocationNilValue {
  return CGPointMake(NSNotFound, NSNotFound);
}

- (BOOL)isLastTouchLocationNil {
  if (self.lastTouchLocation.x == NSNotFound
      && self.lastTouchLocation.y == NSNotFound) {
    return YES;
  }
  return NO;
}

@end
