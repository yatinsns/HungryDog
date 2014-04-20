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
#import "BoneGenerator.h"
#import "DogHandler.h"
#import "StrategyMaker.h"
#import "PowerGenerator.h"
#import "HoleGenerator.h"
#import "PoopGenerator.h"

/**
 This class represents a game play within the app.
 */
@interface GamePlay : NSObject

@property (nonatomic, readonly) ScoreHandler *scoreHandler;
@property (nonatomic, readonly) EnergyBarHandler *energyBarHandler;
@property (nonatomic, readonly) BoneGenerator *boneGenerator;
@property (nonatomic, readonly) DogHandler *dogHandler;
@property (nonatomic, readonly) StrategyMaker *strategyMaker;
@property (nonatomic, readonly) PowerGenerator *powerGenerator;
@property (nonatomic, readonly) HoleGenerator *holeGenerator;
@property (nonatomic, readonly) PoopGenerator *poopGenerator;

@end
