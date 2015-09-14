//
//  StockCurStatusVC.h
//  SimuStock
//
//  Created by Mac on 15/6/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockUtil.h"
#import "SimuUtil.h"
#import "NSStringCategory.h"
#import "CommonFunc.h"
#import "topStockInfoView.h"
#import "simuCenterTabView.h"
#import "SimuFundFlowView.h"
#import "SimuTradeStatus.h"
#import "TrendKLineModel.h"
#import "SimuWaitCounter.h"
#import "TimerUtil.h"
#import "MarketConst.h"
#import "FundBaseInfoView.h"
#import "FundHoldStocksTableViewController.h"
#import "SecuritiesTrendVC.h"
#import "BaseSecuritiesCurStatusVC.h"

@interface StockCurStatusAdapter : BaseTableAdapter

@end

/*
 *类说明：资金行情走势线页面
 */
@interface StockCurStatusVC : BaseSecuritiesCurStatusVC {

  StockCurStatusAdapter *_tableAdapter;
}

/** 数据表格*/
@property(strong, nonatomic) UITableView *tableView;

///多趋势图控制器
@property(strong, nonatomic) SecuritiesTrendVC *securitiesTrendVC;

//上面展示的股票信息
@property(strong, nonatomic) TopStockInfoView *topStockInfoView;

@property(strong, nonatomic) StockQuotationInfo *stockQuotationInfo;

@property(strong, nonatomic) SimuFundFlowView *fundFlowView;



@end
