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
#import "SKAction+CatcherAdditions.h"
#import "Catcher.h"

@interface CatcherHandler ()

@property (nonatomic) CGPoint lastTouchLocation;
@property (nonatomic) CGPoint velocity;

@property (nonatomic) BOOL isPatternInitiated;

@property (nonatomic) BOOL shouldStop;

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
    if (!self.shouldStop) {
      // FIXME (YS): Probable bug
      if (CGPointEqualToPoint(self.velocity, CGPointZero)) {
        [self moveToRandomLocation];
      }
      [self moveSprite:self.catcher velocity:self.velocity timeInterval:timeInterval];
      [self boundsCheckPlayer];
      [self rotateSprite:self.catcher
                  toFace:self.velocity
     rotateRadiansPerSec:self.catcher.rotationSpeed
            timeInterval:timeInterval];
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

- (void)boundsCheckPlayer {
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

#pragma mark - Pattern

- (void)setMovementPattern:(CatcherMovementPattern *)movementPattern {
  _movementPattern = movementPattern;
  self.isPatternInitiated = NO;
}

- (void)setShouldStop:(BOOL)shouldStop {
  _shouldStop = shouldStop;
  if (shouldStop) {
    [self.catcher stop];
  } else {
    [self.catcher start];
  }
}

#pragma mark - Movement methods

- (void)start {
  self.shouldStop = NO;
  [NSObject cancelPreviousPerformRequestsWithTarget:self
                                           selector:@selector(start)
                                             object:nil];
}

- (void)stop {
  self.shouldStop = YES;
  [NSObject cancelPreviousPerformRequestsWithTarget:self
                                           selector:@selector(start)
                                             object:nil];
}

- (void)stopForTimeInterval:(NSTimeInterval)timeInterval {
  [self stop];
  [self performSelector:@selector(start)
             withObject:nil
             afterDelay:timeInterval];
}

@end
