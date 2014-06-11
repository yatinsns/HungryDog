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
#import "BackgroundMusicPlayer.h"
#import "BoneManager.h"
#import "SoundController.h"

const CGFloat NameLabelFontSize_iPhone = 30;
const CGFloat NameLabelFontSize_iPad = 80;

const CGFloat PlayLabelCenterOffsetY_iPhone = 30;
const CGFloat PlayLabelCenterOffsetY_iPad = 80;
const CGFloat PlayLabelFontSize_iPhone = 15;
const CGFloat PlayLabelFontSize_iPad = 40;

const CGFloat DogSizeWidth_iPhone = 157;
const CGFloat DogSizeWidth_iPad = 294;
const CGFloat DogSizeHeight_iPhone = 160;
const CGFloat DogSizeHeight_iPad = 300;
const CGFloat DogOriginX = 10;
const CGFloat DogOriginY = 10;

NSString *const PlayName = @"Play";
NSString *const BuyBonesName = @"BuyBonesName";
NSString *const SoundName = @"SoundName";

@interface MainScene ()

@property (nonatomic) SKLabelNode *nameLabel;
@property (nonatomic) SKLabelNode *playLabel;

@end

@implementation MainScene

- (id)initWithSize:(CGSize)size {
  return [self initWithSize:size suffix:nil];
}

- (id)initWithSize:(CGSize)size lastScore:(NSUInteger)lastScore {
  return [self initWithSize:size suffix:[NSString stringWithFormat:@"%ld", lastScore]];
}

- (id)initWithSize:(CGSize)size suffix:(NSString *)suffix {
  if (self = [super initWithSize:size]) {
    SKSpriteNode *backgroundNode = [SKSpriteNode spriteNodeWithImageNamed:@"Menu-background.png"];
    backgroundNode.size = CGSizeMake(568, 320);
    backgroundNode.position = CGPointZero;
    backgroundNode.anchorPoint = CGPointZero;
    [self addChild:backgroundNode];

    [self addNameLabel];
    [self addPlayLabelWithSuffix:suffix];
    [self addDog];
    [self addTotalBonesLabel];
    [self addBuyBonesLabel];
    [self addSoundLabel];
    self.userInteractionEnabled = YES;
    [[BackgroundMusicPlayer sharedPlayer] playBackgroundMusic:@"menuMusic.mp3"];
  }
  return self;
}

- (void)willMoveFromView:(SKView *)view {
  [self.children enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    SKNode* child = obj;
    [child removeAllActions];
  }];
  [self removeAllChildren];
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

- (void)addPlayLabelWithSuffix:(NSString *)suffix {
  CGFloat fontSize = ValueForDevice(PlayLabelFontSize_iPhone, PlayLabelFontSize_iPad);
  _playLabel = [SKLabelNode labelNodeWithFontNamed:AppFontName
                                          fontSize:fontSize
                                         fontColor:[SKColor greenColor]];
  NSString *text = PlayName;
  if (suffix) {
    text = [text stringByAppendingString:[NSString stringWithFormat:@" (Last score: %@)", suffix]];
  }
  _playLabel.text = text;
  _playLabel.name = PlayName;
  CGFloat centerOffsetY = ValueForDevice(PlayLabelCenterOffsetY_iPhone, PlayLabelCenterOffsetY_iPad);
  _playLabel.position = CGPointMake(self.nameLabel.position.x,
                                    self.nameLabel.position.y - centerOffsetY);
  _playLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
  [self addChild:_playLabel];
}

- (void)addTotalBonesLabel {
  CGFloat fontSize = ValueForDevice(PlayLabelFontSize_iPhone, PlayLabelFontSize_iPad);
  SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:AppFontName
                                                  fontSize:fontSize
                                                 fontColor:[SKColor yellowColor]];
  NSString *text = [NSString stringWithFormat:@"Total bones: %@", @([[BoneManager sharedManager] currentNumberOfBones])];
  label.text = text;
  label.position = CGPointMake(self.nameLabel.position.x,
                               fontSize);
  label.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
  [self addChild:label];
}

- (void)addBuyBonesLabel {
  CGFloat fontSize = ValueForDevice(PlayLabelFontSize_iPhone, PlayLabelFontSize_iPad);
  SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:AppFontName
                                                  fontSize:fontSize
                                                 fontColor:[SKColor yellowColor]];
  label.text = @"Buy bones";
  label.name = BuyBonesName;
  label.position = CGPointMake(self.size.width,
                               fontSize);
  label.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
  label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
  [self addChild:label];
}

- (void)addSoundLabel {
  CGFloat fontSize = ValueForDevice(PlayLabelFontSize_iPhone, PlayLabelFontSize_iPad);
  SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:AppFontName
                                                  fontSize:fontSize
                                                 fontColor:[SKColor yellowColor]];
  NSString *text = @"Sound";
  if ([[SoundController sharedController] isMuted]) {
    text = [text stringByAppendingString:@" Off"];
  } else {
    text = [text stringByAppendingString:@" On"];
  }
  label.text = text;
  label.name = SoundName;
  label.position = CGPointMake(self.size.width,
                               self.size.height - fontSize);
  label.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
  label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
  [self addChild:label];
}

- (void)addDog {
  SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"HungryDog1.png"];
  node.anchorPoint = CGPointZero;
  node.size = CGSizeMake(ValueForDevice(DogSizeWidth_iPhone, DogSizeWidth_iPad),
                         ValueForDevice(DogSizeHeight_iPhone, DogSizeHeight_iPad));
  node.position = CGPointMake(DogOriginX, DogOriginY);
  [self addChild:node];
}

#pragma mark - Touch events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];
  CGPoint touchLocation = [touch locationInNode:self.scene];
  SKNode *node = [self nodeAtPoint:touchLocation];
  if ([node.name isEqualToString:PlayName]) {
    [self handlePlayAction];
  } else if ([node.name isEqualToString:BuyBonesName]) {
    [self handleBuyBones];
  }
}

#pragma mark - User actions

- (void)handlePlayAction {
  [self.delegate mainSceneDidSelectPlayOption:self];
}

- (void)handleBuyBones {
  [self.delegate mainSceneDidSelectBuyBonesOption:self];
}

@end
