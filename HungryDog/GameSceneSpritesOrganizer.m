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

@implementation GameSceneSpritesOrganizer

- (CGPoint)randomPositionForBone {
  CGRect screenRect = [[UIScreen mainScreen] bounds];
  return CGPointMake(arc4random_uniform(screenRect.size.height),
                     arc4random_uniform(screenRect.size.width));
}

- (CGPoint)positionForScoreLabel:(SKLabelNode *)scoreLabel {
  CGRect screenRect = [[UIScreen mainScreen] bounds];
  return CGPointMake(screenRect.size.height - ScoreLabelPaddingRight,
                     screenRect.size.width - scoreLabel.frame.size.height - ScoreLabelPaddingTop);
}

@end
