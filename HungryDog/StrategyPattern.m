//
//  StrategyPattern.m
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/18/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import "StrategyPattern.h"

@implementation StrategyPattern

- (instancetype)initWithMovementPatterns:(NSArray *)movementPatterns {
  self = [super init];
  if (self) {
    _movementPatterns = movementPatterns;
  }
  return self;
}

@end
