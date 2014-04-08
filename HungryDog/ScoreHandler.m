//
//  ScoreHandler.m
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/8/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import "ScoreHandler.h"

@interface ScoreHandler ()

@property (nonatomic) NSUInteger currentScore;

@end

@implementation ScoreHandler

- (instancetype)init {
  self = [super init];
  if (self) {
    _currentScore = 0;
  }
  return self;
}

- (void)incrementScoreByValue:(NSUInteger)value {
  _currentScore += value;
}

@end
