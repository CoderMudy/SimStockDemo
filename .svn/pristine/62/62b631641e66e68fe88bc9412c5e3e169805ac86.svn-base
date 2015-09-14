//
//  FundHoldStocksViewController2.m
//  SimuStock
//
//  Created by Mac on 15/5/11.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "FundHoldStocksViewController.h"
#import "FundHoldStocksTableViewController.h"

@implementation FundHoldStocksViewController {
  FundHoldStocksTableViewController *tableViewController;
}

- (id)initWithFundCode:(NSString *)fundCode withFundName:(NSString *)fundName {
  if (self = [super init]) {
    _fundCode = fundCode;
    _fundName = fundName;
  }
  return self;
}


- (void)viewDidLoad {
  [super viewDidLoad];

  [self resetTitle:[_fundName stringByAppendingString:@"持股明细"]];

  _littleCattleView.hidden = YES;

  tableViewController = [[FundHoldStocksTableViewController alloc]
      initWithFrame:_clientView.bounds];
  tableViewController.fundCode = _fundCode;
  tableViewController.fundName = _fundName;
  [self.clientView addSubview:tableViewController.view];
  [self addChildViewController:tableViewController];

  __weak FundHoldStocksViewController *weakSelf = self;
  tableViewController.beginRefreshCallBack = ^{
    [weakSelf.indicatorView startAnimating];
  };
  tableViewController.endRefreshCallBack = ^{
    [weakSelf.indicatorView stopAnimating];
  };

  [tableViewController refreshButtonPressDown];
}

- (void)refreshButtonPressDown {
  [tableViewController refreshButtonPressDown];
}

@end
