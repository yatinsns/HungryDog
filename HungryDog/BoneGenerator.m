//
//  BoneGenerator.m
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/10/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import "BoneGenerator.h"

@interface BoneGenerator ()

@property (nonatomic) NSTimer *timer;

@end

@implementation BoneGenerator

- (instancetype)init {
  self = [super init];
  if (self) {
    [self createTimer];
  }
  return self;
}

- (void)dealloc {
  [_timer invalidate];
}

- (void)generateBone {
  [self destroyTimer];
  [self __generateBone];
  [self createTimer];
}

#pragma mark - Timer methods

- (void)createTimer {
  self.timer = [NSTimer scheduledTimerWithTimeInterval:15
                                                target:self
                                              selector:@selector(__generateBone)
                                              userInfo:nil
                                               repeats:YES];
}

- (void)destroyTimer {
  [self.timer invalidate];
  self.timer = nil;
}

- (void)__generateBone {
  [self.delegate boneGeneratorDidGenerateNewBone:self];
}

@end
