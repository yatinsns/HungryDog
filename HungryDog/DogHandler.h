//
//  DogHandler.h
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/11/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKSpriteNode;

/**
 This class handles movement of dog.
 */
@interface DogHandler : NSObject

/**
 This property represents the dog to be moved.
 */
@property (nonatomic) SKSpriteNode *dog;

/**
 Designated initializer.
 */
- (instancetype)initWithSpeed:(CGFloat)speed
                rotationSpeed:(CGFloat)rotationSpeed;

/**
 Update movement of dog for `timeInterval`.
 */
- (void)updateForTimeInterval:(NSTimeInterval)timeInterval;

/**
 Move dog towards `location`.
 */
- (void)moveTowardsLocation:(CGPoint)location;

/**
 Stop the dog.
 */
- (void)stop;

@end
