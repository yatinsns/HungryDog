//
//  MainScene.h
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/6/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol MainSceneDelegate;

/**
 This class represents main scene with menu options.
 */
@interface MainScene : SKScene

@property (nonatomic, weak) id<MainSceneDelegate> delegate;

- (id)initWithSize:(CGSize)size lastScore:(NSUInteger)lastScore;

@end


@protocol MainSceneDelegate <NSObject>

- (void)mainSceneDidSelectPlayOption:(MainScene *)mainScene;

@end