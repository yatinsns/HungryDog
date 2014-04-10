//
//  GameSceneSpritesOrganizer.m
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/10/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import "GameSceneSpritesOrganizer.h"

@implementation GameSceneSpritesOrganizer

- (CGPoint)randomPositionForBone {
  CGRect screenRect = [[UIScreen mainScreen] bounds];
  return CGPointMake(arc4random_uniform(screenRect.size.height),
                     arc4random_uniform(screenRect.size.width));
}

@end
