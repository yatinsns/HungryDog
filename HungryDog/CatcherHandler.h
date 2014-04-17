//
//  CatcherHandler.h
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/14/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import <Foundation/Foundation.h>

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
 Designated initializer.
 */
- (instancetype)initWithSpeed:(CGFloat)speed
                rotationSpeed:(CGFloat)rotationSpeed
                         size:(CGSize)size;

/**
 Update movement of catcher.
 */
- (void)update:(NSTimeInterval)currentTime;

/**
 Move catcher towards `location`.
 */
- (void)moveTowardsLocation:(CGPoint)location;

/**
 Updates dog's location.
 */
- (void)setDogLocation:(CGPoint)dogLocation;

@end
