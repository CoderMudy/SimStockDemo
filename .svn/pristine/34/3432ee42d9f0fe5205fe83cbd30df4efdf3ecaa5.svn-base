//
//  FundNetValueView.h
//  SimuStock
//
//  Created by Mac on 15/5/29.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockUtil.h"
#import "DataArray.h"
#import "FundNetWorthList.h"

/**当基金净值被选中或释放时，通知控制器，控制器是唯一的观察者
 * FundNav不为空，表示选中了一个基金净值；为空，表示释放选中态
 * 第二个参数为选中的位置
 * 第三个参数为选择的范围
 */
typedef void (^OnFundNavSelected)(FundNav *, NSInteger, NSInteger);

/*
 *横屏分时视图
 */
@interface FundNetValueView : UIView <UIGestureRecognizerDelegate> {
  ///价格标签数组
  NSMutableArray *_priceLabelArray;
  ///百分比标签数组
  NSMutableArray *_percentLabelArray;
  ///日期标签数组
  NSMutableArray *_dateLabelArray;

  //走势区域点集数组
  NSMutableArray *_trendLinePointArray;

  //百分比标值数组
  NSMutableArray *_percentMarkArray;
  //价格标值数组
  NSMutableArray *_priceMarkArray;
  //价格标值数组
  NSMutableArray *_dateMarkArray;

  //当前数据分钟数量
  NSInteger _dataMinutes;

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

  //价格、时间、涨幅 游标
  UILabel *_currentPriceLabel;
  UILabel *_currentTimeLabel;
  UILabel *_currentPercentLabel;
}

@property(nonatomic, assign) BOOL isHorizontalMode;

//走势价格和量数组
@property(nonatomic, strong) DataArray *dataArray;

///当基金净值被选中或释放时，通知控制器，控制器是唯一的观察者
@property(nonatomic, copy) OnFundNavSelected onFundNavSelected;

///证券信息
@property(nonatomic, strong) SecuritiesInfo *securitiesInfo;

- (void)bindFundNetWorthList:(FundNetWorthList *)list;

///清除所有数据
- (void)clearData;

@end
