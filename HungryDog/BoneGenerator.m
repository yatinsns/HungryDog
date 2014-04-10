//
//  BoneGenerator.m
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/10/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import "BoneGenerator.h"

@implementation BoneGenerator

- (void)generateBone {
  [self __generateBone];
}

#pragma mark - Timer methods

- (void)__generateBone {
  [self.delegate boneGeneratorDidGenerateNewBone:self];
}

@end
