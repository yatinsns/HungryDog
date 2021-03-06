//
//  GameSceneSpritesProvider.m
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/9/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import "GameSceneSpritesProvider.h"
#import "UIUtils.h"
#import "UIConstants.h"
#import "SKLabelNode+HungryDogAdditions.h"

const CGFloat BoneWidth_iPhone = 40;
const CGFloat BoneWidth_iPad = 80;
const CGFloat BoneHeight_iPhone = 40;
const CGFloat BoneHeight_iPad = 80;

const CGFloat ScoreLabelFontSize_iPhone = 20;
const CGFloat ScoreLabelFontSize_iPad = 40;

const CGFloat DogWidth_iPhone = 100;
const CGFloat DogWidth_iPad = 150;
const CGFloat DogHeight_iPhone = 38;
const CGFloat DogHeight_iPad = 74;

const CGFloat CatcherWidth_iPhone = 75;
const CGFloat CatcherWidth_iPad = 150;
const CGFloat CatcherHeight_iPhone = 37;
const CGFloat CatcherHeight_iPad = 74;

const CGFloat HoleWidth_iPhone = 75;
const CGFloat HoleWidth_iPad = 150;
const CGFloat HoleHeight_iPhone = 69;
const CGFloat HoleHeight_iPad = 138;

const CGFloat TunnelWidth_iPhone = 50;
const CGFloat TunnelWidth_iPad = 100;
const CGFloat TunnelHeight_iPhone = 50;
const CGFloat TunnelHeight_iPad = 100;

const CGFloat PauseButtonWidth = 44;
const CGFloat PauseButtonHeight = 44;

@implementation GameSceneSpritesProvider

- (SKLabelNode *)score {
  CGFloat fontSize = ValueForDevice(ScoreLabelFontSize_iPhone, ScoreLabelFontSize_iPad);
  SKLabelNode *node = [SKLabelNode labelNodeWithFontNamed:AppFontName
                                                 fontSize:fontSize
                                                fontColor:[SKColor whiteColor]];
  node.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
  node.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
  return node;
}

- (SKSpriteNode *)energyBarWithSize:(CGSize)size
                             border:(CGFloat)border
                             status:(NSUInteger)status {
  SKSpriteNode *node = [SKSpriteNode node];
  SKShapeNode *topLeft = [SKShapeNode node];
  UIBezierPath *topLeftBezierPath = [[UIBezierPath alloc] init];
  CGPoint bottomLeftPoint = CGPointZero;
  CGPoint topRightPoint = CGPointMake(size.width, size.height);
  [topLeftBezierPath moveToPoint:CGPointMake(bottomLeftPoint.x, bottomLeftPoint.y)];
  [topLeftBezierPath addLineToPoint:CGPointMake(topRightPoint.x, bottomLeftPoint.y)];
  [topLeftBezierPath addLineToPoint:CGPointMake(topRightPoint.x, topRightPoint.y)];
  [topLeftBezierPath addLineToPoint:CGPointMake(bottomLeftPoint.x, topRightPoint.y)];
  [topLeftBezierPath addLineToPoint:CGPointMake(bottomLeftPoint.x, bottomLeftPoint.y)];
  topLeft.path = topLeftBezierPath.CGPath;
  topLeft.lineWidth = border;
  topLeft.strokeColor = [UIColor whiteColor];
  [node addChild:topLeft];
  
  CGFloat barNodeWidth = (topRightPoint.x - bottomLeftPoint.x) - (2 * border);
  CGFloat barNodeHeight = (topRightPoint.y - bottomLeftPoint.y) - (2 * border);
  SKSpriteNode *barNode = [SKSpriteNode spriteNodeWithImageNamed:@"EnergyBar.png"];
  barNode.anchorPoint = CGPointZero;
  CGPoint bottomLeftBarNodePoint = CGPointMake(bottomLeftPoint.x + border, bottomLeftPoint.y + border);
  barNode.position = bottomLeftBarNodePoint;
  barNode.size = CGSizeMake(barNodeWidth,
                            barNodeHeight);
  
  SKShapeNode *maskNode = [SKShapeNode node];
  UIBezierPath *maskBezierPath = [[UIBezierPath alloc] init];
  
  CGPoint bottomLeftMaskPoint = bottomLeftBarNodePoint;
  CGPoint topRightMaskPoint = CGPointMake(bottomLeftMaskPoint.x + barNodeWidth,
                                          bottomLeftMaskPoint.y + ((barNodeHeight * status) / 100));
  [maskBezierPath moveToPoint:CGPointMake(bottomLeftMaskPoint.x, bottomLeftMaskPoint.y)];
  [maskBezierPath addLineToPoint:CGPointMake(topRightMaskPoint.x, bottomLeftMaskPoint.y)];
  [maskBezierPath addLineToPoint:CGPointMake(topRightMaskPoint.x, topRightMaskPoint.y)];
  [maskBezierPath addLineToPoint:CGPointMake(bottomLeftMaskPoint.x, topRightMaskPoint.y)];
  [maskBezierPath addLineToPoint:CGPointMake(bottomLeftMaskPoint.x, bottomLeftMaskPoint.y)];
  maskNode.path = maskBezierPath.CGPath;
  maskNode.fillColor = [UIColor blackColor];

  SKCropNode *cropNode = [SKCropNode node];
  [cropNode addChild:barNode];
  [cropNode setMaskNode:maskNode];
  [node addChild:cropNode];

  return node;
}

