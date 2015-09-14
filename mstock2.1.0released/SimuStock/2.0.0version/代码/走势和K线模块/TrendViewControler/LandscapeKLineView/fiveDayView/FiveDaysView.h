//
//  FiveDayView.h
//  SimuStock
//
//  Created by Yuemeng on 15/4/27.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "StockUtil+float_window.h"

@class TrendData;
@class TrendDataPage;
@class LandscapeKLineViewController;
@class Stock5DayStatusInfo;

/*
 * 五日视图
 */
@interface FiveDaysView : UIView <UIGestureRecognizerDelegate> {
  ///价格标签数组
  NSMutableArray *_priceLabelArray;
  ///百分比标签数组
  NSMutableArray *_percentLabelArray;
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
  //日期标值数组
  NSMutableArray *_dateMarkArray;

  float _originX;

  float _trendOriginX;
  float _trendOriginY;
  float _trendSizeWidth;
  float _trendSizeHeight;

  float _volumeOriginX;
  float _volumeOriginY;
  float _volumeSizeWidth;
  float _volumeSizeHeight;

  /// k线Rect区域
  CGRect _trendRect;
  ///量线Rect区域
  CGRect _volumeRect;

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
  //长按手势
  UILongPressGestureRecognizer *_longPressRecognizer;
  //上次触摸位置
  CGPoint _lastPositon;
  //指标线
  UIView *_verticalLineView;
  //指标线
  UIView *_horicalLineView;
  //指示线交叉点
  UIView *_crossDot;
  //五日具体信息背景视图568*30
  UIView *_detailInfoBackView;
  //五日具体信息标签数组
  NSMutableArray *_detailInfoLabelArray;
  //五日计算数据string数组
  NSMutableArray *_detailStringArray;

  //价格、时间、涨幅 游标
  UILabel *_currentPriceLabel;
  UILabel *_currentTimeLabel;
  UILabel *_currentPercentLabel;

  int _maxPrice;
  int _minPrice;
  int64_t _maxAmount;
}

///走势数据，包含股票名称和股票代码
@property(nonatomic) TrendDataPage *trendDataPage;

///给横屏视图传递时间string
@property(nonatomic, copy) OnPartTimeSelected onPartTimeSelected;

///竖、横屏标识符
@property(nonatomic) BOOL isLandScape;

- (instancetype)initWithFrame:(CGRect)frame isLandScape:(BOOL)isLandScape;

///行情分时数据
- (void)setStock5DaysData:(Stock5DayStatusInfo *)info
             isIndexStock:(BOOL)isIndexStock;

- (void)clearView;

@end
