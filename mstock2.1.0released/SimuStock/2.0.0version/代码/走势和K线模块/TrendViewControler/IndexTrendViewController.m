//
//  IndexTrendViewController.m
//  SimuStock
//
//  Created by Mac on 15/5/27.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "IndexTrendViewController.h"
#import "LandscapeKLineViewController.h"

@implementation IndexTrendViewController

- (id)initWidthCode:(NSString *)code firstType:(NSString *)firstType {
  self = [super init];
  if (self) {
    if (code != Nil) {
      _toView = nil;
      _fromView = nil;
      _pageType = 0;
      _stockCode = [StockUtil eightStockCode:code];
      _waitConter = [[SimuWaitCounter alloc] init];
    }
  }
  return self;
}

- (void)resetWithCode:(NSString *)code firstType:(NSString *)firstType {
  if ([code isEqualToString:_stockCode]) {
    return;
  }
  [self cearlAllTrendData];

  _stockCode = [StockUtil eightStockCode:code];

  CGSize newSize = CGSizeMake(self.view.frame.size.width, 345 + 690);
  [_scrollView setContentSize:newSize];

  [self resetAllControlViewPos:YES];

  ///初始化，分时，日线，周线，月线
  [self initDayWeekMonthData:_pageType];
  //下载所有数据
  [self performSelector:@selector(getInitDataFromNet)
             withObject:nil
             afterDelay:0.1];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self initTrendTimer];
  [self performSelector:@selector(creatallViews) withObject:nil afterDelay:0.1];
}

- (void)refreshData {
  [self performSelector:@selector(getInitDataFromNet)
             withObject:nil
             afterDelay:0.1];
}

#pragma mark
#pragma mark 定时器相关函数
//创建定时器
- (void)initTrendTimer {
  //得到刷新数据
  NSInteger refreshTime = [SimuUtil getCorRefreshTime];
  if (refreshTime == 0)
    return;
  _timeinterval = refreshTime;
  _timer = [NSTimer scheduledTimerWithTimeInterval:_timeinterval
                                            target:self
                                          selector:@selector(KLineHandleTimer:)
                                          userInfo:nil
                                           repeats:YES];
}

//定时器回调函数
- (void)KLineHandleTimer:(NSTimer *)theTimer {
  if (_timer == theTimer) {

    //如果无网络，则什么也不做；
    if (![SimuUtil isExistNetwork]) {
      return;
    }

    //是否是闭市状态
    BOOL isTradeClosed =
        [[SimuTradeStatus instance] getExchangeStatus] == TradeClosed;
    //刷新市场风向标等数据
    [_indexStockWindVaneView updateDatas:isTradeClosed];

    //如果当前交易所状态为闭市，则什么也不做
    if (isTradeClosed) {
      return;
    }

    //下载走势数据
    if (_pageType == 0) {
      [self getInitDataFromNet];
    } else {
      [self getStockQuotationWithFivePriceDataFromNet:_stockCode];
    }
  }
}

//定时器停止
- (void)stopMyTimer {
  if (_timer != nil) {
    if ([_timer isValid]) {
      [_timer invalidate];
      _timer = nil;
      // NSLog(@"[iFreshTimer invalidate];");
    }
  }
}

#pragma mark
#pragma mark 创建控件
- (void)creatallViews {
  [self creatScrollView];
  [self creatStockHeadInfo];
  [self creatTabViews];
  [self creatBaseView];
  [self creatTrendViews];

  //创建股市风向标
  [self createIndexStockWindVaneView];

  [self creatFloatView];
  //初始化，分时，日线，周线，月的数据
  [self initDayWeekMonthData:0];
  //  [self getInitDataFromNet];
}
//初始化，分时，日线，周线，月的数据
- (void)initDayWeekMonthData:(NSInteger)lastIndex {
  [self tabSelected:0];
  for (int i = 3; i >= 0; i--) {
    if (i == lastIndex && i != 0) {
      [self tabSelected:i];
    }
  }
}
//创建滚动页面
- (void)creatScrollView {
  _newsize = 345 + 690;
  //  _newsize = (15 + (534 + 410 + 360) / 2) + 120 + 25.5 + 205 + 17; //1034.5
  _scrollView = [[UIScrollView alloc]
      initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,
                               self.view.bounds.size.height)];
  _scrollView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  _scrollView.showsVerticalScrollIndicator = YES;
  CGSize newSize = CGSizeMake(self.view.frame.size.width, _newsize);

  [_scrollView setContentSize:newSize]; // 320 1034.5
  [self.view addSubview:_scrollView];
}

