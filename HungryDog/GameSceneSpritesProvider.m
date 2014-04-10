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

const CGFloat BoneWidth_iPhone = 50;
const CGFloat BoneWidth_iPad = 100;
const CGFloat BoneHeight_iPhone = 28;
const CGFloat BoneHeight_iPad = 56;

const CGFloat ScoreLabelFontSize_iPhone = 20;
const CGFloat ScoreLabelFontSize_iPad = 40;

@implementation GameSceneSpritesProvider

- (SKLabelNode *)score {
  CGFloat fontSize = ValueForDevice(ScoreLabelFontSize_iPhone, ScoreLabelFontSize_iPad);
  SKLabelNode *node = [SKLabelNode labelNodeWithFontNamed:AppFontName
                                                 fontSize:fontSize
                                                fontColor:[SKColor whiteColor]];
  node.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
  node.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
  return node;
}

- (SKSpriteNode *)energyBarWithBorderWidth:(CGFloat)borderWidth
                           bottomLeftPoint:(CGPoint)bottomLeftPoint
                             topRightPoint:(CGPoint)topRightPoint
                                    status:(NSUInteger)status {
  SKSpriteNode *node = [SKSpriteNode node];
  SKShapeNode *topLeft = [SKShapeNode node];
  UIBezierPath *topLeftBezierPath = [[UIBezierPath alloc] init];
  [topLeftBezierPath moveToPoint:CGPointMake(bottomLeftPoint.x, bottomLeftPoint.y)];
  [topLeftBezierPath addLineToPoint:CGPointMake(topRightPoint.x, bottomLeftPoint.y)];
  [topLeftBezierPath addLineToPoint:CGPointMake(topRightPoint.x, topRightPoint.y)];
  [topLeftBezierPath addLineToPoint:CGPointMake(bottomLeftPoint.x, topRightPoint.y)];
  [topLeftBezierPath addLineToPoint:CGPointMake(bottomLeftPoint.x, bottomLeftPoint.y)];
  topLeft.path = topLeftBezierPath.CGPath;
  topLeft.lineWidth = borderWidth;
  topLeft.strokeColor = [UIColor whiteColor];
  [node addChild:topLeft];
  
  CGFloat barNodeWidth = (topRightPoint.x - bottomLeftPoint.x) - (2 * borderWidth);
  CGFloat barNodeHeight = (topRightPoint.y - bottomLeftPoint.y) - (2 * borderWidth);
  SKSpriteNode *barNode = [SKSpriteNode spriteNodeWithImageNamed:@"EnergyBar.png"];
  barNode.anchorPoint = CGPointZero;
  CGPoint bottomLeftBarNodePoint = CGPointMake(bottomLeftPoint.x + borderWidth, bottomLeftPoint.y + borderWidth);
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

@end
