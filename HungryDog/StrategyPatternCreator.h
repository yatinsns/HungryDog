//
//  StrategyPatternCreator.h
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/18/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StrategyPattern.h"

/**
 This class created predefined set of strategy patterns.
 */
@interface StrategyPatternCreator : NSObject

@property (nonatomic, readonly) NSArray *strategyPatterns;

- (void)createForSize:(CGSize)size;

@end
