//
//  GameSceneSpritesOrganizer.m
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/10/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import "GameSceneSpritesOrganizer.h"
#import <SpriteKit/SpriteKit.h>

const CGFloat ScoreLabelPaddingRight = 10;
const CGFloat ScoreLabelPaddingTop = 10;

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

- (CGPoint)randomPositionForBone {
  return CGPointMake(arc4random_uniform(self.size.width),
                     arc4random_uniform(self.size.height));
}

- (CGPoint)positionForScoreLabel:(SKLabelNode *)scoreLabel {
  return CGPointMake(self.size.width - ScoreLabelPaddingRight,
                     self.size.height - scoreLabel.frame.size.height - ScoreLabelPaddingTop);
}

@end
