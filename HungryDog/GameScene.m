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
#import "SKAction+PowerAdditions.h"
#import "SKAction+HoleAdditions.h"
#import "SKAction+PoopAdditions.h"
#import "VectorUtils.h"
#import "ButtonNode.h"

@import AVFoundation;

const CGFloat EnergyBarStrokeWidth_iPhone = 1;
const CGFloat EnergyBarStrokeWidth_iPad = 3;

const NSTimeInterval BoneAppearanceTimeInterval = 10;
const NSTimeInterval PowerAppearanceTimeInterval = 15;
const NSTimeInterval PoopAppearanceTimeInterval = 15;

static NSString *const BoneName = @"Bone";
static NSString *const HoleName = @"Hole";
static NSString *const CatcherName = @"Catcher";

static NSString *const EnergyBoosterPowerName = @"EnergyBooster";
static NSString *const TimeStopperPowerName = @"TimeStopper";
static NSString *const InvisibilityCloakPowerName = @"InvisibilityCloak";

@interface GameScene () <ScoreHandlerDelegate,
EnergyBarHandlerDelegate,
BoneGeneratorDelegate,
PowerGeneratorDelegate,
StrategyMakerDelegate,
HoleGeneratorDelegate,
PoopGeneratorDelegate>

@property (nonatomic) SKLabelNode *scoreLabel;
@property (nonatomic) SKSpriteNode *dog;
@property (nonatomic) NSArray *catchers;

@property (nonatomic, readwrite) GamePlay *gamePlay;
@property (nonatomic) GameSceneSpritesProvider *spritesProvider;
@property (nonatomic) GameSceneSpritesOrganizer *spritesOrganizer;

@property (nonatomic) NSTimeInterval lastUpdateTime;
@property (nonatomic) NSTimeInterval dt;

@property (nonatomic) SKSpriteNode *energyBarSprite;
@property (nonatomic) BOOL shouldEndGame;

@property (nonatomic) AVAudioPlayer *backgroundMusicPlayer;
@property (nonatomic) BOOL isResumed;

@property (nonatomic) ButtonNode *pauseButton;
@property (nonatomic) BOOL isGamePaused;

@property (nonatomic) BOOL isDogInvisible;
@property (nonatomic) ButtonNode *poopButton;

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
    
    [self addPauseButton];
    [self addScoreLabelWithScore:_gamePlay.scoreHandler.currentScore];
    [self addEnergyBarWithStatus:_gamePlay.energyBarHandler.status];
    [self addBone];
    [self addDog];
    [self addPoopButton];
    
    _gamePlay.dogHandler.dog = _dog;
    [_gamePlay.strategyMaker setDelegate:self];
    [_gamePlay.powerGenerator setDelegate:self];
    [_gamePlay.holeGenerator setDelegate:self];
    [_gamePlay.poopGenerator setDelegate:self];
    self.userInteractionEnabled = YES;

    [self playBackgroundMusic:@"bgMusic.mp3"];
  }
  return self;
}

- (void)pauseScene:(BOOL)pause {
  if (pause == self.isGamePaused) {
    return;
  }
  [self __pauseScene:pause];
}

- (void)__pauseScene:(BOOL)pause {
  self.isGamePaused = pause;
  self.paused = pause;
  if (pause) {
    [self.backgroundMusicPlayer stop];
  } else {
    [self.backgroundMusicPlayer play];
    self.isResumed = YES;
  }
}

- (void)setIsGamePaused:(BOOL)isGamePaused {
  _isGamePaused = isGamePaused;
  [self addPauseButton];
}

- (void)pauseButtonTapped {
  [self __pauseScene:!self.isGamePaused];
}

- (void)setPauseButton:(ButtonNode *)pauseButton {
  [_pauseButton removeFromParent];
  _pauseButton = pauseButton;
}

#pragma mark - Sprites

