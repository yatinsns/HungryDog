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

@interface CatcherHandler ()

@property (nonatomic) CGPoint lastTouchLocation;

@property (nonatomic) CGFloat speed;
@property (nonatomic) CGFloat initialSpeed;
@property (nonatomic) CGFloat rotationSpeed;
@property (nonatomic) CGPoint velocity;

@property (nonatomic) CGSize size;
@property (nonatomic) BOOL isPatternInitiated;

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

- (void)setCatcher:(SKSpriteNode *)catcher {
  _catcher = catcher;
  [self addMovementAnimation];
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
     rotateRadiansPerSec:self.rotationSpeed
            timeInterval:timeInterval];
    }
  } else if (self.mode == CatcherModePattern){
    if (!self.isPatternInitiated) {
      [self initiatePatternMovement];
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

- (void)moveToRandomLocation {
  [self moveTowardsLocation:CGPointMake(arc4random_uniform(self.size.width),
                                        arc4random_uniform(self.size.height))];
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
    [self moveToRandomLocation];
  }
}

#pragma mark - Pattern

- (void)setMovementPattern:(CatcherMovementPattern *)movementPattern {
  _movementPattern = movementPattern;
  self.isPatternInitiated = NO;
}

- (void)addMovementAnimation {
  [self.catcher runAction:[SKAction catcherTextureAction]];
}

- (void)initiatePatternMovement {
  [self.catcher removeAllActions];
  CGPoint initialOffset = CGPointSubtract(self.movementPattern.startPosition,
                                          self.catcher.position);
  CGFloat rotation = ScalarShortestAngleBetween(self.catcher.zRotation,
                                                  CGPointToAngle(initialOffset));
  SKAction *rotateAction = [SKAction rotateByAngle:rotation
                                          duration:self.patternRotationInterval];
  SKAction *initialMoveAction = [SKAction moveTo:self.movementPattern.startPosition
                                        duration:self.patternMovementInterval];

  [self.catcher runAction:[SKAction sequence:@[rotateAction, initialMoveAction]] completion:^{
    CGPoint offset = CGPointSubtract(self.movementPattern.endPosition, self.movementPattern.startPosition);
    CGFloat rotation = ScalarShortestAngleBetween(self.catcher.zRotation, CGPointToAngle(offset));
    SKAction *rotateAction = [SKAction rotateByAngle:rotation duration:self.patternRotationInterval];
    [self.catcher runAction:rotateAction completion:^{
      SKAction *actionMove = [SKAction moveTo:self.movementPattern.endPosition
                                     duration:self.patternMovementInterval];
      CGPoint offset = CGPointSubtract(self.movementPattern.startPosition, self.movementPattern.endPosition);
      CGFloat rotation = ScalarShortestAngleBetween(CGPointToAngle(offset), self.catcher.zRotation);
      SKAction *rotateAction = [SKAction rotateByAngle:rotation
                                              duration:self.patternRotationInterval];
      SKAction *reverseActionMove = [SKAction moveTo:self.movementPattern.startPosition
                                            duration:self.patternMovementInterval];
      SKAction *reverseRotateAction = [rotateAction reversedAction];
      SKAction *sequence = [SKAction sequence:@[actionMove, rotateAction, reverseActionMove, reverseRotateAction]];
      SKAction *finalAction = [SKAction repeatActionForever:sequence];
      [self.catcher runAction:finalAction];
    }];
  }];
}

- (void)setShouldStop:(BOOL)shouldStop {
  _shouldStop = shouldStop;
  if (!shouldStop) {
    [self addMovementAnimation];
  } else {
    [self.catcher removeAllActions];
  }
}

@end
