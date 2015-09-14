//
//  PartTimeView2+controller.m
//  SimuStock
//
//  Created by Mac on 15/6/4.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BasePartTimeVC.h"
#import "CacheUtil+kline.h"
#import "SimuTradeStatus.h"

@implementation FloatWindowViewForPartTime

- (void)awakeFromNib {
  ///设置当空间不足时，自动缩小字体填充
  _timeLabel.adjustsFontSizeToFitWidth = YES;
  _curPriceLabel.adjustsFontSizeToFitWidth = YES;
  _riseValueLabel.adjustsFontSizeToFitWidth = YES;
  _avgPriceLabel.adjustsFontSizeToFitWidth = YES;
  _curAmountLabel.adjustsFontSizeToFitWidth = YES;
}

///显示浮窗数据
- (void)bindPartTimeFloatData:(PartTimeFloatData *)itemInfo {
  //时间
  _timeLabel.text = itemInfo.time;

  _curPriceLabel.text = itemInfo.curPrice;
  _riseValueLabel.text = itemInfo.riseValue;
  _avgPriceLabel.text = itemInfo.avgPrice;

  _curAmountLabel.text = itemInfo.curAmount;

  _curPriceLabel.textColor = itemInfo.color;
  _riseValueLabel.textColor = itemInfo.color;
  _avgPriceLabel.textColor = itemInfo.color;
}

