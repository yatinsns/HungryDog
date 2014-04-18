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

static const CGFloat CatcherSpeed_iPhone = 75;
static const CGFloat CatcherSpeed_iPad = 200;
static const CGFloat CatcherRotationSpeed = 4 * M_PI;

static const NSTimeInterval PatternMovementInterval = 3;
static const NSTimeInterval PatternRotationInterval = 1;

@interface StrategyMaker ()

@property (nonatomic) NSMutableArray *array;
@property (nonatomic) StrategyPatternCreator *strategyPatternCreator;

@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSUInteger currentPatternIndex;

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

- (void)dealloc {
  [_timer invalidate];
}

- (void)setCatchers:(NSArray *)catchers withSize:(CGSize)size {
  [self.strategyPatternCreator createForSize:size];
  StrategyPattern *pattern = [self randomStrategyPattern];
  CGFloat catcherSpeed = ValueForDevice(CatcherSpeed_iPhone, CatcherSpeed_iPad);
  NSUInteger index = 0;
  for (SKSpriteNode *catcher in catchers) {
    CatcherHandler *catcherHandler = [[CatcherHandler alloc] initWithSpeed:catcherSpeed
                                                             rotationSpeed:CatcherRotationSpeed
                                                                      size:size];
    catcherHandler.catcher = catcher;
    catcherHandler.mode = CatcherModePattern;
    catcherHandler.movementPattern = [pattern.movementPatterns objectAtIndex:index];
    catcherHandler.patternRotationInterval = PatternRotationInterval;
    catcherHandler.patternMovementInterval = PatternMovementInterval;
    [self.array addObject:catcherHandler];
    index ++;
  }

  self.timer = [NSTimer scheduledTimerWithTimeInterval:20
                                                target:self
                                              selector:@selector(changePattern)
                                              userInfo:nil
                                               repeats:YES];
}

- (void)changePattern {
  StrategyPattern *pattern = [self randomStrategyPattern];
  NSUInteger index = 0;
  for (CatcherHandler *catcherHandler in self.array) {
    catcherHandler.movementPattern = [pattern.movementPatterns objectAtIndex:index];
    index ++;
  }
}

- (void)updateDogLocation:(CGPoint)location size:(CGSize)size {
  for (CatcherHandler *catcherHandler in self.array) {
    [catcherHandler moveTowardsLocation:location];
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

@end
