//
//  CatcherHandler.h
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/14/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CatcherMode.h"

@class SKSpriteNode;

/**
 This class handles catcher within a single gameplay.
 */
@interface CatcherHandler : NSObject

/**
 This property represents the catcher to be moved.
 */
@property (nonatomic) SKSpriteNode *catcher;

/**
 This property represents the mode of the catcher.
 */
@property (nonatomic) CatcherMode *mode;

/**
 This property represents the radius of radar to follow dog.
 */
@property (nonatomic) CGFloat radarRadius;

/**
 Designated initializer.
 */
- (instancetype)initWithSpeed:(CGFloat)speed
                rotationSpeed:(CGFloat)rotationSpeed
                         size:(CGSize)size;

/**
 Update movement of catcher for `timeInterval`.
 */
- (void)updateForTimeInterval:(NSTimeInterval)timeInterval;

/**
 Move catcher towards `location`.
 */
- (void)moveTowardsLocation:(CGPoint)location;

@end
