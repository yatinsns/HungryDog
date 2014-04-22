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
  CGPoint offset = CGPointSubtract(self.lastTouchLocation, self.dog.position);
  CGFloat length = CGPointLength(offset);
  CGFloat accleration = (length * sqrt(length)) / 500;
  if (length >= (self.speed * timeInterval)) {
    [self boundsCheckPlayer];
    [self moveSprite:self.dog
            velocity:CGPointMultiplyScalar(self.velocity, accleration)
        timeInterval:timeInterval];
    [self rotateSprite:self.dog
                toFace:self.velocity
   rotateRadiansPerSec:self.rotationSpeed
          timeInterval:timeInterval];
  } else {
    self.velocity = CGPointZero;
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

- (void)boundsCheckPlayer {
  BOOL isOnCorner = NO;
  CGPoint newPosition = self.dog.position;
  CGPoint bottomLeft = CGPointZero;
  CGPoint topRight = CGPointMake(560,
                                 320);

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
    self.dog.position = newPosition;
    self.lastTouchLocation = newPosition;
  }
}

@end
