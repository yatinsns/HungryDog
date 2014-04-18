//
//  CatcherMovementPattern.m
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/18/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import "CatcherMovementPattern.h"

@implementation CatcherMovementPattern

- (instancetype)initWithStartPosition:(CGPoint)startPosition
                          endPosition:(CGPoint)endPosition {
  self = [super init];
  if (self) {
    _startPosition = startPosition;
    _endPosition = endPosition;
  }
  return self;
}

@end
