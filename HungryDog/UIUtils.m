//
//  UIUtils.m
//  HungryDog
//
//  Created by Yatin Sarbalia on 4/6/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import "UIUtils.h"

CGFloat ValueForDevice(CGFloat iphoneValue, CGFloat iPadValue) {
  return  UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? iphoneValue : iPadValue;
}
