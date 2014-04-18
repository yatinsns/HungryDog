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

- (void)updateForTimeInterval:(NSTimeInterval)timeInterval {
  if (timeInterval == 0) {
    return;
  }
  if (![self isLastTouchLocationNil]) {
    CGPoint offset = CGPointSubtract(self.lastTouchLocation, self.dog.position);
    CGFloat length = CGPointLength(offset);
    if (length >= (self.speed * timeInterval)) {
      [self moveSprite:self.dog velocity:self.velocity timeInterval:timeInterval];
      [self rotateSprite:self.dog
                  toFace:self.velocity
     rotateRadiansPerSec:self.rotationSpeed
            timeInterval:timeInterval];
    } else {
      self.velocity = CGPointZero;
    }
  } else {
    // No need to stop as it won't be rotated if shortestAngle is zero.
    [self rotateSprite:self.dog
                toFace:self.velocity
   rotateRadiansPerSec:self.rotationSpeed
          timeInterval:timeInterval];
  }
}

- (void)moveSprite:(SKSpriteNode *)sprite
          velocity:(CGPoint)velocity
      timeInterval:(NSTimeInterval)timeInterval {
  CGPoint amountToMove = CGPointMake(velocity.x * timeInterval,
                                     velocity.y * timeInterval);
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
 rotateRadiansPerSec:(CGFloat)rotateRadiansPerSec
        timeInterval:(NSTimeInterval)timeInterval {
  CGFloat targetAngle = CGPointToAngle(velocity);
  CGFloat shortestAngle = ScalarShortestAngleBetween(sprite.zRotation, targetAngle);
  CGFloat amountToRotate = rotateRadiansPerSec * timeInterval;
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
