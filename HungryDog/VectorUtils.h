//
//  VectorUtils.h
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/6/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import <Foundation/Foundation.h>

CGFloat ScalarSign(CGFloat a);

/**
 Returns shortest angle between two angles, between -M_PI and M_PI.
 */
CGFloat ScalarShortestAngleBetween(const CGFloat a, const CGFloat b);

CGPoint CGPointAdd(const CGPoint a, const CGPoint b);

CGPoint CGPointSubtract(const CGPoint a, const CGPoint b);

CGPoint CGPointMultiplyScalar(const CGPoint a, const CGFloat b);

CGFloat CGPointLength(const CGPoint a);

CGPoint CGPointNormalize(const CGPoint a);

CGFloat CGPointToAngle(const CGPoint a);

CGFloat ScalarRandomRange(CGFloat min, CGFloat max);