//创建个股报价控件
- (void)creatStockHeadInfo {
  _topStockInfoView = [[TopStockInfoView alloc]
      initWithFrame:CGRectMake(5, 0, self.view.bounds.size.width - 10, 137)
             IsDapa:YES];
  [_scrollView addSubview:_topStockInfoView];

  _topStockInfoView.frame =
      CGRectMake(5, 0, self.view.bounds.size.width - 10, 120);
}

//创建走势，日线的切换Tab小控件
- (void)creatTabViews {
  NSArray *array = @[ @"分时", @"五日", @"日线", @"周线", @"月线" ];
  _centerTabView = [[SimuCenterTabView alloc]
      initWithFrame:CGRectMake(5, _topStockInfoView.frame.origin.y +
                                      _topStockInfoView.frame.size.height + 1,
                               self.view.bounds.size.width - 10, 25.5)
         titleArray:array];
  _centerTabView.delegate = self;
  [_scrollView addSubview:_centerTabView];
}

//创建走势和K线的基本承载页面
- (void)creatBaseView {
  _trendBaseView = [[UIView alloc]
      initWithFrame:CGRectMake(0, _centerTabView.frame.origin.y +
                                      _centerTabView.frame.size.height + 10,
                               self.view.bounds.size.width, 340 / 2 + 17)];
  _trendBaseView.backgroundColor = [UIColor clearColor];
  [_scrollView addSubview:_trendBaseView];

  //点按弹出横屏视图
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
      initWithTarget:self
              action:@selector(showLandscapeKLineVC)];
  [_trendBaseView addGestureRecognizer:tap];
}

#pragma mark ⭐️弹出横屏K线
- (void)showLandscapeKLineVC {
  LandscapeKLineViewController *landscapeVC =
      [[LandscapeKLineViewController alloc] init];
  landscapeVC.trendData = _trendData;
  landscapeVC.isIndexStock = YES;
  landscapeVC.quotationInfo = _quotationInfo;
  landscapeVC.stockCode = _stockCode;
  landscapeVC.pageType = _pageType;
  landscapeVC.kLineDataInfo = _kLineDataInfo;
  landscapeVC.fiveDayData = _fiveDayData;
  [AppDelegate pushViewControllerFromBottom:landscapeVC];
}

//创建走势页面，加载后初始化创建
- (void)creatTrendViews {
  if (_trendView == nil) {
    _trendView =
        [[TrendView alloc] initWithFrame:_trendBaseView.bounds isIndexStock:NO];
    _trendView.tag = 0;
    [_trendBaseView addSubview:_trendView];
    _fromView = _trendView;
  } else {
    _trendView.frame = _trendBaseView.bounds;
  }
}

//创建并激活走势
- (void)creatOrActiveTrendView {
  if (_trendView == nil) {
    _trendView =
        [[TrendView alloc] initWithFrame:_trendBaseView.bounds isIndexStock:NO];
    _trendView.tag = 0;
    [_trendBaseView addSubview:_trendView];
  }
  _trendView.frame = _trendBaseView.bounds;
  _fromView.hidden = YES;
  _trendView.hidden = NO;
  _fromView = _trendView;
  [_trendBaseView bringSubviewToFront:_trendView];
  [self getInitDataFromNet];
}

//创建并激活五日
- (void)creatOrActiveFiveDaysView {

  if (!_fiveDaysView) {
    _fiveDaysView =
        [[FiveDaysSmallView alloc] initWithFrame:_trendBaseView.bounds];
    _fiveDaysView.tag = 1;
    [_trendBaseView addSubview:_fiveDaysView];
  }
  _fiveDaysView.frame = _trendBaseView.bounds;
  _fromView.hidden = YES;
  _fiveDaysView.hidden = NO;
  _fromView = _fiveDaysView;
  [_trendBaseView bringSubviewToFront:_fiveDaysView];
  [self getStock5DayStatus];
}

