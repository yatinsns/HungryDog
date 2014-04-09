//
//  GamePlay.h
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/8/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScoreHandler.h"
#import "EnergyBarHandler.h"

/**
 This class represents a game play within the app.
 */
@interface GamePlay : NSObject

@property (nonatomic, readonly) ScoreHandler *scoreHandler;
@property (nonatomic, readonly) EnergyBarHandler *energyBarHandler;

@end
