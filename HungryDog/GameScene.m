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

const CGFloat EnergyBarStrokeWidth_iPhone = 1;
const CGFloat EnergyBarStrokeWidth_iPad = 3;

const NSTimeInterval BoneAppearanceTimeInterval = 10;

@interface GameScene () <EnergyBarHandlerDelegate, BoneGeneratorDelegate>

@property (nonatomic) SKLabelNode *scoreLabel;
@property (nonatomic) SKSpriteNode *dog;

@property (nonatomic, readwrite) GamePlay *gamePlay;
@property (nonatomic) GameSceneSpritesProvider *spritesProvider;
@property (nonatomic) GameSceneSpritesOrganizer *spritesOrganizer;

@property (nonatomic) NSTimeInterval lastUpdateTime;
@property (nonatomic) NSTimeInterval dt;

@property (nonatomic) SKSpriteNode *eneryBarSprite;

@end

@implementation GameScene

- (id)initWithSize:(CGSize)size gamePlay:(GamePlay *)gamePlay {
  if (self = [super initWithSize:size]) {
    _gamePlay = gamePlay;
    _gamePlay.energyBarHandler.delegate = self;
    _gamePlay.boneGenerator.delegate = self;

    self.backgroundColor = [SKColor blackColor];
    _spritesProvider = [[GameSceneSpritesProvider alloc] init];
    _spritesOrganizer = [[GameSceneSpritesOrganizer alloc] initWithSize:size];
    
    [self addScoreLabel];
    [self addEnergyBarWithStatus:_gamePlay.energyBarHandler.status];
    [self addBone];
    [self addDog];
    
    _gamePlay.dogHandler.dog = _dog;
    self.userInteractionEnabled = YES;
  }
  return self;
}

#pragma mark - Sprites

- (void)addScoreLabel {
  _scoreLabel = [self.spritesProvider score];
  _scoreLabel.text = [NSString stringWithScore:self.gamePlay.scoreHandler.currentScore];
  _scoreLabel.position = [self.spritesOrganizer positionForScoreLabel:_scoreLabel];
  [self addChild:_scoreLabel];
}

- (void)addEnergyBarWithStatus:(NSUInteger)status {
  CGFloat border = ValueForDevice(EnergyBarStrokeWidth_iPhone, EnergyBarStrokeWidth_iPad);
  self.eneryBarSprite = [self.spritesProvider energyBarWithSize:[self.spritesOrganizer sizeForEnergyBar]
                                                         border:border
                                                         status:status];
  self.eneryBarSprite.anchorPoint = CGPointZero;
  self.eneryBarSprite.position = [self.spritesOrganizer positionForEnergyBar];
}

- (void)addBone {
  SKSpriteNode *node = [self.spritesProvider bone];
  node.position = [self.spritesOrganizer randomPositionForBone];
  [self addChild:node];
  __block typeof (self) weakSelf = self;
  [node runAction:[SKAction boneActionForTimeInterval:BoneAppearanceTimeInterval] completion:^{
    [weakSelf generateBone];
  }];
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

#pragma mark - Gestures

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self handleTouches:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  [self handleTouches:touches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  [self handleTouches:touches];
}

- (void)handleTouches:(NSSet *)touches {
  UITouch *touch = [touches anyObject];
  CGPoint touchLocation = [touch locationInNode:self.scene];
  [self.gamePlay.dogHandler moveTowardsLocation:touchLocation];
}

@end
