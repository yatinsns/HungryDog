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
#import "SKAction+CatcherAdditions.h"
#import "VectorUtils.h"

@import AVFoundation;

const CGFloat EnergyBarStrokeWidth_iPhone = 1;
const CGFloat EnergyBarStrokeWidth_iPad = 3;

const NSTimeInterval BoneAppearanceTimeInterval = 10;

static NSString *const BoneName = @"Bone";
static NSString *const HoleName = @"Hole";
static NSString *const TunnelName1 = @"Tunnel1";
static NSString *const TunnelName2 = @"Tunnel2";
static NSString *const CatcherName = @"Catcher";

@interface GameScene () <ScoreHandlerDelegate, EnergyBarHandlerDelegate, BoneGeneratorDelegate>

@property (nonatomic) SKLabelNode *scoreLabel;
@property (nonatomic) SKSpriteNode *dog;
@property (nonatomic) NSArray *catchers;

@property (nonatomic, readwrite) GamePlay *gamePlay;
@property (nonatomic) GameSceneSpritesProvider *spritesProvider;
@property (nonatomic) GameSceneSpritesOrganizer *spritesOrganizer;

@property (nonatomic) NSTimeInterval lastUpdateTime;
@property (nonatomic) NSTimeInterval dt;

@property (nonatomic) SKSpriteNode *eneryBarSprite;
@property (nonatomic) BOOL shouldEndGame;

@property (nonatomic) SKSpriteNode *tunnel1;
@property (nonatomic) SKSpriteNode *tunnel2;

@property (nonatomic) AVAudioPlayer *backgroundMusicPlayer;

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
    [self addTunnel];
    [self addCatchers];
    
    _gamePlay.dogHandler.dog = _dog;
    [_gamePlay.strategyMaker setCatchers:_catchers withSize:self.size];
    self.userInteractionEnabled = YES;

    [self playBackgroundMusic:@"bgMusic.mp3"];
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

- (void)addCatchers {
  NSMutableArray *array = [NSMutableArray array];
  for (int i = 0; i < 4; i++) {
    SKSpriteNode *node = [self.spritesProvider catcher];
    if (i == 0) {
    node.position = CGPointMake(0, 0);
    } else if (i == 1) {
      node.position = CGPointMake(self.size.width, 0);
    } else if (i == 2) {
      node.position = CGPointMake(0, self.size.height);
    } else {
      node.position = CGPointMake(self.size.width, self.size.height);
    }

    node.name = CatcherName;
    [self addChild:node];
    [node runAction:[SKAction catcherTextureAction]];
    [array addObject:node];
  }
  _catchers = array;
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

  [self enumerateChildNodesWithName:CatcherName usingBlock:^(SKNode *node, BOOL *stop) {
    SKSpriteNode *catcher = (SKSpriteNode *)node;
    if (CGPointLength(CGPointSubtract(catcher.position, self.dog.position)) < 40) {
      self.shouldEndGame = YES;
    }
  }];
  if (self.shouldEndGame) {
    [self endGame];
  }

  [self enumerateChildNodesWithName:TunnelName1 usingBlock:^(SKNode *node, BOOL *stop) {
    SKSpriteNode *tunnel = (SKSpriteNode *)node;
    if (CGPointLength(CGPointSubtract(tunnel.position, self.dog.position)) < 40) {
      [self moveDogToPosition:self.tunnel2.position];
    }
  }];

  [self enumerateChildNodesWithName:TunnelName2 usingBlock:^(SKNode *node, BOOL *stop) {
    SKSpriteNode *tunnel = (SKSpriteNode *)node;
    if (CGPointLength(CGPointSubtract(tunnel.position, self.dog.position)) < 40) {
      [self moveDogToPosition:self.tunnel1.position];
    }
  }];
}

- (void)addHole {
  SKSpriteNode *node = [self.spritesProvider hole];
  node.name = HoleName;
  node.position = [self.spritesOrganizer positionForHole];
  node.zPosition = -1;
  [self addChild:node];
}

- (void)addTunnel {
  SKSpriteNode *node1 = self.tunnel1 = [self.spritesProvider tunnel];
  node1.name = TunnelName1;
  node1.position = CGPointMake(node1.size.width / 2, node1.size.height / 2);
  node1.zPosition = -1;
  [self addChild:node1];

  SKSpriteNode *node2 = self.tunnel2 = [self.spritesProvider tunnel];
  node2.name = TunnelName2;
  node2.position = CGPointMake(node2.size.width / 2, self.size.height - node2.size.height);
  node2.zPosition = -1;
  [self addChild:node2];
}

- (void)moveDogToPosition:(CGPoint)position {
  [self.gamePlay.dogHandler stop];
  position.x += 50;
  self.dog.position = position;
}

#pragma mark - Overridden methods

- (void)update:(NSTimeInterval)currentTime {
  if (self.lastUpdateTime) {
    self.dt = currentTime - self.lastUpdateTime;
  } else {
    self.dt = 0;
  }
  self.lastUpdateTime = currentTime;

  [self.gamePlay.energyBarHandler updateForTimeInterval:self.dt];
  [self.gamePlay.dogHandler updateForTimeInterval:self.dt];

  [self.gamePlay.strategyMaker updateDogLocation:self.dog.position
                                            size:self.size];
  [self.gamePlay.strategyMaker updateForTimeInterval:self.dt];
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

#pragma mark - Music

- (void)playBackgroundMusic:(NSString *)filename {
  NSError *error;
  NSURL *backgroundMusicURL =
  [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
  _backgroundMusicPlayer = [[AVAudioPlayer alloc]
                            initWithContentsOfURL:backgroundMusicURL error:&error];
  _backgroundMusicPlayer.numberOfLoops = -1;
  [_backgroundMusicPlayer prepareToPlay];
  [_backgroundMusicPlayer play];
}

@end
