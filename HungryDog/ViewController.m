//
//  ViewController.m
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/5/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import "ViewController.h"
#import "MainScene.h"

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Configure the view.
  SKView * skView = (SKView *)self.view;
  skView.showsFPS = YES;
  skView.showsNodeCount = YES;
  
  // Create and configure the scene.
  SKScene * scene = [MainScene sceneWithSize:skView.bounds.size];
  scene.scaleMode = SKSceneScaleModeAspectFill;
  
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

@end
