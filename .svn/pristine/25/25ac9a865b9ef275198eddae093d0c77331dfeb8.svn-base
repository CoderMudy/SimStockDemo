//
//  PartTimeView.h
//  SimuStock
//
//  Created by Yuemeng on 15/4/14.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockUtil.h"
#import "DataArray.h"
#import "StockUtil+float_window.h"

@class TrendData;
@class TrendDataPage;
@class LandscapeKLineViewController;

typedef void (^passTimeLabelText)(NSString *);

/*
 *横屏分时视图
 */
@interface PartTimeView : UIView <UIGestureRecognizerDelegate> {
  ///价格标签数组
  NSMutableArray *_priceLabelArray;
  ///百分比标签数组
  NSMutableArray *_percentLabelArray;
  ///时间标签数组
  NSMutableArray *_timeLabelArray;
  ///交易量数组
  NSMutableArray *_volumeLabelArray;
  //走势均线价格数组
  NSMutableArray *_averageLineDataArray;
  //走势价格和量数组
  NSMutableArray *_valueAndVolumeDataArray;
  //走势区域点集数组
  NSMutableArray *_trendLinePointArray;
  //走势均线点集合数组
  NSMutableArray *_averagePointArray;
  //量线画图点数据数组
  NSMutableArray *_volumePointArray;
  //百分比标值数组
  NSMutableArray *_percentMarkArray;
  //价格标值数组
  NSMutableArray *_priceMarkArray;
  //量线标值数组
  NSMutableArray *_dealsMarkArray;

  //当前数据分钟数量
  NSInteger _dataMinutes;
  //纪录总成交量
  NSInteger _totalDeals;
  //是否指数股票(yes:大盘指数  NO:非大盘指数)
  BOOL _isIndexStock;
  //纪录昨收价格
  long _lastClosePrice;
  //是否停牌
  BOOL _isListed;
  //是否走势线为一条直线(是，则不画均线)
  BOOL _isStraightLineTrend;
  //长按手势
  UILongPressGestureRecognizer *_longPressRecognizer;
  //上次触摸位置
  CGPoint _lastPositon;
  //纵向指标线
  UIView *_verticalLineView;
  //横向指标线
  UIView *_horicalLineView;
  //指示线交叉点
  UIView *_crossDot;

  //价格、时间、涨幅 游标
  UILabel *_currentPriceLabel;
  UILabel *_currentTimeLabel;
  UILabel *_currentPercentLabel;
}

@property(nonatomic, assign) BOOL isHorizontalMode;

///给横屏视图传递时间string
@property(nonatomic, copy) OnPartTimeSelected onPartTimeSelected;

///给横屏视图传递时间string
@property(nonatomic, copy) passTimeLabelText passTimeLabelText;

///走势数据，包含股票名称和股票代码
@property(nonatomic) DataArray *trendDataPage;

///证券信息
@property(nonatomic, strong) SecuritiesInfo *securitiesInfo;

///行情分时数据
- (void)setTrendData:(TrendData *)trendData
      securitiesInfo:(SecuritiesInfo *)securitiesInfo;

///清除分时数据
- (void)clearView;

@end
