//
//  GameSceneSpritesOrganizer.h
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/10/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKLabelNode;

@interface GameSceneSpritesOrganizer : NSObject

- (instancetype)initWithSize:(CGSize)size;

- (CGPoint)randomPositionForBone;

- (CGPoint)positionForScoreLabel:(SKLabelNode *)scoreLabel;

@end
