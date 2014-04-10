//
//  GamePlay.m
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/8/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import "GamePlay.h"

static const CGFloat DepletionRateDefault = 0.0025;

static const CGFloat DogSpeed = 150;
static const CGFloat DogRotationSpeed = 4 * M_PI;

@interface GamePlay ()

@property (nonatomic, readwrite) ScoreHandler *scoreHandler;
@property (nonatomic, readwrite) EnergyBarHandler *energyBarHandler;
@property (nonatomic, readwrite) BoneGenerator *boneGenerator;
@property (nonatomic, readwrite) DogHandler *dogHandler;

@end

@implementation GamePlay

- (instancetype)init {
  self = [super init];
  if (self) {
    _scoreHandler = [[ScoreHandler alloc] init];
    _energyBarHandler = [[EnergyBarHandler alloc] initWithDepletionRate:DepletionRateDefault];
    _boneGenerator = [[BoneGenerator alloc] init];
    _dogHandler = [[DogHandler alloc] initWithSpeed:DogSpeed
                                      rotationSpeed:DogRotationSpeed];
  }
  return self;
}

@end
