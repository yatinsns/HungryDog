//
//  MainScene.m
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/6/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import "MainScene.h"
#import "SKLabelNode+HungryDogAdditions.h"
#import "UIConstants.h"
#import "UIUtils.h"

const CGFloat NameLabelFontSize_iPhone = 30;
const CGFloat NameLabelFontSize_iPad = 80;

const CGFloat PlayLabelCenterOffsetY_iPhone = 30;
const CGFloat PlayLabelCenterOffsetY_iPad = 80;
const CGFloat PlayLabelFontSize_iPhone = 15;
const CGFloat PlayLabelFontSize_iPad = 40;

NSString *const PlayName = @"Play";

@interface MainScene ()

@property (nonatomic) SKLabelNode *nameLabel;
@property (nonatomic) SKLabelNode *playLabel;

@end

@implementation MainScene

- (id)initWithSize:(CGSize)size {
  if (self = [super initWithSize:size]) {
    self.backgroundColor = [SKColor blackColor];
    [self addNameLabel];
    [self addPlayLabel];
    self.userInteractionEnabled = YES;
  }
  return self;
}

- (void)addNameLabel {
  CGFloat fontSize = ValueForDevice(NameLabelFontSize_iPhone, NameLabelFontSize_iPad);
  _nameLabel = [SKLabelNode labelNodeWithFontNamed:AppFontName
                                          fontSize:fontSize
                                         fontColor:[SKColor whiteColor]];
  _nameLabel.text = AppName;
  _nameLabel.position = CGPointMake(self.size.width / 2,
                                    self.size.height / 2);
  _nameLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
  [self addChild:_nameLabel];
}

- (void)addPlayLabel {
  CGFloat fontSize = ValueForDevice(PlayLabelFontSize_iPhone, PlayLabelFontSize_iPad);
  _playLabel = [SKLabelNode labelNodeWithFontNamed:AppFontName
                                          fontSize:fontSize
                                         fontColor:[SKColor greenColor]];
  _playLabel.text = PlayName;
  _playLabel.name = PlayName;
  CGFloat centerOffsetY = ValueForDevice(PlayLabelCenterOffsetY_iPhone, PlayLabelCenterOffsetY_iPad);
  _playLabel.position = CGPointMake(self.nameLabel.position.x,
                                    self.nameLabel.position.y - centerOffsetY);
  _playLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
  [self addChild:_playLabel];
}

#pragma mark - Touch events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];
  CGPoint touchLocation = [touch locationInNode:self.scene];
  SKNode *node = [self nodeAtPoint:touchLocation];
  if ([node.name isEqualToString:PlayName]) {
    [self handlePlayAction];
  }
}

#pragma mark - User actions

- (void)handlePlayAction {
  [self.delegate mainSceneDidSelectPlayOption:self];
}

@end
