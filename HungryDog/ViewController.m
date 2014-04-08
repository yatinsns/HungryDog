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

@interface ViewController () <MainSceneDelegate>

@property (nonatomic) GamePlay *currentGamePlay;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // FIXME (YS): Need to move this to another method.
  // Configure the view.
  SKView *skView = (SKView *)self.view;
  skView.showsFPS = YES;
  skView.showsNodeCount = YES;
  
  // Create and configure the scene.
  MainScene *scene = [MainScene sceneWithSize:skView.bounds.size];
  scene.scaleMode = SKSceneScaleModeAspectFill;
  scene.delegate = self;
  
  // Present the scene.
  [skView presentScene:scene];
}

- (BOOL)shouldAutorotate {
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
  self.currentGamePlay = [[GamePlay alloc] init];
  SKView *skView = (SKView *)self.view;
  GameScene *gameScene = [[GameScene alloc] initWithSize:skView.bounds.size
                                                gamePlay:self.currentGamePlay];
  gameScene.scaleMode = SKSceneScaleModeAspectFill;
  [skView presentScene:gameScene];
}

@end
