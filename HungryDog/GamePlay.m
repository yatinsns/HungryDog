//
//  GamePlay.m
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/8/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import "GamePlay.h"

@interface GamePlay ()

@property (nonatomic, readwrite) ScoreHandler *scoreHandler;

@end

@implementation GamePlay

- (instancetype)init {
  self = [super init];
  if (self) {
    _scoreHandler = [[ScoreHandler alloc] init];
  }
  return self;
}

@end
