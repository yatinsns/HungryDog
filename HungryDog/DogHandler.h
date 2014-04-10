//
//  DogHandler.h
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/11/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKSpriteNode;

@interface DogHandler : NSObject

@property (nonatomic) SKSpriteNode *dog;

- (instancetype)initWithSpeed:(CGFloat)speed
                rotationSpeed:(CGFloat)rotationSpeed;

- (void)update:(NSTimeInterval)currentTime;

- (void)moveTowardsLocation:(CGPoint)location;

@end
