//
//  LandscapeKLineVIewController.h
//  SimuStock
//
//  Created by Yuemeng on 15/4/13.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNoTitleViewController.h"
#import "PartTimeView.h"
#import "FiveDaysView.h"
#import "SimuCenterTabView.h"
#import "TrendKLineModel.h"
#import "LandscapeKLineView.h"
#import "BasePartTimeVC.h"
#import "BaseFundNetValueVC.h"

/*
 *横屏趋势图、五日、k线父视图
 */
@interface LandscapeKLineViewController
    : BaseNoTitleViewController <SimuCenterTabViewDelegate> {

  ///昨收价
  float _lastClosePrice;

  ///开始请求明细
  BOOL _isBeginningRequestDetailData;
  ///开始请求分价
  BOOL _isBeginningRequestPriceState;
  /// k线类型
  NSString *_kLineType;
  ///复权类型
  NSString *_xrdrType;
  ///分价-总成交量
  long _totalAmount;
}

///股票名称标签(W:120px)
@property(strong, nonatomic) IBOutlet UILabel *stockNameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stockNameCons;
///股票价格标签(W:48px)
@property(strong, nonatomic) IBOutlet UILabel *stockPriceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stockPriceCons;
///交易量标签(W:115px)
@property(strong, nonatomic) IBOutlet UILabel *dealVolumeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dealVolumeCons;
///当前时间标签(W:85px)
@property(strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeCons;

///分时数据
@property(nonatomic, strong) TrendData *trendData;
///五日数据
@property(nonatomic, strong) Stock5DayStatusInfo *fiveDayData;
///买五卖五数据
@property(nonatomic, strong) StockQuotationInfo *quotationInfo;
/// k线数据
@property(nonatomic, strong) KLineDataItemInfo *kLineDataInfo;

//当前展示的页面类型 （0：分时走势 1：五日 2：日线，3：周线 4：月线）
@property(nonatomic) NSInteger pageType;

///分时视图
@property(strong, nonatomic) HorizontalPartTimeVC *partTimeView;
///五日视图
@property(strong, nonatomic) IBOutlet FiveDaysView *fiveDaysView;
///基金净值
@property(strong, nonatomic) HorizontalFundNetValueVC *fundNetValueVC;
// k线视图
@property(strong, nonatomic) IBOutlet LandscapeKLineView *kLineView;

///退出按钮
@property(strong, nonatomic) IBOutlet UIButton *exitButton;

/// k线图选择器
@property(strong, nonatomic) IBOutlet SimuCenterTabView *kLineTypeTabView;

///复权背景视图
@property(strong, nonatomic) IBOutlet UIView *complexRightBackView;
///不复权
@property(strong, nonatomic) IBOutlet UIButton *noComplexRightButton;
///前复权
@property(strong, nonatomic) IBOutlet UIButton *beforeComplexRightButton;
///后复权
@property(strong, nonatomic) IBOutlet UIButton *afterComplexRightButton;
//中间分割线
@property (weak, nonatomic) IBOutlet UIView *grayLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollTopConstraint;
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;

///证券信息
@property(nonatomic, strong) SecuritiesInfo *securitiesInfo;

- (id)initWithSecuritiesInfo:(SecuritiesInfo *)securitiesInfo
               withPageIndex:(NSInteger)pageIndex;

@end