- (void)addPauseButton {
  ButtonNode *node = [self.spritesProvider pauseButtonWithPausedState:self.isGamePaused];
  node.position = [self.spritesOrganizer positionForPauseButton];
  node.zPosition = -2;
  [node setTouchUpInsideTarget:self action:@selector(pauseButtonTapped)];
  [self addChild:node];
  self.pauseButton = node;
}

- (void)addScoreLabelWithScore:(NSUInteger)score {
  self.scoreLabel = [self.spritesProvider score];
  self.scoreLabel.text = [NSString stringWithScore:score];
  self.scoreLabel.position = [self.spritesOrganizer positionForScoreLabel:_scoreLabel];
  self.scoreLabel.zPosition = -2;
}

- (void)addEnergyBarWithStatus:(NSUInteger)status {
  CGFloat border = ValueForDevice(EnergyBarStrokeWidth_iPhone, EnergyBarStrokeWidth_iPad);
  self.energyBarSprite = [self.spritesProvider energyBarWithSize:[self.spritesOrganizer sizeForEnergyBar]
                                                          border:border
                                                          status:status];
  self.energyBarSprite.anchorPoint = CGPointZero;
  self.energyBarSprite.position = [self.spritesOrganizer positionForEnergyBar];
  self.energyBarSprite.zPosition = -2;
}

