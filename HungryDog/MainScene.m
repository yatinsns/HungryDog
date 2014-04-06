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

@implementation MainScene

- (id)initWithSize:(CGSize)size {
  if (self = [super initWithSize:size]) {
    self.backgroundColor = [SKColor blackColor];
    [self addNameLabel];
  }
  return self;
}

- (void)addNameLabel {
  CGFloat fontSize = ValueForDevice(NameLabelFontSize_iPhone, NameLabelFontSize_iPad);
  SKLabelNode *nameLabel = [SKLabelNode labelNodeWithFontNamed:AppFontName
                                                      fontSize:fontSize
                                                     fontColor:[SKColor whiteColor]];
  nameLabel.text = AppName;
  nameLabel.position = CGPointMake(self.size.width / 2,
                                   self.size.height / 2);
  nameLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
  [self addChild:nameLabel];
}

@end
