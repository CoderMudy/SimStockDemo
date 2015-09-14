//
//  PartTimeTradeVC.m
//  SimuStock
//
//  Created by Mac on 15/6/10.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "PartTimeTradeVC.h"

///头部Tab的高度
static CGFloat TabHeight = 29.f;

static CGFloat TabMargin = 0.f;

@implementation PartTimeTradeVC {
  NSInteger tvc_pageType;
  SimuCenterTabView *tvc_centerTabView;
  BaseNoTitleViewController *currentVC;
}

- (instancetype)initWithFrame:(CGRect)frame
           withSecuritiesInfo:(SecuritiesInfo *)securitiseInfo {
  if (self = [super initWithFrame:frame]) {
    self.securitiesInfo = securitiseInfo;
    tvc_pageType = 0;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self createTabViews];
  [self tabSelected:tvc_pageType];
}

- (CGRect)trendViewFrame {
  return CGRectMake(0, TabHeight, self.view.bounds.size.width,
                    self.view.bounds.size.height - TabHeight);
}

- (NSArray *)tabStringArray {
  return @[ @"五档", @"明细", @"分价" ];
}

- (void)resetWithFrame:(CGRect)frame
    withSecuritiesInfo:(SecuritiesInfo *)securitiesInfo {
  self.securitiesInfo = securitiesInfo;
  [self createTabViews];
}

//创建走势，日线的切换Tab小控件
- (void)createTabViews {
  if (tvc_centerTabView) {
    [tvc_centerTabView removeFromSuperview];
  }
  tvc_centerTabView = [[SimuCenterTabView alloc]
      initWithFrame:CGRectMake(TabMargin, TabMargin,
                               self.view.bounds.size.width - TabMargin * 2,
                               TabHeight - TabMargin * 2)
         titleArray:self.tabStringArray];
  tvc_centerTabView.delegate = self;

  [self.view addSubview:tvc_centerTabView];

  _vc1 = [[HorizontalS5B5VC alloc] initWithFrame:[self trendViewFrame]
                              withSecuritiesInfo:self.securitiesInfo];
  _vc1.stockQuotationInfoReady = self.stockQuotationInfoReady;
  
  _vc2 = [[StockDetailTableViewController alloc]
           initWithFrame:[self trendViewFrame]
      withSecuritiesInfo:self.securitiesInfo];
  
  _vc3 =
      [[StockPriceStateViewController alloc] initWithFrame:[self trendViewFrame]
                                        withSecuritiesInfo:self.securitiesInfo];
}

#pragma mark
#pragma mark SimuCenterTabViewDelegate 分时和K线，周线切换函数协议
- (void)tabSelected:(NSInteger)index {
  if (currentVC) {
    [currentVC.view removeFromSuperview];
    [currentVC removeFromParentViewController];
  }
  switch (index) {
  case 0:
    currentVC = _vc1;
    if (!_vc1.dataBinded) {
      [_vc1 refreshView];
    }
    break;
  case 1:
    currentVC = _vc2;
    if (!_vc2.dataBinded) {
      [_vc2 requestResponseWithRefreshType:RefreshTypeRefresh];
    }
    break;
  default:
    currentVC = _vc3;
    if (!_vc3.dataBinded) {
      [_vc3 requestResponseWithRefreshType:RefreshTypeRefresh];
    }
    break;
  }
  tvc_pageType = index;
  [self.view addSubview:currentVC.view];
  [self addChildViewController:currentVC];
}

- (void)refreshView {
  switch (tvc_pageType) {
  case 0:
    [_vc1 refreshView];
    break;
  case 1:
    [_vc2 requestResponseWithRefreshType:RefreshTypeRefresh];
    break;
  default:
    [_vc3 requestResponseWithRefreshType:RefreshTypeRefresh];
    break;
  }
}

#pragma mark
- (void)setNoNetwork {
  [NewShowLabel showNoNetworkTip];
}

@end
