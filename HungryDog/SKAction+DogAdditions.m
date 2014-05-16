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
  [textures addObject:[SKTexture textureWithImageNamed:@"dog_tail_3.png"]];
  for (int i = 2; i > 0; i--) {
    NSString *textureName = [NSString stringWithFormat:@"dog_tail_%d.png", i];
    SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
    [textures addObject:texture];
  }
  for (int i = 1; i <= 5; i++) {
    NSString *textureName = [NSString stringWithFormat:@"dog_tail_%d.png", i];
    SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
    [textures addObject:texture];
  }
  for (int i = 5; i > 3; i--) {
    NSString *textureName = [NSString stringWithFormat:@"dog_tail_%d.png", i];
    SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
    [textures addObject:texture];
  }

  SKAction *animation = [SKAction animateWithTextures:textures timePerFrame:0.1];
  return [SKAction repeatActionForever:animation];
}

@end
