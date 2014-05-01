//
//  DogHandler.h
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/11/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NodeUpdater.h"

@class SKSpriteNode;

/**
 This class handles movement of dog.
 */
@interface DogHandler : NSObject <NodeUpdater>

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
 Move dog towards `location`.
 */
- (void)moveTowardsLocation:(CGPoint)location;

@end
