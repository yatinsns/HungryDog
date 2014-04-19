//
//  PowerGenerator.h
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/20/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PowerType) {
  PowerTypeEnergyBooster,
  PowerTypeTimeStopper,
  PowerTypeInvisibiltyCloak
};

@protocol PowerGeneratorDelegate;

/**
 This class generates powers within single game play.
 */
@interface PowerGenerator : NSObject

@property (nonatomic, weak) id<PowerGeneratorDelegate> delegate;

@end


@protocol PowerGeneratorDelegate <NSObject>

- (void)powerGenerator:(PowerGenerator *)powerGenerator
didGeneratePowerOfType:(PowerType)powerType;

@end
