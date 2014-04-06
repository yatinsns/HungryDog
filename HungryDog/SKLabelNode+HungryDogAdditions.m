//
//  SKLabelNode+HungryDogAdditions.m
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/6/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import "SKLabelNode+HungryDogAdditions.h"

@implementation SKLabelNode (HungryDogAdditions)

+ (SKLabelNode*)labelNodeWithFontNamed:(NSString *)fontName
                              fontSize:(CGFloat)fontSize
                             fontColor:(SKColor *)fontColor {
  SKLabelNode *labelNode = [SKLabelNode labelNodeWithFontNamed:fontName];
  labelNode.fontSize = fontSize;
  labelNode.fontColor = fontColor;
  return labelNode;
}

@end
