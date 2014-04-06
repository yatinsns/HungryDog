//
//  SKLabelNode+HungryDogAdditions.h
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/6/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKLabelNode (HungryDogAdditions)

/**
 Convenience class method to assign font properties at once.
 */
+ (SKLabelNode*)labelNodeWithFontNamed:(NSString *)fontName
                              fontSize:(CGFloat)fontSize
                             fontColor:(SKColor *)fontColor;

@end
