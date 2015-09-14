//
//  ComposePartTimeVC.m
//  SimuStock
//
//  Created by Mac on 15/6/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ComposePartTimeVC.h"

@implementation ComposePartTimeVC

- (void)viewDidLoad {
  [super viewDidLoad];

  self.partTimeVC =
      [[PortaitPartTimeVC alloc] initWithFrame:self.partTimeFrame
                            withSecuritiesInfo:self.securitiesInfo];
  self.partTimeVC.beginRefreshCallBack = self.beginRefreshCallBack;
  self.partTimeVC.endRefreshCallBack = self.endRefreshCallBack;
  [self.view addSubview:self.partTimeVC.view];
  [self addChildViewController:self.partTimeVC];

  self.baseS5B5VC = [[PortaitS5B5VC alloc] initWithFrame:self.s5b5Frame
                                      withSecuritiesInfo:self.securitiesInfo];
  self.baseS5B5VC.stockQuotationInfoReady = self.stockQuotationInfoReady;
  self.baseS5B5VC.beginRefreshCallBack = self.beginRefreshCallBack;
  self.baseS5B5VC.endRefreshCallBack = self.endRefreshCallBack;
  [self.view addSubview:self.baseS5B5VC.view];
  [self addChildViewController:self.baseS5B5VC];
  self.baseS5B5VC.view.hidden = self.isIndex;
}

- (CGRect)partTimeFrame {
  return self.isIndex
             ? self.view.bounds
             : CGRectMake(0, 0, self.view.bounds.size.width - S5B5ViewWidth -
                                    S5B5ViewMarginLeftRight * 2,
                          self.view.bounds.size.height);
}

static CGFloat S5B5ViewWidth = 77.f;
static CGFloat S5B5ViewMarginLeftRight = 6;
static CGFloat S5B5ViewMarginBottom = 10;

- (CGRect)s5b5Frame {
  return self.isIndex
             ? CGRectZero
             : CGRectMake(self.view.bounds.size.width - S5B5ViewWidth -
                              S5B5ViewMarginLeftRight,
                          0, S5B5ViewWidth,
                          self.view.bounds.size.height - S5B5ViewMarginBottom);
}

- (BOOL)isIndex {
  NSString *firstType = self.securitiesInfo.securitiesFirstType();
  return [StockUtil isMarketIndex:firstType];
}

- (void)resetWithFrame:(CGRect)frame
    withSecuritiesInfo:(SecuritiesInfo *)securitiesInfo {
  [super resetWithFrame:frame withSecuritiesInfo:securitiesInfo];

  [self.partTimeVC resetWithFrame:self.partTimeFrame
               withSecuritiesInfo:securitiesInfo];
  [self.baseS5B5VC resetWithFrame:self.s5b5Frame
               withSecuritiesInfo:securitiesInfo];
  self.baseS5B5VC.view.hidden = self.isIndex;
}

- (void)refreshView {
  [self.partTimeVC refreshView];
  [self.baseS5B5VC refreshView];
}

- (void)clearView {
  [self.partTimeVC clearView];
  [self.baseS5B5VC clearView];
}

- (BOOL)dataBinded {
  return self.partTimeVC.dataBinded && self.baseS5B5VC.dataBinded;
}

@end
