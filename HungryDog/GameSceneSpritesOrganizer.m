//
//  GameSceneSpritesOrganizer.m
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/10/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import "GameSceneSpritesOrganizer.h"
#import <SpriteKit/SpriteKit.h>
#import "UIUtils.h"
#import "VectorUtils.h"

const CGFloat ScoreLabelPaddingRight = 80;

const CGFloat EnergyBarSizeWidth_iPhone = 20;
const CGFloat EnergyBarSizeWidth_iPad = 50;

const CGFloat EnergyBarPaddingRight_iPhone = 15;
const CGFloat EnergyBarPaddingRight_iPad = 15;

const CGFloat EnergyBarPaddingTop_iPhone = 70;
const CGFloat EnergyBarPaddingTop_iPad = 80;

const CGFloat MinimumDistanceForBone = 100;

@interface GameSceneSpritesOrganizer ()

@property (nonatomic) CGSize size;

@end

@implementation GameSceneSpritesOrganizer

- (instancetype)initWithSize:(CGSize)size {
  self = [super init];
  if (self) {
    _size = size;
  }
  return self;
}

- (CGPoint)randomPositionForBoneAwayFromLocation:(CGPoint)location {
  CGPoint randomPoint;
  do {
    randomPoint = CGPointMake(arc4random_uniform(self.size.width),
                              arc4random_uniform(self.size.height));
  } while (CGPointLength(CGPointSubtract(randomPoint, location)) < MinimumDistanceForBone);
  return randomPoint;
}

- (CGPoint)positionForScoreLabel:(SKLabelNode *)scoreLabel {
  return CGPointMake(self.size.width - ScoreLabelPaddingRight,
                     scoreLabel.frame.size.height);
}

- (CGSize)sizeForEnergyBar {
  CGFloat paddingTop = ValueForDevice(EnergyBarPaddingTop_iPhone, EnergyBarPaddingTop_iPad);
  CGFloat energyBarWidth = ValueForDevice(EnergyBarSizeWidth_iPhone, EnergyBarSizeWidth_iPad);
  CGFloat energyBarHeight = self.size.height - 2 * paddingTop;
  return CGSizeMake(energyBarWidth, energyBarHeight);
}

- (CGPoint)positionForEnergyBar {
  CGFloat paddingTop = ValueForDevice(EnergyBarPaddingTop_iPhone, EnergyBarPaddingTop_iPad);
  CGFloat paddingRight = ValueForDevice(EnergyBarPaddingRight_iPhone, EnergyBarPaddingRight_iPad);
  CGFloat energyBarWidth = ValueForDevice(EnergyBarSizeWidth_iPhone, EnergyBarSizeWidth_iPad);
  return CGPointMake(self.size.width - energyBarWidth - paddingRight, paddingTop);
}

- (CGPoint)initialPositionForDog {
  return CGPointMake(200, 80);
}

- (CGPoint)positionForHole {
  return CGPointMake(self.size.width / 2, self.size.height / 2);
}

- (CGPoint)positionForPauseButton {
  return CGPointMake(self.size.width - 80, self.size.height - 30);
}

- (CGPoint)randomPositionForPowerAwayFromLocation:(CGPoint)location {
  CGPoint randomPoint;
  do {
    randomPoint = CGPointMake(arc4random_uniform(self.size.width),
                              arc4random_uniform(self.size.height));
  } while (CGPointLength(CGPointSubtract(randomPoint, location)) < MinimumDistanceForBone);
  return randomPoint;
}

@end
