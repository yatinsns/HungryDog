//
//  ViewController.m
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/5/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import "ViewController.h"
#import "MainScene.h"
#import "GameScene.h"
#import "GamePlay.h"

@interface ViewController () <MainSceneDelegate, GameSceneDelegate>

@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
  }
  return self;
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  
  // Configure the view.
  SKView * skView = (SKView *)self.view;
  if (!skView.scene) {
    // Create and configure the scene.
    MainScene *scene = [MainScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.delegate = self;

    // Present the scene.
    [skView presentScene:scene];
  }
}

- (BOOL)shouldAutorotate {
  return YES;
}

- (BOOL)prefersStatusBarHidden {
  return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    return UIInterfaceOrientationMaskAllButUpsideDown;
  } else {
    return UIInterfaceOrientationMaskAll;
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - MainSceneDelegate methods

- (void)mainSceneDidSelectPlayOption:(MainScene *)mainScene {
  GamePlay *gamePlay = [[GamePlay alloc] init];
  SKView *skView = (SKView *)self.view;
  GameScene *gameScene = [[GameScene alloc] initWithSize:skView.bounds.size
                                                gamePlay:gamePlay];
  gameScene.delegate = self;
  gameScene.scaleMode = SKSceneScaleModeAspectFill;
  [skView presentScene:gameScene];
}

#pragma mark - GameSceneDelegate methods

- (void)gameSceneDidEndGame:(GameScene *)gameScene {
  SKView * skView = (SKView *)self.view;
  MainScene *scene = [[MainScene  alloc] initWithSize:skView.bounds.size
                                            lastScore:gameScene.gamePlay.scoreHandler.currentScore];
  scene.delegate = self;
  SKTransition *reveal = [SKTransition fadeWithDuration:0.5];
  [skView presentScene:scene transition:reveal];
}

#pragma mark - UIApplication notifications

- (void)applicationDidBecomeActive:(NSNotification *)notification {
  [self pauseGameScene:NO];
}

- (void)applicationWillResignActive:(NSNotification *)notification {
  [self pauseGameScene:YES];
}

- (void)pauseGameScene:(BOOL)pause {
  SKView *skView = (SKView *)self.view;
  if ([skView.scene isKindOfClass:[GameScene class]]) {
    [(GameScene *)skView.scene pauseScene:pause];
  }
}

@end
