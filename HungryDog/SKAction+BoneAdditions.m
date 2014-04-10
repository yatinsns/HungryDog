//
//  SKAction+BoneAdditions.m
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/10/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import "SKAction+BoneAdditions.h"

@implementation SKAction (BoneAdditions)

+ (SKAction *)boneAction {
  SKAction *appear = [SKAction scaleTo:1.0 duration:0.5];
  SKAction *leftWiggle = [SKAction rotateByAngle:M_PI/8 duration:0.5];
  SKAction *rightWiggle = [leftWiggle reversedAction];
  SKAction *fullWiggle = [SKAction sequence:@[leftWiggle, rightWiggle]];
  SKAction *scaleUp = [SKAction scaleBy:1.2 duration:0.25];
  SKAction *scaleDown = [scaleUp reversedAction];
  SKAction *fullScale = [SKAction sequence:@[scaleUp, scaleDown, scaleUp, scaleDown]];
  SKAction *disappear = [SKAction scaleTo:0.0 duration:0.5];
  SKAction *group = [SKAction group:@[fullScale, fullWiggle]];
  SKAction *groupWait = [SKAction repeatAction:group count:10];
  SKAction *removeFromParent = [SKAction removeFromParent];
  return [SKAction sequence:@[appear, groupWait, disappear, removeFromParent]];
}

@end
