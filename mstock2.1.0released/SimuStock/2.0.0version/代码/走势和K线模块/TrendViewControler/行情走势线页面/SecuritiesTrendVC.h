//
//  SecuritiesTrendVC.h
//  SimuStock
//
//  Created by Mac on 15/5/13.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimuIndicatorView.h"
#import "StockUtil.h"
#import "StockUtil+view.h"
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
#import "BaseViewController.h"
#import "BasePartTimeVC.h"
#import "BaseTrendVC.h"
#import "BaseFundNetValueVC.h"

/** 证券趋势图，由分时，净值（基金），五日（股票），日K，周K，月K等页面构成 */
@interface SecuritiesTrendVC : BaseTrendVC <SimuCenterTabViewDelegate> {

  //走势，日线，周线等切换控件
  SimuCenterTabView *tvc_centerTabView;

  UIViewController *currentVC;

  //当前展示的页面类型 （0：分时走势。1：日线，2：周线 3：月线）
  NSInteger tvc_pageType;

  NSMutableArray *trendVCs;
}

///报价信息返回，通知观察者
@property(nonatomic, copy) OnStockQuotationInfoReady stockQuotationInfoReady;

- (instancetype)initWithFrame:(CGRect)frame
           withSecuritiesInfo:(SecuritiesInfo *)securitiseInfo;

@end
