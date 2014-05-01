//
//  StrategyMaker.h
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/15/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NodeGenerator.h"
#import "NodeUpdater.h"

@class SKSpriteNode, Catcher;

@protocol StrategyMakerDelegate;

/**
 This class handles strategy of catchers within single gameplay.
 */
@interface StrategyMaker : NSObject <NodeGenerator, NodeUpdater>

@property (nonatomic, weak) id<StrategyMakerDelegate> delegate;

- (void)addCatcher:(Catcher *)catcher;

- (void)stopCatchersForInterval:(NSTimeInterval)timeInterval;

@end


@protocol StrategyMakerDelegate <NSObject>

- (void)strategyMakerDidStopCatchers:(StrategyMaker *)strategyMaker;

- (void)strategyMakerDidStartCatchers:(StrategyMaker *)strategyMaker;

- (void)strategyMakerDidGenerateCatcher:(StrategyMaker *)strategyMaker;

- (CGSize)screenSizeForStrategyMaker:(StrategyMaker *)strategyMaker;

- (CGPoint)dogPositionForStrategyMaker:(StrategyMaker *)strategyMaker;

@end