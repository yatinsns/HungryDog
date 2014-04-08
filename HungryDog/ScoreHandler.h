//
//  ScoreHandler.h
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/8/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 This class handles score related to single gameplay.
 */
@interface ScoreHandler : NSObject

- (void)incrementScoreByValue:(NSUInteger)value;

- (NSUInteger)currentScore;

@end