- (SKSpriteNode *)bone {
  SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"Bone.png"];
  node.xScale = 0.0;
  node.yScale = 0.0;
  CGFloat width = ValueForDevice(BoneWidth_iPhone, BoneWidth_iPad);
  CGFloat height = ValueForDevice(BoneHeight_iPhone, BoneHeight_iPad);
  node.size = CGSizeMake(width, height);
  node.zRotation = -M_PI / 16;
  return node;
}

- (SKSpriteNode *)dog {
  SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"dog_tail_3.png"];
  node.size = CGSizeMake(ValueForDevice(DogWidth_iPhone, DogWidth_iPad),
                         ValueForDevice(DogHeight_iPhone, DogHeight_iPad));
  return node;
}

- (Catcher *)catcher {
  Catcher *node = [Catcher spriteNodeWithImageNamed:@"zombie1.png"];
  node.size = CGSizeMake(ValueForDevice(CatcherWidth_iPhone, CatcherWidth_iPad),
                         ValueForDevice(CatcherHeight_iPhone, CatcherHeight_iPhone));
  return node;
}

- (SKSpriteNode *)hole {
  SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"Hole.png"];
  node.size = CGSizeMake(ValueForDevice(HoleWidth_iPhone, HoleWidth_iPad),
                         ValueForDevice(HoleHeight_iPhone, HoleHeight_iPad));
  return node;
}

- (SKSpriteNode *)tunnel {
  SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"Tunnel"];
  node.size = CGSizeMake(ValueForDevice(TunnelWidth_iPhone, TunnelWidth_iPad),
                         ValueForDevice(TunnelHeight_iPhone, TunnelHeight_iPad));
  return node;
}

- (ButtonNode *)pauseButtonWithPausedState:(BOOL)pausedState {
  NSString *normal = nil, *selected = nil;
  if (pausedState) {
    normal = @"play.png";
    selected = @"pause.png";
  } else {
    normal = @"pause.png";
    selected = @"play.png";
  }
  ButtonNode *node = [[ButtonNode alloc] initWithImageNamedNormal:normal selected:selected];
  node.size = CGSizeMake(PauseButtonWidth, PauseButtonHeight);
  return node;
}

- (SKSpriteNode *)powerWithType:(PowerType)powerType {
  SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:[self imageNameForPowerType:powerType]];
  node.size = [self sizeForPowerType:powerType];
  return node;
}

- (NSString *)imageNameForPowerType:(PowerType)powerType {
  switch (powerType) {
    case PowerTypeEnergyBooster:
      return @"Gift.png";
      break;
    case PowerTypeTimeStopper:
      return @"Gift.png";
      break;
    case PowerTypeInvisibiltyCloak:
      return @"Gift.png";
      break;
    default:
      break;
  }
  return nil;
}

- (CGSize)sizeForPowerType:(PowerType)powerType {
  switch (powerType) {
    case PowerTypeEnergyBooster:
      return CGSizeMake(40, 40);
      break;
    case PowerTypeInvisibiltyCloak:
      return CGSizeMake(40, 40);
      break;
    case PowerTypeTimeStopper:
      return CGSizeMake(40, 40);
      break;
    default:
      break;
  }
  return CGSizeZero;
}

- (SKLabelNode *)notificationWithText:(NSString *)text {
  SKLabelNode *node = [SKLabelNode labelNodeWithFontNamed:AppFontName
                                                 fontSize:70
                                                fontColor:[SKColor whiteColor]];
  node.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
  node.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
  node.text = text;
  return node;
}

- (SKSpriteNode *)poop {
  SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"Poop1.png"];
  node.size = CGSizeMake(35, 43);
  return node;
}

@end
