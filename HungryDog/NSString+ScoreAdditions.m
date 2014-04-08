//
//  NSString+ScoreAdditions.m
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/9/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import "NSString+ScoreAdditions.h"

@implementation NSString (ScoreAdditions)

+ (NSString *)stringWithScore:(NSUInteger)score {
  return [NSString stringWithFormat:@"Bones: %lu", (unsigned long)score];
}

@end
