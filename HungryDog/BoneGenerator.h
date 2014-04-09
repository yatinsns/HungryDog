//
//  BoneGenerator.h
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/10/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BoneGeneratorDelegate;

/**
 This class generates bones periodically.
 */
@interface BoneGenerator : NSObject

@property (nonatomic, weak) id<BoneGeneratorDelegate> delegate;

/**
 Generate new bone.
 */
- (void)generateBone;

@end

@protocol BoneGeneratorDelegate <NSObject>

- (void)boneGeneratorDidGenerateNewBone:(BoneGenerator *)boneGenerator;

@end
