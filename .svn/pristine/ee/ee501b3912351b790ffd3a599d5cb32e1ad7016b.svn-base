//
//  SameStockHeroMainViewController.m
//  SimuStock
//
//  Created by Mac on 15/4/29.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SameStockHeroMainViewController.h"

@implementation SameStockHeroHeaderView

/** 重置 */
- (void)reset {
  self.lblHoldUserNum.text = @"--";
  self.lblProfitRate.text = @"--";
  self.lblAvgCostPrice.text = @"--";
  self.lblAvgProfitRate.text = @"--";
  self.lblAvgProfitRate.textColor = [StockUtil getColorByText:@"--"];
}

/** 数据绑定 */
- (void)bindData:(SameStockHeroList *)heroList {
  self.lblHoldUserNum.text = [@(heroList.count) stringValue];
  self.lblProfitRate.text =
      [NSString stringWithFormat:@"%.2f%%", heroList.rate * 100.0f];
  NSString *format = _priceFormat ? _priceFormat() : @"%.2f";
  self.lblAvgCostPrice.text =
      [NSString stringWithFormat:format, heroList.avgCostPrice];
  self.lblAvgProfitRate.textColor =
      [StockUtil getColorByFloat:heroList.avgProfitRate];
  self.lblAvgProfitRate.text =
      [NSString stringWithFormat:@"%.2f%%", heroList.avgProfitRate * 100.0f];
}

@end

@implementation SameStockHeroMainViewController

- (id)initWithFrame:(CGRect)frame
      withStockCode:(NSString *)stockCode
          firstType:(NSString *)firstType {
  if (self = [super initWithFrame:frame]) {
    _stockCode = stockCode;
    _firstType = firstType;
  }
  return self;
}

- (void)resetStockCode:(NSString *)stockCode firstType:(NSString *)firstType {
  if ([self.stockCode isEqualToString:stockCode]) {
    return;
  }
  _stockCode = stockCode;
  _firstType = firstType;
  [_headView reset];
  [_heroListVC resetStockCode:stockCode];
  self.heroList = nil;
  [self refresh];
}

- (void)refresh {
  [_heroListVC requestResponseWithRefreshType:RefreshTypeRefresh];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  CGFloat headerHeight = 82.0f;

  NSArray *array =
      [[NSBundle mainBundle] loadNibNamed:@"SameStockHeroHeaderView"
                                    owner:nil
                                  options:nil];
  _headView = [array lastObject];
  _headView.frame = CGRectMake(0, 0, self.view.bounds.size.width, headerHeight);
  [self.view addSubview:_headView];

  __weak SameStockHeroMainViewController *weakSelf = self;
  _headView.priceFormat = ^{
    return [weakSelf priceFormat];
  };
  [_headView reset];

  CGRect frame = CGRectMake(0.0f, headerHeight, self.view.bounds.size.width,
                            self.frameInParent.size.height - headerHeight);
  _heroListVC =
      [[SameStockHeroListViewController alloc] initWithFrame:frame
                                               withStockCode:self.stockCode];

  _heroListVC.beginRefreshCallBack = self.beginRefreshCallBack;
  _heroListVC.endRefreshCallBack = self.endRefreshCallBack;
  _heroListVC.onDataReadyCallBack = ^{
    [weakSelf bindTitleData];
  };
  _heroListVC.priceFormat = ^{
    return [weakSelf priceFormat];
  };
  [self.view addSubview:_heroListVC.view];
  [self addChildViewController:_heroListVC];
}

- (NSString *)priceFormat {
  return [StockUtil getPriceFormatWithFirstType:_firstType];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  if (!_heroListVC.dataArray.dataBinded) {
    [_heroListVC requestResponseWithRefreshType:RefreshTypeRefresh];
  }
}

- (void)bindTitleData {
  self.heroList = _heroListVC.heroList;
  [_headView bindData:_heroList];
}

@end
