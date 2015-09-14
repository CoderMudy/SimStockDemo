//
//  BaseFiveDaysVC.m
//  SimuStock
//
//  Created by Mac on 15/6/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseFiveDaysVC.h"
#import "CacheUtil+kline.h"

@implementation BaseFiveDaysVC

- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {
  if (![self dataBinded]) {
    Stock5DayStatusInfo *kLineDataInfo = [CacheUtil
        load5DaysDataWithStockCode:self.securitiesInfo.securitiesCode()
                         firstType:self.securitiesInfo.securitiesFirstType()];
    if (kLineDataInfo) {
      [_fiveDaysView setStock5DaysData:kLineDataInfo
                          isIndexStock:self.isMarketIndex];
    }
  }
  [Stock5DayStatusInfo
      getStock5DayStatusWithStockCode:self.securitiesInfo.securitiesCode()
                         withCallback:callback];
}

- (BOOL)isMarketIndex {
  return [StockUtil isMarketIndex:self.securitiesInfo.securitiesFirstType()];
}

- (void)bindRequestObject:(NSObject<Collectionable> *)latestData
    withRequestParameters:(NSDictionary *)parameters
          withRefreshType:(RefreshType)refreshType {
  self.dataArray.dataBinded = YES;
  Stock5DayStatusInfo *info = (Stock5DayStatusInfo *)latestData;
  info.stockcode = self.securitiesInfo.securitiesCode();
  [CacheUtil save5DaysData:info
                 firstType:self.securitiesInfo.securitiesFirstType()];
  //显示分时，需要区分用户当前在哪个页面
  [_fiveDaysView setStock5DaysData:info isIndexStock:self.isMarketIndex];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.fiveDaysView =
      [[FiveDaysView alloc] initWithFrame:self.view.bounds isLandScape:NO];
  [self.view addSubview:self.fiveDaysView];
}

- (void)clearView {
  [self.fiveDaysView clearView];
}

@end

///浮窗左边距、右边距、上边距
static CGFloat CommonMarginFloatWindowView = 10.f;

///股票、基金建议的窗口大小
static CGFloat AdviseWidthFloatWindowView = 84.f;
static CGFloat AdviseHeightFloatWindowView = 80.f;

///指数建议的窗口大小
static CGFloat IndexAdviseWidthFloatWindowView = 90.f;
static CGFloat IndexAdviseHeightFloatWindowView = 64.f;

@implementation PortaitFiveDaysVC

- (void)viewDidLoad {
  [super viewDidLoad];

  [self setFloatWindowView];
}

- (void)resetWithFrame:(CGRect)frame
    withSecuritiesInfo:(SecuritiesInfo *)securitiesInfo {
  [super resetWithFrame:frame withSecuritiesInfo:securitiesInfo];
  [self setFloatWindowView];
}

- (BOOL)isIndex {
  NSString *firstType = self.securitiesInfo.securitiesFirstType();
  return [StockUtil isMarketIndex:firstType];
}

- (void)setFloatWindowView {
  [self.floatWindowView removeFromSuperview];
  ///添加浮窗

  CGFloat windowWidth = self.isIndex ? IndexAdviseWidthFloatWindowView
                                     : AdviseWidthFloatWindowView;
  CGFloat windowHeight = self.isIndex ? IndexAdviseHeightFloatWindowView
                                      : AdviseHeightFloatWindowView;

  NSString *nibName = self.isIndex ? @"IndexFloatWindow4PartTimeView"
                                   : @"FloatWindow4PartTimeView";
  self.floatWindowView = [[[NSBundle mainBundle] loadNibNamed:nibName
                                                        owner:nil
                                                      options:nil] firstObject];

  self.floatWindowView.hidden = YES;
  [self.floatWindowView setFloatWindowStyle];
  [self.view addSubview:self.floatWindowView];

  __weak PortaitFiveDaysVC *weakSelf = self;
  self.fiveDaysView.onPartTimeSelected = ^(PartTimeFloatData *fundNav) {
    if (fundNav) {
      if (fundNav.index > fundNav.range / 2) {
        weakSelf.floatWindowView.frame =
            CGRectMake(CommonMarginFloatWindowView, CommonMarginFloatWindowView,
                       windowWidth, windowHeight);
      } else {
        weakSelf.floatWindowView.frame =
            CGRectMake(weakSelf.fiveDaysView.bounds.size.width -
                           CommonMarginFloatWindowView - windowWidth,
                       CommonMarginFloatWindowView, windowWidth, windowHeight);
      }
      weakSelf.floatWindowView.hidden = NO;
      [weakSelf.floatWindowView bindPartTimeFloatData:fundNav];
    } else {
      weakSelf.floatWindowView.hidden = YES;
    }
  };
}

@end
