//
//  CatcherMovementPattern.h
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/18/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 This represents movement pattern for a catcher in game play.
 */
@interface CatcherMovementPattern : NSObject

@property (nonatomic, readonly) CGPoint startPosition;
@property (nonatomic, readonly) CGPoint endPosition;

- (instancetype)initWithStartPosition:(CGPoint)startPosition
                          endPosition:(CGPoint)endPosition;

@end
