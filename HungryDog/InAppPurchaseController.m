//
//  InAppPurchaseController.m
//  HungryDog
//
//  Created by Yatin on 19/05/14.
//  Copyright (c) 2014 Yatin Sarbalia. All rights reserved.
//

#import "InAppPurchaseController.h"

@interface InAppPurchaseController ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@end

@implementation InAppPurchaseController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  self.scrollView.backgroundColor = [UIColor redColor];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
