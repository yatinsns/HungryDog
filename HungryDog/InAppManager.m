//
//  InAppManager.m
//  HungryDog
//
//  Created by Yatin on 16/05/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import "InAppManager.h"
#import "InAppObserver.h"

@interface InAppManager () <SKProductsRequestDelegate>

@property (nonatomic) InAppObserver *inAppObserver;
@property (nonatomic) NSMutableArray *purchasableProducts;

@end

@implementation InAppManager

+ (InAppManager *)sharedManager {
  static InAppManager *inAppManager;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    inAppManager = [[InAppManager alloc] init];
  });
  return inAppManager;
}

- (instancetype)init {
  if (self = [super init]) {
    [self requestProductsData];
    _inAppObserver = [[InAppObserver alloc] init];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:_inAppObserver];
    _purchasableProducts = [NSMutableArray array];
  }
  return self;
}

- (void)requestProductsData {
  SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:InAppPurchaseProductIDs()];
  request.delegate = self;
  [request start];
}

- (void)buyProduct:(InAppPurchaseProduct)product {
  NSString *productID = InAppPurchaseProductIDForProduct(product);
  NSLog(@"InAppManager: Buy product with ID %@", productID);
  if ([SKPaymentQueue canMakePayments]) {
    SKProduct *skProduct = [self skProductWithProductID:productID];
    SKPayment *payment = [SKPayment paymentWithProduct:skProduct];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
  } else {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                        message:@"You can't purchase from the app store"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
  }
}

- (void)provideProduct:(InAppPurchaseProduct)product {
  NSLog(@"InAppManager: Provide product %@", @(product));
  [self.delegate inAppManager:self didProvideProduct:product];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
  NSString *failedMessage = [NSString stringWithFormat:@"%@ \n %@",
                             [transaction.error localizedFailureReason],
                             [transaction.error localizedRecoverySuggestion]];
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to complete your purchase"
                                                  message:failedMessage
                                                 delegate:nil
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
  [alert show];
}

- (void)restoreCompletedTransactions {
  [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (SKProduct *)skProductWithProductID:(NSString *)productID {
  for (SKProduct *skProduct in self.purchasableProducts) {
    if ([skProduct.productIdentifier isEqualToString:productID]) {
      return skProduct;
    }
  }
  return nil;
}

#pragma mark - SKProductRequestDelegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
  NSArray *skProducts = response.products;
  NSLog(@"InAppManager: Product request response %@", response.products);
  if ([skProducts count] != 0 && [self.purchasableProducts count] == 0) {
    for (SKProduct *skProduct in skProducts) {
      [self.purchasableProducts addObject:skProduct];
      NSLog(@"Feature: %@, Cost: %f, ID: %@", [skProduct localizedTitle], [[skProduct price] doubleValue], [skProduct productIdentifier]);
    }
  }
  NSLog(@"We found %@ in app purchases in iTunes connect", @([self.purchasableProducts count]));
}

@end
