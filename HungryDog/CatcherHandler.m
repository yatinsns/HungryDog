//
//  CatcherHandler.m
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/14/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import "CatcherHandler.h"
#import <SpriteKit/SpriteKit.h>
#import "VectorUtils.h"

@interface CatcherHandler ()

@property (nonatomic) CGPoint lastTouchLocation;

@property (nonatomic) CGFloat speed;
@property (nonatomic) CGFloat initialSpeed;
@property (nonatomic) CGFloat rotationSpeed;
@property (nonatomic) CGPoint velocity;

@property (nonatomic) CGSize size;
@property (nonatomic) BOOL shouldUpdateLastTouchLocation;

@end

@implementation CatcherHandler

- (instancetype)initWithSpeed:(CGFloat)speed
                rotationSpeed:(CGFloat)rotationSpeed
                         size:(CGSize)size {
  self = [super init];
  if (self) {
    _initialSpeed = speed;
    _speed = speed;
    _rotationSpeed = rotationSpeed;
    _size = size;
    _shouldUpdateLastTouchLocation = YES;
  }
  return self;
}

- (void)updateForTimeInterval:(NSTimeInterval)timeInterval {
  [self moveSprite:self.catcher velocity:self.velocity timeInterval:timeInterval];
  [self boundsCheckPlayer];
  [self rotateSprite:self.catcher
              toFace:self.velocity
 rotateRadiansPerSec:self.rotationSpeed
        timeInterval:timeInterval];
}

- (void)moveSprite:(SKSpriteNode *)sprite
          velocity:(CGPoint)velocity
      timeInterval:(NSTimeInterval)timeInterval {
  CGPoint amountToMove = CGPointMake(velocity.x * timeInterval,
                                     velocity.y * timeInterval);
  sprite.position = CGPointAdd(sprite.position, amountToMove);
}

- (void)moveTowardsLocation:(CGPoint)location {
  CGPoint offset = CGPointSubtract(location, self.catcher.position);
  if (self.shouldUpdateLastTouchLocation || CGPointLength(offset) < self.radarRadius) {
    self.lastTouchLocation = location;
    CGPoint offset = CGPointSubtract(location, self.catcher.position);
    CGPoint direction = CGPointNormalize(offset);
    self.velocity = CGPointMultiplyScalar(direction, self.speed);
    self.shouldUpdateLastTouchLocation = NO;
  }
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

- (void)boundsCheckPlayer {
  BOOL isOnCorner = NO;
  CGPoint newPosition = self.catcher.position;
  CGPoint bottomLeft = CGPointZero;
  CGPoint topRight = CGPointMake(self.size.width,
                                 self.size.height);

  if (newPosition.x <= bottomLeft.x) {
    newPosition.x = bottomLeft.x;
    isOnCorner = YES;
  }
  if (newPosition.x >= topRight.x) {
    newPosition.x = topRight.x;
    isOnCorner = YES;
  }
  if (newPosition.y <= bottomLeft.y) {
    newPosition.y = bottomLeft.y;
    isOnCorner = YES;
  }
  if (newPosition.y >= topRight.y) {
    newPosition.y = topRight.y;
    isOnCorner = YES;
  }

  if (isOnCorner) {
    self.catcher.position = newPosition;
    self.shouldUpdateLastTouchLocation = YES;
    [self moveTowardsLocation:CGPointMake(arc4random_uniform(self.size.width),
                                          arc4random_uniform(self.size.height))];
  }
}

@end
