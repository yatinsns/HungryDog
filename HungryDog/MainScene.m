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
#import "BoneManager.h"
#import "SoundController.h"
#import "ButtonNode.h"
#import "SoundController.h"

static const CGFloat BonesLabelFontSize_iPhone = 20;
static const CGFloat BonesLabelFontSize_iPad = 40;

static NSString *const CreditsLabelName = @"Credits";

@interface MainScene ()

@property (nonatomic) SKLabelNode *nameLabel;
@property (nonatomic) SKLabelNode *playLabel;
@property (nonatomic) ButtonNode *soundButton;

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
    self.userInteractionEnabled = YES;

    SKSpriteNode *backgroundNode = [SKSpriteNode spriteNodeWithImageNamed:@"Menu-background.png"];
    backgroundNode.size = CGSizeMake(1336 / 2, 753 / 2);;
    backgroundNode.position = CGPointZero;
    backgroundNode.anchorPoint = CGPointZero;
    backgroundNode.zPosition = -1;
    [self addChild:backgroundNode];

    SKAction *move = [SKAction moveByX:-50 y:0 duration:10];
    SKAction *reverseMove = [move reversedAction];
    [backgroundNode runAction:[SKAction repeatActionForever:[SKAction sequence:@[move, reverseMove]]]];

    [self addLogo];
    [self addGrass];
    [self addPlayButton];
    [self addStoreButton];
    [self addCreditsLabel];
    [self addSoundButton];
    [[SoundController sharedController] playBackgroundMusic:@"menuMusic.mp3"];
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

- (void)addPlayButton {
  ButtonNode *node = [[ButtonNode alloc] initWithImageNamedNormal:@"Play-normal" selected:@"Play-pressed"];

  // FIXME : For iPad
  node.size = CGSizeMake(180, 54);
  node.position = CGPointMake(284, 19 + 54 + 19 + 27);

  [node setTouchUpInsideTarget:self action:@selector(playButtonTapped)];
  [self addChild:node];
  
  [node runAction:[self playButtonAction]];
}

- (SKAction *)playButtonAction {
  SKAction *appear = [SKAction scaleTo:1.0 duration:0.5];
  SKAction *wait = [SKAction sequence:@[[self animatedAction], [SKAction waitForDuration:1]]];
  return [SKAction sequence:@[appear, [SKAction repeatActionForever:wait]]];
}

- (SKAction *)animatedAction {
  SKAction *scaleUp = [SKAction scaleTo:1.05 duration:0.50];
  SKAction *scaleDown = [SKAction scaleTo:1.0 duration:0.25];
  return [SKAction sequence:@[scaleUp, scaleDown, scaleUp, scaleDown]];
}

- (void)playButtonTapped {
  [self handlePlayAction];
}

- (void)addStoreButton {
  ButtonNode *node = [[ButtonNode alloc] initWithImageNamedNormal:@"Store-normal"
                                                         selected:@"Store-pressed"];
  
  // FIXME : For iPad
  node.size = CGSizeMake(180, 54);
  node.position = CGPointMake(284, 19 + 27);

  [node setTouchUpInsideTarget:self action:@selector(storeButtonTapped)];
  [self addChild:node];
}

- (void)storeButtonTapped {
  [self handleBuyBones];
}

- (void)addCreditsLabel {
  CGFloat fontSize = ValueForDevice(BonesLabelFontSize_iPhone, BonesLabelFontSize_iPad);
  SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"ProximaNova-Black"
                                                  fontSize:fontSize
                                                 fontColor:[SKColor whiteColor]];
  label.text = @"Credits";
  label.name = CreditsLabelName;
  label.position = CGPointMake(self.size.width - 10, 19);
  label.verticalAlignmentMode = SKLabelVerticalAlignmentModeBaseline;
  label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
  [self addChild:label];
}

- (void)addLogo {
  SKSpriteNode *logo = [SKSpriteNode spriteNodeWithImageNamed:@"Game-logo.png"];
  logo.size = CGSizeMake(138, 138);
  logo.position = CGPointMake(self.size.width / 2,
                              self.size.height - (138 / 2) - 19);
  [self addChild:logo];
}

- (void)addGrass {
  SKSpriteNode *grass = [SKSpriteNode spriteNodeWithImageNamed:@"Menu-grass.png"];
  grass.size = CGSizeMake(1536 / 2, 865 / 2);
  grass.position = CGPointZero;
  grass.anchorPoint = CGPointZero;
  [self addChild:grass];

  SKAction *move = [SKAction moveByX:-200 y:0 duration:10];
  SKAction *reverseMove = [move reversedAction];
  [grass runAction:[SKAction repeatActionForever:[SKAction sequence:@[move, reverseMove]]]];
}

- (void)addSoundButton {
  BOOL isMuted = [[SoundController sharedController] isMuted];
  NSString *imageNormalName = @"Menu-sound-on";
  NSString *imageSelectedName = @"Menu-sound-on-pressed";
  if (isMuted) {
    imageNormalName = @"Menu-sound-off";
    imageSelectedName = @"Menu-sound-off-pressed";
  }
  ButtonNode *node = [[ButtonNode alloc] initWithImageNamedNormal:imageNormalName
                                                         selected:imageSelectedName];

  // FIXME : For iPad
  node.size = CGSizeMake(44, 44);
  node.anchorPoint = CGPointZero;
  node.position = CGPointMake(19, 19);

  [node setTouchUpInsideTarget:self action:@selector(soundButtonTapped)];
  self.soundButton = node;
}

- (void)soundButtonTapped {
  [SoundController sharedController].muted = ![[SoundController sharedController] isMuted];
  [self addSoundButton];
}

- (void)setSoundButton:(ButtonNode *)soundButton {
  [_soundButton removeFromParent];
  _soundButton = soundButton;
  [self addChild:_soundButton];
}

#pragma mark - User actions

- (void)handlePlayAction {
  [self.delegate mainSceneDidSelectPlayOption:self];
}

- (void)handleBuyBones {
  [self.delegate mainSceneDidSelectBuyBonesOption:self];
}

#pragma mark - Effects

- (CIFilter *)blurFilter {
  CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
  [filter setDefaults];
  [filter setValue:[NSNumber numberWithFloat:15] forKey:@"inputRadius"];
  return filter;
}

- (void)addBlur {
  self.filter = [self blurFilter];
  self.shouldEnableEffects = YES;
}

- (void)removeBlur {
  self.shouldEnableEffects = NO;
  self.filter = nil;
}

#pragma mark - Touches Handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  if (self.filter != nil) {
    [self removeBlur];
    return;
  }

  UITouch *touch = [touches anyObject];
  CGPoint location = [touch locationInNode:self];
  SKNode *node = [self nodeAtPoint:location];

  if ([node.name isEqualToString:CreditsLabelName]) {
    [self addBlur];
  }
}

@end
