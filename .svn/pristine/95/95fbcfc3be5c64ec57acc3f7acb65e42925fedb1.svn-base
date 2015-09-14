//
//  LandscapeKLineVIewController.m
//  SimuStock
//
//  Created by Yuemeng on 15/4/13.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "LandscapeKLineViewController.h"
#import "CacheUtil+kline.h"
#import "FundCurStatus.h"

@interface LandscapeKLineViewController () {
  __weak id _observerSegmentHide;
  __weak id _observerExit;
  __weak id _observerS5B5Data;

  NSString *priceFormat;
}

@end

@implementation LandscapeKLineViewController {
  CGRect _trendViewframe;
}

- (id)initWithSecuritiesInfo:(SecuritiesInfo *)securitiesInfo withPageIndex:(NSInteger)pageIndex {
  if (self = [super initWithFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN, HEIGHT_OF_SCREEN)]) {
    self.securitiesInfo = securitiesInfo;
    self.pageType = pageIndex;
  }
  return self;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:_observerSegmentHide];
  [[NSNotificationCenter defaultCenter] removeObserver:_observerExit];
  [[NSNotificationCenter defaultCenter] removeObserver:_observerS5B5Data];
  NSLog(@"横屏K线页面释放");
}

static CGFloat MarginLeftRight = 8.f;
static CGFloat MarginTop = 37.f;
static CGFloat MarginBottom = 5.f;

- (void)viewDidLoad {
  [super viewDidLoad];

  [[NewShowLabel newShowLabel] landscapeStyle:YES];

  NSString *firstType = _securitiesInfo.securitiesFirstType();
  priceFormat = [StockUtil getPriceFormatWithFirstType:firstType];
  [UIApplication sharedApplication].statusBarHidden = YES;
  self.view.transform = CGAffineTransformMakeRotation(M_PI / 2);
  [self initVariables];
  [self createUI];

  //注册消息通知
  [self registingNotification];

  NSString *stockNameAndCode =
      [_securitiesInfo.securitiesName() stringByAppendingString:[StockUtil sixStockCode:self.stockCode]];
  _stockNameLabel.text = stockNameAndCode;
  _stockPriceLabel.text = @"";
  _dealVolumeLabel.text = @"";

  //根据传进来的数据决定显示页面
  NSInteger tempPageType = _pageType;
  [SimuUtil performBlockOnMainThread:^{
    [self tabSelected:0]; //先显示分时图，触发时间显示逻辑，然后切换至指定的页面
    [_kLineTypeTabView buttonSelected:tempPageType];
  } withDelaySeconds:.1f];
}

- (void)bindCurStatus:(NSObject *)obj {
  if ([obj isKindOfClass:[StockQuotationInfo class]]) {
    _quotationInfo = (StockQuotationInfo *)obj;
  } else if ([obj isKindOfClass:[FundCurStatusWrapper class]]) {
    _quotationInfo = ((FundCurStatusWrapper *)obj).stockQuotationInfo;
  }
  if (_quotationInfo) {
    [self setCurrentInfo];
  }
}

#pragma mark - 设置当前股票信息，数据在返回买5卖5时数据时绑定
- (void)setCurrentInfo {
  //股票名称和代码
  [_quotationInfo.dataArray enumerateObjectsUsingBlock:^(PacketTableData *data, NSUInteger idx, BOOL *stop) {
    if ([data.tableName isEqualToString:@"CurStatus"]) {
      *stop = YES;
      NSDictionary *dic = data.tableItemDataArray.firstObject;
      NSString *stockNameAndCode = [dic[@"name"] stringByAppendingString:[NSString stringWithFormat:@" %@", dic[@"stockCode"]]];
      _stockNameLabel.text = stockNameAndCode;
      //股票当前价格
      //昨收价格
      _lastClosePrice = [dic[@"closePrice"] floatValue];
      self.securitiesInfo.otherInfoDic[LastClosePriceKey] = [@(_lastClosePrice) stringValue];
      float curPrice = [dic[@"curPrice"] floatValue];
      _stockPriceLabel.text = [NSString stringWithFormat:priceFormat, curPrice];
      _stockPriceLabel.textColor = (curPrice == 0.0f)
                                       ? [Globle colorFromHexRGB:Color_Text_Common]
                                       : [StockUtil getColorByFloat:(curPrice - _lastClosePrice)];
      //总成交量
      int64_t volume = [dic[@"totalAmount"] longLongValue];

      NSString *volumeStr = [@"成交 "
          stringByAppendingString:[StockUtil handsStringFromVolume:volume needsHand:YES]];
      _dealVolumeLabel.attributedText = [SimuUtil attributedString:volumeStr
                                                             color:[Globle colorFromHexRGB:COLOR_KLINE_INFO_TITLE]
                                                             range:NSMakeRange(0, 2)];
    }
  }];

  //根据内容调整label大小
  _stockNameCons.constant = [SimuUtil widthNeededOfLabel:_stockNameLabel font:Font_Height_15_0];
  _stockPriceCons.constant = [SimuUtil widthNeededOfLabel:_stockPriceLabel font:Font_Height_15_0];
  _dealVolumeCons.constant = [SimuUtil widthNeededOfLabel:_dealVolumeLabel font:Font_Height_15_0];
  _timeCons.constant = [SimuUtil widthNeededOfLabel:_timeLabel font:Font_Height_15_0];
}