- (void)addBone {
  SKSpriteNode *node = [self.spritesProvider bone];
  node.position = [self.spritesOrganizer randomPositionForBoneAwayFromLocation:self.dog.position];
  node.name = BoneName;
  node.zPosition = -1;
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

- (void)setEnergyBarSprite:(SKSpriteNode *)energyBarSprite {
  SKSpriteNode *node = _energyBarSprite;
  _energyBarSprite = energyBarSprite;
  [node removeFromParent];
  [self addChild:_energyBarSprite];
}

- (void)addDog {
  SKSpriteNode *node = self.dog = [self.spritesProvider dog];
  node.position = [self.spritesOrganizer initialPositionForDog];
  [self addChild:node];
  [node runAction:[SKAction dogTextureAction]];
}

- (void)addCatcher {
  Catcher *node = [self.spritesProvider catcher];
  node.position = CGPointMake(0, 0);
  node.name = CatcherName;
  [node setScale:0.0];
  [self addChild:node];
  SKAction *action = [SKAction scaleTo:1.0 duration:1];
  [node runAction:action completion:^{
    [self.gamePlay.strategyMaker addCatcher:node];
  }];
}

- (void)checkCollisions {
  [self enumerateChildNodesWithName:BoneName usingBlock:^(SKNode *node, BOOL *stop){
    SKSpriteNode *bone = (SKSpriteNode *)node;
    if (CGPointLength(CGPointSubtract(bone.position, self.dog.position)) < 40) {
      [bone removeFromParent];
      [self.gamePlay.scoreHandler incrementScoreByValue:1];
      [self.gamePlay.energyBarHandler boost];
      [self generateBone];
      [self.gamePlay.poopGenerator intake];
    }
  }];
  
  [self enumerateChildNodesWithName:EnergyBoosterPowerName usingBlock:^(SKNode *node, BOOL *stop){
    SKSpriteNode *power = (SKSpriteNode *)node;
    if (CGPointLength(CGPointSubtract(power.position, self.dog.position)) < (power.size.width / 2)) {
      [power removeFromParent];
      [self.gamePlay.energyBarHandler boostToFull];
      [self showNotificationWithText:@"Energy boosted"];
    }
  }];
  
  [self enumerateChildNodesWithName:TimeStopperPowerName usingBlock:^(SKNode *node, BOOL *stop){
    SKSpriteNode *power = (SKSpriteNode *)node;
    if (CGPointLength(CGPointSubtract(power.position, self.dog.position)) < (power.size.width / 2)) {
      [power removeFromParent];
      [self.gamePlay.strategyMaker stopCatchersForInterval:10];
      [self showNotificationWithText:@"Time stopped"];
    }
  }];
  
  [self enumerateChildNodesWithName:InvisibilityCloakPowerName usingBlock:^(SKNode *node, BOOL *stop){
    SKSpriteNode *power = (SKSpriteNode *)node;
    if (CGPointLength(CGPointSubtract(power.position, self.dog.position)) < (power.size.width / 2)) {
      [power removeFromParent];
      [self setDogAsInvisible:@(YES)];
      [self showNotificationWithText:@"Invisible Now"];
    }
  }];

  [self enumerateChildNodesWithName:HoleName usingBlock:^(SKNode *node, BOOL *stop) {
    SKSpriteNode *hole = (SKSpriteNode *)node;
    if (CGPointLength(CGPointSubtract(hole.position, self.dog.position)) < 35) {
      self.shouldEndGame = YES;
    }
  }];
  if (self.shouldEndGame) {
    [self endGame];
  }

  if (!self.isDogInvisible) {
    [self enumerateChildNodesWithName:CatcherName usingBlock:^(SKNode *node, BOOL *stop) {
      SKSpriteNode *catcher = (SKSpriteNode *)node;
      if (CGPointLength(CGPointSubtract(catcher.position, self.dog.position)) < 40) {
        self.shouldEndGame = YES;
      }
    }];
    if (self.shouldEndGame) {
      [self endGame];
    }
  }
}

- (void)addHole {
  SKSpriteNode *node = [self.spritesProvider hole];
  node.name = HoleName;
  [node setScale:0.0];
  node.zPosition = -3;
  NSMutableArray *locations = [NSMutableArray array];
  [locations addObject:[NSValue valueWithCGPoint:self.dog.position]];
  [self enumerateChildNodesWithName:HoleName usingBlock:^(SKNode *node, BOOL *stop) {
    SKSpriteNode *hole = (SKSpriteNode *)node;
    [locations addObject:[NSValue valueWithCGPoint:hole.position]];
  }];
  node.position = [self.spritesOrganizer randomPositionForHoleAwayFromLocations:locations];
  [node runAction:[SKAction holeActionForTimeInterval:10] completion:^{
    [self.gamePlay.holeGenerator generateHole];
  }];
  [self addChild:node];
}

- (void)addPowerWithType:(PowerType)powerType {
  SKSpriteNode *node = [self.spritesProvider powerWithType:powerType];
  node.position = [self.spritesOrganizer randomPositionForPowerAwayFromLocation:self.dog.position];
  node.zPosition = -1;
  node.name = [self nodeNameForPowerType:powerType];
  [node setScale:0.0];
  [node runAction:[SKAction powerActionForTimeInterval:PowerAppearanceTimeInterval]];
  [self addChild:node];
}

- (NSString *)nodeNameForPowerType:(PowerType)powerType {
  switch (powerType) {
    case PowerTypeEnergyBooster:
      return EnergyBoosterPowerName;
      
    case PowerTypeTimeStopper:
      return TimeStopperPowerName;
      
    case PowerTypeInvisibiltyCloak:
      return InvisibilityCloakPowerName;
      
    default:
      break;
  }
  return nil;
}

- (void)addPoopButton {
  ButtonNode *node = self.poopButton = [[ButtonNode alloc] initWithImageNamedNormal:@"Poop-enable.png"
                                                                           selected:@"Poop-selected.png"
                                                                           disabled:@"Poop-disable.png"];
  node.size = CGSizeMake(44, 44);
  node.position = CGPointMake(self.size.width - 25, self.size.height - 80);
  node.isEnabled = NO;
  [node setTouchUpInsideTarget:self action:@selector(poopButtonTapped)];
  [self addChild:node];
}

- (void)poopButtonTapped {
  [self.gamePlay.poopGenerator poop];
}

- (void)addPoop {
  SKSpriteNode *node = [self.spritesProvider poop];
  node.position = self.dog.position;
  node.zPosition = -4;
  [node runAction:[SKAction poopActionForTimeInterval:PoopAppearanceTimeInterval]];
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

  if (!self.isPaused && !self.isResumed) {
    [self.gamePlay.energyBarHandler updateForTimeInterval:self.dt];
    [self.gamePlay.dogHandler updateForTimeInterval:self.dt];
    [self.gamePlay.strategyMaker updateForTimeInterval:self.dt];
    self.gamePlay.duration += self.dt;
  } else if (self.isResumed) {
    self.isResumed = NO;
  }
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
  NSUInteger status = energyBarHandler.status;
  [self addEnergyBarWithStatus:status];
  if (status == 0) {
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
  [self handleTouches:touches];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  [self handleTouches:touches];
}

- (void)handleTouches:(NSSet *)touches {
  if (!self.isGamePaused) {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self.scene];
    [self.gamePlay.dogHandler moveTowardsLocation:touchLocation];
  }
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

#pragma mark - Power

- (void)setDogAsInvisible:(NSNumber *)isInvisible {
  if ([isInvisible boolValue]) {
    self.isDogInvisible = YES;
    self.dog.alpha = 0.3;
    [self performSelector:@selector(toggleDogInvisibility:) withObject:@(1) afterDelay:8];
  } else {
    self.isDogInvisible = NO;
    self.dog.alpha = 1.0;
  }
}

- (void)toggleDogInvisibility:(NSNumber *)turn {
  if (self.dog.alpha < 1.0) {
    self.dog.alpha = 1.0;
  } else {
    self.dog.alpha = 0.3;
  }
  if ([turn intValue] < 10) {
    [self performSelector:@selector(toggleDogInvisibility:) withObject:@([turn intValue] + 1) afterDelay:0.5];
  } else {
    [self setDogAsInvisible:@(NO)];
  }
}

#pragma mark - PowerGeneratorDelegate

- (void)powerGenerator:(PowerGenerator *)powerGenerator
didGeneratePowerOfType:(PowerType)powerType {
  [self addPowerWithType:powerType];
}

#pragma mark - In-app notification

- (void)showNotificationWithText:(NSString *)text {
  SKLabelNode *node = [self.spritesProvider notificationWithText:text];
  node.position = [self.spritesOrganizer positionForNotification];
  SKAction *action = [SKAction scaleTo:0.0 duration:1.5];
  [node runAction:action];
  [self addChild:node];
}

#pragma mark - StrategyMakerDelegate

- (void)strategyMakerDidStopCatchers:(StrategyMaker *)strategyMaker {
  self.isDogInvisible = YES;
}

- (void)strategyMakerDidStartCatchers:(StrategyMaker *)strategyMaker {
  self.isDogInvisible = NO;
}

- (void)strategyMakerDidGenerateCatcher:(StrategyMaker *)strategyMaker {
  [self addCatcher];
}

- (CGSize)screenSizeForStrategyMaker:(StrategyMaker *)strategyMaker {
  return self.size;
}

- (CGPoint)dogPositionForStrategyMaker:(StrategyMaker *)strategyMaker {
  return self.dog.position;
}

#pragma mark - HoleGeneratorDelegate

- (void)holeGeneratorDidGenerateHole:(HoleGenerator *)holeGenerator {
  [self addHole];
}

#pragma mark - PoopGeneratorDelegate

- (void)poopGeneratorShouldEnablePoop:(PoopGenerator *)poopGenerator {
  self.poopButton.isEnabled = YES;
}

- (void)poopGeneratorShouldDisablePoop:(PoopGenerator *)poopGenerator {
  self.poopButton.isEnabled = NO;
}

- (void)poopGeneratorDidPoop:(PoopGenerator *)poopGenerator {
  [self showNotificationWithText:@"POOP"];
  [self addPoop];
}

@end
