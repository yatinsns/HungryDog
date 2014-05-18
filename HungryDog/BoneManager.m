//
//  BoneManager.m
//  HungryDog
//
//  Created by Yatin on 19/05/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import "BoneManager.h"

static NSString *const NSUserDefaultsBonesKey = @"NSUserDefaultsBonesKey";

@interface BoneManager ()

@property (nonatomic, readwrite) NSUInteger currentNumberOfBones;

@end

@implementation BoneManager

@synthesize currentNumberOfBones = _currentNumberOfBones;

+ (BoneManager *)sharedManager {
  static BoneManager *boneManager;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    boneManager = [[BoneManager alloc] init];
  });
  return boneManager;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _currentNumberOfBones = 0;
  }
  return self;
}

- (NSUInteger)currentNumberOfBones {
  if (_currentNumberOfBones == 0) {
    _currentNumberOfBones = [[NSUserDefaults standardUserDefaults] integerForKey:NSUserDefaultsBonesKey];
  }
  return _currentNumberOfBones;
}

- (void)setCurrentNumberOfBones:(NSUInteger)currentNumberOfBones {
  _currentNumberOfBones = currentNumberOfBones;
  [[NSUserDefaults standardUserDefaults] setInteger:_currentNumberOfBones forKey:NSUserDefaultsBonesKey];
}

- (void)boostByNumberOfBones:(NSUInteger)numberOfBones {
  self.currentNumberOfBones += numberOfBones;
}

@end
