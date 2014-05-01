//
//  CatcherHandler.h
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/14/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CatcherMode.h"

@class CatcherMovementPattern, Catcher;

@protocol CatcherHandlerDelegate;

@class SKSpriteNode;

/**
 This class handles catcher within a single gameplay.
 */
@interface CatcherHandler : NSObject

/**
 Delegate.
 */
@property (nonatomic, weak) id<CatcherHandlerDelegate> delegate;

/**
 This property represents the catcher to be moved.
 */
@property (nonatomic, readonly) Catcher *catcher;

/**
 This property represents the mode of the catcher.
 */
@property (nonatomic) CatcherMode mode;

// Pattern mode

/**
 This property represents pattern of movement.
 */
@property (nonatomic) CatcherMovementPattern *movementPattern;

// Methods

/**
 Designated initializer.
 */
- (instancetype)initWithCatcher:(Catcher *)catcher;

/**
 Update movement of catcher for `timeInterval`.
 */
- (void)updateForTimeInterval:(NSTimeInterval)timeInterval;

/**
 Movement methods.
 */
- (void)start;

/**
 Movement methods.
 */
- (void)stop;

/**
 Movement methods.
 */
- (void)stopForTimeInterval:(NSTimeInterval)timeInterval;

@end

@protocol CatcherHandlerDelegate <NSObject>

- (CGPoint)dogPositionForCatcherHandler:(CatcherHandler *)catcherHandler;

- (CGSize)screenSizeForCatcherHandler:(CatcherHandler *)catcherHandler;

@end
