//
//  NSString+ScoreAdditions.h
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/9/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ScoreAdditions)

/**
 @return NSString representation of score.
 */
+ (NSString *)stringWithScore:(NSUInteger)score;

@end
