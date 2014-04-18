//
//  StrategyPatternCreator.m
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/18/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import "StrategyPatternCreator.h"

@implementation StrategyPatternCreator

- (instancetype)init {
  self = [super init];
  if (self) {
    [self createPatterns];
  }
  return self;
}

- (void)createPatterns {
  NSMutableArray *patterns = [NSMutableArray array];
  NSArray *arrayOfPositionsArray = [self arrayOfPositionsArray];
  for (NSArray *positionArray in arrayOfPositionsArray) {
    [patterns addObject:[self strategyPatternWithPositions:positionArray]];
  }
  _strategyPatterns = patterns;
}

- (NSArray *)arrayOfPositionsArray {
  return @[
           @[[NSValue valueWithCGPoint:CGPointZero], [NSValue valueWithCGPoint:CGPointZero], [NSValue valueWithCGPoint:CGPointZero], [NSValue valueWithCGPoint:CGPointZero], [NSValue valueWithCGPoint:CGPointZero], [NSValue valueWithCGPoint:CGPointZero], [NSValue valueWithCGPoint:CGPointZero], [NSValue valueWithCGPoint:CGPointZero]],
           @[[NSValue valueWithCGPoint:CGPointZero], [NSValue valueWithCGPoint:CGPointZero], [NSValue valueWithCGPoint:CGPointZero], [NSValue valueWithCGPoint:CGPointZero], [NSValue valueWithCGPoint:CGPointZero], [NSValue valueWithCGPoint:CGPointZero], [NSValue valueWithCGPoint:CGPointZero], [NSValue valueWithCGPoint:CGPointZero]],
           @[[NSValue valueWithCGPoint:CGPointZero], [NSValue valueWithCGPoint:CGPointZero], [NSValue valueWithCGPoint:CGPointZero], [NSValue valueWithCGPoint:CGPointZero], [NSValue valueWithCGPoint:CGPointZero], [NSValue valueWithCGPoint:CGPointZero], [NSValue valueWithCGPoint:CGPointZero], [NSValue valueWithCGPoint:CGPointZero]],
           @[[NSValue valueWithCGPoint:CGPointZero], [NSValue valueWithCGPoint:CGPointZero], [NSValue valueWithCGPoint:CGPointZero], [NSValue valueWithCGPoint:CGPointZero], [NSValue valueWithCGPoint:CGPointZero], [NSValue valueWithCGPoint:CGPointZero], [NSValue valueWithCGPoint:CGPointZero], [NSValue valueWithCGPoint:CGPointZero]]
           ];
}

- (StrategyPattern *)strategyPatternWithPositions:(NSArray *)positions {
  NSMutableArray *movementPatterns = [NSMutableArray array];
  for (int i = 0; i < 3; i++) {
    CGPoint position1 = [(NSValue *)[positions objectAtIndex:2 * i] CGPointValue];
    CGPoint position2 = [(NSValue *)[positions objectAtIndex:(2 * i + 1)] CGPointValue];
    CatcherMovementPattern *movementPattern = [[CatcherMovementPattern alloc] initWithStartPosition:position1
                                                                                        endPosition:position2];
    [movementPatterns addObject:movementPattern];
  }
  
  StrategyPattern *startegyPattern = [[StrategyPattern alloc] initWithMovementPatterns:movementPatterns];
  return startegyPattern;
}

@end
