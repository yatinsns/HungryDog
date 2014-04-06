//
//  VectorUtils.m
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/6/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import "VectorUtils.h"

#define ARC4RANDOM_MAX 0x100000000

#pragma mark - Scalar functions

CGFloat ScalarSign(CGFloat a) {
  return a >= 0 ? 1 : -1;
}

CGFloat ScalarShortestAngleBetween(const CGFloat a, const CGFloat b) {
  CGFloat difference = b - a;
  CGFloat angle = fmodf(difference, M_PI * 2);
  if (angle >= M_PI) {
    angle -= M_PI * 2;
  }
  return angle;
}

#pragma mark - Vector functions

CGPoint CGPointAdd(const CGPoint a, const CGPoint b) {
  return CGPointMake(a.x + b.x, a.y + b.y);
}

CGPoint CGPointSubtract(const CGPoint a, const CGPoint b) {
  return CGPointMake(a.x - b.x, a.y - b.y);
}

CGPoint CGPointMultiplyScalar(const CGPoint a, const CGFloat b) {
  return CGPointMake(a.x * b, a.y * b);
}

CGFloat CGPointLength(const CGPoint a) {
  return sqrtf(a.x * a.x + a.y * a.y);
}

CGPoint CGPointNormalize(const CGPoint a) {
  CGFloat length = CGPointLength(a);
  return CGPointMake(a.x / length, a.y / length);
}

CGFloat CGPointToAngle(const CGPoint a) {
  return atan2f(a.y, a.x);
}

#pragma mark - Miscellaneous functions

CGFloat ScalarRandomRange(CGFloat min, CGFloat max) {
  return floorf(((double)arc4random() / ARC4RANDOM_MAX) * (max - min) + min);
}