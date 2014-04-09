//
//  GamePlay.m
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/8/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import "GamePlay.h"

static const CGFloat DepletionRateDefault = 0.00001;

@interface GamePlay ()

@property (nonatomic, readwrite) ScoreHandler *scoreHandler;
@property (nonatomic, readwrite) EnergyBarHandler *energyBarHandler;

@end

@implementation GamePlay

- (instancetype)init {
  self = [super init];
  if (self) {
    _scoreHandler = [[ScoreHandler alloc] init];
    _energyBarHandler = [[EnergyBarHandler alloc] initWithDepletionRate:DepletionRateDefault];
  }
  return self;
}

@end
