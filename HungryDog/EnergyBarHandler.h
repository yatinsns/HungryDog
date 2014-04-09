//
//  EnergyBarHandler.h
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/10/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 This class handles energy bar depletion for a single gameplay.
 */
@interface EnergyBarHandler : NSObject

/**
 This denotes energy depletion rate per millisecond.
 */
@property (nonatomic) CGFloat depletionRate;

/**
 Designated initializer.

 @param depletionRate Energy depletion rate per millisecond.
 */
- (instancetype)initWithDepletionRate:(CGFloat)depletionRate;

/**
 Denotes percentage of energy left. Value can be between 0 to 100 only.
 */
- (NSUInteger)status;

/**
 Updates status according to `currentTime`.
 */
- (void)update:(NSTimeInterval)currentTime;

@end
