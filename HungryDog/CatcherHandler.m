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
#import "CatcherMovementPattern.h"
#import "Catcher.h"

@interface CatcherHandler ()

@property (nonatomic) CGPoint lastTouchLocation;
@property (nonatomic) CGPoint velocity;

@property (nonatomic) BOOL isPatternInitiated;

@end

@implementation CatcherHandler

- (instancetype)initWithCatcher:(Catcher *)catcher {
  self = [super init];
  if (self) {
    _catcher = catcher;
    _catcher.catcherHandler = self;
  }
  return self;
}

- (void)updateForTimeInterval:(NSTimeInterval)timeInterval {
  if (self.mode == CatcherModeRandom) {
    if (self.catcher.isMoving) {
      // FIXME (YS): Probable bug
      if (CGPointEqualToPoint(self.velocity, CGPointZero)) {
        [self moveToRandomLocation];
      }
      [self moveSprite:self.catcher velocity:self.velocity timeInterval:timeInterval];
      [self rotateSprite:self.catcher
                  toFace:self.velocity
     rotateRadiansPerSec:self.catcher.rotationSpeed
            timeInterval:timeInterval];
      [self checkBounds];
    }
  } else if (self.mode == CatcherModePattern){
    if (!self.isPatternInitiated) {
      [self.catcher startMovementPattern:self.movementPattern];
      self.isPatternInitiated = YES;
    }
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
  CGPoint offset = CGPointSubtract(location, self.catcher.position);
  CGPoint direction = CGPointNormalize(offset);
  self.velocity = CGPointMultiplyScalar(direction, self.catcher.movementSpeed);
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

- (void)moveToRandomLocation {
  CGSize size = [self.delegate screenSizeForCatcherHandler:self];
  [self moveTowardsLocation:CGPointMake(arc4random_uniform(size.width),
                                        arc4random_uniform(size.height))];
}

- (void)checkBounds {
  if (self.catcher.shouldLeave) {
    [self checkIfCatcherHasLeft];
    return;
  }

  BOOL isOnCorner = NO;
  CGPoint newPosition = self.catcher.position;
  CGPoint bottomLeft = CGPointZero;
  CGSize size = [self.delegate screenSizeForCatcherHandler:self];
  CGPoint topRight = CGPointMake(size.width, size.height);

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
    [self moveToRandomLocation];
  }
}

- (void)checkIfCatcherHasLeft {
  CGFloat margin = 50;
  CGSize size = [self.delegate screenSizeForCatcherHandler:self];
  CGRect extendedBounds = CGRectMake(-margin,
                                     -margin,
                                     size.width + 2 * margin,
                                     size.height + 2 * margin);
  if (CGRectContainsPoint(extendedBounds, self.catcher.position)) {
    [self.delegate catcherHasLeftForCatcherHandler:self];
  }
}

#pragma mark - Pattern

- (void)setMovementPattern:(CatcherMovementPattern *)movementPattern {
  _movementPattern = movementPattern;
  self.isPatternInitiated = NO;
}

@end