- (void)initVariables {
  _partTimeView.securitiesInfo = _securitiesInfo;

  _kLineType = @"D";
  _xrdrType = @"0";
}

- (void)createUI {
  //初始化分时等切换视图
  _kLineTypeTabView = [[SimuCenterTabView alloc]
      initWithFrame:CGRectMake(6, 37, HEIGHT_OF_SCREEN - 6 * 2, 29)
         titleArray:
             @[ @"分时", @"五日", @"日线", @"周线", @"月线", @"5分", @"15分", @"30分", @"60分" ]];
  UIButton *button = ((UIButton *)_kLineTypeTabView.buttonArray[1]);
  NSString *title = self.isFund ? @"净值" : @"五日";

  [button setTitle:title forState:UIControlStateNormal];
  [button setTitle:title forState:UIControlStateHighlighted];

  _kLineTypeTabView.delegate = self;
  [self.view addSubview:_kLineTypeTabView];

  //复权背景视图
  _complexRightBackView.layer.borderColor = [[Globle colorFromHexRGB:Color_Border] CGColor];
  _complexRightBackView.layer.borderWidth = 0.5f;

  //  //根据是否是指数股来决定10个指标按钮的背景图大小
  _scrollTopConstraint.constant = (self.isIndexStock || self.isFund ? 0 : 90);
  _noComplexRightButton.hidden = self.isIndexStock || self.isFund;
  _beforeComplexRightButton.hidden = self.isIndexStock || self.isFund;
  _afterComplexRightButton.hidden = self.isIndexStock || self.isFund;
  _grayLine.hidden = self.isIndexStock || self.isFund;
}

- (BOOL)isFund {
  return [StockUtil isFund:_securitiesInfo.securitiesFirstType()];
}

- (BOOL)isIndexStock {
  return [StockUtil isMarketIndex:_securitiesInfo.securitiesFirstType()];
}

#pragma mark - tabView切换
- (void)tabSelected:(NSInteger)index {
  self.pageType = index;

  switch (index) {
  case 0: {
    //分时页面
    [self setViewHidden:4];
  } break;
  case 1: {
    //五日
    [self setViewHidden:2];
    if ([StockUtil isFund:_securitiesInfo.securitiesFirstType()]) {
      _fundNetValueVC.securitiesInfo = _securitiesInfo;
      if (![_fundNetValueVC dataBinded]) {
        [_fundNetValueVC refreshView];
      };
    } else {
      [self getStock5DayStatus];
    }
  } break;
  case 2: {
    //日线
    [self getStockKLineDataWithType:@"D"];
    [self setViewHidden:1];
  } break;
  case 3: {
    //周线
    [self getStockKLineDataWithType:@"W"];
    [self setViewHidden:1];
  } break;
  case 4: {
    //月线
    [self getStockKLineDataWithType:@"M"];
    [self setViewHidden:1];
  } break;
  case 5: {
    // 5分
    [self getStockKLineDataWithType:@"5M"];
    [self setViewHidden:1];
  } break;
  case 6: {
    // 15分
    [self getStockKLineDataWithType:@"15M"];
    [self setViewHidden:1];
  } break;
  case 7: {
    // 30分
    [self getStockKLineDataWithType:@"30M"];
    [self setViewHidden:1];
  } break;
  case 8: {
    // 60分
    [self getStockKLineDataWithType:@"60M"];
    [self setViewHidden:1];
  } break;

  default:
    break;
  }

  [self.view bringSubviewToFront:_kLineTypeTabView];
}

