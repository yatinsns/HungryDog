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

const CGFloat ScoreLabelFontSize_iPhone = 20;
const CGFloat ScoreLabelFontSize_iPad = 40;
const CGFloat ScoreLabelPaddingRight = 10;
const CGFloat ScoreLabelPaddingTop = 10;

@interface GameScene ()

@property (nonatomic) SKLabelNode *scoreLabel;
@property (nonatomic) GamePlay *gamePlay;

@end

@implementation GameScene

- (id)initWithSize:(CGSize)size gamePlay:(GamePlay *)gamePlay {
  if (self = [super initWithSize:size]) {
    _gamePlay = gamePlay;

    self.backgroundColor = [SKColor blackColor];
    [self addScoreLabel];
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

@end
