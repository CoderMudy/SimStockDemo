//
//  LandscapeKLineView.h
//  SimuStock
//
//  Created by Yuemeng on 15/4/28.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrendDateElement.h"
#import "TrendKLineModel.h"
#import "KLineENUM.h"
#import "StockUtil.h"
#import "FloatWindow4KLineView.h"

#define PRICE_MARKS_5 5

/*
 *类说明：横屏k线页面
 */
@interface LandscapeKLineView : UIView <UIGestureRecognizerDelegate> {
  // k线页面基本数据元素数组

  NSMutableArray *_dateElementArray;
  // K线页面一些需要显示变量的数据字典(比如股票名称)
  NSMutableDictionary *_dataDic;
  // 5日均线数组
  NSMutableArray *_5AverageDataArray;
  // 10日均线数组
  NSMutableArray *_10AverageDataArray;
  // 20日均线数组
  NSMutableArray *_20AverageDataArray;
  // 30日均线数组
  NSMutableArray *_30AverageDataArray;
  // 60日均线数组
  NSMutableArray *_60AverageDataArray;
  //当前屏幕k线开始序号
  NSInteger _screenStartIndex;
  //当前屏幕k线结束序号
  NSInteger _screenEndIndex;
  //价格刻度值数组
  NSInteger _priceMarkArray[PRICE_MARKS_5];
  //最大VOL成交量
  int64_t _maxVolume;
  //当前状态，屏幕最大显示k线数量
  NSInteger _showedCount;
  //指标线index
  NSInteger _index;
  //标签刻度数组
  NSMutableArray *_priceLabelArray;
  //保留小数位数
  NSInteger _decimalNumber;
  //捏合手势放大或缩小比例
  CGFloat _scale;
  //上次移动事件最后点纪录
  CGPoint _lastPositon;

  //当前鼠标点击位置
  CGPoint _beginPosition;
  //上一次移动位置
  CGPoint _lastMovePosition;

  // 5日均线数组
  SAverageDataManager *_5AverageDataManager;
  // 10日均线数组
  SAverageDataManager *_10AverageDataManager;
  // 20日均线数组
  SAverageDataManager *_20AverageDataManager;
  // 30日均线数组
  SAverageDataManager *_30AverageDataManager;
  // 60日均线数组
  SAverageDataManager *_60AverageDataManager;

  //可移动时间指示标签
  UILabel *_currentTimeLabel;
  //可移动价格指示标签
  UILabel *_currentPriceLabel;
  //创建横向指标线
  UIView *_horizontalLineView;
  //创建纵向指标线
  UIView *_verticalLineView;
  //当前那个按钮正在长按（用于按钮长按方法）
//  KLineNowPressButtonMode _pressingButtonMode;
  //定时器(该定时器用语按钮的长按事件记时)
  NSTimer *_timer;
  //定时器间隔时间
  NSTimeInterval _timeInterval;
  //浮窗显示状态
  TrendFLWindowState _flowWindowState;
  //长安手势
  UILongPressGestureRecognizer *_longPressGesture;
  //左右按钮区域
  CGRect _buttonRectArray[2];

  //k线区
  CGRect _candleRect;
  //量线区
  CGRect _volumeRect;

  float _originX;

  float _candleRectX;
  float _candleRectY;
  float _candleRectW;
  float _candleRectH;

  float _volumeRectX;
  float _volumeRectY;
  float _volumeRectW;
  float _volumeRectH;

  //上面具体信息背景视图568*30
  UIView *_detailInfoBackView;
  //上面具体信息标签数组
  NSMutableArray *_detailInfoLabelArray;
  // MA指示标签背景图
  UIView *_maBackView;
  // MA数值标签背景图
  UIView *_maLabelBackView;
  // Ma标签数组
  NSMutableArray *_maLabelArray;
  //时间标签背景图，用来挡住时间竖线同时方便清除上面的label
  UIView *_dateBackView;
  //浮点数据数组
  KLineDataItemInfo *_kLineDataItemInfo;
  //左下角的标签背景，用于显示基本信息及切换指标时清空
  UIView *_indicatorInfoBackView;
  //量线区实时信息标签
  UILabel *_currentInfoLabel;
  //默认量线区名称
  NSString *_volumeTitle;
  //当前指示线类型
  IndicatorLineType _indicatorLineType;

  // MACD
  NSArray *_macdPoints;
  // KDJ
  NSArray *_kdjPoints;
  // RSI
  NSArray *_rsiPoints;
  // BOLL
  NSArray *_bollPoints;
  // BRAR
  NSArray *_brarPoints;
  // OBV
  NSArray *_obvPoints;
  // DMI
  NSArray *_dmiPoints;
  // BIAS
  NSArray *_biasPoints;
  // W&R
  NSArray *_wrPoints;

  NSString *priceFormat;
  
  //竖屏浮窗
  FloatWindow4KLineView *_floatWindow4KLineView;
  
  BOOL _needClearStartIndex;
  
  //左边界起始点，数据如果超过500条，则为数据-500
  NSInteger _leftBorderNum;
}

/// k线图全部显示区域
@property(assign) CGRect allShowFrame;
/// 当前k线放大倍数
@property(assign) float zoomNumber;
/// k线宽度
@property(assign) NSInteger kLineWidth;
/// k线纵坐标刻度最大宽度
@property(assign) NSInteger scaleMaxWidth;
/// K线指标（macd ,kdj）等的序列号
@property(assign) NSInteger indicatorIndex;
///是否横屏
@property(nonatomic) BOOL isLandscape;

///证券信息
@property(nonatomic, strong) SecuritiesInfo *securitiesInfo;

///竖屏初始化
- (instancetype)initWithFrame:(CGRect)frame isLandscape:(BOOL)isLandscape;

- (void)setPageData:(KLineDataItemInfo *)pagedata
 withSecuritiesInfo:(SecuritiesInfo *)securitiesInfo;
///根据指标选项显示相关指标线
- (void)setIndicatorLineType:(NSInteger)index;
//清除所有K线数据
- (void)clearAllData;
- (void)hideFloatView;

@end
