//
//  NodeGenerator.h
//  HungryDog
//
//  Created by Yatin Sarbalia on 5/1/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NodeGenerator <NSObject>

- (void)generateForGameDuration:(NSTimeInterval)gameDuration;

@end
