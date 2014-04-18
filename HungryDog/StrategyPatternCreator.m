//
//  StrategyPatternCreator.m
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/18/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import "StrategyPatternCreator.h"

@implementation StrategyPatternCreator

- (instancetype)init {
  self = [super init];
  if (self) {
    [self createPatterns];
  }
  return self;
}

- (void)createPatterns {
  NSMutableArray *patterns = [NSMutableArray array];
  _strategyPatterns = patterns;
}

@end