//创建并激活日K走势
- (void)creatOrActiveDayKLineView {
  if (_dayKLineView == nil) {
    _dayKLineView = [[KLineView alloc] initWithFrame:_trendBaseView.bounds];
    _dayKLineView.tag = 2;
    [_trendBaseView addSubview:_dayKLineView];
  }
  _dayKLineView.frame = _trendBaseView.bounds;
  _fromView.hidden = YES;
  _dayKLineView.hidden = NO;
  _fromView = _dayKLineView;
  [_trendBaseView bringSubviewToFront:_dayKLineView];

  if (!_dayKLineView.isDownLoaded) {
    [self getStockKLineDataFromNet:_stockCode Type:@"D"];
  }
}
//创建并激活周K走势
- (void)creatOrActiveweekKLineView {
  if (_weekKLineView == nil) {
    _weekKLineView = [[KLineView alloc] initWithFrame:_trendBaseView.bounds];
    _weekKLineView.tag = 3;
    [_trendBaseView addSubview:_weekKLineView];
  }
  _weekKLineView.frame = _trendBaseView.bounds;
  _fromView.hidden = YES;
  _weekKLineView.hidden = NO;
  _fromView = _weekKLineView;
  [_trendBaseView bringSubviewToFront:_weekKLineView];
  if (!_weekKLineView.isDownLoaded) {
    [self getStockKLineDataFromNet:_stockCode Type:@"W"];
  }
}
//创建并激活月K走势
- (void)creatOrActiveMonthKLineView {
  if (_monthKLineView == nil) {
    _monthKLineView = [[KLineView alloc] initWithFrame:_trendBaseView.bounds];
    _monthKLineView.tag = 4;
    [_trendBaseView addSubview:_monthKLineView];
  }
  _monthKLineView.frame = _trendBaseView.bounds;
  _fromView.hidden = YES;
  _monthKLineView.hidden = NO;
  _fromView = _monthKLineView;
  [_trendBaseView bringSubviewToFront:_monthKLineView];

  if (!_monthKLineView.isDownLoaded) {
    [self getStockKLineDataFromNet:_stockCode Type:@"M"];
  }
  //[self getKlineDataWithPaketFormNet:_stockCode KLineType:@"M"];
}

///创建指数股市场风向标
- (void)createIndexStockWindVaneView {
  if (!_indexStockWindVaneView) {
    _indexStockWindVaneView = [[IndexStockWindVaneView alloc]
        initWithFrame:CGRectMake(0, 345, 320, 690)];
    [_scrollView addSubview:_indexStockWindVaneView];
  }
}

//创建浮窗控件
- (void)creatFloatView {
  //创建走势浮窗控件
  CGRect test = CGRectMake(0, 0, 150, 200);
  _floatView = [[TrendFloatView alloc] initWithFrame:test
                                     ForReciveMsgTye:Type_TREND_TO_FloatView];
  [_trendBaseView addSubview:_floatView];

  _klfloatView = [[TrendFloatView alloc] initWithFrame:test
                                       ForReciveMsgTye:Type_KLine_TO_FloatView];
  [_trendBaseView addSubview:_klfloatView];
}

