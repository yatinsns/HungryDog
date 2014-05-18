//
//  InAppObserver.h
//  HungryDog
//
//  Created by Yatin on 16/05/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

/**
 This class observes in app purchases.
 */
@interface InAppObserver : NSObject <SKPaymentTransactionObserver>

@end
