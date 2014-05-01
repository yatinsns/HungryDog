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

const CGFloat ScoreLabelPaddingRight = 15;

const CGFloat EnergyBarSizeWidth_iPhone = 20;
const CGFloat EnergyBarSizeWidth_iPad = 50;

const CGFloat EnergyBarPaddingRight_iPhone = 15;
const CGFloat EnergyBarPaddingRight_iPad = 15;

const CGFloat EnergyBarPaddingTop_iPhone = 120;
const CGFloat EnergyBarPaddingTop_iPad = 130;

const CGFloat EnergyBarPaddingBottom_iPhone = 20;
const CGFloat EnergyBarPaddingBottom_iPad = 30;

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
  return CGPointMake(ScoreLabelPaddingRight,
                     self.size.height - scoreLabel.frame.size.height);
}

- (CGSize)sizeForEnergyBar {
  CGFloat paddingTop = ValueForDevice(EnergyBarPaddingTop_iPhone, EnergyBarPaddingTop_iPad);
  CGFloat paddingBottom = ValueForDevice(EnergyBarPaddingBottom_iPhone, EnergyBarPaddingBottom_iPad);
  CGFloat energyBarWidth = ValueForDevice(EnergyBarSizeWidth_iPhone, EnergyBarSizeWidth_iPad);
  CGFloat energyBarHeight = self.size.height - paddingTop - paddingBottom;
  return CGSizeMake(energyBarWidth, energyBarHeight);
}

- (CGPoint)positionForEnergyBar {
  CGFloat paddingBottom = ValueForDevice(EnergyBarPaddingBottom_iPhone, EnergyBarPaddingBottom_iPad);
  CGFloat paddingRight = ValueForDevice(EnergyBarPaddingRight_iPhone, EnergyBarPaddingRight_iPad);
  CGFloat energyBarWidth = ValueForDevice(EnergyBarSizeWidth_iPhone, EnergyBarSizeWidth_iPad);
  return CGPointMake(self.size.width - energyBarWidth - paddingRight, paddingBottom);
}

- (CGPoint)initialPositionForDog {
  return CGPointMake(200, 80);
}

- (CGPoint)randomPositionForHoleAwayFromLocations:(NSArray *)locations {
  CGPoint randomPoint;
  BOOL hasFound;
  do {
    hasFound = YES;
    randomPoint = CGPointMake(arc4random_uniform(self.size.width),
                              arc4random_uniform(self.size.height));
    for (NSValue *location in locations) {
      if (CGPointLength(CGPointSubtract(randomPoint, [location CGPointValue])) > MinimumDistanceForBone) {
        hasFound = hasFound && YES;
      } else {
        hasFound = NO;
      }
    }
  } while (!hasFound);
  return randomPoint;
}

- (CGPoint)positionForPauseButton {
  return CGPointMake(self.size.width - 25, self.size.height - 30);
}

- (CGPoint)randomPositionForPowerAwayFromLocation:(CGPoint)location {
  CGPoint randomPoint;
  do {
    randomPoint = CGPointMake(arc4random_uniform(self.size.width),
                              arc4random_uniform(self.size.height));
  } while (CGPointLength(CGPointSubtract(randomPoint, location)) < MinimumDistanceForBone);
  return randomPoint;
}

- (CGPoint)positionForNotification {
  return CGPointMake(self.size.width / 2, self.size.height / 2);
}

@end
