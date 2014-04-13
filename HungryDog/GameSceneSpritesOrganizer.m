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

const CGFloat ScoreLabelPaddingRight = 10;
const CGFloat ScoreLabelPaddingTop = 10;

const CGFloat EnergyBarSizeWidth_iPhone = 30;
const CGFloat EnergyBarSizeWidth_iPad = 50;

const CGFloat EnergyBarPaddingRight_iPhone = 30;
const CGFloat EnergyBarPaddingRight_iPad = 15;

const CGFloat EnergyBarPaddingTop_iPhone = 50;
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
                     self.size.height - scoreLabel.frame.size.height - ScoreLabelPaddingTop);
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

@end
