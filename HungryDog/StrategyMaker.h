//
//  StrategyMaker.h
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/15/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 This class handles strategy of catchers within single gameplay.
 */
@interface StrategyMaker : NSObject

- (void)setCatchers:(NSArray *)catchers withSize:(CGSize)size;

- (void)updateDogLocation:(CGPoint)location size:(CGSize)size;

- (void)updateForTimeInterval:(NSTimeInterval)timeInterval;

- (void)stopCatchersForInterval:(NSTimeInterval)timeInterval;

@end
