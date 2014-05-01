//
//  Catcher.m
//  HungryDog
//
//  Created by Yatin Sarbalia on 5/1/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import "Catcher.h"
#import "SKAction+CatcherAdditions.h"
#import "VectorUtils.h"
#import "CatcherMovementPattern.h"

@implementation Catcher

- (void)start {
  [self runAction:[SKAction catcherTextureAction]];
}

- (void)stop {
  [self removeAllActions];
}

- (void)startMovementPattern:(CatcherMovementPattern *)movementPattern {
  [self stop];
  CGPoint initialOffset = CGPointSubtract(movementPattern.startPosition,
                                          self.position);
  CGFloat rotation = ScalarShortestAngleBetween(self.zRotation,
                                                CGPointToAngle(initialOffset));
  SKAction *rotateAction = [SKAction rotateByAngle:rotation
                                          duration:self.patternRotationInterval];
  SKAction *initialMoveAction = [SKAction moveTo:movementPattern.startPosition
                                        duration:self.patternMovementInterval];
  
  [self runAction:[SKAction sequence:@[rotateAction, initialMoveAction]] completion:^{
    CGPoint offset = CGPointSubtract(movementPattern.endPosition, movementPattern.startPosition);
    CGFloat rotation = ScalarShortestAngleBetween(self.zRotation, CGPointToAngle(offset));
    SKAction *rotateAction = [SKAction rotateByAngle:rotation duration:self.patternRotationInterval];
    [self runAction:rotateAction completion:^{
      SKAction *actionMove = [SKAction moveTo:movementPattern.endPosition
                                     duration:self.patternMovementInterval];
      CGPoint offset = CGPointSubtract(movementPattern.startPosition, movementPattern.endPosition);
      CGFloat rotation = ScalarShortestAngleBetween(CGPointToAngle(offset), self.zRotation);
      SKAction *rotateAction = [SKAction rotateByAngle:rotation
                                              duration:self.patternRotationInterval];
      SKAction *reverseActionMove = [SKAction moveTo:movementPattern.startPosition
                                            duration:self.patternMovementInterval];
      SKAction *reverseRotateAction = [rotateAction reversedAction];
      SKAction *sequence = [SKAction sequence:@[actionMove, rotateAction, reverseActionMove, reverseRotateAction]];
      SKAction *finalAction = [SKAction repeatActionForever:sequence];
      [self runAction:finalAction];
    }];
  }];
}

@end
