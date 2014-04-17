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

@property (nonatomic) NSTimeInterval lastUpdateTime;
@property (nonatomic) NSTimeInterval dt;
@property (nonatomic) CGPoint lastTouchLocation;

@property (nonatomic) CGFloat speed;
@property (nonatomic) CGFloat initialSpeed;
@property (nonatomic) CGFloat rotationSpeed;
@property (nonatomic) CGPoint velocity;

@property (nonatomic) CGSize size;
@property (nonatomic) NSUInteger count;

@property (nonatomic) NSTimeInterval markerTime;
@property (nonatomic) int lastIncrement;

@property (nonatomic) NSTimer *timer;
@property (nonatomic) CGPoint dogLocation;

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
  }
  return self;
}

- (void)update:(NSTimeInterval)currentTime {
  if (self.markerTime == 0) {
    self.markerTime = currentTime;
  }
  if (self.lastUpdateTime) {
    self.dt = currentTime - self.lastUpdateTime;
  } else {
    self.dt = 0;
  }
  self.lastUpdateTime = currentTime;
  
  int increment = (currentTime - self.markerTime)/ 5;
  if (self.lastIncrement != increment && self.lastIncrement < 7) {
    self.lastIncrement = increment;
    self.speed += increment * 3;
  }
  if (self.lastIncrement == 7) {
    if (self.timer == nil) {
      self.timer = [NSTimer scheduledTimerWithTimeInterval:5
                                                    target:self
                                                  selector:@selector(randomizeSpeed)
                                                  userInfo:nil
                                                   repeats:YES];
    }
  }

  [self moveSprite:self.catcher velocity:self.velocity];
  [self boundsCheckPlayer];
  [self rotateSprite:self.catcher
              toFace:self.velocity
 rotateRadiansPerSec:self.rotationSpeed];
}

- (void)randomizeSpeed {
  self.speed = arc4random_uniform(50) + (self.initialSpeed);
}

- (void)moveSprite:(SKSpriteNode *)sprite velocity:(CGPoint)velocity {
  CGPoint amountToMove = CGPointMake(velocity.x * self.dt,
                                     velocity.y * self.dt);
  sprite.position = CGPointAdd(sprite.position, amountToMove);
}

- (void)moveTowardsLocation:(CGPoint)location {
  CGPoint offset = CGPointSubtract(location, self.catcher.position);
  if (self.count == 0 || (self.lastIncrement == 7 && CGPointLength(offset) < 100 && (self.speed = self.initialSpeed))) {
    self.lastTouchLocation = location;
    CGPoint offset = CGPointSubtract(location, self.catcher.position);
    CGPoint direction = CGPointNormalize(offset);
    self.velocity = CGPointMultiplyScalar(direction, self.speed);
  }
  self.count++;
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
    self.count = 0;
    if (arc4random_uniform(2) % 2 == 0) {
      [self moveTowardsLocation:CGPointMake(arc4random_uniform(self.size.width), arc4random_uniform(self.size.height))];
    } else {
      [self moveTowardsLocation:self.dogLocation];
    }
  }
}

@end
