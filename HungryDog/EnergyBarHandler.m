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
@property (nonatomic) NSTimeInterval lastUpdatedTime;

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

- (void)boost {
  self.statusValue = (self.statusValue + 10);
  if (self.statusValue > 100) {
    self.statusValue = 100;
  }
  [self.delegate energyBarHandlerDidUpdateStatus:self];
}

- (void)update:(NSTimeInterval)currentTime {
  if (self.lastUpdatedTime) {
    NSTimeInterval difference = currentTime - self.lastUpdatedTime;
    [self updateStatusWithChangeInTime:difference];
  }
  self.lastUpdatedTime = currentTime;
}

- (void)updateStatusWithChangeInTime:(NSTimeInterval)timeDifference {
  if (self.statusValue != 0) {
    NSTimeInterval numberOfMilliseconds = timeDifference * 1000;
    NSUInteger oldValue = ceil(self.statusValue);
    self.statusValue = (self.statusValue - numberOfMilliseconds * self.depletionRate);
    NSUInteger newValue = ceil(self.statusValue);
    if (newValue == 0) {
      self.statusValue = 0;
    }
    if (oldValue != newValue) {
      [self.delegate energyBarHandlerDidUpdateStatus:self];
    }
  }
}

- (NSUInteger)status {
  return ceil(self.statusValue);
}

@end
