//
//  InAppPurchaseProductsInformationProvider.m
//  HungryDog
//
//  Created by Yatin on 16/05/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import "InAppPurchaseProductsInformationProvider.h"

static NSDictionary *productsDictionary;

void __InitiateProductsDictionary() {
  NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
  dictionary[@"HDBones1000"] = @(InAppPurchaseProductDollar1);
  dictionary[@"HDBones2200"] = @(InAppPurchaseProductDollar2);
  dictionary[@"HDBones3500"] = @(InAppPurchaseProductDollar3);
  dictionary[@"HDBones6000"] = @(InAppPurchaseProductDollar5);
  dictionary[@"HDBones13000"] = @(InAppPurchaseProductDollar10);
  dictionary[@"HDNoAds"] = @(InAppPurchaseProductNoAds);
  productsDictionary = [NSDictionary dictionaryWithDictionary:dictionary];
}


InAppPurchaseProduct InAppPurchaseProductForProductID(NSString *productID) {
  if (productsDictionary == nil) {
    __InitiateProductsDictionary();
  }
  return [productsDictionary[productID] intValue];
}

NSString *InAppPurchaseProductIDForProduct(InAppPurchaseProduct product) {
  if (productsDictionary == nil) {
    __InitiateProductsDictionary();
  }
  for (NSString *key in [productsDictionary allKeys]) {
    if ([productsDictionary[key] intValue] == product) {
      return key;
    }
  }
  return nil;
}

NSSet *InAppPurchaseProductIDs() {
  if (productsDictionary == nil) {
    __InitiateProductsDictionary();
  }
  return [NSSet setWithArray:[productsDictionary allKeys]];
}