//根据二进制视图显示状态：100，010，001 即4 2 1
- (void)setViewHidden:(NSInteger)number {
  BOOL partTimeViewHidden = !(number & 4);
  if (partTimeViewHidden) {
    [_partTimeView removeFromParentViewController];
    [_partTimeView.view removeFromSuperview];
  } else {
    __weak LandscapeKLineViewController *weakSelf = self;

    if (!_partTimeView) {
      _trendViewframe =
          CGRectMake(MarginLeftRight, MarginTop, self.view.bounds.size.width - MarginLeftRight * 2,
                     self.view.bounds.size.height - MarginTop - MarginBottom);

      _partTimeView = [[HorizontalPartTimeVC alloc] initWithFrame:_trendViewframe
                                               withSecuritiesInfo:_securitiesInfo];

      _partTimeView.stockQuotationInfoReady = ^(NSObject *obj) {
        [weakSelf bindCurStatus:obj];
      };
      //设置时间标签
      __weak UILabel *weakTimeLabel = _timeLabel;
      _partTimeView.passTimeLabelText = ^(NSString *timeStr) {
        //时间
        weakTimeLabel.attributedText = [SimuUtil attributedString:timeStr
                                                            color:[Globle colorFromHexRGB:COLOR_KLINE_INFO_TITLE]
                                                            range:NSMakeRange(0, 2)];
        [weakSelf bindCurStatus:nil];
      };
    }

    [self.view addSubview:_partTimeView.view];
    [self addChildViewController:_partTimeView];

    if (![_partTimeView dataBinded]) {
      [_partTimeView refreshView];
    }
  }

  BOOL fundNetValueHidden;
  if (self.isFund) {
    _fiveDaysView.hidden = YES;
    fundNetValueHidden = !(number & 2);
  } else {
    _fiveDaysView.hidden = !(number & 2);
    fundNetValueHidden = YES;
  }
  if (fundNetValueHidden) {
    [_fundNetValueVC removeFromParentViewController];
    [_fundNetValueVC.view removeFromSuperview];
  } else {
    if (!_fundNetValueVC) {
      _fundNetValueVC = [[HorizontalFundNetValueVC alloc] initWithFrame:_trendViewframe
                                                     withSecuritiesInfo:_securitiesInfo];
    }

    [self.view addSubview:_fundNetValueVC.view];
    [self addChildViewController:_fundNetValueVC];
  }

  _kLineView.hidden = !(number & 1);
  _complexRightBackView.hidden = !(number & 1);
}

#pragma mark - 注册通知
- (void)registingNotification {
  __weak LandscapeKLineViewController *weakSelf = self;

  //滑动时隐藏k线选择segment

  __weak SimuCenterTabView *weakSegmentControl = _kLineTypeTabView;
  _observerSegmentHide =
      [[NSNotificationCenter defaultCenter] addObserverForName:LandscapeSegmentShouldHideNotification
                                                        object:nil
                                                         queue:[NSOperationQueue mainQueue]
                                                    usingBlock:^(NSNotification *note) {

                                                      NSNumber *isShouldHideSegment = note.object;
                                                      if (isShouldHideSegment.boolValue) {
                                                        [weakSelf.view sendSubviewToBack:weakSegmentControl];
                                                      } else {
                                                        [weakSelf.view bringSubviewToFront:weakSegmentControl];
                                                      }

                                                      [UIView animateWithDuration:0.25
                                                                       animations:^{
                                                                         weakSegmentControl.alpha =
                                                                             !isShouldHideSegment.boolValue;
                                                                       }];
                                                    }];

  //双击退出
  _observerExit = [[NSNotificationCenter defaultCenter] addObserverForName:LandscapeVCExitNotification
                                                                    object:nil
                                                                     queue:[NSOperationQueue mainQueue]
                                                                usingBlock:^(NSNotification *note) {
                                                                  [weakSelf exit:nil];
                                                                }];
}

#pragma mark - 网络请求
- (void)setNoNetwork {
  [NewShowLabel showNoNetworkTip];
}

- (NSString *)stockCode {
  return _securitiesInfo.securitiesCode();
}

- (NSString *)firstType {
  return _securitiesInfo.securitiesFirstType();
}

