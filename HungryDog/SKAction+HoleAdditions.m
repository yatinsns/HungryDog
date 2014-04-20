//
//  SKAction+HoleAdditions.m
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/20/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import "SKAction+HoleAdditions.h"

@implementation SKAction (HoleAdditions)

+ (SKAction *)holeActionForTimeInterval:(NSTimeInterval)timeInterval {
  SKAction *appear = [SKAction scaleTo:1.0 duration:1.0];
  SKAction *groupWait = [SKAction waitForDuration:(timeInterval - 1)];
  SKAction *disappear = [SKAction scaleTo:0.0 duration:1.0];
  SKAction *removeFromParent = [SKAction removeFromParent];
  return [SKAction sequence:@[appear, groupWait, disappear, removeFromParent]];
}

@end
