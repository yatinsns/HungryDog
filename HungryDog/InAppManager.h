//
//  InAppManager.h
//  HungryDog
//
//  Created by Yatin on 16/05/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "InAppPurchaseProductsInformationProvider.h"

@protocol InAppManagerDelegate;

@interface InAppManager : NSObject

@property (nonatomic) id<InAppManagerDelegate> delegate;

+ (InAppManager *)sharedManager;

- (void)buyProduct:(InAppPurchaseProduct)product;
- (void)provideProduct:(InAppPurchaseProduct)product;

- (void)failedTransaction:(SKPaymentTransaction *)transaction;
- (void)restoreCompletedTransactions;

@end

@protocol InAppManagerDelegate <NSObject>

- (void)inAppManager:(InAppManager *)inAppManager didProvideProduct:(InAppPurchaseProduct)product;

@end