- (void)setFloatWindowStyle {
  self.layer.cornerRadius = 5.f;
  // A thin border.
  self.layer.borderColor = [UIColor whiteColor].CGColor;
  self.layer.borderWidth = 0.3;

  // Drop shadow.
  self.layer.shadowColor = [UIColor blackColor].CGColor;
  self.layer.shadowOpacity = 0.5;
  self.layer.shadowRadius = 3;
  self.layer.shadowOffset = CGSizeMake(0, 2);
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

static CGFloat PartTimeCycleTime = 30.f;

@implementation BasePartTimeVC

- (void)dealloc {
  [timerUtil stopTimer];
}

- (id)initWithFrame:(CGRect)frame
 withSecuritiesInfo:(SecuritiesInfo *)securitiesInfo {
  if (self = [super initWithFrame:frame]) {
    self.securitiesInfo = securitiesInfo;

    __weak BasePartTimeVC *weakSelf = self;
    timerUtil = [[TimerUtil alloc]
        initWithTimeInterval:PartTimeCycleTime
            withTimeCallBack:^{
              //如果无网络，则什么也不做；
              if (![SimuUtil isExistNetwork]) {
                return;
              }
              //如果当前交易所状态为闭市，则什么也不做
              if ([[SimuTradeStatus instance] getExchangeStatus] ==
                  TradeClosed) {
                return;
              }

              [weakSelf requestResponseWithRefreshType:RefreshTypeTimerRefresh];
            }];
  }
  return self;
}

- (void)resetWithFrame:(CGRect)frame
    withSecuritiesInfo:(SecuritiesInfo *)securitiesInfo {
  [super resetWithFrame:frame withSecuritiesInfo:securitiesInfo];
  self.partTimeView.frame = self.view.bounds;
  self.partTimeView.securitiesInfo = self.securitiesInfo;
}

- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {
  if (![self dataBinded]) {
    // load cache
    NSString *stockCode = self.securitiesInfo.securitiesCode();
    NSString *firstType = self.securitiesInfo.securitiesFirstType();
    TrendData *trendData =
        [CacheUtil loadTrendDataWithStockCode:stockCode firstType:firstType];
    [self.partTimeView setTrendData:trendData
                     securitiesInfo:self.securitiesInfo];
  }
  [TrendData getStockTrendInfo:self.securitiesInfo.securitiesCode()
                withStartIndex:@"1"
                  withCallback:callback];
}

- (void)bindRequestObject:(NSObject<Collectionable> *)latestData
    withRequestParameters:(NSDictionary *)parameters
          withRefreshType:(RefreshType)refreshType {
  TrendData *trendData = (TrendData *)latestData;
  [self.partTimeView setTrendData:trendData securitiesInfo:self.securitiesInfo];

  // save to cache
  NSString *stockCode = self.securitiesInfo.securitiesCode();
  NSString *firstType = self.securitiesInfo.securitiesFirstType();
  trendData.stockcode = stockCode;
  [CacheUtil saveTrendData:trendData firstType:firstType];
}

- (void)clearView {
  [self.partTimeView clearView];
}

- (BOOL)dataBinded {
  return self.partTimeView.trendDataPage.dataBinded;
}

@end

/*
 *  竖屏分时
 */
@implementation PortaitPartTimeVC

- (void)viewDidLoad {
  [super viewDidLoad];

  ///添加分时趋势图
  self.partTimeView = [[PartTimeView alloc] initWithFrame:self.view.bounds];
  self.partTimeView.securitiesInfo = self.securitiesInfo;
  self.partTimeView.isHorizontalMode = NO;
  self.partTimeView.backgroundColor = [UIColor clearColor];
  [self.view addSubview:self.partTimeView];

  [self setFloatWindowView];
}

- (void)resetWithFrame:(CGRect)frame
    withSecuritiesInfo:(SecuritiesInfo *)securitiesInfo {
  [super resetWithFrame:frame withSecuritiesInfo:securitiesInfo];
  self.partTimeView.securitiesInfo = self.securitiesInfo;
  self.partTimeView.frame = self.view.bounds;
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

  __weak PortaitPartTimeVC *weakSelf = self;
  self.partTimeView.onPartTimeSelected = ^(PartTimeFloatData *fundNav) {
    if (fundNav) {
      if (fundNav.index > fundNav.range / 2) {
        weakSelf.floatWindowView.frame =
            CGRectMake(CommonMarginFloatWindowView, CommonMarginFloatWindowView,
                       windowWidth, windowHeight);
      } else {
        weakSelf.floatWindowView.frame =
            CGRectMake(weakSelf.partTimeView.bounds.size.width -
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

///头部浮窗的高度
static CGFloat TopFloatWindowHeight = 37.f;
static CGFloat PartTimeTradeViewWidth = 102.f;
static CGFloat PartTimeTradeViewMarginLeft = 10.f;

/*
 *  横屏分时
 */
@implementation HorizontalPartTimeVC

- (void)viewDidLoad {
  [super viewDidLoad];

  ///添加分时趋势图
  [self createPartTimeView];
  [self createFloatWindowView];
}

- (BOOL)isIndex {
  NSString *firstType = self.securitiesInfo.securitiesFirstType();
  return [StockUtil isMarketIndex:firstType];
}

- (CGRect)partTimeViewFrame {
  return self.isIndex
             ? CGRectMake(0, TopFloatWindowHeight, self.view.width - 16,
                          self.view.height - TopFloatWindowHeight)
             : CGRectMake(0, TopFloatWindowHeight,
                          self.view.width - 16 - PartTimeTradeViewWidth -
                              PartTimeTradeViewMarginLeft,
                          self.view.height - TopFloatWindowHeight);
}

- (CGRect)partTimeTradeViewFrame {
  return self.isIndex
             ? CGRectZero
             : CGRectMake(self.view.width - PartTimeTradeViewWidth,
                          TopFloatWindowHeight, PartTimeTradeViewWidth,
                          self.view.height - TopFloatWindowHeight);
}

- (void)createPartTimeView {
  self.view.backgroundColor = [UIColor clearColor];

  //分时视图
  self.partTimeView =
      [[PartTimeView alloc] initWithFrame:[self partTimeViewFrame]];
  self.partTimeView.securitiesInfo = self.securitiesInfo;
  self.partTimeView.isHorizontalMode = YES;
  self.partTimeView.backgroundColor = [UIColor clearColor];
  self.partTimeView.passTimeLabelText = self.passTimeLabelText;
  [self.view addSubview:self.partTimeView];

  //五档
  self.partTimeTradeVC =
      [[PartTimeTradeVC alloc] initWithFrame:[self partTimeTradeViewFrame]
                          withSecuritiesInfo:self.securitiesInfo];
  self.partTimeTradeVC.stockQuotationInfoReady = self.stockQuotationInfoReady;
  self.partTimeTradeVC.view.backgroundColor = [UIColor clearColor];
  [self.view addSubview:self.partTimeTradeVC.view];
  [self addChildViewController:self.partTimeTradeVC];
  self.partTimeTradeVC.view.hidden = self.isIndex;

  __weak HorizontalPartTimeVC *weakSelf = self;
  self.partTimeView.onPartTimeSelected = ^(PartTimeFloatData *fundNav) {
    HorizontalPartTimeVC *strongSelf = weakSelf;
    if (!strongSelf) {
      return;
    }
    if (strongSelf.floatWindowView == nil) {
      [strongSelf createFloatWindowView];
    }
    if (fundNav) {
      strongSelf.floatWindowView.hidden = NO;
      [strongSelf.floatWindowView bindPartTimeFloatData:fundNav];
    } else {
      strongSelf.floatWindowView.hidden = YES;
    }

    [[NSNotificationCenter defaultCenter]
        postNotificationName:LandscapeSegmentShouldHideNotification
                      object:@(fundNav != nil)];
  };
}

- (void)createFloatWindowView {
  [self.floatWindowView removeFromSuperview];
  ///添加浮窗
  NSString *firstType = self.securitiesInfo.securitiesFirstType();
  BOOL isIndex = [StockUtil isMarketIndex:firstType];

  NSString *nibName =
      isIndex ? @"IndexTopWindow4PartTimeView" : @"TopWindow4PartTimeView";
  self.floatWindowView = [[[NSBundle mainBundle] loadNibNamed:nibName
                                                        owner:nil
                                                      options:nil] firstObject];
  self.floatWindowView.frame =
      CGRectMake(0, 0, self.view.bounds.size.width, TopFloatWindowHeight);

  self.floatWindowView.hidden = YES;
  self.floatWindowView.backgroundColor =
      [Globle colorFromHexRGB:Color_BG_Common];
  [self.view addSubview:self.floatWindowView];
}

@end
