//
//  GamePlay.m
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/8/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import "GamePlay.h"
#import "UIUtils.h"

static const CGFloat DepletionRateDefault = 0.004;

static const CGFloat DogSpeed_iPhone = 150;
static const CGFloat DogSpeed_iPad = 350;
static const CGFloat DogRotationSpeed = 4 * M_PI;

@implementation GamePlay

- (instancetype)init {
  self = [super init];
  if (self) {
    _scoreHandler = [[ScoreHandler alloc] init];
    _energyBarHandler = [[EnergyBarHandler alloc] initWithDepletionRate:DepletionRateDefault];
    _boneGenerator = [[BoneGenerator alloc] init];

    CGFloat dogSpeed = ValueForDevice(DogSpeed_iPhone, DogSpeed_iPad);
    _dogHandler = [[DogHandler alloc] initWithSpeed:dogSpeed
                                      rotationSpeed:DogRotationSpeed];

    _strategyMaker = [[StrategyMaker alloc] init];
    _powerGenerator = [[PowerGenerator alloc] init];
  }
  return self;
}

@end
