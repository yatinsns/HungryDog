//
//  BoneManager.h
//  HungryDog
//
//  Created by Yatin on 19/05/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 This class manages the current number of bones in application.
 */
@interface BoneManager : NSObject

+ (BoneManager *)sharedManager;

- (NSUInteger)currentNumberOfBones;

- (void)boostByNumberOfBones:(NSUInteger)numberOfBones;

@end
