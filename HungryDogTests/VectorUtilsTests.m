//
//  VectorUtilsTests.m
//  VectorUtilsTests
//
//  Created by Yatin Sarbalia on 4/5/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VectorUtils.h"

@interface VectorUtilsTests : XCTestCase

@end

@implementation VectorUtilsTests

- (void)testItShouldReturnScalarSign {
  XCTAssertEqualObjects(@(ScalarSign(8)), @1);
  XCTAssertEqualObjects(@(ScalarSign(-8)), @(-1));
  XCTAssertEqualObjects(@(ScalarSign(0)), @1);
}

- (void)testItShouldReturnAdditionResult {
  CGPoint first = CGPointMake(1, 2);
  CGPoint second = CGPointMake(2, 3);
  CGPoint result = CGPointAdd(first, second);
  XCTAssertEqualObjects(@(result.x), @3, @"");
  XCTAssertEqualObjects(@(result.y), @5, @"");
}

- (void)testItShouldReturnSubtractionResult {
  CGPoint first = CGPointMake(1, 2);
  CGPoint second = CGPointMake(2, 3);
  CGPoint result = CGPointSubtract(second, first);
  XCTAssertEqualObjects(@(result.x), @1, @"");
  XCTAssertEqualObjects(@(result.y), @1, @"");
}

- (void)testItShouldReturnMutliplicationResult {
  CGPoint point = CGPointMake(1, 2);
  CGPoint result = CGPointMultiplyScalar(point, 3);
  XCTAssertEqualObjects(@(result.x), @3, @"");
  XCTAssertEqualObjects(@(result.y), @6, @"");
}

- (void)testItShouldReturnLengthResult {
  CGPoint point = CGPointMake(3, 4);
  CGFloat result = CGPointLength(point);
  XCTAssertEqualObjects(@(result), @5, @"");
}

- (void)testItShouldReturnNormalizationResult {
  CGPoint point = CGPointMake(3, 4);
  CGPoint result = CGPointNormalize(point);
  XCTAssertEqualObjects(@(result.x), @0.6, @"");
  XCTAssertEqualObjects(@(result.y), @0.8, @"");
}

- (void)testItShouldReturnAngleResult {
  CGPoint point = CGPointMake(3, 4);
  CGFloat result = CGPointToAngle(point);
  XCTAssertEqualObjects(@(result), @(atan2f(4, 3)), @"");
}

- (void)testItShouldReturnRandomRangeResult {
  CGFloat min = 10, max = 100;
  CGFloat result = ScalarRandomRange(min, max);
  XCTAssertTrue(result >= min, @"");
  XCTAssertTrue(result < max, @"");
}

- (void)testItShouldReturnShortestAngleResult {
  CGFloat first = 0;
  CGFloat second = 3.14/2;
  CGFloat result = ScalarShortestAngleBetween(first, second);
  XCTAssertTrue(fabsf(result - second) < 0.0000001, @"");
}

@end
