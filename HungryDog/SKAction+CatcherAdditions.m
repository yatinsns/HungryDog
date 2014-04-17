//
//  SKAction+CatcherAdditions.m
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/14/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import "SKAction+CatcherAdditions.h"

@implementation SKAction (CatcherAdditions)

+ (SKAction *)catcherTextureAction {
  NSMutableArray *textures = [NSMutableArray arrayWithCapacity:10];
  for (int i = 1; i < 4; i++) {
    NSString *textureName = [NSString stringWithFormat:@"zombie%d", i];
    SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
    [textures addObject:texture];
  }
  for (int i = 4; i > 1; i--) {
    NSString *textureName = [NSString stringWithFormat:@"zombie%d", i];
    SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
    [textures addObject:texture];
  }
  
  SKAction *animation = [SKAction animateWithTextures:textures timePerFrame:0.1];
  return [SKAction repeatActionForever:animation];
}

@end
