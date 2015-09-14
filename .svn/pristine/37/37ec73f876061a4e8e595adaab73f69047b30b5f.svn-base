//
//  IndexTrendViewController.h
//  SimuStock
//
//  Created by Mac on 15/5/27.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseNoTitleViewController.h"
#import "SimuIndicatorView.h"
#import "StockUtil.h"
#import "SimuUtil.h"
#import "NSStringCategory.h"
#import "CommonFunc.h"
#import "TopStockInfoView.h"
#import "SimuCenterTabView.h"
#import "TrendView.h"
#import "KLineView.h"
#import "SimuFundFlowView.h"
#import "SimuTradeStatus.h"
#import "TrendKLineModel.h"
#import "SimuWaitCounter.h"
#import "FiveDaysSmallView.h"
#import "SimuTrendLineViewController.h"

@class IndexStockWindVaneView;

@interface IndexTrendViewController
    : BaseNoTitleViewController <SimuCenterTabViewDelegate> {

  //当前股票代码
  NSString *_stockCode;
  //滚动页面
  UIScrollView *_scrollView;
  //上面展示的股票信息
  TopStockInfoView *_topStockInfoView;
  //走势，日线，周线等切换控件
  SimuCenterTabView *_centerTabView;
  //创建走势和K线的基本承载页面
  UIView *_trendBaseView;
  UIView *_fromView;
  UIView *_toView;
  //走势页面
  TrendView *_trendView;
  //五日页面
  FiveDaysSmallView *_fiveDaysView;
  //日K线
  KLineView *_dayKLineView;
  //周K线
  KLineView *_weekKLineView;
  //月K线
  KLineView *_monthKLineView;

  //浮窗控件
  TrendFloatView *_floatView;
  TrendFloatView *_klfloatView;
  //高度
  float _newsize;
  //当前展示的页面类型 （0：分时走势 1：五日 2：日线，3：周线 4：月线）
  int _pageType;
  //定时期
  NSTimer *_timer;
  //定时器间隔时间
  NSTimeInterval _timeinterval;
  //菊花等待是否取消计数器
  SimuWaitCounter *_waitConter;
  ///指数股市场风向标
  IndexStockWindVaneView *_indexStockWindVaneView;
}

///分时数据
@property(nonatomic, strong) TrendData *trendData;
///五日数据
@property(nonatomic, strong) Stock5DayStatusInfo *fiveDayData;
///买五卖五数据
@property(nonatomic, strong) StockQuotationInfo *quotationInfo;
/// k线数据
@property(nonatomic, strong) KLineDataItemInfo *kLineDataInfo;

@property(strong, nonatomic) SimuIndicatorView *indicatorView;

/** 刷新上方股票报价和涨幅 */
@property(nonatomic, copy) topStockInfoBlock topStockInfoBlock;

//带股票代码初始化
- (id)initWidthCode:(NSString *)code firstType:(NSString *)firstType;
//重新设置股票代码初始化
- (void)resetWithCode:(NSString *)code firstType:(NSString *)firstType;
//刷新
- (void)refreshData;
//取得当前价格
- (NSString *)getNewPrice;
//取得涨跌幅
- (NSString *)getProfit;
//取得涨跌额
- (NSString *)getUpDownPrice;
//得到滚动视图
- (UIScrollView *)getScrollView;
//清理当前数据
- (void)cearlAllTrendData;
- (void)stopMyTimer;
- (void)initTrendTimer;
//走势页面浮窗消息
- (void)hideTrendFloatViews;

//初始化，分时，日线，周线，月的数据
- (void)initDayWeekMonthData:(NSInteger)lastObject;

@end
