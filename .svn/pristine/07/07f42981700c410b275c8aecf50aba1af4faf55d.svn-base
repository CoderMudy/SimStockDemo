//
//  PartTimeTradeVC.h
//  SimuStock
//
//  Created by Mac on 15/6/10.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseTrendVC.h"
#import "SimuCenterTabView.h"
#import "BaseS5B5VC.h"
#import "StockDetailTableViewController.h"
#import "StockPriceStateViewController.h"

@interface PartTimeTradeVC : BaseTrendVC <SimuCenterTabViewDelegate>

///五档切换视图
@property(strong, nonatomic) SimuCenterTabView *fiveShiftTabView;

@property(strong, nonatomic) HorizontalS5B5VC *vc1;
@property(strong, nonatomic) StockDetailTableViewController *vc2;
@property(strong, nonatomic) StockPriceStateViewController *vc3;

///报价信息返回，通知观察者
@property(nonatomic, copy) OnStockQuotationInfoReady stockQuotationInfoReady;

@end
