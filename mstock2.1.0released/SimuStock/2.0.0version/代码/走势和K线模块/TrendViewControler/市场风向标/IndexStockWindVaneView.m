//
//  IndexStockWindVaneView.m
//  SimuStock
//
//  Created by Yuemeng on 15/5/15.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "IndexStockWindVaneView.h"
#import "WindVaneView.h"
#import "CowThanBearView.h"
#import "RiseFallStatView.h"
#import "SimuTradeStatus.h"

@implementation IndexStockWindVaneView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self createUI];
    __weak IndexStockWindVaneView *weakSelf = self;
    timerUtil = [[TimerUtil alloc] initWithTimeInterval:1800 //按安卓规则
                                       withTimeCallBack:^{
                                         //如果无网络，则什么也不做；
                                         if (![SimuUtil isExistNetwork]) {
                                           return;
                                         }
                                         //如果当前交易所状态为闭市，则什么也不做
                                         if ([[SimuTradeStatus instance] getExchangeStatus] ==
                                             TradeClosed) {
                                           return;
                                         }

                                         [weakSelf refreshView];
                                       }];
  }
  return self;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [timerUtil resumeTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [timerUtil stopTimer];
}

- (void)createUI {
  //市场风向标
  _windVaneView =
      [[[NSBundle mainBundle] loadNibNamed:@"WindVaneView" owner:self options:nil] firstObject];
  [_windVaneView setFrame:CGRectMake(0, 13, self.view.width, 190)];
  [self.view addSubview:_windVaneView];
  [_windVaneView requestDataFromNet];

  //每日牛熊比
  _cowThanBearView =
      [[[NSBundle mainBundle] loadNibNamed:@"CowThanBearView" owner:self options:nil] firstObject];
  [_cowThanBearView setFrame:CGRectMake(0, 217, self.view.width, 183)];
  [self.view addSubview:_cowThanBearView];
  [_cowThanBearView requestCowThanBearData];

  //涨跌数统计
  _riseFallStatView =
      [[RiseFallStatView alloc] initWithFrame:CGRectMake(0, 410, self.view.width, 280)];
  [self.view addSubview:_riseFallStatView];
  [_riseFallStatView requestRiseFallStatData];
}

- (void)refreshView {
  [_windVaneView requestDataFromNet];
  [_cowThanBearView requestCowThanBearData];
  [_riseFallStatView requestRiseFallStatData];
}

- (BOOL)dataBinded {
  return NO;
}

@end
