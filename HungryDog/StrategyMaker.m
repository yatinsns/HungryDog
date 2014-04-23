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

static const CGFloat CatcherSpeed_iPhone = 75;
static const CGFloat CatcherSpeed_iPad = 200;
static const CGFloat CatcherRotationSpeed = 4 * M_PI;

static const NSTimeInterval PatternMovementInterval = 3;
static const NSTimeInterval PatternRotationInterval = 1;

@interface StrategyMaker () <CatcherHandlerDelegate>

@property (nonatomic) NSMutableArray *array;
@property (nonatomic) StrategyPatternCreator *strategyPatternCreator;

@property (nonatomic) NSUInteger currentPatternIndex;

@property (nonatomic) CGPoint dogPosition;

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
  if (self.numberOfCatchers < 10) {
    if ((NSUInteger)(floor((gameDuration / 5))) != self.numberOfCatchers) {
      self.numberOfCatchers ++;
      [self.delegate strategyMakerDidGenerateCatcher:self];
    }
  }
}

- (void)addCatcher:(SKSpriteNode *)catcher withSize:(CGSize)size {
  if ([self.strategyPatternCreator.strategyPatterns count] == 0) {
    [self.strategyPatternCreator createForSize:size];
  }

  CGFloat catcherSpeed = ValueForDevice(CatcherSpeed_iPhone, CatcherSpeed_iPad);
  CatcherHandler *catcherHandler = [[CatcherHandler alloc] initWithSpeed:catcherSpeed
                                                           rotationSpeed:CatcherRotationSpeed
                                                                    size:size];
  catcherHandler.catcher = catcher;
  catcherHandler.mode = CatcherModeRandom;
  catcherHandler.patternRotationInterval = PatternRotationInterval;
  catcherHandler.patternMovementInterval = PatternMovementInterval;
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

- (void)updateDogLocation:(CGPoint)location {
  self.dogPosition = location;
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
    catcherHandler.shouldStop = YES;
  }
  [self.delegate strategyMakerDidStopCatchers:self];
  [self performSelector:@selector(startCatchers) withObject:nil afterDelay:timeInterval];
}

- (void)startCatchers {
  for (CatcherHandler *catcherHandler in self.array) {
    catcherHandler.shouldStop = NO;
  }
  [self.delegate strategyMakerDidStartCatchers:self];
}

#pragma mark - CatcherHandlerDelegate

- (CGPoint)dogPositionForCatcherHandler:(CatcherHandler *)catcherHandler {
  return self.dogPosition;
}

@end
