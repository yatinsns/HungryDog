//
//  HoleGenerator.h
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/20/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HoleGeneratorDelegate;

@interface HoleGenerator : NSObject

@property (nonatomic, weak) id<HoleGeneratorDelegate> delegate;

- (void)generateHole;

@end

@protocol HoleGeneratorDelegate <NSObject>

- (void)holeGeneratorDidGenerateHole:(HoleGenerator *)holeGenerator;

@end
