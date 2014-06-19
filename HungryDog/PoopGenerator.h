//
//  PoopGenerator.h
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/20/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PoopGeneratorDelegate;

/**
 This class handles resposibility of pooping.
 */
@interface PoopGenerator : NSObject

@property (nonatomic, weak) id<PoopGeneratorDelegate> delegate;

- (instancetype)initWithIntakeThreshold:(NSUInteger)intakeThreshold;

- (void)intake;

- (void)poop;

@end

@protocol PoopGeneratorDelegate <NSObject>

- (void)poopGenerator:(PoopGenerator *)poopGenerator didChangeStatus:(CGFloat)status;

- (void)poopGeneratorDidPoop:(PoopGenerator *)poopGenerator;

@end
