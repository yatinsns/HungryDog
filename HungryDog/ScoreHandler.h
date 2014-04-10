//
//  ScoreHandler.h
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/8/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ScoreHandlerDelegate;

/**
 This class handles score related to single gameplay.
 */
@interface ScoreHandler : NSObject

@property (nonatomic, weak) id<ScoreHandlerDelegate> delegate;

- (void)incrementScoreByValue:(NSUInteger)value;

- (NSUInteger)currentScore;

@end


@protocol ScoreHandlerDelegate <NSObject>

- (void)scoreHandlerDidUpdateScore:(ScoreHandler *)scoreHandler;

@end