#pragma mark 取得个股5日分时
- (void)getStock5DayStatus {
  //优先加载缓存
  _fiveDayData = [CacheUtil load5DaysDataWithStockCode:self.stockCode firstType:self.firstType];
  if (_fiveDayData) {
    [_fiveDaysView setStock5DaysData:_fiveDayData isIndexStock:self.isIndexStock];
    return;
  }

  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    return;
  }
  __weak LandscapeKLineViewController *weakSelf = self;
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onCheckQuitOrStopProgressBar = ^{
    LandscapeKLineViewController *strongSelf = weakSelf;
    if (strongSelf) {
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *object) {
    LandscapeKLineViewController *strongSelf = weakSelf;
    if (strongSelf) {
      Stock5DayStatusInfo *info = (Stock5DayStatusInfo *)object;
      info.stockcode = self.stockCode;
      [CacheUtil save5DaysData:info firstType:self.firstType];
      //显示分时，需要区分用户当前在哪个页面
      [_fiveDaysView setStock5DaysData:info isIndexStock:self.isIndexStock];
    }
  };

  [Stock5DayStatusInfo getStock5DayStatusWithStockCode:self.stockCode withCallback:callback];
}

#pragma mark 取得（日，周，月， 分钟）K线数据
- (void)getStockKLineDataWithType:(NSString *)type {
  _kLineType = type;

  //优先加载缓存
  _kLineDataInfo = [CacheUtil loadKLineDataWithStockCode:self.stockCode
                                               firstType:self.firstType
                                                    type:type
                                                xrdrType:_xrdrType];
  if (_kLineDataInfo) {
    @try {
      [_kLineView setPageData:_kLineDataInfo withSecuritiesInfo:_securitiesInfo];
      return;
    } @catch (NSException *exception) {
      [NSException raise:@"kline crash"
                  format:@"%@,stockCode: %@, xrdrType:%@ ", exception.reason, self.stockCode, _xrdrType];
    }
  }

  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    return;
  }
  __weak LandscapeKLineViewController *weakSelf = self;
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onCheckQuitOrStopProgressBar = ^{
    LandscapeKLineViewController *strongSelf = weakSelf;
    if (strongSelf) {
      //
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *object) {
    LandscapeKLineViewController *strongSelf = weakSelf;
    if (strongSelf) {
      KLineDataItemInfo *data = (KLineDataItemInfo *)object;
      data.stockcode = self.stockCode;
      data.type = type;
      data.xrdrType = _xrdrType;
      [CacheUtil saveKLineData:data firstType:self.firstType];
      [_kLineView setPageData:data withSecuritiesInfo:_securitiesInfo];
    }
  };

  callback.onFailed = ^() {
    [self setNoNetwork];
  };

  [KLineDataItemInfo getKLineTypesInfo:self.stockCode
                                  type:type
                              xrdrType:_xrdrType
                          withCallback:callback];
}

#pragma mark - 复权按钮
- (IBAction)complexRightButtonClick:(UIButton *)button {
  if (button == _noComplexRightButton) {
    [self setButtonSelected:4];
    _xrdrType = @"0";
    [self getStockKLineDataWithType:_kLineType];
  } else if (button == _beforeComplexRightButton) {
    [self setButtonSelected:2];
    _xrdrType = @"1";
    [self getStockKLineDataWithType:_kLineType];
  } else if (button == _afterComplexRightButton) {
    [self setButtonSelected:1];
    _xrdrType = @"2";
    [self getStockKLineDataWithType:_kLineType];
  }
}

//根据二进制开关设定按钮按下状态：100，010，001 即4 2 1
- (void)setButtonSelected:(NSInteger)number {
  // iOS7上必须为1才能算YES，iOS8则为非零数
  _noComplexRightButton.selected = (number & 4) != 0;
  _beforeComplexRightButton.selected = (number & 2) != 0;
  _afterComplexRightButton.selected = (number & 1) != 0;
}

#pragma mark - 10项指标按钮
- (IBAction)indicatorButtonClick:(UIButton *)button {
  //循环遍历父视图设定selected状态
  [_scrollContentView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    if ([[obj class] isSubclassOfClass:[UIButton class]]) {
      UIButton *subButton = obj;
      subButton.selected = (subButton.tag == button.tag);
    }
  }];
  //让k线页面显示相关指标线
  [_kLineView setIndicatorLineType:button.tag - 1000];
}

#pragma mark - 退出
#pragma mark 关闭退出
- (IBAction)exit:(UIButton *)sender {
  [UIApplication sharedApplication].statusBarHidden = NO;
  [AppDelegate popViewControllerToBottom];
  _securitiesInfo.otherInfoDic[SelectTrendViewIndexKey] = @(_pageType);
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [[NewShowLabel newShowLabel] landscapeStyle:NO];
}

@end
