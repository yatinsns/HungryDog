//
//  EnergyBarHandler.h
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/10/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NodeUpdater.h"

@protocol EnergyBarHandlerDelegate;

/**
 This class handles energy bar depletion for a single gameplay.
 */
@interface EnergyBarHandler : NSObject <NodeUpdater>

/**
 This denotes energy depletion rate per millisecond.
 */
@property (nonatomic) CGFloat depletionRate;

@property (nonatomic, weak) id<EnergyBarHandlerDelegate> delegate;

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
 Boosts energy by a fixed amount.
 */
- (void)boost;

/**
 Boosts energy to the maximum amount.
 */
- (void)boostToFull;

@end

@protocol EnergyBarHandlerDelegate <NSObject>

- (void)energyBarHandlerDidUpdateStatus:(EnergyBarHandler *)energyBarHandler;

@end
