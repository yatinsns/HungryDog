//
//  StrategyPatternCreator.m
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/18/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import "StrategyPatternCreator.h"

@interface StrategyPatternCreator ()

@property (nonatomic, readwrite) NSArray *strategyPatterns;
@property (nonatomic) CGSize size;

@end

@implementation StrategyPatternCreator

- (void)createForSize:(CGSize)size {
  self.size = size;
  [self createPatterns];
}

- (void)createPatterns {
  NSMutableArray *patterns = [NSMutableArray array];
  NSArray *arrayOfPositionsArray = [self arrayOfPositionsArray];
  for (NSArray *positionArray in arrayOfPositionsArray) {
    [patterns addObject:[self strategyPatternWithPositions:positionArray]];
  }
  self.strategyPatterns = patterns;
}

- (NSArray *)arrayOfPositionsArray {
  CGFloat width = self.size.width;
  CGFloat height = self.size.height;
  CGFloat midWidth = width / 2;
  CGFloat midHeight = height / 2;
  return @[
           @[[NSValue valueWithCGPoint:CGPointMake(0, midHeight + 50)], [NSValue valueWithCGPoint:CGPointMake(width, midHeight + 50)],
             [NSValue valueWithCGPoint:CGPointMake(width, midHeight - 50)], [NSValue valueWithCGPoint:CGPointMake(0, midHeight - 50)],
             [NSValue valueWithCGPoint:CGPointMake(midWidth - 50, 0)], [NSValue valueWithCGPoint:CGPointMake(midWidth - 50, height)],
             [NSValue valueWithCGPoint:CGPointMake(midWidth + 50, height)], [NSValue valueWithCGPoint:CGPointMake(midWidth + 50, 0)]],
           @[[NSValue valueWithCGPoint:CGPointMake(0, midHeight - 50)], [NSValue valueWithCGPoint:CGPointMake(width, midHeight - 50)],
             [NSValue valueWithCGPoint:CGPointMake(width, midHeight + 50)], [NSValue valueWithCGPoint:CGPointMake(0, midHeight + 50)],
             [NSValue valueWithCGPoint:CGPointMake(midWidth - 50, 0)], [NSValue valueWithCGPoint:CGPointMake(midWidth - 50, height)],
             [NSValue valueWithCGPoint:CGPointMake(midWidth + 50, height)], [NSValue valueWithCGPoint:CGPointMake(midWidth + 50, 0)]],
           @[[NSValue valueWithCGPoint:CGPointMake(midWidth - 50, 0)], [NSValue valueWithCGPoint:CGPointMake(midWidth - 50, height)],
             [NSValue valueWithCGPoint:CGPointMake(midWidth + 50, height)], [NSValue valueWithCGPoint:CGPointMake(midWidth + 50, 0)],
             [NSValue valueWithCGPoint:CGPointMake(midWidth + 100, 0)], [NSValue valueWithCGPoint:CGPointMake(midWidth + 100, height)],
             [NSValue valueWithCGPoint:CGPointMake(midWidth - 100, height)], [NSValue valueWithCGPoint:CGPointMake(midWidth - 100, 0)]],
           @[[NSValue valueWithCGPoint:CGPointMake(midWidth - 50, 0)], [NSValue valueWithCGPoint:CGPointMake(midWidth - 50, height)],
             [NSValue valueWithCGPoint:CGPointMake(midWidth + 50, 0)], [NSValue valueWithCGPoint:CGPointMake(midWidth + 50, height)],
             [NSValue valueWithCGPoint:CGPointMake(midWidth + 100, 0)], [NSValue valueWithCGPoint:CGPointMake(midWidth + 100, height)],
             [NSValue valueWithCGPoint:CGPointMake(midWidth - 100, 0)], [NSValue valueWithCGPoint:CGPointMake(midWidth - 100, height)]]
           ];
}

- (StrategyPattern *)strategyPatternWithPositions:(NSArray *)positions {
  NSMutableArray *movementPatterns = [NSMutableArray array];
  for (int i = 0; i < 4; i++) {
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
