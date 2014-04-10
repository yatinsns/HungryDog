//
//  SKAction+DogAdditions.m
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/11/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import "SKAction+DogAdditions.h"

@implementation SKAction (DogAdditions)

+ (SKAction *)dogTextureAction {
  NSMutableArray *textures = [NSMutableArray arrayWithCapacity:10];
  [textures addObject:[SKTexture textureWithImageNamed:@"Dog-main.png"]];
  for (int i = 1; i < 3; i++) {
    NSString *textureName = [NSString stringWithFormat:@"Dog-main%d.png", i];
    SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
    [textures addObject:texture];
  }
  for (int i = 2; i > 0; i--) {
    NSString *textureName = [NSString stringWithFormat:@"Dog-main%d.png", i];
    SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
    [textures addObject:texture];
  }
  [textures addObject:[SKTexture textureWithImageNamed:@"Dog-main.png"]];
  for (int i = 3; i < 5; i++) {
    NSString *textureName = [NSString stringWithFormat:@"Dog-main%d.png", i];
    SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
    [textures addObject:texture];
  }
  for (int i = 4; i > 2; i--) {
    NSString *textureName = [NSString stringWithFormat:@"Dog-main%d.png", i];
    SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
    [textures addObject:texture];
  }
  [textures addObject:[SKTexture textureWithImageNamed:@"Dog-main.png"]];

  SKAction *animation = [SKAction animateWithTextures:textures timePerFrame:0.1];
  return [SKAction repeatActionForever:animation];
}

@end