#pragma mark
#pragma mark simuCenterTabViewDelegate 分时和K线，周线切换函数协议
- (void)tabSelected:(NSInteger)index {
  if (index == 0) {
    //切换到走势页面
    _pageType = 0;
    [self creatOrActiveTrendView];
  } else if (index == 1) {
    //切换到五日页面
    _pageType = 1;
    [self creatOrActiveFiveDaysView];
  } else if (index == 2) {
    //切换到日K页面
    _pageType = 2;
    [self creatOrActiveDayKLineView];
  } else if (index == 3) {
    // 切换到周K页面
    _pageType = 3;
    [self creatOrActiveweekKLineView];
  } else if (index == 4) {
    //切换到月K页面
    _pageType = 4;
    [self creatOrActiveMonthKLineView];
  }
  [self hideTrendFloatViews];
}
#pragma mark
#pragma mark 功能函数
//走势页面浮窗消息
- (void)hideTrendFloatViews {
  if (_trendView) {
    [_trendView HideFloatView];
  }
  if (_dayKLineView) {
    [_dayKLineView hideFloatView];
  }
  if (_weekKLineView) {
    [_weekKLineView hideFloatView];
  }
  if (_monthKLineView) {
    [_monthKLineView hideFloatView];
  }
}
/**
 * 设置无网络小牛
 */
- (void)setNoNetwork {
  [NewShowLabel showNoNetworkTip];
}

- (void)stopLoading {
  [_waitConter reduceCounter];
  if ([_waitConter isCanStop]) {
    [_indicatorView stopAnimating];
  }
}
//当切换了个股和大盘股票后，重新设定页面各个股票的位置
- (void)resetAllControlViewPos:(BOOL)isDapan {
  if (isDapan) {
    //大盘
    _topStockInfoView.frame =
        CGRectMake(5, 0, self.view.bounds.size.width - 10, 120);

  } else {
    //个股
    _topStockInfoView.frame =
        CGRectMake(5, 0, self.view.bounds.size.width - 10, 137);
  }
  _centerTabView.frame =
      CGRectMake(5, _topStockInfoView.frame.origin.y +
                        _topStockInfoView.frame.size.height + 1,
                 self.view.bounds.size.width - 10, 25.5);
  if (isDapan) {
    _trendBaseView.frame =
        CGRectMake(0, _centerTabView.frame.origin.y +
                          _centerTabView.frame.size.height + 10,
                   self.view.bounds.size.width, 340 / 2 + 17);

  } else {
    _trendBaseView.frame =
        CGRectMake(0, _centerTabView.frame.origin.y +
                          _centerTabView.frame.size.height + 10,
                   self.view.bounds.size.width, 340 / 2 + 17);
  }
  NSLog(@"高度：%f,%f", _topStockInfoView.height, _trendBaseView.height);
}

#pragma mark ⭐️网络函数
//取得初始化数据
- (void)getInitDataFromNet {
  //分时走势
  [self getTrendDataFromNet:_stockCode];
  //五档买卖数据
  [self getStockQuotationWithFivePriceDataFromNet:_stockCode];
}

#pragma mark 联网取得分时走势
- (void)getTrendDataFromNet:(NSString *)stockCode {
  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    return;
  }
  __weak IndexTrendViewController *weakSelf = self;
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onCheckQuitOrStopProgressBar = ^{
    IndexTrendViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *object) {
    IndexTrendViewController *strongSelf = weakSelf;
    if (strongSelf) {
      TrendData *data = (TrendData *)object;
      _trendData = data;
      if (_trendView) {
        //分时数据绑定
        [_trendView setTrendData:(TrendData *)data isIndexStock:YES];
        //给partTimeView发送趋势图更新数据通知
        [[NSNotificationCenter defaultCenter]
            postNotificationName:LandscapeTrendDataNotification
                          object:@[ data, @(YES) ]
                        userInfo:nil];
      }
    }
  };

  callback.onFailed = ^() {
    [self setNoNetwork];
  };

  [_indicatorView startAnimating];
  [_waitConter addCounter];
  [TrendData getStockTrendInfo:stockCode
                withStartIndex:@"1"
                  withCallback:callback];
}

