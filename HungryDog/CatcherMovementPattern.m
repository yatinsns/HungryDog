//
//  CatcherMovementPattern.m
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/18/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import "CatcherMovementPattern.h"

@implementation CatcherMovementPattern

- (instancetype)initWithPoint1:(CGPoint)point1
                        point2:(CGPoint)point2 {
  self = [super init];
  if (self) {
    _point1 = point1;
    _point2 = point2;
  }
  return self;
}

@end
