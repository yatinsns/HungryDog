//
//  PowerGenerator.m
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/20/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import "PowerGenerator.h"

const NSTimeInterval PowerInterval = 30;

@interface PowerGenerator ()

@property (nonatomic) NSTimer *timer;

@end

@implementation PowerGenerator

- (instancetype)init {
  self = [super init];
  if (self) {
    _timer = [NSTimer scheduledTimerWithTimeInterval:PowerInterval
                                              target:self
                                            selector:@selector(generatePower)
                                            userInfo:nil
                                             repeats:YES];
  }
  return self;
}

- (void)dealloc {
  [_timer invalidate];
}

- (void)generatePower {
  PowerType powerType = [self randomPowerType];
  [self.delegate powerGenerator:self didGeneratePowerOfType:powerType];
}

- (PowerType)randomPowerType {
  NSUInteger type = arc4random_uniform(3);
  return type;
}

@end
