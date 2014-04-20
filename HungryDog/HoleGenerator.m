//
//  HoleGenerator.m
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/20/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import "HoleGenerator.h"

const NSUInteger NumberOfHolesMax = 4;
const NSTimeInterval HoleAdditionInterval = 70;

@interface HoleGenerator ()

@property (nonatomic) NSUInteger numberOfHoles;

@end

@implementation HoleGenerator

- (void)generateHole {
  [self.delegate holeGeneratorDidGenerateHole:self];
}

- (void)updateWithGameDuration:(NSTimeInterval)gameDuration {
  if (self.numberOfHoles < NumberOfHolesMax) {
    if ((NSUInteger)(floorf(gameDuration / HoleAdditionInterval)) > self.numberOfHoles) {
      self.numberOfHoles ++;
      [self generateHole];
    }
  }
}

@end
