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

static const CGFloat CatcherSpeed_iPhone = 75;
static const CGFloat CatcherSpeed_iPad = 200;
static const CGFloat CatcherRotationSpeed = 4 * M_PI;

@interface StrategyMaker ()

@property (nonatomic) NSMutableArray *array;

@end

@implementation StrategyMaker

- (instancetype)init {
  self = [super init];
  if (self) {
    _array = [NSMutableArray array];
  }
  return self;
}

- (void)setCatchers:(NSArray *)catchers withSize:(CGSize)size {
  CGFloat catcherSpeed = ValueForDevice(CatcherSpeed_iPhone, CatcherSpeed_iPad);
  for (SKSpriteNode *catcher in catchers) {
    CatcherHandler *catcherHandler = [[CatcherHandler alloc] initWithSpeed:catcherSpeed
                                                             rotationSpeed:CatcherRotationSpeed
                                                                      size:size];
    catcherHandler.catcher = catcher;
    [self.array addObject:catcherHandler];
  }
}

- (void)updateDogLocation:(CGPoint)location size:(CGSize)size {
  for (CatcherHandler *catcherHandler in self.array) {
    [catcherHandler setDogLocation:location];
    [catcherHandler moveTowardsLocation:location];
  }
}

- (void)update:(NSTimeInterval)currentTime {
  for (CatcherHandler *catcherHandler in self.array) {
    [catcherHandler update:currentTime];
  }
}

@end
