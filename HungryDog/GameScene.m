//
//  GameScene.m
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/6/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import "GameScene.h"
#import "SKLabelNode+HungryDogAdditions.h"
#import "UIConstants.h"
#import "UIUtils.h"
#import "GamePlay.h"
#import "NSString+ScoreAdditions.h"
#import "GameSceneSpritesProvider.h"

const CGFloat ScoreLabelFontSize_iPhone = 20;
const CGFloat ScoreLabelFontSize_iPad = 40;
const CGFloat ScoreLabelPaddingRight = 10;
const CGFloat ScoreLabelPaddingTop = 10;

const CGFloat EnergyBarSizeWidth_iPhone = 30;
const CGFloat EnergyBarSizeWidth_iPad = 50;

const CGFloat EnergyBarPaddingRight_iPhone = 30;
const CGFloat EnergyBarPaddingRight_iPad = 15;

const CGFloat EnergyBarPaddingTop_iPhone = 50;
const CGFloat EnergyBarPaddingTop_iPad = 80;
const CGFloat EnergyBarStrokeWidth_iPhone = 1;
const CGFloat EnergyBarStrokeWidth_iPad = 3;

@interface GameScene () <EnergyBarHandlerDelegate>

@property (nonatomic) SKLabelNode *scoreLabel;
@property (nonatomic, readwrite) GamePlay *gamePlay;
@property (nonatomic) GameSceneSpritesProvider *spritesProvider;

@property (nonatomic) NSTimeInterval lastUpdateTime;
@property (nonatomic) NSTimeInterval dt;

@property (nonatomic) SKSpriteNode *eneryBarSprite;

@end

@implementation GameScene

- (id)initWithSize:(CGSize)size gamePlay:(GamePlay *)gamePlay {
  if (self = [super initWithSize:size]) {
    _gamePlay = gamePlay;
    _gamePlay.energyBarHandler.delegate = self;

    self.backgroundColor = [SKColor blackColor];
    _spritesProvider = [[GameSceneSpritesProvider alloc] init];
    [self addScoreLabel];
    [self addEnergyBarWithStatus:_gamePlay.energyBarHandler.status];
  }
  return self;
}

- (void)addScoreLabel {
  CGFloat fontSize = ValueForDevice(ScoreLabelFontSize_iPhone, ScoreLabelFontSize_iPad);
  _scoreLabel = [SKLabelNode labelNodeWithFontNamed:AppFontName
                                          fontSize:fontSize
                                         fontColor:[SKColor whiteColor]];
  _scoreLabel.text = [NSString stringWithScore:self.gamePlay.scoreHandler.currentScore];
  _scoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
  _scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
  _scoreLabel.position = CGPointMake(self.size.width - ScoreLabelPaddingRight,
                                     self.size.height - _scoreLabel.frame.size.height - ScoreLabelPaddingTop);
  [self addChild:_scoreLabel];
}

- (void)addEnergyBarWithStatus:(NSUInteger)status {
  CGFloat energyBarWidth = ValueForDevice(EnergyBarSizeWidth_iPhone, EnergyBarSizeWidth_iPad);
  CGFloat borderWidth = ValueForDevice(EnergyBarStrokeWidth_iPhone, EnergyBarStrokeWidth_iPad);
  CGFloat paddingTop = ValueForDevice(EnergyBarPaddingTop_iPhone, EnergyBarPaddingTop_iPad);
  CGFloat paddingRight = ValueForDevice(EnergyBarPaddingRight_iPhone, EnergyBarPaddingRight_iPad);
  
  CGPoint bottomLeftPoint = CGPointMake(self.size.width - energyBarWidth - paddingRight,
                                        paddingTop);
  CGPoint topRightPoint = CGPointMake(self.size.width - paddingRight,
                                      self.size.height - paddingTop);
  self.eneryBarSprite = [self.spritesProvider energyBarWithBorderWidth:borderWidth
                                                       bottomLeftPoint:bottomLeftPoint
                                                         topRightPoint:topRightPoint
                                                                status:status];
}

- (void)setEneryBarSprite:(SKSpriteNode *)eneryBarSprite {
  [_eneryBarSprite removeFromParent];
  _eneryBarSprite = eneryBarSprite;
  [self addChild:_eneryBarSprite];
}

- (void)update:(NSTimeInterval)currentTime {
  if (self.lastUpdateTime) {
    self.dt = currentTime - self.lastUpdateTime;
  } else {
    self.dt = 0;
  }
  self.lastUpdateTime = currentTime;

  [self.gamePlay.energyBarHandler update:currentTime];
}

#pragma mark - EnergyBarHandlerDelegate

- (void)energyBarHandlerDidUpdateStatus:(EnergyBarHandler *)energyBarHandler {
  [self addEnergyBarWithStatus:energyBarHandler.status];
  if (energyBarHandler.status == 0) {
    [self endGame];
  }
}

#pragma mark - Game events

- (void)endGame {
  [self.delegate gameSceneDidEndGame:self];
}

@end
