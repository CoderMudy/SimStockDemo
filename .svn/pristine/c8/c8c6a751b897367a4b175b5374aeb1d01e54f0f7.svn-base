//
//  SecuritesCurStatusVC.m
//  SimuStock
//
//  Created by Mac on 14-8-11.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SecuritiesCurStatusVC.h"

@implementation SecuritiesCurStatusVC {
  BaseSecuritiesCurStatusVC *currentVC;
}

- (void)resetWithFrame:(CGRect)frame
    withSecuritiesInfo:(SecuritiesInfo *)securitiesInfo {
  [super resetWithFrame:frame withSecuritiesInfo:securitiesInfo];
  if (currentVC) {
    [currentVC removeFromParentViewController];
    [currentVC.view removeFromSuperview];
    currentVC = nil;
    self.fundCurStatusVC = nil;
    self.indexCurStatusVC = nil;
    self.stockCurStatusVC = nil;
  }
  [self setCurrentCurStatasVC];
}

- (void)setCurrentCurStatasVC {
  if ([StockUtil isFund:self.securitiesInfo.securitiesFirstType()]) {
    currentVC = self.fundCurStatusVC;
  } else if ([StockUtil
                 isMarketIndex:self.securitiesInfo.securitiesFirstType()]) {
    currentVC = self.indexCurStatusVC;
  } else {
    currentVC = self.stockCurStatusVC;
  }
  currentVC.onDataReadyCallBack = self.onDataReadyCallBack;
  currentVC.beginRefreshCallBack = self.beginRefreshCallBack;
  currentVC.endRefreshCallBack = self.endRefreshCallBack;
  [self.view addSubview:currentVC.view];
  [self addChildViewController:currentVC];
}

- (FundCurStatusVC *)fundCurStatusVC {
  if (_fundCurStatusVC == nil) {
    _fundCurStatusVC =
        [[FundCurStatusVC alloc] initWithFrame:self.view.bounds
                            withSecuritiesInfo:self.securitiesInfo];
  }
  return _fundCurStatusVC;
}

- (IndexCurStatusVC *)indexCurStatusVC {
  if (_indexCurStatusVC == nil) {
    _indexCurStatusVC =
        [[IndexCurStatusVC alloc] initWithFrame:self.view.bounds
                             withSecuritiesInfo:self.securitiesInfo];
  }
  return _indexCurStatusVC;
}

- (StockCurStatusVC *)stockCurStatusVC {
  if (_stockCurStatusVC == nil) {
    _stockCurStatusVC =
        [[StockCurStatusVC alloc] initWithFrame:self.view.bounds
                             withSecuritiesInfo:self.securitiesInfo];
  }
  return _stockCurStatusVC;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setCurrentCurStatasVC];
}

- (void)refreshSecuritesData {
  [currentVC refreshSecuritesData];
}

- (void)refreshView {
  [currentVC refreshSecuritesData];
}

- (void)clearSecuritesData {
  [currentVC clearSecuritesData];
}

- (UIView *)curStatusViewForShare {
  return [currentVC curStatusViewForShare];
}

- (NSString *)curPrice {
  return currentVC.curPrice;
}
- (NSString *)riseRate {
  return currentVC.riseRate;
}

@end
