//
//  StrategyPattern.h
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/18/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CatcherMovementPattern.h"

/**
 This class represents set of movement patters used in strategy of a catcher.
 */
@interface StrategyPattern : NSObject

@property (nonatomic, readonly) NSArray *movementPatterns;

/**
 Designated initializer.
 
 @param movementPatterns NSArray consisting of instances of `CatcherMovementPatterns`.
 */
- (instancetype)initWithMovementPatterns:(NSArray *)movementPatterns;

@end
