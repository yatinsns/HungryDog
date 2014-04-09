//
//  EnergyBarHandler.m
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/10/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import "EnergyBarHandler.h"

@interface EnergyBarHandler ()

@property (nonatomic) CGFloat statusValue;
@property (nonatomic) NSTimeInterval markerTime;

@end

@implementation EnergyBarHandler

- (instancetype)initWithDepletionRate:(CGFloat)depletionRate {
  self = [super init];
  if (self) {
    _statusValue = 100;
    _depletionRate = depletionRate;
  }
  return self;
}

- (void)update:(NSTimeInterval)currentTime {
  if (self.markerTime) {
    NSTimeInterval difference = currentTime - self.markerTime;
    [self updateStatusWithChangeInTime:difference];
  } else {
    self.markerTime = currentTime;
  }
}

- (void)updateStatusWithChangeInTime:(NSTimeInterval)timeDifference {
  NSTimeInterval numberOfMilliseconds = timeDifference * 1000;
  self.statusValue = (self.statusValue - numberOfMilliseconds * self.depletionRate);
}

- (NSUInteger)status {
  return ceil(self.statusValue);
}

@end
