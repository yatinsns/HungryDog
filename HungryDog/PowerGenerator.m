//
//  PowerGenerator.m
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/20/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import "PowerGenerator.h"

const NSTimeInterval PowerInterval = 40;

@interface PowerGenerator ()

@property (nonatomic) NSUInteger lastIndex;

@end

@implementation PowerGenerator

- (void)updateWithGameDuration:(NSTimeInterval)gameDuration {
  if ((NSUInteger)(floor((gameDuration / PowerInterval))) > self.lastIndex) {
    self.lastIndex ++;
    [self generatePower];
  }
}

- (void)generatePower {
  PowerType powerType = [self randomPowerType];
  [self.delegate powerGenerator:self didGeneratePowerOfType:powerType];
}

- (PowerType)randomPowerType {
  NSUInteger type = arc4random_uniform(3);
  return type;
}

@end