#pragma mark 取得包含买卖五档的个股报价
- (void)getStockQuotationWithFivePriceDataFromNet:(NSString *)stockCode {
  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    return;
  }
  __weak IndexTrendViewController *weakSelf = self;
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onCheckQuitOrStopProgressBar = ^{
    IndexTrendViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *object) {
    IndexTrendViewController *strongSelf = weakSelf;
    if (strongSelf) {
      StockQuotationInfo *data = (StockQuotationInfo *)object;
      _quotationInfo = data;
      if (_topStockInfoView) {
        //设定个股报价
        [_topStockInfoView setHeadStcokInfo:data IsDapan:YES];
        //添加block，从其他分页进入时刷新股票价格和涨幅
        _topStockInfoBlock();
      }
      if (_trendView != nil) {
        //买五卖五数据
        [_trendView setStockPage:data];
      }
      //给LandscapeKLineViewController发送买5卖5数据更新通知
      [[NSNotificationCenter defaultCenter]
          postNotificationName:LandscapeS5B5DataNotification
                        object:data
                      userInfo:nil];
    }
  };

  callback.onFailed = ^() {
    [self setNoNetwork];
  };

  [_indicatorView startAnimating];
  [_waitConter addCounter];
  [StockQuotationInfo getStockQuotaWithFivePriceInfo:stockCode
                                        withCallback:callback];
}
#pragma mark 取得个股5日分时
- (void)getStock5DayStatus {
  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    return;
  }

  __weak IndexTrendViewController *weakSelf = self;
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onCheckQuitOrStopProgressBar = ^{
    IndexTrendViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *object) {
    IndexTrendViewController *strongSelf = weakSelf;
    if (strongSelf) {
      Stock5DayStatusInfo *info = (Stock5DayStatusInfo *)object;
      _fiveDayData = info;
      //显示分时，需要区分用户当前在哪个页面
      [_fiveDaysView setStock5DaysData:info isIndexStock:YES];
    }
  };

  [_indicatorView startAnimating];
  [_waitConter addCounter];
  [Stock5DayStatusInfo getStock5DayStatusWithStockCode:_stockCode
                                          withCallback:callback];
}

#pragma mark 取得（日，周，月）K线数据
- (void)getStockKLineDataFromNet:(NSString *)stockCode Type:(NSString *)type {

  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    return;
  }
  __weak IndexTrendViewController *weakSelf = self;
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onCheckQuitOrStopProgressBar = ^{
    IndexTrendViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *object) {
    IndexTrendViewController *strongSelf = weakSelf;
    if (strongSelf) {
      KLineDataItemInfo *data = (KLineDataItemInfo *)object;
      _kLineDataInfo = data;
      if ([type isEqualToString:@"D"] == YES) {
        //日线
        if (_dayKLineView) {
          [_dayKLineView setPageData:data];
        }
      }
      if ([type isEqualToString:@"W"] == YES) {
        //周线
        if (_weekKLineView) {
          [_weekKLineView setPageData:data];
        }
      } else if ([type isEqualToString:@"M"] == YES) {
        //月线
        if (_monthKLineView) {
          [_monthKLineView setPageData:data];
        }
      }
    }
  };

  callback.onFailed = ^() {
    [self setNoNetwork];
  };

  [_indicatorView startAnimating];
  [_waitConter addCounter];
  [KLineDataItemInfo getKLineTypesInfo:stockCode
                                  type:type
                              xrdrType:@"0"
                          withCallback:callback];
}
#pragma mark
#pragma mark 对外接口
//取得当前价格
- (NSString *)getNewPrice {
  if (_topStockInfoView) {
    return [_topStockInfoView getNewPrice];
  }
  return nil;
}
//取得涨跌幅
- (NSString *)getProfit {
  if (_topStockInfoView) {
    return [_topStockInfoView getProfit];
  }
  return nil;
}
//取得涨跌额
- (NSString *)getUpDownPrice {
  if (_topStockInfoView) {
    return [_topStockInfoView getUpDownPrice];
  }
  return nil;
}

//清理当前数据
- (void)cearlAllTrendData {
  if (_trendView) {
    [_trendView clearAllData];
  }
  if (_topStockInfoView) {
    [_topStockInfoView clearallData];
  }
  if (_dayKLineView) {
    [_dayKLineView clearAllData];
  }
  if (_weekKLineView) {
    [_weekKLineView clearAllData];
  }
  if (_monthKLineView) {
    [_monthKLineView clearAllData];
  }
}

- (UIScrollView *)getScrollView {
  if (_scrollView) {
    return _scrollView;
  }
  return nil;
}

@end
