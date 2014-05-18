//
//  InAppObserver.m
//  HungryDog
//
//  Created by Yatin on 16/05/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import "InAppObserver.h"
#import "InAppManager.h"
#import "InAppPurchaseProductsInformationProvider.h"

@implementation InAppObserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
  for (SKPaymentTransaction *transaction in transactions) {
    switch (transaction.transactionState) {
      case SKPaymentTransactionStatePurchased:
        [self completeTransaction:transaction];
        break;
        
      case SKPaymentTransactionStateFailed:
        [self failedTransaction:transaction];
        break;
        
      case SKPaymentTransactionStateRestored:
        [self restoreTransaction:transaction];
        break;
        
      default:
        break;
    }
  }
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
  NSLog(@"InAppObserver: Transaction failed");
  if (transaction.error.code != SKErrorPaymentCancelled) {
    [[InAppManager sharedManager] failedTransaction:transaction];
  }
  [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
  NSLog(@"InAppObserver: Transaction completed");
  NSString *productIdentifier = transaction.payment.productIdentifier;
  InAppPurchaseProduct product = InAppPurchaseProductForProductID(productIdentifier);
  [[InAppManager sharedManager] provideProduct:product];
  [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
  NSLog(@"InAppObserver: Transaction restore");
  NSString *productIdentifier = transaction.originalTransaction.payment.productIdentifier;
  InAppPurchaseProduct product = InAppPurchaseProductForProductID(productIdentifier);
  [[InAppManager sharedManager] provideProduct:product];
  [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

@end
