//
//  HoleGenerator.m
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/20/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import "HoleGenerator.h"

@implementation HoleGenerator

- (void)generateHole {
  [self.delegate holeGeneratorDidGenerateHole:self];
}

@end
