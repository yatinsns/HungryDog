//
//  PoopGenerator.m
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/20/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import "PoopGenerator.h"

@interface PoopGenerator ()

@property (nonatomic) NSUInteger intakeThreshold;
@property (nonatomic) NSUInteger intakeCount;

@end

@implementation PoopGenerator

- (instancetype)initWithIntakeThreshold:(NSUInteger)intakeThreshold {
  self = [super init];
  if (self) {
    _intakeThreshold = intakeThreshold;
    _intakeCount = 0;
  }
  return self;
}

- (void)intake {
  self.intakeCount ++;
  if (self.intakeCount > self.intakeThreshold) {
    self.intakeCount = self.intakeThreshold;
  }
  [self.delegate poopGenerator:self didChangeStatus:(((CGFloat)self.intakeCount) / self.intakeThreshold)];
}

- (void)poop {
  if (self.intakeCount == self.intakeThreshold) {
    [self.delegate poopGeneratorDidPoop:self];
    self.intakeCount = 0;
    [self.delegate poopGenerator:self didChangeStatus:(self.intakeCount / self.intakeThreshold)];
  }
}

@end
