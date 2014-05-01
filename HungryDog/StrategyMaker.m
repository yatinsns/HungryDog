//
//  StrategyMaker.m
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/15/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import "StrategyMaker.h"
#import "CatcherHandler.h"
#import "UIUtils.h"
#import "StrategyPatternCreator.h"
#import <SpriteKit/SpriteKit.h>
#import "Catcher.h"

static const CGFloat CatcherMovementSpeed_iPhone = 75;
static const CGFloat CatcherMovementSpeed_iPad = 200;
static const CGFloat CatcherRotationSpeed = 4 * M_PI;

static const NSTimeInterval PatternMovementInterval = 3;
static const NSTimeInterval PatternRotationInterval = 1;

@interface StrategyMaker () <CatcherHandlerDelegate>

@property (nonatomic) NSMutableArray *array;
@property (nonatomic) StrategyPatternCreator *strategyPatternCreator;

@property (nonatomic) NSUInteger currentPatternIndex;

@property (nonatomic) NSUInteger numberOfCatchers;

@end

@implementation StrategyMaker

- (instancetype)init {
  self = [super init];
  if (self) {
    _array = [NSMutableArray array];
    _strategyPatternCreator = [[StrategyPatternCreator alloc] init];
  }
  return self;
}

- (void)updateWithGameDuration:(NSTimeInterval)gameDuration {
  if (self.numberOfCatchers < 1) {
    if ((NSUInteger)(floor((gameDuration / 2))) != self.numberOfCatchers) {
      self.numberOfCatchers ++;
      [self.delegate strategyMakerDidGenerateCatcher:self];
    }
  }
}

- (void)addCatcher:(Catcher *)catcher {
  if ([self.strategyPatternCreator.strategyPatterns count] == 0) {
    [self.strategyPatternCreator createForSize:[self.delegate screenSizeForStrategyMaker:self]];
  }

  CGFloat catcherMovementSpeed = ValueForDevice(CatcherMovementSpeed_iPhone, CatcherMovementSpeed_iPad);
  catcher.movementSpeed = catcherMovementSpeed;
  catcher.rotationSpeed = CatcherRotationSpeed;
  catcher.patternRotationInterval = PatternRotationInterval;
  catcher.patternMovementInterval = PatternMovementInterval;
  CatcherHandler *catcherHandler = [[CatcherHandler alloc] initWithCatcher:catcher];
  catcherHandler.delegate = self;
  catcherHandler.mode = CatcherModeRandom;
  [catcherHandler start];

  [self.array addObject:catcherHandler];
}

- (void)setPattern {
  StrategyPattern *pattern = [self randomStrategyPattern];
  NSUInteger index = 0;
  for (CatcherHandler *catcherHandler in self.array) {
    catcherHandler.movementPattern = [pattern.movementPatterns objectAtIndex:index];
    index ++;
  }
}

- (void)updateForTimeInterval:(NSTimeInterval)timeInterval {
  for (CatcherHandler *catcherHandler in self.array) {
    [catcherHandler updateForTimeInterval:timeInterval];
  }
}

- (StrategyPattern *)randomStrategyPattern {
  NSUInteger index = 0;
  do {
    index = arc4random_uniform((u_int32_t)[self.strategyPatternCreator.strategyPatterns count]);
  } while (self.currentPatternIndex == index);
  self.currentPatternIndex = index;
  return [self.strategyPatternCreator.strategyPatterns objectAtIndex:self.currentPatternIndex];
}

- (void)stopCatchersForInterval:(NSTimeInterval)timeInterval {
  for (CatcherHandler *catcherHandler in self.array) {
    [catcherHandler stop];
  }
  [self.delegate strategyMakerDidStopCatchers:self];
  [self performSelector:@selector(startCatchers) withObject:nil afterDelay:timeInterval];
}

- (void)startCatchers {
  for (CatcherHandler *catcherHandler in self.array) {
    [catcherHandler start];
  }
  [self.delegate strategyMakerDidStartCatchers:self];
}

#pragma mark - CatcherHandlerDelegate

- (CGPoint)dogPositionForCatcherHandler:(CatcherHandler *)catcherHandler {
  return [self.delegate dogPositionForStrategyMaker:self];
}

- (CGSize)screenSizeForCatcherHandler:(CatcherHandler *)catcherHandler {
  return [self.delegate screenSizeForStrategyMaker:self];
}

@end
