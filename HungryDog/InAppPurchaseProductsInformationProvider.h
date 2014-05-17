//
//  InAppPurchaseProductsInformationProvider.h
//  HungryDog
//
//  Created by Yatin on 16/05/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, InAppPurchaseProduct) {
  InAppPurchaseProductDollar1 = 1000,
  InAppPurchaseProductDollar2 = 2200,
  InAppPurchaseProductDollar3 = 3500,
  InAppPurchaseProductDollar5 = 6000,
  InAppPurchaseProductDollar10 = 13000
};

InAppPurchaseProduct InAppPurchaseProductForProductID(NSString *productID);

NSString *InAppPurchaseProductIDForProduct(InAppPurchaseProduct product);

NSSet *InAppPurchaseProductIDs();