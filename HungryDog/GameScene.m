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
#import "GameSceneSpritesOrganizer.h"
#import "SKAction+BoneAdditions.h"
#import "SKAction+DogAdditions.h"
#import "VectorUtils.h"

const CGFloat EnergyBarStrokeWidth_iPhone = 1;
const CGFloat EnergyBarStrokeWidth_iPad = 3;

const NSTimeInterval BoneAppearanceTimeInterval = 10;

static NSString *const BoneName = @"Bone";
static NSString *const HoleName = @"Hole";

@interface GameScene () <ScoreHandlerDelegate, EnergyBarHandlerDelegate, BoneGeneratorDelegate>

@property (nonatomic) SKLabelNode *scoreLabel;
@property (nonatomic) SKSpriteNode *dog;

@property (nonatomic, readwrite) GamePlay *gamePlay;
@property (nonatomic) GameSceneSpritesProvider *spritesProvider;
@property (nonatomic) GameSceneSpritesOrganizer *spritesOrganizer;

@property (nonatomic) NSTimeInterval lastUpdateTime;
@property (nonatomic) NSTimeInterval dt;

@property (nonatomic) SKSpriteNode *eneryBarSprite;
@property (nonatomic) BOOL shouldEndGame;

@end

@implementation GameScene

- (id)initWithSize:(CGSize)size gamePlay:(GamePlay *)gamePlay {
  if (self = [super initWithSize:size]) {
    _gamePlay = gamePlay;
    _gamePlay.scoreHandler.delegate = self;
    _gamePlay.energyBarHandler.delegate = self;
    _gamePlay.boneGenerator.delegate = self;

    self.backgroundColor = [SKColor blackColor];
    _spritesProvider = [[GameSceneSpritesProvider alloc] init];
    _spritesOrganizer = [[GameSceneSpritesOrganizer alloc] initWithSize:size];
    
    [self addScoreLabelWithScore:_gamePlay.scoreHandler.currentScore];
    [self addEnergyBarWithStatus:_gamePlay.energyBarHandler.status];
    [self addBone];
    [self addDog];
    [self addHole];
    
    _gamePlay.dogHandler.dog = _dog;
    self.userInteractionEnabled = YES;
  }
  return self;
}

#pragma mark - Sprites

- (void)addScoreLabelWithScore:(NSUInteger)score {
  self.scoreLabel = [self.spritesProvider score];
  self.scoreLabel.text = [NSString stringWithScore:score];
  self.scoreLabel.position = [self.spritesOrganizer positionForScoreLabel:_scoreLabel];
  self.scoreLabel.zPosition = -1;
}

- (void)addEnergyBarWithStatus:(NSUInteger)status {
  CGFloat border = ValueForDevice(EnergyBarStrokeWidth_iPhone, EnergyBarStrokeWidth_iPad);
  self.eneryBarSprite = [self.spritesProvider energyBarWithSize:[self.spritesOrganizer sizeForEnergyBar]
                                                         border:border
                                                         status:status];
  self.eneryBarSprite.anchorPoint = CGPointZero;
  self.eneryBarSprite.position = [self.spritesOrganizer positionForEnergyBar];
  self.eneryBarSprite.zPosition = -1;
}

- (void)addBone {
  SKSpriteNode *node = [self.spritesProvider bone];
  node.position = [self.spritesOrganizer randomPositionForBoneAwayFromLocation:self.dog.position];
  node.name = BoneName;
  [self addChild:node];
  __block typeof (self) weakSelf = self;
  [node runAction:[SKAction boneActionForTimeInterval:BoneAppearanceTimeInterval] completion:^{
    [weakSelf generateBone];
  }];
}

- (void)setScoreLabel:(SKLabelNode *)scoreLabel {
  [_scoreLabel removeFromParent];
  _scoreLabel = scoreLabel;
  [self addChild:_scoreLabel];
}

- (void)setEneryBarSprite:(SKSpriteNode *)eneryBarSprite {
  [_eneryBarSprite removeFromParent];
  _eneryBarSprite = eneryBarSprite;
  [self addChild:_eneryBarSprite];
}

- (void)addDog {
  SKSpriteNode *node = self.dog = [self.spritesProvider dog];
  node.position = [self.spritesOrganizer initialPositionForDog];
  [self addChild:node];
  [node runAction:[SKAction dogTextureAction]];
}

- (void)checkCollisions {
  [self enumerateChildNodesWithName:BoneName usingBlock:^(SKNode *node, BOOL *stop){
    SKSpriteNode *bone = (SKSpriteNode *)node;
    if (CGRectIntersectsRect(bone.frame, self.dog.frame)) {
      [bone removeFromParent];
      [self.gamePlay.scoreHandler incrementScoreByValue:1];
      [self.gamePlay.energyBarHandler boost];
      [self generateBone];
    }
  }];

  [self enumerateChildNodesWithName:HoleName usingBlock:^(SKNode *node, BOOL *stop) {
    SKSpriteNode *hole = (SKSpriteNode *)node;
    if (CGPointLength(CGPointSubtract(hole.position, self.dog.position)) < 40) {
      self.shouldEndGame = YES;
    }
  }];
  if (self.shouldEndGame) {
    [self endGame];
  }
}

- (void)addHole {
  SKSpriteNode *node = [self.spritesProvider hole];
  node.name = HoleName;
  node.position = [self.spritesOrganizer positionForHole];
  node.zPosition = -1;
  [self addChild:node];
}

#pragma mark - Overridden methods

- (void)update:(NSTimeInterval)currentTime {
  if (self.lastUpdateTime) {
    self.dt = currentTime - self.lastUpdateTime;
  } else {
    self.dt = 0;
  }
  self.lastUpdateTime = currentTime;

  [self.gamePlay.energyBarHandler update:currentTime];
  [self.gamePlay.dogHandler update:currentTime];  
}

- (void)willMoveFromView:(SKView *)view {
  [self.children enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    SKNode* child = obj;
    [child removeAllActions];
  }];
  [self removeAllChildren];
}

- (void)didEvaluateActions {
  if (!self.shouldEndGame) {
    [self checkCollisions];
  }
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

- (void)generateBone {
  [self.gamePlay.boneGenerator generateBone];
}

#pragma mark - BoneGeneratorDelegate

- (void)boneGeneratorDidGenerateNewBone:(BoneGenerator *)boneGenerator {
  [self addBone];
}

#pragma mark - ScoreHandlerDelegate

- (void)scoreHandlerDidUpdateScore:(ScoreHandler *)scoreHandler {
  [self addScoreLabelWithScore:scoreHandler.currentScore];
}

#pragma mark - Gestures

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self handleTouches:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  [self handleTouches:touches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  [self cancelTouches];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  [self cancelTouches];
}

- (void)handleTouches:(NSSet *)touches {
  UITouch *touch = [touches anyObject];
  CGPoint touchLocation = [touch locationInNode:self.scene];
  [self.gamePlay.dogHandler moveTowardsLocation:touchLocation];
}

- (void)cancelTouches {
  [self.gamePlay.dogHandler stop];
}

@end
