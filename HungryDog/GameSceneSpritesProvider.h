//
//  GameSceneSpritesProvider.h
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/9/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface GameSceneSpritesProvider : NSObject

- (SKSpriteNode *)energyBarWithBorderWidth:(CGFloat)borderWidth
                           bottomLeftPoint:(CGPoint)bottomLeftPoint
                             topRightPoint:(CGPoint)topRightPoint
                                    status:(NSUInteger)status;

- (SKSpriteNode *)bone;

@end
