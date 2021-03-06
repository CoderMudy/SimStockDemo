//
//  IndexCurStatusVC.h
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
#import "SecuritiesTrendVC.h"
#import "IndexStockWindVaneView.h"
#import "BaseSecuritiesCurStatusVC.h"

@interface IndexCurStatusAdapter : BaseTableAdapter

@end

/*
 *类说明：资金行情走势线页面
 */
@interface IndexCurStatusVC : BaseSecuritiesCurStatusVC {

  IndexCurStatusAdapter *_tableAdapter;
}

/** 数据表格*/
@property(strong, nonatomic) UITableView *tableView;

///多趋势图控制器
@property(strong, nonatomic) SecuritiesTrendVC *securitiesTrendVC;

//上面展示的大盘信息
@property(strong, nonatomic) TopStockInfoView *topStockInfoView;

///股市风向标
@property(strong, nonatomic) IndexStockWindVaneView *indexStockWindVaneView;

@property(strong, nonatomic) StockQuotationInfo *stockQuotationInfo;


@end
