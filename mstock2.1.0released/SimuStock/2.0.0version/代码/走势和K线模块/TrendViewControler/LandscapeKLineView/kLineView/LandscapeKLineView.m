//
//  LandscapeKLineView.m
//  SimuStock
//
//  Created by Yuemeng on 15/4/28.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "LandscapeKLineView.h"
#import "IndicatorLines.h"

//定义k线横坐标基本长度，‼️注意，这是k线宽度的半径！
#define KLMinWidth 3.0f

//当前k线宽度
#define KLINE_WIDTH (KLMinWidth * self.zoomNumber)
//定义刻度字体
#define UIScaleFont [UIFont fontWithName:FONT_ARIAL size:11]
//定义走势刻度字体
#define TrendScaleFont [UIFont systemFontOfSize:11]
// k线图距离MA标志的距离
#define DISTANCE_MA 16

@implementation LandscapeKLineView

- (void)dealloc {

  if (_flowWindowState == MOD_TREND_SHOWFLWindows) {
    [self hideFloatView];
  };

  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//竖屏
- (instancetype)initWithFrame:(CGRect)frame isLandscape:(BOOL)isLandscape {
  if (self = [super initWithFrame:frame]) {
    self.backgroundColor = [UIColor clearColor];
    self.isLandscape = NO;
    //创建手势
    [self createGestureRecognizer];
    //初始化变量
    [self initVariables];
    [self createUI];
    [self createFloatWindow];
  }
  return self;
}

//横屏
- (void)awakeFromNib {
  //创建手势
  [self createGestureRecognizer];
  //初始化变量
  [self initVariables];
  //延迟加载
  [SimuUtil performBlockOnMainThread:^{
    [self createUI];
  } withDelaySeconds:.1f];
}

- (void)createGestureRecognizer {
  //创建长按手势
  _longPressGesture =
      [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
  [_longPressGesture setDelegate:self];
  _longPressGesture.minimumPressDuration = 0.5;
  _longPressGesture.allowableMovement = 12;
  [self addGestureRecognizer:_longPressGesture];

  if (!_isLandscape) {
    return;
  }

  //创建捏合手势
  UIPinchGestureRecognizer *pinchRecognizer =
      [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
  pinchRecognizer.delegate = self;
  [self addGestureRecognizer:pinchRecognizer];

  //创建左右滑动手势
  UIPanGestureRecognizer *panRecognizer =
      [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
  panRecognizer.delegate = self;
  [self addGestureRecognizer:panRecognizer];

  //双击退出手势
  UITapGestureRecognizer *doubleTap =
      [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendLandscapeVCExit)];
  doubleTap.numberOfTapsRequired = 2;
  [self addGestureRecognizer:doubleTap];
}

- (void)initVariables {
  _dateElementArray = [[NSMutableArray alloc] init];
  _dataDic = [[NSMutableDictionary alloc] init];
  _5AverageDataArray = [[NSMutableArray alloc] init];
  _10AverageDataArray = [[NSMutableArray alloc] init];
  _20AverageDataArray = [[NSMutableArray alloc] init];
  _30AverageDataArray = [[NSMutableArray alloc] init];
  _60AverageDataArray = [[NSMutableArray alloc] init];
  _priceLabelArray = [[NSMutableArray alloc] init];
  _detailInfoLabelArray = [[NSMutableArray alloc] init];
  _maLabelArray = [[NSMutableArray alloc] init];
  _screenStartIndex = 0;
  _screenEndIndex = 0;
  _zoomNumber = 1;
  _showedCount = 0;
  _index = 0;
  _indicatorIndex = 0;
  _decimalNumber = 2;
  _flowWindowState = MOD_TREND_NOFLWindows;
  _scale = 1.0;
  _timeInterval = 0.1;

  _5AverageDataManager = [[SAverageDataManager alloc] init];
  _10AverageDataManager = [[SAverageDataManager alloc] init];
  _20AverageDataManager = [[SAverageDataManager alloc] init];
  _30AverageDataManager = [[SAverageDataManager alloc] init];
  _60AverageDataManager = [[SAverageDataManager alloc] init];

  _volumeTitle = @"VOL";
  _indicatorLineType = indicatorVOL;
}

- (void)createUI {
  _originX = _isLandscape ? 45 : 4;
  //⭐️核心frame，其他控件均与此相关计算
  _allShowFrame =
      CGRectMake(0, 0, _isLandscape ? (self.width - _originX) : (self.width - _originX * 2), self.height);
  _candleRect = CGRectMake(_originX, 0, _allShowFrame.size.width - 4, _allShowFrame.size.height * 2 / 3);
  _volumeRect =
      CGRectMake(_originX, _candleRect.origin.y + _candleRect.size.height + _allShowFrame.size.height / 12,
                 _allShowFrame.size.width - 4, _allShowFrame.size.height / 4);

  _candleRectX = _candleRect.origin.x;
  _candleRectY = _candleRect.origin.y;
  _candleRectW = _candleRect.size.width;
  _candleRectH = _candleRect.size.height;

  _volumeRectX = _volumeRect.origin.x;
  _volumeRectY = _volumeRect.origin.y;
  _volumeRectW = _volumeRect.size.width;
  _volumeRectH = _volumeRect.size.height;

  //创建标签
  [self createScaleLabels];
  //创建MA均线标签
  [self createMALabels];
}

#pragma mark 创建刻度标签
- (void)createScaleLabels {

  if (_isLandscape) {
    //创建具体信息背景视图
    _detailInfoBackView = [[UIView alloc] initWithFrame:CGRectMake(-8, -37, HEIGHT_OF_SCREEN, 30)];
    _detailInfoBackView.backgroundColor = [UIColor clearColor];
    _detailInfoBackView.alpha = 0;
    [self addSubview:_detailInfoBackView];

    //创建上面具体信息标签
    CGFloat spaceOfLabel = (HEIGHT_OF_SCREEN - 20) / 6;
    for (NSInteger i = 0; i < 6; i++) {
      UILabel *infoLabel =
          [[UILabel alloc] initWithFrame:CGRectMake(20 + spaceOfLabel * i, 0, spaceOfLabel, 30)];
      infoLabel.font = [UIFont systemFontOfSize:(HEIGHT_OF_SCREEN <= 480 ? 12 : 14)];
      infoLabel.textColor = (i == 0) ? [Globle colorFromHexRGB:Color_Text_Common]
                                     : [Globle colorFromHexRGB:COLOR_KLINE_INFO_TITLE];
      infoLabel.textAlignment = NSTextAlignmentLeft;
      infoLabel.backgroundColor = [UIColor clearColor];
      [_detailInfoBackView addSubview:infoLabel];
      [_detailInfoLabelArray addObject:infoLabel];
    }
  }

  NSInteger labelHeight = 11;
  NSInteger spaceHeight = (_candleRectH - labelHeight - DISTANCE_MA) / (PRICE_MARKS_5 - 1);
  float labelWidth = 42;
  //价格刻度标签
  for (int i = 0; i < PRICE_MARKS_5; i++) {
    UILabel *priceLabel =
        [[UILabel alloc] initWithFrame:CGRectMake(_isLandscape ? 0 : _candleRectX, i * spaceHeight + DISTANCE_MA, labelWidth, labelHeight)];

    priceLabel.textAlignment = _isLandscape ? NSTextAlignmentRight : NSTextAlignmentLeft;
    priceLabel.textColor = [Globle colorFromHexRGB:Color_Dark];
    priceLabel.backgroundColor = [UIColor clearColor];
    priceLabel.font = UIScaleFont;
    priceLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:priceLabel];
    [_priceLabelArray addObject:priceLabel];
  }

  //左下角的标签背景
  _indicatorInfoBackView =
      [[UIView alloc] initWithFrame:CGRectMake(0, _volumeRectY, _volumeRectX, _volumeRectH)];
  _indicatorInfoBackView.backgroundColor = [UIColor clearColor];
  [self addSubview:_indicatorInfoBackView];

  //时间标签背景图
  _dateBackView =
      [[UIView alloc] initWithFrame:CGRectMake(0, _candleRectY + _candleRectH + 0.5f, _candleRectX + _candleRectW,
                                               _allShowFrame.size.height / 12 - 1.f)];
  _dateBackView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  [self addSubview:_dateBackView];
}

#pragma mark - ☀️手势回调函数
//长按
- (void)longPressToDo:(UILongPressGestureRecognizer *)gesture {
  if (gesture.state == UIGestureRecognizerStateBegan) {
    //发送通知隐藏横屏K线选择segment
    [[NSNotificationCenter defaultCenter] postNotificationName:LandscapeSegmentShouldHideNotification
                                                        object:@(YES)];
    _flowWindowState = MOD_TREND_SHOWFLWindows;
    _lastMovePosition = _beginPosition = _lastPositon = [gesture locationInView:self];
    [self touchClickAndMove:_beginPosition];
    [UIView animateWithDuration:0.25
                     animations:^{
                       _detailInfoBackView.alpha = 1;
                     }];
  } else if (gesture.state == UIGestureRecognizerStateChanged) {
    _lastPositon = [gesture locationInView:self];

    [self touchClickAndMove:_lastPositon];

  } else if (gesture.state == UIGestureRecognizerStateEnded) {
    [UIView animateWithDuration:0.25
                     animations:^{
                       _detailInfoBackView.alpha = 0;
                     }];
    //发送通知隐藏横屏K线选择segment
    [[NSNotificationCenter defaultCenter] postNotificationName:LandscapeSegmentShouldHideNotification
                                                        object:@(NO)];
    if (_flowWindowState == MOD_TREND_SHOWFLWindows) {
      [self hideFloatView];
    }
  }
}

//捏合
- (void)scale:(UIPinchGestureRecognizer *)pincher {

  if ([pincher state] == UIGestureRecognizerStateBegan) {
    _scale = [pincher scale];
  } else if ([pincher state] == UIGestureRecognizerStateChanged) {
    CGFloat scale = [pincher scale];
    if (scale > _scale + 0.1) {
      [self kLineShapChange:KLSC_Larger];
      _scale = scale;
    } else if (scale < _scale - 0.1) {
      [self kLineShapChange:KLSC_Smaller];
      _scale = scale;
      if (_scale < 1.0f) {
        _scale = 1.0f;
      }
    }
  }
}

//滑动
- (void)pan:(UIPanGestureRecognizer *)paner {
  CGPoint panPoint = [paner translationInView:self];
  [paner setTranslation:CGPointZero inView:self];

  static float movedX = 0;
  NSInteger step = KLMinWidth * 2 * _scale; //必须每步重新计算，可能已经放大或缩小

  //计算移动累加值，如果大于目前放大倍数后的k线宽度才能移动，1倍时为6
  if (paner.state == UIGestureRecognizerStateChanged) {
    movedX += panPoint.x;
    if (movedX <= -step || movedX >= step) {
      NSInteger steps = (int)movedX / step;
      _screenStartIndex -= steps;
      movedX -= steps * step;
      [self calculationScaleNumber:KL_Move_Mode];
      [self setNeedsDisplay];
    }
  } else if (paner.state == UIGestureRecognizerStateEnded) {
    movedX = 0;
  }
}

//双击退出
- (void)sendLandscapeVCExit {
  //发送通知退出横屏视图
  [[NSNotificationCenter defaultCenter] postNotificationName:LandscapeVCExitNotification
                                                      object:nil];
}

#pragma mark 创建五日，十日，二十日，三十日，六十日均线的当前价格标签
- (void)createMALabels {

  // MA指示标签背景图
  _maBackView = [[UIView alloc] initWithFrame:CGRectMake(_candleRectX, 0, _candleRectW, 16)];
  [self addSubview:_maBackView];

  // MA数值标签背景图
  _maLabelBackView = [[UIView alloc] initWithFrame:CGRectMake(_candleRectX, 0, _candleRectW, 16)];
  [self addSubview:_maLabelBackView];
  _maLabelBackView.hidden = YES;

  NSArray *labelTitles = _isLandscape ? @[ @"MA5", @"MA10", @"MA20", @"MA30", @"MA60" ]
                                      : @[ @"MA5", @"MA10", @"MA20" ];
  NSArray *colors =
      @[ COLOR_MA_BLUE, COLOR_MA_ORANGE, COLOR_MA_PURPLE, COLOR_MA_GREEN, COLOR_MA_MAGENTA ];

  // MA指示标签
  for (NSInteger i = 0; i < labelTitles.count; i++) {
    //均线竖线
    CALayer *daylayer = [CALayer layer];
    float startX = _candleRectW - (_isLandscape ? 225 : 139);
    daylayer.frame = CGRectMake((i == 0 ? startX : startX - 5) + i * 48, 3, 4, 11);
    daylayer.backgroundColor = [Globle colorFromHexRGB:colors[i]].CGColor;
    [_maBackView.layer addSublayer:daylayer];

    // MA 标签
    UILabel *daylabel =
        [[UILabel alloc] initWithFrame:CGRectMake(daylayer.frame.origin.x + daylayer.frame.size.width + 2,
                                                  daylayer.frame.origin.y, 40, 11)];
    daylabel.backgroundColor = [UIColor clearColor];
    daylabel.font = [UIFont systemFontOfSize:Font_Height_10_0];
    daylabel.text = labelTitles[i];
    daylabel.textColor = [Globle colorFromHexRGB:colors[i]];
    [_maBackView addSubview:daylabel];
  }

  // MA数值指示标签
  float spaceWidth = _candleRectW / labelTitles.count;
  for (NSInteger i = 0; i < labelTitles.count; i++) {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(spaceWidth * i, 3, spaceWidth, 11)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:Font_Height_10_0];
    label.text = labelTitles[i];
    label.textColor = [Globle colorFromHexRGB:colors[i]];
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;
    [_maLabelArray addObject:label];
    [_maLabelBackView addSubview:label];
  }
}

#pragma mark - 创建浮窗
- (void)createFloatWindow {
  _floatWindow4KLineView = [[[NSBundle mainBundle] loadNibNamed:@"FloatWindow4KLineView"
                                                          owner:nil
                                                        options:nil] firstObject];
  _floatWindow4KLineView.frame = CGRectMake(0, 0, 94, 94);
  _floatWindow4KLineView.hidden = YES;
  [self addSubview:_floatWindow4KLineView];
}

#pragma mark - 隐藏浮窗
- (void)hideFloatView {
  _flowWindowState = MOD_TREND_NOFLWindows;
  _currentInfoLabel.text = _volumeTitle;
  _currentInfoLabel.textAlignment = NSTextAlignmentLeft;
  _maBackView.hidden = NO;
  _maLabelBackView.hidden = YES;
  _currentTimeLabel.hidden = YES;
  _currentPriceLabel.hidden = YES;
  _horizontalLineView.hidden = YES;
  _verticalLineView.hidden = YES;
  _floatWindow4KLineView.hidden = YES;

  CGRect rect = CGRectZero;
  TrendFloatViewMsg *msg = [[TrendFloatViewMsg alloc] init:rect
                                               forShowMode:MOD_TREND_NOFLWindows
                                                forMsgType:Type_KLine_TO_FloatView];
  [[NSNotificationCenter defaultCenter] postNotificationName:SYS_VAR_NAME_SHOWFLOATVIWE_MSG
                                                      object:msg];
}

#pragma mark
#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
  if (gestureRecognizer == _longPressGesture) {
    CGPoint pt = _lastPositon = [gestureRecognizer locationInView:self];
    if (CGRectContainsPoint(_buttonRectArray[0], pt) == YES ||
        CGRectContainsPoint(_buttonRectArray[1], pt) == YES) {
      return NO;
    }
  }
  return YES;
}

#pragma mark
#pragma mark 外部接口函数
//清除所有K线数据
- (void)clearAllData {
  [_dateElementArray removeAllObjects];
  // 5日均线赋值
  [_5AverageDataArray removeAllObjects];
  [_10AverageDataArray removeAllObjects];
  [_20AverageDataArray removeAllObjects];
  [_30AverageDataArray removeAllObjects];
  [_60AverageDataArray removeAllObjects];

  [_5AverageDataManager resetDataArray];
  [_10AverageDataManager resetDataArray];
  [_20AverageDataManager resetDataArray];
  [_30AverageDataManager resetDataArray];
  [_60AverageDataManager resetDataArray];

  for (UILabel *lable in _priceLabelArray) {
    lable.text = @"";
  }

  [self setNeedsDisplay];
}

#pragma mark
#pragma mark 功能函数
//设定k线数据
- (void)setPageData:(KLineDataItemInfo *)dataItemInfo
 withSecuritiesInfo:(SecuritiesInfo *)securitiesInfo {
  if (dataItemInfo == nil)
    return;

  _securitiesInfo = securitiesInfo;
  NSString *firstType = _securitiesInfo.securitiesFirstType();
  priceFormat = [StockUtil getPriceFormatWithFirstType:firstType];
  _decimalNumber = [StockUtil isFund:firstType] ? 3 : 2;

  //如果只是复权类型改变，则当前显示的index不变
  if ([_kLineDataItemInfo.type isEqualToString:dataItemInfo.type] &&
      ![_kLineDataItemInfo.xrdrType isEqualToString:dataItemInfo.xrdrType]) {
    _needClearStartIndex = NO;
  } else {
    _needClearStartIndex = YES;
  }
  _kLineDataItemInfo = dataItemInfo;
  //  _pressingButtonMode = KLNPB_Mode_NoneButton;
  //基本元素赋值
  int scale = 1000;
  [_dateElementArray removeAllObjects];

  for (KLineDataItem *item in dataItemInfo.dataArray) {
    KLineDayData *data = [[KLineDayData alloc] init];
    if (data) {
      data.openPrice = item.openprice * scale;
      data.closePrice = item.closeprice * scale;
      data.highestPrice = item.highprice * scale;
      data.lowestPrice = item.lowprice * scale;
      data.date = item.date;
      data.volume = item.volume;
      data.amount = item.amount;
      [_dateElementArray addObject:data];
    }
  }

  // 5日均线赋值
  [_5AverageDataArray removeAllObjects];
  [_10AverageDataArray removeAllObjects];
  [_20AverageDataArray removeAllObjects];
  [_30AverageDataArray removeAllObjects];
  [_60AverageDataArray removeAllObjects];
  [_5AverageDataManager resetDataArray];
  [_10AverageDataManager resetDataArray];
  [_20AverageDataManager resetDataArray];
  [_30AverageDataManager resetDataArray];
  [_60AverageDataManager resetDataArray];

  for (KLineDayData *data in _dateElementArray) {
    [_5AverageDataManager addKLinePrice:data.closePrice];
    [_10AverageDataManager addKLinePrice:data.closePrice];
    [_20AverageDataManager addKLinePrice:data.closePrice];
    [_30AverageDataManager addKLinePrice:data.closePrice];
    [_60AverageDataManager addKLinePrice:data.closePrice];
  }

  [_5AverageDataManager setSAPeriod:5];
  [_10AverageDataManager setSAPeriod:10];
  [_20AverageDataManager setSAPeriod:20];
  [_30AverageDataManager setSAPeriod:30];
  [_60AverageDataManager setSAPeriod:60];

  [_5AverageDataManager calAverageData];
  [_10AverageDataManager calAverageData];
  [_20AverageDataManager calAverageData];
  [_30AverageDataManager calAverageData];
  [_60AverageDataManager calAverageData];

  [_5AverageDataArray addObjectsFromArray:_5AverageDataManager.averageDataAarray];
  [_10AverageDataArray addObjectsFromArray:_10AverageDataManager.averageDataAarray];
  [_20AverageDataArray addObjectsFromArray:_20AverageDataManager.averageDataAarray];
  [_30AverageDataArray addObjectsFromArray:_30AverageDataManager.averageDataAarray];
  [_60AverageDataArray addObjectsFromArray:_60AverageDataManager.averageDataAarray];

  //计算k线
  [self calculationScaleNumber:KL_Common_Mode];
  //重新画图
  [self setNeedsDisplay];
}

#pragma mark - ⭐️当前屏幕k线显示量计算
- (void)calculationScaleNumber:(KLineCalMode)type {
  NSInteger maxPrice = 0, minPrice = 0;
  int64_t maxVolume = 0;

  if (_dateElementArray.count == 0) //
    return;

  NSInteger nDayCount = _dateElementArray.count;
  _leftBorderNum = (nDayCount > 500 ? nDayCount - 500 : 0);

  if (type == KL_Zoom_Mode) {
    _showedCount = (_candleRectW) / (2 * KLINE_WIDTH);
    //放缩重新计算
    // z指标线和开始指标重合，则向后推移放缩
    if (_index == _screenStartIndex) {
      _screenStartIndex = fmin(_screenStartIndex, nDayCount - _showedCount);
      if (_screenStartIndex < _leftBorderNum)
        _screenStartIndex = _leftBorderNum;
      _screenEndIndex = fmin(_screenStartIndex + _showedCount, nDayCount);

      //不在屏幕中，或者和结束k线重合，则由后向前推进放缩
    } else if (_index == _screenEndIndex || _index < _screenStartIndex || _index > _screenEndIndex) {
      _screenStartIndex = _screenEndIndex - _showedCount;
      _screenStartIndex = fmin(_screenStartIndex, nDayCount - _showedCount);
      if (_screenStartIndex < _leftBorderNum)
        _screenStartIndex = _leftBorderNum;
      _screenEndIndex = fmin(_screenStartIndex + _showedCount, nDayCount);

      // k线在屏幕中，以指标线为基准放缩
    } else {
      float pricent = ((float)(_index - _screenStartIndex)) / ((float)(_screenEndIndex - _screenStartIndex));
      _screenStartIndex = _index - _showedCount * pricent;
      _screenStartIndex = fmin(_screenStartIndex, nDayCount - _showedCount);
      if (_screenStartIndex < _leftBorderNum)
        _screenStartIndex = _leftBorderNum;
      _screenEndIndex = fmin(_screenStartIndex + _showedCount, nDayCount);
    }

    // K线初始化
  } else if (type == KL_Common_Mode) {
    _showedCount = _candleRectW / (2 * KLINE_WIDTH);
    //初始化计算，如果不是复权，则必定是切换股票，需要重算
    if (_needClearStartIndex) {
      _screenStartIndex = nDayCount - _showedCount;
    }
    if (_screenStartIndex < _leftBorderNum)
      _screenStartIndex = _leftBorderNum;
    _screenEndIndex = fmin(_screenStartIndex + _showedCount, nDayCount);

    // k线移动
  } else if (type == KL_Move_Mode) {
    _showedCount = _candleRectW / (2 * KLINE_WIDTH);
    _screenStartIndex = fmin(_screenStartIndex, nDayCount - _showedCount);
    if (_screenStartIndex < _leftBorderNum)
      _screenStartIndex = _leftBorderNum;
    _screenEndIndex = fmin(_screenStartIndex + _showedCount, nDayCount);
  }

  if (_screenStartIndex >= nDayCount) {
    _screenStartIndex = fmax(0, nDayCount - _showedCount);
  }

  KLineDayData *elment = _dateElementArray[_screenStartIndex];
  maxPrice = elment.highestPrice;
  minPrice = elment.lowestPrice;
  maxVolume = elment.volume;
  NSInteger i = 0;
  for (i = _screenStartIndex; i < fmin(_screenStartIndex + _showedCount, nDayCount); i++) {
    KLineDayData *data = _dateElementArray[i];
    NSNumber *p5 = _5AverageDataArray[i];
    NSNumber *p10 = _10AverageDataArray[i];
    NSNumber *p20 = _20AverageDataArray[i];
    NSNumber *p30 = _30AverageDataArray[i];
    NSNumber *p60 = _60AverageDataArray[i];

    if (data.highestPrice > maxPrice)
      maxPrice = data.highestPrice;
    if ([p5 intValue] > maxPrice)
      maxPrice = [p5 intValue];
    if ([p10 intValue] > maxPrice)
      maxPrice = [p10 intValue];
    if ([p20 intValue] > maxPrice)
      maxPrice = [p20 intValue];
    if ([p30 intValue] > maxPrice)
      maxPrice = [p30 intValue];

    if ([p60 intValue] > maxPrice)
      maxPrice = [p60 intValue];

    if (data.lowestPrice < minPrice)
      minPrice = data.lowestPrice;
    if ([p5 intValue] < minPrice)
      minPrice = [p5 intValue];
    if ([p10 intValue] < minPrice)
      minPrice = [p10 intValue];
    if ([p20 intValue] < minPrice)
      minPrice = [p20 intValue];
    if ([p30 intValue] < minPrice)
      minPrice = [p30 intValue];
    if ([p60 intValue] < minPrice)
      minPrice = [p60 intValue];
    if (data.volume > maxVolume)
      maxVolume = data.volume;
  }

  //计算价格刻度
  if (minPrice != maxPrice) {
    for (i = 0; i < PRICE_MARKS_5; i++) {
      _priceMarkArray[i] = minPrice + i * ((maxPrice - minPrice) / (PRICE_MARKS_5 - 1));
    }
  } else {
    //如果最大、最小值相等，则是开盘涨停，直接按50%比例计算
    for (i = 0; i < PRICE_MARKS_5; i++) {
      _priceMarkArray[i] = minPrice * 0.25 * (i + 2);
    }
  }

  _maxVolume = maxVolume;
  _kLineWidth = KLINE_WIDTH;

  ///纵向文字刻度
  [self resetScaleValue];
}

#pragma mark - 重新设定纵向的刻度数值
- (void)resetScaleValue {

  int i = 0;
  for (UILabel *label in _priceLabelArray) {
    NSString *priceScale = [SimuUtil formatDecimal:_priceMarkArray[PRICE_MARKS_5 - 1 - i]
                                        ForDeciNum:_decimalNumber
                                           ForSign:YES];
    label.text = priceScale;
    i++;
  }

  //创建实时信息标签
  if (!_currentInfoLabel && _isLandscape) {
    _currentInfoLabel =
        [[UILabel alloc] initWithFrame:CGRectMake(_volumeRectX, _volumeRectY, _volumeRectW, 10)];
    _currentInfoLabel.font = [UIFont systemFontOfSize:Font_Height_10_0];
    _currentInfoLabel.textColor = [Globle colorFromHexRGB:Color_Dark];
    _currentInfoLabel.textAlignment = NSTextAlignmentLeft;
    _currentInfoLabel.backgroundColor = [UIColor clearColor];
    _currentInfoLabel.text = _volumeTitle;
    [self addSubview:_currentInfoLabel];
  }

  //创建移动时间标签
  NSString *timeStr = @"9999/99/99";
  int width = [timeStr sizeWithFont:TrendScaleFont].width + 4;
  if (!_currentTimeLabel && _isLandscape) {
    _currentTimeLabel =
        [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, _allShowFrame.size.height / 12)];
    _currentTimeLabel.layer.borderWidth = 0.5f;
    _currentTimeLabel.layer.borderColor = [[Globle colorFromHexRGB:Color_Gray] CGColor];
    _currentTimeLabel.layer.cornerRadius = 2;
    _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    _currentTimeLabel.hidden = YES;
    _currentTimeLabel.center =
        CGPointMake(0, _candleRectY + _candleRectH + _currentTimeLabel.size.height / 2);
    _currentTimeLabel.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
    _currentTimeLabel.font = TrendScaleFont;
    _currentTimeLabel.textColor = [Globle colorFromHexRGB:Color_Blue_but];
    [self addSubview:_currentTimeLabel];
  }

  //创建 价格 游标
  if (!_currentPriceLabel && _isLandscape) {
    //价格
    _currentPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 17)];
    _currentPriceLabel.layer.borderWidth = 0.5f;
    _currentPriceLabel.layer.borderColor = [[Globle colorFromHexRGB:Color_Gray] CGColor];
    _currentPriceLabel.layer.cornerRadius = 2;
    _currentPriceLabel.textAlignment = NSTextAlignmentCenter;
    _currentPriceLabel.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
    _currentPriceLabel.font = [UIFont systemFontOfSize:Font_Height_11_0];
    _currentPriceLabel.textColor = [Globle colorFromHexRGB:Color_Blue_but];
    _currentPriceLabel.hidden = YES;
    [self addSubview:_currentPriceLabel];
  }
}

#pragma mark - ⭐️显示具体信息
- (void)sendShowFloatViewContent:(NSInteger)index {
  if (index < 0 || _dateElementArray.count == 0 || index >= _dateElementArray.count) {
    return;
  }
  _index = index;
  //  _currentVolumeLabel.hidden = NO;
  _currentTimeLabel.hidden = NO;
  _currentPriceLabel.hidden = NO;
  _horizontalLineView.hidden = NO;
  _verticalLineView.hidden = NO;

  //得到当前数组内容
  NSInteger arrayIndex = _screenStartIndex + index;
  if (arrayIndex < 0 || arrayIndex >= _dateElementArray.count) {
    return;
  }
  //  NSLog(@"k线触摸序列号：%ld", (long)arrayIndex);

  KLineDayData *element = _dateElementArray[arrayIndex];
  NSInteger lastIndex = (arrayIndex > 0) ? (arrayIndex - 1) : arrayIndex;
  KLineDayData *lastElement = _dateElementArray[lastIndex];
  //计算收盘价
  NSInteger preClosePrice = 0;
  if (arrayIndex > 0) {
    KLineDayData *preElement = _dateElementArray[arrayIndex - 1];
    preClosePrice = preElement.closePrice;
  }
  //  } else {
  //    preClosePrice = element.closePrice;
  //  }

  NSString *contentTitle = @"";
  NSString *content;
  UIColor *color = [Globle colorFromHexRGB:Color_Dark];

  for (int i = 0; i < 6; i++) {
    if (i == 0) {

      NSString *tempDateStr = [NSString stringWithFormat:@"%lld", element.date];

      //@"20150427132500"
      NSString *dateStr;
      //如果是分钟线 格式：05-12 15:00
      if ([[tempDateStr substringFromIndex:8] integerValue] != 0) {
        dateStr =
            [NSString stringWithFormat:@"%@-%@ %@:%@", [tempDateStr substringFromIndex:4 toIndex:6],
                                       [tempDateStr substringFromIndex:6 toIndex:8],
                                       [tempDateStr substringFromIndex:8 toIndex:10],
                                       [tempDateStr substringFromIndex:10 toIndex:12]];
      } else {
        //如果是日k等 格式：2015-05-12
        dateStr =
            [NSString stringWithFormat:@"%@-%@-%@", [tempDateStr substringFromIndex:0 toIndex:4],
                                       [tempDateStr substringFromIndex:4 toIndex:6],
                                       [tempDateStr substringFromIndex:6 toIndex:8]];
      }

      content = dateStr;
      _floatWindow4KLineView.timeLabel.text = dateStr;

    } else if (i == 1) {
      contentTitle = @"开 ";
      NSInteger openprice = element.openPrice;
      content = [SimuUtil formatDecimal:openprice ForDeciNum:_decimalNumber ForSign:YES];
      if (openprice > preClosePrice) {
        color = [Globle colorFromHexRGB:Color_Red];
      } else if (openprice == preClosePrice) {
        color = [Globle colorFromHexRGB:Color_Dark];
      } else {
        color = [Globle colorFromHexRGB:Color_Green];
      }

      _floatWindow4KLineView.openPriceLabel.text = content;
      _floatWindow4KLineView.openPriceLabel.textColor = color;

    } else if (i == 2) {
      contentTitle = @"高 ";
      NSInteger openprice = element.highestPrice;
      content = [SimuUtil formatDecimal:openprice ForDeciNum:_decimalNumber ForSign:YES];
      if (openprice > preClosePrice) {
        color = [Globle colorFromHexRGB:Color_Red];
      } else if (openprice == preClosePrice) {
        color = [Globle colorFromHexRGB:Color_Dark];
      } else {
        color = [Globle colorFromHexRGB:Color_Green];
      }

      _floatWindow4KLineView.heightPriceLabel.text = content;
      _floatWindow4KLineView.heightPriceLabel.textColor = color;

    } else if (i == 3) {
      contentTitle = @"低 ";
      NSInteger openprice = element.lowestPrice;
      content = [SimuUtil formatDecimal:openprice ForDeciNum:_decimalNumber ForSign:YES];
      if (openprice > preClosePrice) {
        color = [Globle colorFromHexRGB:Color_Red];
      } else if (openprice == preClosePrice) {
        color = [Globle colorFromHexRGB:Color_Dark];
      } else {
        color = [Globle colorFromHexRGB:Color_Green];
      }

      _floatWindow4KLineView.lowPriceLabel.text = content;
      _floatWindow4KLineView.lowPriceLabel.textColor = color;

    } else if (i == 4) {
      contentTitle = @"收 ";
      NSInteger openprice = element.closePrice;
      content = [SimuUtil formatDecimal:openprice ForDeciNum:_decimalNumber ForSign:YES];
      if (openprice > preClosePrice) {
        color = [Globle colorFromHexRGB:Color_Red];
      } else if (openprice == preClosePrice) {
        color = [Globle colorFromHexRGB:Color_Dark];
      } else {
        color = [Globle colorFromHexRGB:Color_Green];
      }

      _floatWindow4KLineView.closePriceLabel.text = content;
      _floatWindow4KLineView.closePriceLabel.textColor = color;

    } else if (i == 5) {
      contentTitle = @"涨跌 ";
      NSInteger n_closeprice = element.closePrice;
      NSInteger n_yestodayprice = lastElement.closePrice;
      float f_profit = ((float)(n_closeprice - n_yestodayprice)) / (float)n_yestodayprice;
      content = [NSString stringWithFormat:@"%.2f", f_profit * 100];
      content = [content stringByAppendingString:@"%"];
      if (f_profit > 0) {
        color = [Globle colorFromHexRGB:Color_Red];
      } else if (f_profit == 0) {
        color = [Globle colorFromHexRGB:Color_Dark];
      } else {
        color = [Globle colorFromHexRGB:Color_Green];
      }
    }

    _floatWindow4KLineView.changePriceLabel.text = content;
    _floatWindow4KLineView.changePriceLabel.textColor = color;

    //设定上方详细信息数据
    if (i < _detailInfoLabelArray.count) {
      UILabel *infoLabel = _detailInfoLabelArray[i];
      NSString *finalContent = [contentTitle stringByAppendingString:content];
      //设置属性字符串
      NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:finalContent];
      if (i != 0) {
        [attr addAttribute:NSForegroundColorAttributeName
                     value:color
                     range:NSMakeRange(2, finalContent.length - 2)];
      }
      infoLabel.attributedText = attr;
    }
  }

  //设置MA数据
  NSArray *titles = @[ @"MA5: ", @"MA10: ", @"MA20: ", @"MA30: ", @"MA60: " ];
  NSArray *avgDatas = @[
    _5AverageDataArray,
    _10AverageDataArray,
    _20AverageDataArray,
    _30AverageDataArray,
    _60AverageDataArray
  ];
  NSArray *startDates = @[ @(5), @(10), @(20), @(30), @(60) ];
  [_maLabelArray enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
    NSInteger startDate = [startDates[idx] integerValue];
    NSString *priceStr;
    //判断arrayIndex相对应的MA线是否存在，不存在时数值为“-”
    if (arrayIndex >= startDate) {
      NSInteger price = [avgDatas[idx][arrayIndex] integerValue];
      priceStr = [NSString stringWithFormat:priceFormat, price / 1000.f];
    } else {
      priceStr = @"-";
    }
    label.text = [titles[idx] stringByAppendingString:priceStr];
  }];

  //    arrayIndex;
  //根据当前指标线类型显示详细信息
  switch (_indicatorLineType) {
  case indicatorVOL: {

    NSString *volumeScale = [StockUtil handsStringFromVolume:element.volume needsHand:YES];

    content = volumeScale;

    //设置当前成交量数据
    _currentInfoLabel.text = volumeScale;
  } break;
  case indicatorMACD: {
    MACDPoint *point = _macdPoints[arrayIndex];

    NSString *content =
        [NSString stringWithFormat:@"DIF:%.3f  DEA:%.3f  MACD:%.3f", point.dif, point.dea, point.macd];

    //相关文字长度
    NSInteger difLength = [SimuUtil stringFromFloat:point.dif bits:3].length;
    NSInteger deaLength = [SimuUtil stringFromFloat:point.dea bits:3].length;
    NSInteger macdLength = [SimuUtil stringFromFloat:point.macd bits:3].length;

    //设置属性字符串
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:content];
    // DIF
    [attr addAttribute:NSForegroundColorAttributeName
                 value:[Globle colorFromHexRGB:COLOR_MA_ORANGE]
                 range:NSMakeRange(0, 4 + difLength)];
    // DEA
    [attr addAttribute:NSForegroundColorAttributeName
                 value:[Globle colorFromHexRGB:COLOR_MA_BLUE]
                 range:NSMakeRange(4 + difLength + 2, 4 + deaLength)];
    // MACD
    [attr addAttribute:NSForegroundColorAttributeName
                 value:[Globle colorFromHexRGB:COLOR_MA_PURPLE]
                 range:NSMakeRange(8 + difLength + deaLength + 4, 5 + macdLength)];

    _currentInfoLabel.attributedText = attr;
  } break;
  case indicatorKDJ: {
    KDJPoint *point = _kdjPoints[arrayIndex];
    NSString *content = [NSString stringWithFormat:@"K:%.2f  D:%.2f  J:%.2f", point.k, point.d, point.j];

    //相关文字长度
    NSInteger kLength = [SimuUtil stringFromFloat:point.k bits:2].length;
    NSInteger dLength = [SimuUtil stringFromFloat:point.d bits:2].length;
    NSInteger jLength = [SimuUtil stringFromFloat:point.j bits:2].length;

    //设置属性字符串
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:content];
    // K
    [attr addAttribute:NSForegroundColorAttributeName
                 value:[Globle colorFromHexRGB:COLOR_MA_ORANGE]
                 range:NSMakeRange(0, 2 + kLength)];
    // D
    [attr addAttribute:NSForegroundColorAttributeName
                 value:[Globle colorFromHexRGB:COLOR_MA_BLUE]
                 range:NSMakeRange(2 + kLength + 2, 2 + dLength)];
    // J
    [attr addAttribute:NSForegroundColorAttributeName
                 value:[Globle colorFromHexRGB:COLOR_MA_PURPLE]
                 range:NSMakeRange(4 + kLength + dLength + 4, 2 + jLength)];

    _currentInfoLabel.attributedText = attr;
  } break;
  case indicatorRSI: {
    RSIPoint *point = _rsiPoints[arrayIndex];

    NSNumber *rsi6 = point.valueDic[@(6)];
    NSNumber *rsi12 = point.valueDic[@(12)];
    NSNumber *rsi24 = point.valueDic[@(24)];

    float rsi6f = [rsi6 isEqual:[NSNull null]] ? NAN : [rsi6 floatValue];
    float rsi12f = [rsi12 isEqual:[NSNull null]] ? NAN : [rsi12 floatValue];
    float rsi24f = [rsi24 isEqual:[NSNull null]] ? NAN : [rsi24 floatValue];

    NSString *content =
        [NSString stringWithFormat:@"RSI6:%.2f  RSI12:%.2f  RSI24:%.2f", rsi6f, rsi12f, rsi24f];

    //相关文字长度
    NSInteger kLength = [SimuUtil stringFromFloat:rsi6f bits:2].length;
    NSInteger dLength = [SimuUtil stringFromFloat:rsi12f bits:2].length;
    NSInteger jLength = [SimuUtil stringFromFloat:rsi24f bits:2].length;

    //设置属性字符串
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:content];
    // RSI6
    [attr addAttribute:NSForegroundColorAttributeName
                 value:[Globle colorFromHexRGB:COLOR_MA_ORANGE]
                 range:NSMakeRange(0, 5 + kLength)];
    // RSI12
    [attr addAttribute:NSForegroundColorAttributeName
                 value:[Globle colorFromHexRGB:COLOR_MA_BLUE]
                 range:NSMakeRange(5 + kLength + 2, 6 + dLength)];
    // RSI24
    [attr addAttribute:NSForegroundColorAttributeName
                 value:[Globle colorFromHexRGB:COLOR_MA_PURPLE]
                 range:NSMakeRange(11 + kLength + dLength + 4, 6 + jLength)];

    _currentInfoLabel.attributedText = attr;
  } break;
  case indicatorBOLL: {
    BOLLPoint *point = _bollPoints[arrayIndex];

    float upper = !point.upper ? NAN : [point.upper floatValue];
    float mid = !point.mid ? NAN : [point.mid floatValue];
    float lower = !point.lower ? NAN : [point.lower floatValue];

    NSString *content = [NSString stringWithFormat:@"UPPER:%.2f  MID:%.2f  LOWER:%.2f", upper, mid, lower];

    //相关文字长度
    NSInteger uLength = [SimuUtil stringFromFloat:upper bits:2].length;
    NSInteger mLength = [SimuUtil stringFromFloat:mid bits:2].length;
    NSInteger lLength = [SimuUtil stringFromFloat:lower bits:2].length;

    //设置属性字符串
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:content];
    // UPPER
    [attr addAttribute:NSForegroundColorAttributeName
                 value:[Globle colorFromHexRGB:COLOR_MA_ORANGE]
                 range:NSMakeRange(0, 6 + uLength)];
    // MID
    [attr addAttribute:NSForegroundColorAttributeName
                 value:[Globle colorFromHexRGB:COLOR_MA_BLUE]
                 range:NSMakeRange(6 + uLength + 2, 4 + mLength)];
    // LOWER
    [attr addAttribute:NSForegroundColorAttributeName
                 value:[Globle colorFromHexRGB:COLOR_MA_PURPLE]
                 range:NSMakeRange(10 + uLength + mLength + 4, 6 + lLength)];

    _currentInfoLabel.attributedText = attr;
  } break;
  case indicatorBRAR: {
    BRARPoint *point = _brarPoints[arrayIndex];

    float br = point.br ? [point.br floatValue] : NAN;
    float ar = point.ar ? [point.ar floatValue] : NAN;

    NSString *content = [NSString stringWithFormat:@"BR:%.2f  AR:%.2f", br, ar];

    //相关文字长度
    NSInteger brLength = [SimuUtil stringFromFloat:br bits:2].length;
    NSInteger arLength = [SimuUtil stringFromFloat:ar bits:2].length;

    //设置属性字符串
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:content];
    // BR
    [attr addAttribute:NSForegroundColorAttributeName
                 value:[Globle colorFromHexRGB:COLOR_MA_ORANGE]
                 range:NSMakeRange(0, 3 + brLength)];
    // AR
    [attr addAttribute:NSForegroundColorAttributeName
                 value:[Globle colorFromHexRGB:COLOR_MA_BLUE]
                 range:NSMakeRange(3 + brLength + 2, 3 + arLength)];

    _currentInfoLabel.attributedText = attr;
  } break;
  case indicatorOBV: {
    OBVPoint *point = _obvPoints[arrayIndex];

    int64_t obv = [point.obv isEqual:[NSNull null]] ? NAN : [point.obv longLongValue];
    int64_t maobv = [point.maObv isEqual:[NSNull null]] ? NAN : [point.maObv longLongValue];

    NSString *obvStr = [StockUtil handsStringFromVolume:obv needsHand:NO];
    NSString *maobvStr = [StockUtil handsStringFromVolume:maobv needsHand:NO];

    NSString *content = [NSString stringWithFormat:@"OBV:%@  OBV30:%@", obvStr, maobvStr];

    //相关文字长度
    NSInteger obvLength = obvStr.length;
    NSInteger maObvLength = maobvStr.length;

    //设置属性字符串
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:content];
    // OBV
    [attr addAttribute:NSForegroundColorAttributeName
                 value:[Globle colorFromHexRGB:COLOR_MA_BLUE]
                 range:NSMakeRange(0, 4 + obvLength)];
    // OBV30
    [attr addAttribute:NSForegroundColorAttributeName
                 value:[Globle colorFromHexRGB:COLOR_MA_GREEN]
                 range:NSMakeRange(4 + obvLength + 2, 6 + maObvLength)];

    _currentInfoLabel.attributedText = attr;
  } break;
  case indicatorDMI: {
    DMIPoint *point = _dmiPoints[arrayIndex];

    float adxr = [point.adxr isEqual:[NSNull null]] ? NAN : [point.adxr floatValue];
    float adx = [point.adx isEqual:[NSNull null]] ? NAN : [point.adx floatValue];
    float mdi = [point.mdi isEqual:[NSNull null]] ? NAN : [point.mdi floatValue];
    float pdi = [point.pdi isEqual:[NSNull null]] ? NAN : [point.pdi floatValue];

    NSString *adxrStr = [StockUtil handsStringFromDouble:adxr needsHand:NO];
    NSString *adxStr = [StockUtil handsStringFromDouble:adx needsHand:NO];
    NSString *mdiStr = [StockUtil handsStringFromDouble:mdi needsHand:NO];
    NSString *pdiStr = [StockUtil handsStringFromDouble:pdi needsHand:NO];

    NSString *content =
        [NSString stringWithFormat:@"ADXR:%@  ADX:%@  MDI:%@  PDI:%@", adxrStr, adxStr, mdiStr, pdiStr];

    //相关文字长度
    NSInteger adxrLength = adxrStr.length;
    NSInteger adxLength = adxStr.length;
    NSInteger mdiLength = mdiStr.length;
    NSInteger pdiLength = pdiStr.length;

    //设置属性字符串
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:content];
    // adxr
    [attr addAttribute:NSForegroundColorAttributeName
                 value:[Globle colorFromHexRGB:COLOR_MA_GREEN]
                 range:NSMakeRange(0, 5 + adxrLength)];
    // adx
    [attr addAttribute:NSForegroundColorAttributeName
                 value:[Globle colorFromHexRGB:COLOR_MA_PURPLE]
                 range:NSMakeRange(5 + adxrLength + 2, 4 + adxLength)];
    // mdi
    [attr addAttribute:NSForegroundColorAttributeName
                 value:[Globle colorFromHexRGB:COLOR_MA_ORANGE]
                 range:NSMakeRange(9 + adxrLength + adxLength + 4, 4 + mdiLength)];
    // pdi
    [attr addAttribute:NSForegroundColorAttributeName
                 value:[Globle colorFromHexRGB:COLOR_MA_BLUE]
                 range:NSMakeRange(13 + adxrLength + adxLength + mdiLength + 6, 4 + pdiLength)];

    _currentInfoLabel.attributedText = attr;
  } break;
  case indicatorBIAS: {
    BIASPoint *point = _biasPoints[arrayIndex];

    float bias1 = !point.bias1 ? NAN : [point.bias1 floatValue];
    float bias2 = !point.bias2 ? NAN : [point.bias2 floatValue];
    float bias3 = !point.bias3 ? NAN : [point.bias3 floatValue];

    NSString *content = [NSString stringWithFormat:@"BIAS1:%.2f  BIAS2:%.2f  BIAS3:%.2f", bias1, bias2, bias3];

    //相关文字长度
    NSInteger bias1Length = [SimuUtil stringFromFloat:bias1 bits:2].length;
    NSInteger bias2Length = [SimuUtil stringFromFloat:bias2 bits:2].length;
    NSInteger bias3Length = [SimuUtil stringFromFloat:bias3 bits:2].length;

    //设置属性字符串
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:content];
    // BIAS1
    [attr addAttribute:NSForegroundColorAttributeName
                 value:[Globle colorFromHexRGB:COLOR_MA_BLUE]
                 range:NSMakeRange(0, 6 + bias1Length)];
    // BIAS2
    [attr addAttribute:NSForegroundColorAttributeName
                 value:[Globle colorFromHexRGB:COLOR_MA_ORANGE]
                 range:NSMakeRange(6 + bias1Length + 2, 6 + bias2Length)];
    // BIAS3
    [attr addAttribute:NSForegroundColorAttributeName
                 value:[Globle colorFromHexRGB:COLOR_MA_PURPLE]
                 range:NSMakeRange(12 + bias1Length + bias2Length + 4, 6 + bias3Length)];

    _currentInfoLabel.attributedText = attr;
  } break;
  case indicatorWR: {
    WRPoint *point = _wrPoints[arrayIndex];

    float wr1 = !point.wr1 ? NAN : [point.wr1 floatValue];
    float wr2 = !point.wr2 ? NAN : [point.wr2 floatValue];

    NSString *content = [NSString stringWithFormat:@"WR1:%.2f  WR2:%.2f", wr1, wr2];

    //相关文字长度
    NSInteger wr1Length = [SimuUtil stringFromFloat:wr1 bits:2].length;
    NSInteger wr2Length = [SimuUtil stringFromFloat:wr2 bits:2].length;

    //设置属性字符串
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:content];
    // WR1
    [attr addAttribute:NSForegroundColorAttributeName
                 value:[Globle colorFromHexRGB:COLOR_MA_ORANGE]
                 range:NSMakeRange(0, 4 + wr1Length)];
    // WR2
    [attr addAttribute:NSForegroundColorAttributeName
                 value:[Globle colorFromHexRGB:COLOR_MA_BLUE]
                 range:NSMakeRange(4 + wr1Length + 2, 4 + wr2Length)];

    _currentInfoLabel.attributedText = attr;
  } break;

  default:
    break;
  }
}

#pragma mark - k线形状改变
- (void)kLineShapChange:(KLineShapChangeMode)mode {
  if (mode == KLSC_MoveLeft) {
    _screenStartIndex = _screenStartIndex - 1;
    [self calculationScaleNumber:KL_Move_Mode];
  } else if (mode == KLSC_MoveRight) {
    _screenStartIndex = _screenStartIndex + 1;
    [self calculationScaleNumber:KL_Move_Mode];
  } else if (mode == KLSC_Larger) {
    _zoomNumber = _zoomNumber + 0.5; // 2*_zoomNumber;
    if (_zoomNumber > 4)
      _zoomNumber = 4;
    [self calculationScaleNumber:KL_Zoom_Mode];
  } else if (mode == KLSC_Smaller) {
    _zoomNumber = _zoomNumber - 0.5; // _zoomNumber/2;
    if (_zoomNumber < 1)
      _zoomNumber = 1;
    [self calculationScaleNumber:KL_Zoom_Mode];
  }
  [self setNeedsDisplay];
}

#pragma mark
#pragma mark 画图函数
- (void)drawRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();
  [self drawFrameSlideline:context];
  [self drawCandeAndLine:context];
  [_indicatorInfoBackView removeAllSubviews];

  //根据当前指标线类型画线
  switch (_indicatorLineType) {
  case 0: {
    // VOL
    [self drawVOLLine:context];
  } break;
  case 1: {
    // MACD
    [self drawMACDLine:context];
  } break;
  case 2: {
    // KDJ
    [self drawKDJLine:context];
  } break;
  case 3: {
    // RSI
    [self drawRSILine:context];
  } break;
  case 4: {
    // BOLL
    [self drawBOLLLine:context];
  } break;
  case 5: {
    // BRAR
    [self drawBRARLine:context];
  } break;
  case 6: {
    // OBV
    [self drawOBVLine:context];
  } break;
  case 7: {
    // DMI
    [self drawDMILine:context];
  } break;
  case 8: {
    // BIAS
    [self drawBIASLine:context];
  } break;
  case 9: {
    // W&R
    [self drawWRLine:context];
  } break;

  default:
    break;
  }
}

#pragma mark 画出所有需要的边框
- (void)drawFrameSlideline:(CGContextRef)context {

  //设定颜色
  [[Globle colorFromHexRGB:COLOR_KLINE_BORDER] set];
  CGContextSetLineWidth(context, 0.5f);
  CGContextAddRect(context, _candleRect);
  CGContextAddRect(context, _volumeRect);
  CGContextStrokePath(context);

  [[Globle colorFromHexRGB:COLOR_KLINE_SEPARATOR] set];

  CGContextSetLineWidth(context, 0.5f);

  //价格横线
  //计算刻度的单位高度
  NSInteger spaceH = (_candleRectH - DISTANCE_MA) / (PRICE_MARKS_5 - 1);

  for (int i = 1; i < PRICE_MARKS_5 - 1; i++) {
    CGPoint pt1 = CGPointMake(_candleRectX, _candleRectY + i * spaceH + DISTANCE_MA);
    CGPoint pt2 = CGPointMake(_candleRectX + _candleRectW, _candleRectY + i * spaceH + DISTANCE_MA);
    CGContextMoveToPoint(context, pt1.x, pt1.y);
    CGContextAddLineToPoint(context, pt2.x, pt2.y);
    CGContextStrokePath(context);
  }
}

#pragma mark - ⭐️画蜡烛线和均线
- (void)drawCandeAndLine:(CGContextRef)context {
  CGRect tempCandleRect = CGRectZero;
  NSInteger elementCount = _dateElementArray.count;
  if (elementCount <= 0) {
    return;
  }

  //清空时间轴上所有日期标签
  [_dateBackView removeAllSubviews];

  float startX, startY, endX, endY, candleW, candleH;
  NSInteger kLineWidth, tempCandleH;
  kLineWidth = KLINE_WIDTH;
  int iCount = 0;
  //是否是最后一屏数据 如果是则需计算第一个点
  BOOL isLastData = NO;
  if (_screenStartIndex + _showedCount >= elementCount) {
    isLastData = YES;
  }

  //五个MA数据数组
  NSArray *numbers = _isLandscape ? @[ @(5), @(10), @(20), @(30), @(60) ] : @[ @(5), @(10), @(20) ];

  NSArray *maAvgDataArray = @[
    _5AverageDataArray,
    _10AverageDataArray,
    _20AverageDataArray,
    _30AverageDataArray,
    _60AverageDataArray
  ];

  NSArray *colors =
      @[ COLOR_MA_BLUE, COLOR_MA_ORANGE, COLOR_MA_PURPLE, COLOR_MA_GREEN, COLOR_MA_MAGENTA ];

  NSInteger minDays = fmin(elementCount, _screenStartIndex + _showedCount);

  for (NSInteger i = _screenStartIndex; i < minDays; i++, iCount++) {
    //画月份线,每次检测到不同的月份或日期便画一条竖线
    KLineDayData *data = _dateElementArray[i];
    NSString *content = [NSString stringWithFormat:@"%lld", data.date];

    // 1.线判断是日k线还是分钟线
    //@"20150427132500"
    NSString *tempDateStr;
    float labelWidth = 0.f;
    BOOL isMinuteLine = NO;
    //如果是分钟线 格式：05-12 15:00
    if ([[content substringFromIndex:8] integerValue] != 0) {
      tempDateStr =
          [NSString stringWithFormat:@"%@-%@ %@:%@", [content substringFromIndex:4 toIndex:6],
                                     [content substringFromIndex:6 toIndex:8],
                                     [content substringFromIndex:8 toIndex:10],
                                     [content substringFromIndex:10 toIndex:12]];
      labelWidth = 63.f;
      isMinuteLine = YES;
    } else {
      //如果是日k等 格式：2015-05
      tempDateStr = [NSString stringWithFormat:@"%@-%@", [content substringFromIndex:0 toIndex:4],
                                               [content substringFromIndex:4 toIndex:6]];
      labelWidth = 44.f;
      isMinuteLine = NO;
    }

    static NSString *dateStr;

    //根据k线类型比较月份或日期是否有变化
    if (isMinuteLine ? ![[dateStr substringToIndex:5] isEqualToString:[tempDateStr substringToIndex:5]]
                     : ![dateStr isEqualToString:tempDateStr]) {
      dateStr = tempDateStr;

      static float lineStartX = 0;
      float currentStartX = _candleRectX + kLineWidth * 2 * iCount + kLineWidth;
      //必须间隔1个标签宽度以上，保证标签不重叠，同时特殊处理第一根线
      if ((float)fabsf(currentStartX - lineStartX) >= labelWidth * 2 || (lineStartX == _candleRectX + kLineWidth)) {
        lineStartX = currentStartX;

        //不能画在边界上，起始最小坐标为61
        if (_candleRectX + 16 < lineStartX && lineStartX < _candleRectX + _candleRectW - labelWidth / 2) {

          [[Globle colorFromHexRGB:COLOR_KLINE_BORDER] set];
          CGContextSetLineWidth(context, 0.5f);
          CGContextMoveToPoint(context, lineStartX - 1, 0);
          CGContextAddLineToPoint(context, lineStartX - 1, _allShowFrame.size.height);
          CGContextStrokePath(context);
          //时间轴上添加标签
          UILabel *dateLabel =
              [[UILabel alloc] initWithFrame:CGRectMake(lineStartX - labelWidth / 2, 0, labelWidth, _dateBackView.height)];
          dateLabel.font = UIScaleFont;
          dateLabel.textColor = [Globle colorFromHexRGB:Color_Dark];
          dateLabel.text = dateStr;
          dateLabel.textAlignment = NSTextAlignmentCenter;
          dateLabel.backgroundColor = [UIColor clearColor];
          [_dateBackView addSubview:dateLabel];
        }
      }
    }

    if (data.openPrice == 0 || data.highestPrice == 0 || data.lowestPrice == 0 || data.closePrice == 0)
      break;

    //画蜡烛轴线(竖线）
    if (kLineWidth == 2) {
      startX = _candleRectX + kLineWidth * 2 * iCount + kLineWidth / 2;
    } else {
      startX = _candleRectX + kLineWidth * 2 * iCount + kLineWidth - 1;
    }

    startY = _candleRectY + _candleRectH -
             ((_candleRectH - DISTANCE_MA) * (data.highestPrice - _priceMarkArray[0])) /
                 (_priceMarkArray[PRICE_MARKS_5 - 1] - _priceMarkArray[0]);
    endX = startX;
    endY = _candleRectY + _candleRectH -
           ((_candleRectH - DISTANCE_MA) * (data.lowestPrice - _priceMarkArray[0])) /
               (_priceMarkArray[PRICE_MARKS_5 - 1] - _priceMarkArray[0]);

    if (endY < _candleRectY + DISTANCE_MA)
      endY = _candleRectY + DISTANCE_MA;
    if (endY > _candleRectY + _candleRectH)
      endY = _candleRectY + _candleRectH;
    if (startY < _candleRectY + DISTANCE_MA)
      startY = _candleRectY + DISTANCE_MA;
    if (startY > _candleRectY + _candleRectH)
      startY = _candleRectY + _candleRectH;

    CGPoint startPoint, endPoint;
    startPoint = CGPointMake(startX, startY);
    endPoint = CGPointMake(endX, endY);

    //画蜡烛体,如果上涨则空心,否则为实心
    //如果开盘和收盘一样，则看涨幅
    if (data.openPrice == data.closePrice) {
      KLineDayData *preData = _dateElementArray[(i > 0 ? i : 1) - 1];

      [[Globle colorFromHexRGB:((preData.closePrice <= data.closePrice) ? Color_Red : Color_Green)] set];
    } else {
      [[Globle colorFromHexRGB:((data.openPrice < data.closePrice) ? Color_Red : Color_Green)] set];
    }
    //设定线宽度
    CGContextSetLineWidth(context, 1.0);

    if (data.openPrice <= data.closePrice) {

      startX = _candleRectX + kLineWidth * 2 * iCount;
      tempCandleH = ((_candleRectH - DISTANCE_MA) * (data.closePrice - _priceMarkArray[0])) /
                    (_priceMarkArray[PRICE_MARKS_5 - 1] - _priceMarkArray[0]);
      startY = _candleRectY + _candleRectH - (tempCandleH < 1 ? 1 : (int)tempCandleH);

      if (startY < _candleRectY + DISTANCE_MA)
        startY = _candleRectY + DISTANCE_MA;
      if (startY > _candleRectY + _candleRectH)
        startY = _candleRectY + _candleRectH;
      if (kLineWidth == 2) {
        if ((kLineWidth % 2) == 0)
          candleW = kLineWidth + 1;
        else
          candleW = kLineWidth;
      } else
        candleW = 2 * kLineWidth * .8f;

      tempCandleH = (_candleRectH - DISTANCE_MA) * (data.closePrice - data.openPrice) /
                    (_priceMarkArray[PRICE_MARKS_5 - 1] - _priceMarkArray[0]);

      candleH = (tempCandleH < 1) ? 1 : (int)tempCandleH;
      tempCandleRect = CGRectMake(startX, startY, candleW, candleH);

      //画出矩形
      CGContextAddRect(context, tempCandleRect);
      CGContextFillPath(context);

      if (candleH == 1) {
        CGContextMoveToPoint(context, startX + 1, startY + 1);
        CGContextAddLineToPoint(context, startX + 1, startY + candleH);
        CGContextStrokePath(context);
      } else {
        CGContextMoveToPoint(context, startX + 1, startY + 1);
        CGContextAddLineToPoint(context, startX + 1, startY + candleH - 1);
        CGContextStrokePath(context);
      }
    } else {

      startX = _candleRectX + kLineWidth * 2 * iCount;
      tempCandleH = ((_candleRectH - DISTANCE_MA) * (data.openPrice - _priceMarkArray[0])) /
                    (_priceMarkArray[PRICE_MARKS_5 - 1] - _priceMarkArray[0]);
      startY = _candleRectY + _candleRectH - (tempCandleH < 1 ? 1 : (int)tempCandleH);

      if (startY < _candleRectY + DISTANCE_MA)
        startY = _candleRectY + DISTANCE_MA;
      if (startY > _candleRectY + _candleRectH)
        startY = _candleRectY + _candleRectH;

      if (kLineWidth == 2) {
        if ((kLineWidth % 2) == 0)
          candleW = kLineWidth + 1;
        else
          candleW = kLineWidth;
      } else {
        candleW = 2 * kLineWidth * .8f;
      }
      tempCandleH = ((_candleRectH - DISTANCE_MA) * (data.openPrice - data.closePrice)) /
                    (_priceMarkArray[PRICE_MARKS_5 - 1] - _priceMarkArray[0]);

      candleH = tempCandleH < 1 ? 1 : (int)tempCandleH;

      tempCandleRect = CGRectMake(startX, startY, candleW, candleH);
      CGContextAddRect(context, tempCandleRect);
      CGContextFillPath(context);
    }

    //一字板不画竖线
    if (data.highestPrice != data.lowestPrice) {
      CGContextMoveToPoint(context, startX + candleW / 2, startY);          // m_pos1.x+w/8.f
      CGContextAddLineToPoint(context, startX + candleW / 2, startPoint.y); // m_pos1.x+w/8.f
      CGContextStrokePath(context);
      CGContextMoveToPoint(context, startX + candleW / 2, startY + candleH); // m_pos2.x+w/8.f
      CGContextAddLineToPoint(context, startX + candleW / 2, endPoint.y);    // m_pos2.x+w/8.f
      CGContextStrokePath(context);
    }
  }

  //防止“穿心"
  iCount = 0;
  for (NSInteger i = _screenStartIndex; i < minDays; i++, iCount++) {
    //画5条MA线
    if (i < minDays - 1) {
      for (NSInteger j = 0; j < numbers.count; j++) {
        NSInteger num = [numbers[j] integerValue];
        if (i >= num - 1 && num <= elementCount) {
          NSNumber *number = maAvgDataArray[j][i - 1];
          NSNumber *number2 = maAvgDataArray[j][i];
          NSInteger value1 = [number longValue];
          NSInteger value2 = [number2 longValue];
          startX = _candleRectX + kLineWidth * 2 * iCount + kLineWidth;
          startY = _candleRectY + _candleRectH -
                   ((_candleRectH - DISTANCE_MA) * (value1 - _priceMarkArray[0])) /
                       (_priceMarkArray[PRICE_MARKS_5 - 1] - _priceMarkArray[0]);

          endX = startX + kLineWidth * 2;
          if (startX < 4)
            startX = _candleRectX;
          endY = _candleRectY + _candleRectH -
                 ((_candleRectH - DISTANCE_MA) * (value2 - _priceMarkArray[0])) /
                     (_priceMarkArray[PRICE_MARKS_5 - 1] - _priceMarkArray[0]);

          if (endY < _candleRectY + DISTANCE_MA)
            endY = _candleRectY + DISTANCE_MA;
          if (endY > _candleRectY + _candleRectH)
            endY = _candleRectY + _candleRectH;
          if (startY < _candleRectY + DISTANCE_MA)
            startY = _candleRectY + DISTANCE_MA;
          if (startY > _candleRectY + _candleRectH)
            startY = _candleRectY + _candleRectH;

          UIColor *color = [Globle colorFromHexRGB:colors[j]];
          [color set];
          CGContextMoveToPoint(context, startX, startY);
          CGContextAddLineToPoint(context, endX, endY);
          CGContextStrokePath(context);
        }
      }
    }
  }
}

#pragma mark - 使用视图画出指标线
- (void)drawViewIndexLine {
  if (_screenStartIndex + _index >= _dateElementArray.count) {
    return;
  }

  //宽度
  CGPoint pt1 = CGPointMake(_candleRectX + 2 * KLINE_WIDTH * (_index) + 2 * KLINE_WIDTH / 2, _candleRectY);

  if (!_verticalLineView) {

    CGRect rect = CGRectMake(pt1.x, pt1.y, 1, CGRectGetHeight(_allShowFrame));
    _verticalLineView = [[UIView alloc] initWithFrame:rect];
    //设定颜色
    _verticalLineView.backgroundColor = [Globle colorFromHexRGB:COLOR_INDICATOR_LINE];

    [self insertSubview:_verticalLineView
                atIndex:[[self subviews] indexOfObject:_dateBackView] + 1];
  }

  _verticalLineView.center = CGPointMake(pt1.x - 1, _candleRectY + _verticalLineView.bounds.size.height / 2);

  //画出横线
  pt1 = CGPointMake(_candleRectX, _lastPositon.y);
  CGPoint pt2 = CGPointMake(_candleRectX + _candleRectW / 2, _lastPositon.y);

  if (!_horizontalLineView) {
    CGRect rect = CGRectMake(pt1.x, pt1.y, _candleRectW, 1);
    _horizontalLineView = [[UIView alloc] initWithFrame:rect];
    //设定颜色
    _horizontalLineView.backgroundColor = [Globle colorFromHexRGB:COLOR_INDICATOR_LINE];

    [self insertSubview:_horizontalLineView
                atIndex:[[self subviews] indexOfObject:_dateBackView] + 1];
  }

  //重置纵、横线位置
  _horizontalLineView.center = CGPointMake(pt2.x, pt1.y);

  //重设横线坐标
  KLineDayData *data = _dateElementArray[_screenStartIndex + _index];
  float y = _candleRectY + _candleRectH -
            ((_candleRectH - DISTANCE_MA) * (data.closePrice - _priceMarkArray[0])) /
                (_priceMarkArray[PRICE_MARKS_5 - 1] - _priceMarkArray[0]);
  _horizontalLineView.center = CGPointMake(pt2.x, y);

  //画出横屏的价格方框
  [self drawMoveScaleLabel:_lastPositon];
}

#pragma mark - 画出移动价格标签
- (void)drawMoveScaleLabel:(CGPoint)point {

  BOOL isRighted = (point.x >= _candleRectX + _candleRectW / 2);

  if (isRighted) {
    _currentInfoLabel.textAlignment = NSTextAlignmentLeft;
    _floatWindow4KLineView.center = CGPointMake(_candleRectX + 45, 57);
  } else {
    _currentInfoLabel.textAlignment = NSTextAlignmentRight;
    _floatWindow4KLineView.center = CGPointMake(_candleRectX + 45 + _candleRectW - 87, 57);
  }

  if (!_isLandscape) {
    return;
  }

  //设定标签内容
  NSInteger arrayindex = _screenStartIndex + _index;
  if (arrayindex < 0 || arrayindex >= _dateElementArray.count) {
    return;
  }

  KLineDayData *element = _dateElementArray[arrayindex];
  if (element) {
    NSString *content = [NSString stringWithFormat:@"%lld", element.date];
    //@"20150427132500"
    NSString *dateStr;
    //如果是分钟线 格式：05-12 15:00
    if ([[content substringFromIndex:8] integerValue] != 0) {
      dateStr = [NSString stringWithFormat:@"%@-%@ %@:%@", [content substringFromIndex:4 toIndex:6],
                                           [content substringFromIndex:6 toIndex:8],
                                           [content substringFromIndex:8 toIndex:10],
                                           [content substringFromIndex:10 toIndex:12]];
    } else {
      //如果是日k等 格式：2015-05-12
      dateStr = [NSString stringWithFormat:@"%@-%@-%@", [content substringFromIndex:0 toIndex:4],
                                           [content substringFromIndex:4 toIndex:6],
                                           [content substringFromIndex:6 toIndex:8]];
    }
    _currentTimeLabel.text = dateStr;
  }

  //画出时间标签
  //设定时间标签的位置
  [SimuUtil widthOfLabel:_currentTimeLabel font:Font_Height_11_0];
  float labelWidth = _currentTimeLabel.bounds.size.width;
  if (point.x < _candleRectX + labelWidth / 2) {
    _currentTimeLabel.center = CGPointMake(_candleRectX + labelWidth / 2, _currentTimeLabel.center.y);
  } else if (point.x > _candleRectX + _candleRectW - labelWidth) {
    _currentTimeLabel.center =
        CGPointMake(_candleRectX + _candleRectW - labelWidth / 2, _currentTimeLabel.center.y);
  } else {
    _currentTimeLabel.center = CGPointMake(point.x, _currentTimeLabel.center.y);
  }

  //价格游标
  KLineDataItem *item = _kLineDataItemInfo.dataArray[arrayindex];
  NSString *format = [StockUtil getPriceFormatWithFirstType:_securitiesInfo.securitiesFirstType()];
  _currentPriceLabel.text = [NSString stringWithFormat:format, item.closeprice];
  [SimuUtil widthOfLabel:_currentPriceLabel font:Font_Height_11_0];
  _currentPriceLabel.center =
      CGPointMake(_candleRectX - _currentPriceLabel.width / 2 - 1, _horizontalLineView.centerY);
  if (_currentPriceLabel.top < _candleRectY) {
    _currentPriceLabel.top = _candleRectY;
  } else if (_currentPriceLabel.top > _candleRectY + _candleRectH) {
    _currentPriceLabel.top = _candleRectY + _candleRectH;
  }
}

///获取字符串的长度
- (CGFloat)lengthOfString:(NSString *)string andFont:(UIFont *)font {
  if (SYSTEM_VERSION >= 7.0) {
    CGSize size = [string sizeWithAttributes:@{NSFontAttributeName : font}];
    return size.width + 3;
  } else {
    CGSize size = [string sizeWithFont:font];
    return size.width + 3;
  }
}

#pragma mark
#pragma mark 点击消息回调
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  //纪录初始点
  _lastMovePosition = _beginPosition = _lastPositon = [[touches anyObject] locationInView:self];
  if (_flowWindowState == MOD_TREND_SHOWFLWindows) {
    [self hideFloatView];
  }
}

- (void)touchClickAndMove:(CGPoint)point {
  if (_flowWindowState == MOD_TREND_NOFLWindows)
    return;
  _maBackView.hidden = YES;
  _maLabelBackView.hidden = NO;
  _floatWindow4KLineView.hidden = NO;
  CGRect rect = CGRectMake(_candleRectX, _candleRectY, _candleRectW, HEIGHT_OF_VIEW + 7);
  if (CGRectContainsPoint(rect, point)) {
    //点击均线和量线区域s
    NSInteger index = (point.x - (float)_candleRectX) / (2 * KLINE_WIDTH);
    if (index >= _dateElementArray.count) {
      index = _dateElementArray.count - 1;
      if (_lastPositon.x > _candleRectX + _dateElementArray.count * (2 * KLINE_WIDTH)) {
        _lastPositon.x = _candleRectX + _dateElementArray.count * (2 * KLINE_WIDTH);
      }
    }
    if (index >= 0 && _dateElementArray && index < _dateElementArray.count) {
      [self sendShowFloatViewContent:index];
      _index = index;
      [self drawViewIndexLine];
      return;
    }
  }
}

#pragma mark - 显示指定的指标线
- (void)setIndicatorLineType:(NSInteger)index {
  switch (index) {
  case 0: {
    // VOL
    _indicatorLineType = indicatorVOL;
    _volumeTitle = @"VOL";
    _currentInfoLabel.text = _volumeTitle;
    [self setNeedsDisplay];
  } break;
  case 1: {
    // MACD
    _indicatorLineType = indicatorMACD;
    _volumeTitle = @"MACD(12,26,9)";
    _currentInfoLabel.text = _volumeTitle;
    [self setNeedsDisplay];
  } break;
  case 2: {
    // KDJ
    _indicatorLineType = indicatorKDJ;
    _volumeTitle = @"KDJ(9,3,3)";
    _currentInfoLabel.text = _volumeTitle;
    [self setNeedsDisplay];
  } break;
  case 3: {
    // RSI
    _indicatorLineType = indicatorRSI;
    _volumeTitle = @"RSI(6,12,24)";
    _currentInfoLabel.text = _volumeTitle;
    [self setNeedsDisplay];
  } break;
  case 4: {
    // BOLL
    _indicatorLineType = indicatorBOLL;
    _volumeTitle = @"BOLL(20,2)";
    _currentInfoLabel.text = _volumeTitle;
    [self setNeedsDisplay];
  } break;
  case 5: {
    // BRAR
    _indicatorLineType = indicatorBRAR;
    _volumeTitle = @"BRAR(26,70,150)";
    _currentInfoLabel.text = _volumeTitle;
    [self setNeedsDisplay];
  } break;
  case 6: {
    // OBV
    _indicatorLineType = indicatorOBV;
    _volumeTitle = @"OBV(30)";
    _currentInfoLabel.text = _volumeTitle;
    [self setNeedsDisplay];
  } break;
  case 7: {
    // DMI
    _indicatorLineType = indicatorDMI;
    _volumeTitle = @"DMI(14,6)";
    _currentInfoLabel.text = _volumeTitle;
    [self setNeedsDisplay];
  } break;
  case 8: {
    // BIAS
    _indicatorLineType = indicatorBIAS;
    _volumeTitle = @"BIAS(6,-3,3,12,24)";
    _currentInfoLabel.text = _volumeTitle;
    [self setNeedsDisplay];
  } break;
  case 9: {
    // W&R
    _indicatorLineType = indicatorWR;
    _volumeTitle = @"W&R(10,20,80)";
    _currentInfoLabel.text = _volumeTitle;
    [self setNeedsDisplay];
  } break;

  default:
    break;
  }
}

#pragma mark - 🌛画指标线
#pragma mark 0⃣️画出VOL
- (void)drawVOLLine:(CGContextRef)context {

  NSInteger elementCount = _dateElementArray.count;
  if (elementCount <= 0) {
    return;
  }

  CGContextSetLineWidth(context, 1.0);

  float startX, startY, width, height;
  NSInteger kLineWidth = KLINE_WIDTH;

  for (NSInteger i = _screenStartIndex; i < fmin(elementCount, _screenStartIndex + _showedCount); i++) {

    KLineDayData *data = _dateElementArray[i];
    if (data.openPrice == 0 || data.highestPrice == 0 || data.lowestPrice == 0 || data.closePrice == 0)
      break;

    startX = _volumeRectX + kLineWidth * 2 * (i - _screenStartIndex);
    startY = _volumeRectY + _volumeRectH - ((_volumeRectH * (data.volume)) / (_maxVolume));

    //处理数据异常导致的画线越界
    if (startY < _volumeRectY)
      startY = _volumeRectY;

    if (kLineWidth == 2)
      width = kLineWidth;
    else
      width = 2 * kLineWidth * .8f;
    height = _volumeRectY + _volumeRectH - startY;

    //如果成交量的高度小于等于0，默认改成1
    if (height <= 1) {
      height = 1;
    }

    CGRect volumeRect = CGRectMake(startX, startY, width, height);
    [[Globle colorFromHexRGB:((data.openPrice <= data.closePrice) ? Color_Red : Color_Green)] set];

    CGContextAddRect(context, volumeRect);
    CGContextFillPath(context);
  }

  //创建交易量标签
  UILabel *volumeLabel =
      [[UILabel alloc] initWithFrame:CGRectMake(_isLandscape ? 0 : _volumeRectX, 0, 42, 11)];
  volumeLabel.textAlignment = _isLandscape ? NSTextAlignmentRight : NSTextAlignmentLeft;
  volumeLabel.textColor = [Globle colorFromHexRGB:Color_Dark];
  volumeLabel.backgroundColor = [UIColor clearColor];
  volumeLabel.font = UIScaleFont;
  volumeLabel.adjustsFontSizeToFitWidth = YES;
  volumeLabel.text = [StockUtil handsStringFromVolume:_maxVolume needsHand:NO];
  [_indicatorInfoBackView addSubview:volumeLabel];

  //“手”标签
  UILabel *handLabel =
      [[UILabel alloc] initWithFrame:CGRectMake(0, _volumeRectH - 11, _volumeRectX - 3, 11)];
  handLabel.text = @"手";
  handLabel.textAlignment = NSTextAlignmentRight;
  handLabel.textColor = [Globle colorFromHexRGB:Color_Dark];
  handLabel.backgroundColor = [UIColor clearColor];
  handLabel.font = UIScaleFont;
  handLabel.adjustsFontSizeToFitWidth = YES;
  [_indicatorInfoBackView addSubview:handLabel];
}

#pragma mark 1⃣️画出MACD
- (void)drawMACDLine:(CGContextRef)context {
  _macdPoints = [MACD getMACDPoints:_kLineDataItemInfo.dataArray];

  NSInteger count = _macdPoints.count;

  if (count == 0) {
    return;
  }

  //需要循环的次数
  int needLoops = fmin(count, _screenStartIndex + _showedCount);

  // 1.先计算出最大刻度值
  float maxScale = [_macdPoints[needLoops - 1] dif];

  for (NSInteger i = _screenStartIndex; i < needLoops; i++) {

    MACDPoint *point = _macdPoints[i];

    //计算此区域内最大值来决定最大刻度
    float tempMax = fmaxf(fmaxf(fabsf(point.dif), fabsf(point.dea)), fabsf(point.macd));
    if (maxScale < tempMax) {
      maxScale = tempMax;
    }
  }
  if (maxScale == 0) {
    return;
  }

  CGContextSetLineWidth(context, 1.0);

  float startX, startY, endX, endY, width, height;
  NSInteger kLineWidth = KLINE_WIDTH; //‼️注意，这是k线宽度的半径！

  //区域线最高高度,所有坐标向下偏移10，方便显示标签
  float lineMaxH = (_volumeRectH - 10) / 2;

  //中间线坐标
  float middleLineY = _volumeRectY + 10 + lineMaxH - 1; //防止超界

  // 2.计算每个point相对于最大值的具体坐标
  for (NSInteger i = _screenStartIndex; i < needLoops; i++) {

    MACDPoint *point = _macdPoints[i];

    // 2.1 MACD
    startX = _volumeRectX + kLineWidth * 2 * (i - _screenStartIndex);

    if (kLineWidth == 2)
      width = kLineWidth;
    else
      width = 2 * kLineWidth * .8f;
    height = -point.macd / maxScale * lineMaxH;

    [[Globle colorFromHexRGB:((point.macd > 0) ? Color_Red : Color_Green)] set];
    CGContextAddRect(context, CGRectMake(startX, middleLineY, width, height));
    CGContextFillPath(context);
  }

  //为了防止“穿线”问题，必须先画完MACD再画两根曲线，必须重复两遍循环
  for (NSInteger i = _screenStartIndex; i < needLoops; i++) {

    MACDPoint *point = _macdPoints[i];

    startX = _volumeRectX + kLineWidth * 2 * (i - _screenStartIndex);

    if (kLineWidth == 2)
      width = kLineWidth;
    else
      width = 2 * kLineWidth * .8f;
    height = -point.macd / maxScale * lineMaxH;

    //‼️注意需要少取一个点
    if (i < needLoops - 1) {
      MACDPoint *nextPoint = _macdPoints[i + 1];

      // 2.2 DIF，正的在上，负的在下
      startX += kLineWidth - 1; //向左移动1，恰好保证与k线对齐
      startY = middleLineY - point.dif / maxScale * lineMaxH;

      endX = startX + kLineWidth * 2;
      endY = middleLineY - nextPoint.dif / maxScale * lineMaxH;

      [[Globle colorFromHexRGB:COLOR_MA_ORANGE] set];
      CGContextMoveToPoint(context, startX, startY);
      CGContextAddLineToPoint(context, endX, endY);
      CGContextStrokePath(context);

      // 2.3 DEA
      startY = middleLineY - point.dea / maxScale * lineMaxH;
      endY = middleLineY - nextPoint.dea / maxScale * lineMaxH;

      [[Globle colorFromHexRGB:COLOR_MA_BLUE] set];
      CGContextMoveToPoint(context, startX, startY);
      CGContextAddLineToPoint(context, endX, endY);
      CGContextStrokePath(context);
    }
  }

  //刻度标签Y坐标数组
  NSArray *infoLabelYArray = @[ @(10), @(lineMaxH + 10 - 11 / 2), @(_volumeRectH - 11) ];
  // 高、中、低 标签
  for (NSInteger i = 0; i < 3; i++) {
    UILabel *minLabel =
        [[UILabel alloc] initWithFrame:CGRectMake(0, [infoLabelYArray[i] floatValue], _volumeRectX - 3, 11)];
    minLabel.text = [NSString stringWithFormat:@"%.3f", maxScale * (1 - i)];
    minLabel.textAlignment = NSTextAlignmentRight;
    minLabel.textColor = [Globle colorFromHexRGB:Color_Dark];
    minLabel.backgroundColor = [UIColor clearColor];
    minLabel.font = UIScaleFont;
    minLabel.adjustsFontSizeToFitWidth = YES;
    [_indicatorInfoBackView addSubview:minLabel];
  }
}

#pragma mark 2⃣️画出KDJ
- (void)drawKDJLine:(CGContextRef)context {
  _kdjPoints = [KDJ getKDJPoints:_kLineDataItemInfo.dataArray];

  NSInteger count = _kdjPoints.count;

  if (count == 0) {
    return;
  }

  //需要循环的次数
  int needLoops = fmin(count, _screenStartIndex + _showedCount);

  // 1.先计算出最大刻度值，最小刻度值
  float maxScale = [_kdjPoints[needLoops - 1] j];
  float minScale = maxScale;

  for (NSInteger i = _screenStartIndex; i < needLoops; i++) {

    KDJPoint *point = _kdjPoints[i];

    //计算此区域内最大值来决定最大刻度
    if (maxScale < point.j) {
      maxScale = point.j;
    }

    //最小
    if (minScale > point.j) {
      minScale = point.j;
    }
  }

  //价格区间
  float scaleRange = maxScale - minScale;
  if (scaleRange == 0) {
    return;
  }

  CGContextSetLineWidth(context, 1.0);

  float startX, startY, endX, endY;
  NSInteger kLineWidth = KLINE_WIDTH; //‼️注意，这是k线宽度的半径！

  //区域线最高高度,所有坐标向下偏移10，方便显示标签
  // 1.KD的取值范围都是0～100，分为 80 50 20 线，范围-10~110+，30间隔
  float lineMaxH = _volumeRectH - 10; //基准线上面最高高度

  //基准线Y坐标，0线
  float baseLineY = _volumeRectY + _volumeRectH - 1; //防止超界

  [[Globle colorFromHexRGB:COLOR_KLINE_SEPARATOR] set];

  //刻度标签Y坐标数组
  NSMutableArray *infoLabelYArray = [[NSMutableArray alloc] init];

  //添加80线
  startY = baseLineY - (80.f - minScale) / scaleRange * lineMaxH;
  CGContextMoveToPoint(context, _volumeRectX, startY);
  CGContextAddLineToPoint(context, _volumeRectX + _volumeRectW, startY);
  CGContextStrokePath(context);
  [infoLabelYArray addObject:@(startY)];

  //添加50线
  startY = baseLineY - (50.f - minScale) / scaleRange * lineMaxH;
  CGContextMoveToPoint(context, _volumeRectX, startY);
  CGContextAddLineToPoint(context, _volumeRectX + _volumeRectW, startY);
  CGContextStrokePath(context);
  [infoLabelYArray addObject:@(startY)];

  //添加20线
  startY = baseLineY - (20.f - minScale) / scaleRange * lineMaxH;
  CGContextMoveToPoint(context, _volumeRectX, startY);
  CGContextAddLineToPoint(context, _volumeRectX + _volumeRectW, startY);
  CGContextStrokePath(context);
  [infoLabelYArray addObject:@(startY)];

  // 2.计算每个point相对于最大值的具体坐标
  for (NSInteger i = _screenStartIndex; i < needLoops - 1; i++) {

    KDJPoint *point = _kdjPoints[i];
    KDJPoint *nextPoint = _kdjPoints[i + 1];

    // 2.1 K
    startX = _volumeRectX + kLineWidth * 2 * (i - _screenStartIndex) + kLineWidth - 1; //向左移动1，恰好保证与k线对齐
    startY = baseLineY - (point.k - minScale) / scaleRange * lineMaxH;

    endX = startX + kLineWidth * 2;
    endY = baseLineY - (nextPoint.k - minScale) / scaleRange * lineMaxH;

    [[Globle colorFromHexRGB:COLOR_MA_ORANGE] set];
    CGContextMoveToPoint(context, startX, startY);
    CGContextAddLineToPoint(context, endX, endY);
    CGContextStrokePath(context);

    // 2.2 D
    startY = baseLineY - (point.d - minScale) / scaleRange * lineMaxH;
    endY = baseLineY - (nextPoint.d - minScale) / scaleRange * lineMaxH;

    [[Globle colorFromHexRGB:COLOR_MA_BLUE] set];
    CGContextMoveToPoint(context, startX, startY);
    CGContextAddLineToPoint(context, endX, endY);
    CGContextStrokePath(context);

    // 2.3 J
    startY = baseLineY - (point.j - minScale) / scaleRange * lineMaxH;
    endY = baseLineY - (nextPoint.j - minScale) / scaleRange * lineMaxH;

    [[Globle colorFromHexRGB:COLOR_MA_PURPLE] set];
    CGContextMoveToPoint(context, startX, startY);
    CGContextAddLineToPoint(context, endX, endY);
    CGContextStrokePath(context);
  }

  // 80.0 50.0 20.0 标签
  for (NSInteger i = 0; i < 3; i++) {
    UILabel *minLabel =
        [[UILabel alloc] initWithFrame:CGRectMake(0, [infoLabelYArray[i] floatValue] - _volumeRectY - 11 / 2, _volumeRectX - 3, 11)];
    minLabel.text = [NSString stringWithFormat:@"%.1f", 80.0f - i * 30.0f];
    minLabel.textAlignment = NSTextAlignmentRight;
    minLabel.textColor = [Globle colorFromHexRGB:Color_Dark];
    minLabel.backgroundColor = [UIColor clearColor];
    minLabel.font = UIScaleFont;
    minLabel.adjustsFontSizeToFitWidth = YES;
    [_indicatorInfoBackView addSubview:minLabel];
  }
}

#pragma mark 3⃣️画出RSI
- (void)drawRSILine:(CGContextRef)context {
  _rsiPoints = [RSI getRSIPoints:_kLineDataItemInfo.dataArray];

  NSInteger count = _rsiPoints.count;

  if (count == 0) {
    return;
  }

  //需要循环的次数
  int needLoops = fmin(count, _screenStartIndex + _showedCount);

  CGContextSetLineWidth(context, 1.0);

  float startX, startY, endX, endY;
  NSInteger kLineWidth = KLINE_WIDTH; //‼️注意，这是k线宽度的半径！

  //区域线最高高度,所有坐标向下偏移10，方便显示标签
  // KD的取值范围都是0～100，分为 80 50 20 线，范围-10~110，30间隔
  float lineMaxH = _volumeRectH - 10; //基准线上面最高高度

  //基准线Y坐标，0线
  float baseLineY = _volumeRectY + _volumeRectH - 1; //防止超界

  [[Globle colorFromHexRGB:COLOR_KLINE_SEPARATOR] set];

  //刻度标签Y坐标数组
  NSMutableArray *infoLabelYArray = [[NSMutableArray alloc] init];

  //添加80线
  startY = baseLineY - 80.f / 100 * lineMaxH;
  CGContextMoveToPoint(context, _volumeRectX, startY);
  CGContextAddLineToPoint(context, _volumeRectX + _volumeRectW, startY);
  CGContextStrokePath(context);
  [infoLabelYArray addObject:@(startY)];

  //添加50线
  startY = baseLineY - 50.f / 100 * lineMaxH;
  CGContextMoveToPoint(context, _volumeRectX, startY);
  CGContextAddLineToPoint(context, _volumeRectX + _volumeRectW, startY);
  CGContextStrokePath(context);
  [infoLabelYArray addObject:@(startY)];

  //添加20线
  startY = baseLineY - 20.f / 100 * lineMaxH;
  CGContextMoveToPoint(context, _volumeRectX, startY);
  CGContextAddLineToPoint(context, _volumeRectX + _volumeRectW, startY);
  CGContextStrokePath(context);
  [infoLabelYArray addObject:@(startY)];

  //指标临时数值
  NSNumber *number1, *number2;

  //计算每个point相对于最大值的具体坐标
  for (NSInteger i = _screenStartIndex; i < needLoops - 1; i++) {

    RSIPoint *point = _rsiPoints[i];
    RSIPoint *nextPoint = _rsiPoints[i + 1];

    startX = _volumeRectX + kLineWidth * 2 * (i - _screenStartIndex) + kLineWidth - 1; //向左移动1，恰好保证与k线对齐
    endX = startX + kLineWidth * 2;

    // rsi6
    number1 = point.valueDic[@(6)];
    number2 = nextPoint.valueDic[@(6)];

    if (![number1 isEqual:[NSNull null]] && ![number2 isEqual:[NSNull null]]) {
      startY = baseLineY - [number1 floatValue] / 100 * lineMaxH;
      endY = baseLineY - [number2 floatValue] / 100 * lineMaxH;

      [[Globle colorFromHexRGB:COLOR_MA_ORANGE] set];
      CGContextMoveToPoint(context, startX, startY);
      CGContextAddLineToPoint(context, endX, endY);
      CGContextStrokePath(context);
    }

    // rsi12
    number1 = point.valueDic[@(12)];
    number2 = nextPoint.valueDic[@(12)];

    if (![number1 isEqual:[NSNull null]] && ![number2 isEqual:[NSNull null]]) {

      startY = baseLineY - [number1 floatValue] / 100 * lineMaxH;
      endY = baseLineY - [number2 floatValue] / 100 * lineMaxH;

      [[Globle colorFromHexRGB:COLOR_MA_BLUE] set];
      CGContextMoveToPoint(context, startX, startY);
      CGContextAddLineToPoint(context, endX, endY);
      CGContextStrokePath(context);
    }

    // rsi24
    number1 = point.valueDic[@(24)];
    number2 = nextPoint.valueDic[@(24)];

    if (![number1 isEqual:[NSNull null]] && ![number2 isEqual:[NSNull null]]) {

      startY = baseLineY - [number1 floatValue] / 100 * lineMaxH;
      endY = baseLineY - [number2 floatValue] / 100 * lineMaxH;

      [[Globle colorFromHexRGB:COLOR_MA_PURPLE] set];
      CGContextMoveToPoint(context, startX, startY);
      CGContextAddLineToPoint(context, endX, endY);
      CGContextStrokePath(context);
    }
  }

  // 80.0 50.0 20.0 标签
  for (NSInteger i = 0; i < 3; i++) {
    UILabel *minLabel =
        [[UILabel alloc] initWithFrame:CGRectMake(0, [infoLabelYArray[i] floatValue] - _volumeRectY - 11 / 2, _volumeRectX - 3, 11)];
    minLabel.text = [NSString stringWithFormat:@"%.1f", 80.0f - i * 30.0f];
    minLabel.textAlignment = NSTextAlignmentRight;
    minLabel.textColor = [Globle colorFromHexRGB:Color_Dark];
    minLabel.backgroundColor = [UIColor clearColor];
    minLabel.font = UIScaleFont;
    minLabel.adjustsFontSizeToFitWidth = YES;
    [_indicatorInfoBackView addSubview:minLabel];
  }
}

#pragma mark 4⃣️画出BOLL
- (void)drawBOLLLine:(CGContextRef)context {
  _bollPoints = [BOLL getBOLLPoints:_kLineDataItemInfo.dataArray];

  NSInteger count = _bollPoints.count;

  if (count == 0) {
    return;
  }

  //需要循环的次数
  int needLoops = fmin(count, _screenStartIndex + _showedCount);

  // 1.先计算出最大刻度值，最小刻度值
  float maxScale = [_kLineDataItemInfo.dataArray[needLoops - 1] openprice];
  float minScale = maxScale;

  for (NSInteger i = _screenStartIndex; i < needLoops; i++) {

    BOLLPoint *point = _bollPoints[i];
    KLineDataItem *data = _kLineDataItemInfo.dataArray[i];

    //先从k线的数据中取最大最小值
    float tempMaxData =
        (fmaxf(fmaxf(data.highprice, data.closeprice), fmaxf(data.openprice, data.lowprice)));

    if (maxScale < tempMaxData) {
      maxScale = tempMaxData;
    }

    float tempMminData =
        (fminf(fminf(data.highprice, data.closeprice), fminf(data.openprice, data.lowprice)));

    if (minScale > tempMminData) {
      minScale = tempMminData;
    }

    //如果有一个为零，跳过计算
    if ([point.mid floatValue] == 0 || [point.upper floatValue] == 0 || [point.upper floatValue] == 0) {

      continue;
    }

    //计算最大值，计算此区域内最大值来决定最大刻度
    float tempMax = fmaxf(fmaxf([point.mid floatValue], [point.upper floatValue]),
                          fmaxf(tempMaxData, [point.lower floatValue]));
    if (maxScale < tempMax) {
      maxScale = tempMax;
    }

    //最小
    float tempMin = fminf(fminf([point.mid floatValue], [point.upper floatValue]),
                          fminf(tempMminData, [point.lower floatValue]));
    if (minScale > tempMin) {
      minScale = tempMin;
    }
  }

  //价格区间
  float scaleRange = maxScale - minScale;
  if (scaleRange == 0) {
    return;
  }

  CGContextSetLineWidth(context, 1.0);

  float startX, startY, endX, endY, width;
  NSInteger kLineWidth = KLINE_WIDTH; //‼️注意，这是k线宽度的半径！

  //区域线最高高度,所有坐标向下偏移10，方便显示标签
  float lineMaxH = _volumeRectH - 10;

  //基准线Y坐标，0线
  float baseLineY = _volumeRectY + _volumeRectH - 1; //防止超界

  //绘制另一种样式的k线，一丨一 线
  for (NSInteger i = _screenStartIndex; i < needLoops; i++) {

    //得到当前元素
    KLineDataItem *data = _kLineDataItemInfo.dataArray[i];

    //画蜡烛体,如果上涨则空心,否则为实心
    [[Globle colorFromHexRGB:((data.openprice <= data.closeprice) ? Color_Red : Color_Green)] set];
    if (kLineWidth == 2)
      width = kLineWidth;
    else
      width = kLineWidth - 1;

    //竖线，最高价~最低价
    startX = _volumeRectX + kLineWidth * 2 * (i - _screenStartIndex) + kLineWidth - 1;
    startY = baseLineY - (data.highprice - minScale) / scaleRange * lineMaxH;

    endX = startX;
    endY = baseLineY - (data.lowprice - minScale) / scaleRange * lineMaxH;

    CGContextMoveToPoint(context, startX, startY);
    CGContextAddLineToPoint(context, endX, endY);
    CGContextStrokePath(context);

    //开盘价横线
    startX -= width;
    startY = baseLineY - (data.openprice - minScale) / scaleRange * lineMaxH;
    endY = startY;

    CGContextMoveToPoint(context, startX, startY);
    CGContextAddLineToPoint(context, endX, endY);
    CGContextStrokePath(context);

    //收盘价横线
    startX = endX;
    startY = baseLineY - (data.closeprice - minScale) / scaleRange * lineMaxH;
    endY = startY;
    endX += width;

    CGContextMoveToPoint(context, startX, startY);
    CGContextAddLineToPoint(context, endX, endY);
    CGContextStrokePath(context);
  }

  //指标临时数值
  NSNumber *number1, *number2;

  //计算每个point相对于最大值的具体坐标
  for (NSInteger i = _screenStartIndex; i < needLoops - 1; i++) {

    BOLLPoint *point = _bollPoints[i];
    BOLLPoint *nextPoint = _bollPoints[i + 1];

    startX = _volumeRectX + kLineWidth * 2 * (i - _screenStartIndex) + kLineWidth - 1; //向左移动1，恰好保证与k线对齐
    endX = startX + kLineWidth * 2;

    // mid
    number1 = point.mid;
    number2 = nextPoint.mid;

    if ([number1 floatValue] != 0 && [number2 floatValue] != 0) {
      startY = baseLineY - ([number1 floatValue] - minScale) / scaleRange * lineMaxH;

      endY = baseLineY - ([number2 floatValue] - minScale) / scaleRange * lineMaxH;

      [[Globle colorFromHexRGB:COLOR_MA_ORANGE] set];
      CGContextMoveToPoint(context, startX, startY);
      CGContextAddLineToPoint(context, endX, endY);
      CGContextStrokePath(context);
    }

    // upper
    number1 = point.upper;
    number2 = nextPoint.upper;

    if ([number1 floatValue] != 0 && [number2 floatValue] != 0) {

      startY = baseLineY - ([number1 floatValue] - minScale) / scaleRange * lineMaxH;
      endY = baseLineY - ([number2 floatValue] - minScale) / scaleRange * lineMaxH;

      [[Globle colorFromHexRGB:COLOR_MA_BLUE] set];
      CGContextMoveToPoint(context, startX, startY);
      CGContextAddLineToPoint(context, endX, endY);
      CGContextStrokePath(context);
    }

    // lower
    number1 = point.lower;
    number2 = nextPoint.lower;

    if ([number1 floatValue] != 0 && [number2 floatValue] != 0) {

      startY = baseLineY - ([number1 floatValue] - minScale) / scaleRange * lineMaxH;
      endY = baseLineY - ([number2 floatValue] - minScale) / scaleRange * lineMaxH;

      [[Globle colorFromHexRGB:COLOR_MA_PURPLE] set];
      CGContextMoveToPoint(context, startX, startY);
      CGContextAddLineToPoint(context, endX, endY);
      CGContextStrokePath(context);
    }
  }

  //最高标签
  UILabel *maxLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, _volumeRectX - 3, 11)];
  maxLabel.text = [NSString stringWithFormat:priceFormat, maxScale];
  maxLabel.textAlignment = NSTextAlignmentRight;
  maxLabel.textColor = [Globle colorFromHexRGB:Color_Dark];
  maxLabel.backgroundColor = [UIColor clearColor];
  maxLabel.font = UIScaleFont;
  maxLabel.adjustsFontSizeToFitWidth = YES;
  [_indicatorInfoBackView addSubview:maxLabel];

  //最低标签
  UILabel *minLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _volumeRectH - 11, _volumeRectX - 3, 11)];
  minLabel.text = [NSString stringWithFormat:priceFormat, minScale];
  minLabel.textAlignment = NSTextAlignmentRight;
  minLabel.textColor = [Globle colorFromHexRGB:Color_Dark];
  minLabel.backgroundColor = [UIColor clearColor];
  minLabel.font = UIScaleFont;
  minLabel.adjustsFontSizeToFitWidth = YES;
  [_indicatorInfoBackView addSubview:minLabel];
}

#pragma mark 5⃣️画出BRAR
- (void)drawBRARLine:(CGContextRef)context {
  _brarPoints = [BRAR getBRARPoints:_kLineDataItemInfo.dataArray];

  NSInteger count = _brarPoints.count;

  if (count == 0) {
    return;
  }

  //需要循环的次数
  int needLoops = fmin(count, _screenStartIndex + _showedCount);

  // 1.先计算出最大刻度值
  float maxScale = [[_brarPoints[needLoops - 1] ar] floatValue];

  for (NSInteger i = _screenStartIndex; i < needLoops; i++) {

    BRARPoint *point = _brarPoints[i];

    //计算此区域内最大值来决定最大刻度
    float tempMax = fmaxf([point.ar floatValue], [point.br floatValue]);

    if (maxScale < tempMax) {
      maxScale = tempMax;
    }
  }

  CGContextSetLineWidth(context, 1.0);

  float startX, startY, endX, endY;
  NSInteger kLineWidth = KLINE_WIDTH; //‼️注意，这是k线宽度的半径！

  //区域线最高高度,所有坐标向下偏移10，方便显示标签
  // KD的取值范围都是0～100，分为 80 50 20 线，范围-10~110，30间隔
  float lineMaxH = _volumeRectH - 10; //基准线上面最高高度

  //基准线Y坐标，0线
  float baseLineY = _volumeRectY + _volumeRectH - 1; //防止超界

  [[Globle colorFromHexRGB:COLOR_KLINE_SEPARATOR] set];

  //刻度标签Y坐标数组
  NSMutableArray *infoLabelYArray = [[NSMutableArray alloc] init];

  //添加3/4线
  startY = baseLineY - 0.75f * lineMaxH;
  CGContextMoveToPoint(context, _volumeRectX, startY);
  CGContextAddLineToPoint(context, _volumeRectX + _volumeRectW, startY);
  CGContextStrokePath(context);
  [infoLabelYArray addObject:@(startY)];

  //添加2/4线
  startY = baseLineY - 0.5f * lineMaxH;
  CGContextMoveToPoint(context, _volumeRectX, startY);
  CGContextAddLineToPoint(context, _volumeRectX + _volumeRectW, startY);
  CGContextStrokePath(context);
  [infoLabelYArray addObject:@(startY)];

  //添加1/4线
  startY = baseLineY - 0.25f * lineMaxH;
  CGContextMoveToPoint(context, _volumeRectX, startY);
  CGContextAddLineToPoint(context, _volumeRectX + _volumeRectW, startY);
  CGContextStrokePath(context);
  [infoLabelYArray addObject:@(startY)];

  //指标临时数值
  NSNumber *number1, *number2;

  //计算每个point相对于最大值的具体坐标
  for (NSInteger i = _screenStartIndex; i < needLoops - 1; i++) {

    BRARPoint *point = _brarPoints[i];
    BRARPoint *nextPoint = _brarPoints[i + 1];

    startX = _volumeRectX + kLineWidth * 2 * (i - _screenStartIndex) + kLineWidth - 1; //向左移动1，恰好保证与k线对齐
    endX = startX + kLineWidth * 2;

    // ar
    number1 = point.ar;
    number2 = nextPoint.ar;

    if (number1 && number2) {
      startY = baseLineY - [number1 floatValue] / maxScale * lineMaxH;

      endY = baseLineY - [number2 floatValue] / maxScale * lineMaxH;

      [[Globle colorFromHexRGB:COLOR_MA_BLUE] set];
      CGContextMoveToPoint(context, startX, startY);
      CGContextAddLineToPoint(context, endX, endY);
      CGContextStrokePath(context);
    }

    // br
    number1 = point.br;
    number2 = nextPoint.br;

    if (number1 && number2) {

      startY = baseLineY - [number1 floatValue] / maxScale * lineMaxH;
      endY = baseLineY - [number2 floatValue] / maxScale * lineMaxH;

      [[Globle colorFromHexRGB:COLOR_MA_ORANGE] set];
      CGContextMoveToPoint(context, startX, startY);
      CGContextAddLineToPoint(context, endX, endY);
      CGContextStrokePath(context);
    }
  }

  // 75% 50% 25% 标签
  for (NSInteger i = 0; i < 3; i++) {
    UILabel *minLabel =
        [[UILabel alloc] initWithFrame:CGRectMake(0, [infoLabelYArray[i] floatValue] - _volumeRectY - 11 / 2, _volumeRectX - 3, 11)];
    minLabel.text = [NSString stringWithFormat:@"%.1f", maxScale * 0.25f * (3 - i)];
    minLabel.textAlignment = NSTextAlignmentRight;
    minLabel.textColor = [Globle colorFromHexRGB:Color_Dark];
    minLabel.backgroundColor = [UIColor clearColor];
    minLabel.font = UIScaleFont;
    minLabel.adjustsFontSizeToFitWidth = YES;
    [_indicatorInfoBackView addSubview:minLabel];
  }
}

#pragma mark 6⃣️画出OBV
- (void)drawOBVLine:(CGContextRef)context {
  _obvPoints = [OBV getOBVPoints:_kLineDataItemInfo.dataArray];

  NSInteger count = _obvPoints.count;

  if (count == 0) {
    return;
  }

  //需要循环的次数
  int needLoops = fmin(count, _screenStartIndex + _showedCount);

  // 1.先计算出最大刻度值，最小刻度值
  int64_t maxScale = [[_obvPoints[needLoops - 1] obv] longLongValue]; //取最后一个数据，可以保证不为nil或null
  int64_t minScale = maxScale;

  for (NSInteger i = _screenStartIndex; i < needLoops; i++) {

    OBVPoint *point = _obvPoints[i];

    //计算此区域内最大值来决定最大刻度
    int64_t tempMax = fmaxf([point.obv longLongValue], [point.maObv longLongValue]);
    if (maxScale < tempMax) {
      maxScale = tempMax;
    }

    int64_t tempMin = fminf([point.obv longLongValue], [point.maObv longLongValue]);
    if (minScale > tempMin) {
      minScale = tempMin;
    }
  }

  //价格区间
  int64_t scaleRange = maxScale - minScale;

  CGContextSetLineWidth(context, 1.0);

  float startX, startY, endX, endY;
  NSInteger kLineWidth = KLINE_WIDTH; //‼️注意，这是k线宽度的半径！

  //区域线最高高度,所有坐标向下偏移10，方便显示标签
  // KD的取值范围都是0～100，分为 80 50 20 线，范围-10~110，30间隔
  float lineMaxH = _volumeRectH - 10; //基准线上面最高高度

  //基准线Y坐标，0线
  float baseLineY = _volumeRectY + _volumeRectH - 1;

  [[Globle colorFromHexRGB:COLOR_KLINE_SEPARATOR] set];

  //刻度标签Y坐标数组
  NSMutableArray *infoLabelYArray = [[NSMutableArray alloc] init];

  //添加3/4线
  startY = baseLineY - 0.75f * (_volumeRectH - 10);
  CGContextMoveToPoint(context, _volumeRectX, startY);
  CGContextAddLineToPoint(context, _volumeRectX + _volumeRectW, startY);
  CGContextStrokePath(context);
  [infoLabelYArray addObject:@(startY)];

  //添加2/4线
  startY = baseLineY - 0.5f * (_volumeRectH - 10);
  CGContextMoveToPoint(context, _volumeRectX, startY);
  CGContextAddLineToPoint(context, _volumeRectX + _volumeRectW, startY);
  CGContextStrokePath(context);
  [infoLabelYArray addObject:@(startY)];

  //添加1/4线
  startY = baseLineY - 0.25f * (_volumeRectH - 10);
  CGContextMoveToPoint(context, _volumeRectX, startY);
  CGContextAddLineToPoint(context, _volumeRectX + _volumeRectW, startY);
  CGContextStrokePath(context);
  [infoLabelYArray addObject:@(startY)];

  //指标临时数值
  NSNumber *number1, *number2;

  //计算每个point相对于最大值的具体坐标
  for (NSInteger i = _screenStartIndex; i < needLoops - 1; i++) {

    OBVPoint *point = _obvPoints[i];
    OBVPoint *nextPoint = _obvPoints[i + 1];

    startX = _volumeRectX + kLineWidth * 2 * (i - _screenStartIndex) + kLineWidth - 1; //向左移动1，恰好保证与k线对齐
    endX = startX + kLineWidth * 2;

    // obv
    number1 = point.obv;
    number2 = nextPoint.obv;

    if (![number1 isEqual:[NSNull null]] && ![number2 isEqual:[NSNull null]]) {
      startY = baseLineY - ([number1 longLongValue] - minScale) * 1.f / scaleRange * lineMaxH;

      endY = baseLineY - ([number2 longLongValue] - minScale) * 1.f / scaleRange * lineMaxH;

      [[Globle colorFromHexRGB:COLOR_MA_BLUE] set];
      CGContextMoveToPoint(context, startX, startY);
      CGContextAddLineToPoint(context, endX, endY);
      CGContextStrokePath(context);
    }

    // maobv
    number1 = point.maObv;
    number2 = nextPoint.maObv;

    if (![number1 isEqual:[NSNull null]] && ![number2 isEqual:[NSNull null]]) {

      startY = baseLineY - ([number1 longLongValue] - minScale) * 1.f / scaleRange * lineMaxH;
      endY = baseLineY - ([number2 longLongValue] - minScale) * 1.f / scaleRange * lineMaxH;

      [[Globle colorFromHexRGB:COLOR_MA_GREEN] set];
      CGContextMoveToPoint(context, startX, startY);
      CGContextAddLineToPoint(context, endX, endY);
      CGContextStrokePath(context);
    }
  }

  // 75% 50% 25% 标签
  for (NSInteger i = 0; i < 3; i++) {
    UILabel *minLabel =
        [[UILabel alloc] initWithFrame:CGRectMake(0, [infoLabelYArray[i] floatValue] - _volumeRectY - 11 / 2, _volumeRectX - 3, 11)];
    minLabel.text = [StockUtil handsStringFromVolume:maxScale * 0.25f * (3 - i)needsHand:NO];
    minLabel.textAlignment = NSTextAlignmentRight;
    minLabel.textColor = [Globle colorFromHexRGB:Color_Dark];
    minLabel.backgroundColor = [UIColor clearColor];
    minLabel.font = UIScaleFont;
    minLabel.adjustsFontSizeToFitWidth = YES;
    [_indicatorInfoBackView addSubview:minLabel];
  }
}

#pragma mark 7⃣️画出DMI
- (void)drawDMILine:(CGContextRef)context {
  _dmiPoints = [DMI getDMIPoints:_kLineDataItemInfo.dataArray];

  NSInteger count = _dmiPoints.count;

  if (count == 0) {
    return;
  }

  //需要循环的次数
  int needLoops = fmin(count, _screenStartIndex + _showedCount);

  CGContextSetLineWidth(context, 1.0);

  float startX, startY, endX, endY;
  NSInteger kLineWidth = KLINE_WIDTH; //‼️注意，这是k线宽度的半径！

  //区域线最高高度,所有坐标向下偏移10，方便显示标签
  // KD的取值范围都是0～100，分为 80 50 20 线，范围-10~110，30间隔
  float lineMaxH = _volumeRectH - 10; //基准线上面最高高度

  //基准线Y坐标，0线
  float baseLineY = _volumeRectY + _volumeRectH - 1; //防止超界

  [[Globle colorFromHexRGB:COLOR_KLINE_SEPARATOR] set];

  //刻度标签Y坐标数组
  NSMutableArray *infoLabelYArray = [[NSMutableArray alloc] init];

  //添加80线
  startY = baseLineY - 80.f / 100 * lineMaxH;
  CGContextMoveToPoint(context, _volumeRectX, startY);
  CGContextAddLineToPoint(context, _volumeRectX + _volumeRectW, startY);
  CGContextStrokePath(context);
  [infoLabelYArray addObject:@(startY)];

  //添加50线
  startY = baseLineY - 50.f / 100 * lineMaxH;
  CGContextMoveToPoint(context, _volumeRectX, startY);
  CGContextAddLineToPoint(context, _volumeRectX + _volumeRectW, startY);
  CGContextStrokePath(context);
  [infoLabelYArray addObject:@(startY)];

  //添加20线
  startY = baseLineY - 20.f / 100 * lineMaxH;
  CGContextMoveToPoint(context, _volumeRectX, startY);
  CGContextAddLineToPoint(context, _volumeRectX + _volumeRectW, startY);
  CGContextStrokePath(context);
  [infoLabelYArray addObject:@(startY)];

  //指标临时数值
  NSNumber *number1, *number2;

  //计算每个point相对于最大值的具体坐标
  for (NSInteger i = _screenStartIndex; i < needLoops - 1; i++) {

    DMIPoint *point = _dmiPoints[i];
    DMIPoint *nextPoint = _dmiPoints[i + 1];

    startX = _volumeRectX + kLineWidth * 2 * (i - _screenStartIndex) + kLineWidth - 1; //向左移动1，恰好保证与k线对齐
    endX = startX + kLineWidth * 2;

    // pdi
    number1 = point.pdi;
    number2 = nextPoint.pdi;

    if (![number1 isEqual:[NSNull null]] && ![number2 isEqual:[NSNull null]]) {
      startY = baseLineY - [number1 floatValue] / 100 * lineMaxH;
      endY = baseLineY - [number2 floatValue] / 100 * lineMaxH;

      [[Globle colorFromHexRGB:COLOR_MA_BLUE] set];
      CGContextMoveToPoint(context, startX, startY);
      CGContextAddLineToPoint(context, endX, endY);
      CGContextStrokePath(context);
    }

    // mdi
    number1 = point.mdi;
    number2 = nextPoint.mdi;

    if (![number1 isEqual:[NSNull null]] && ![number2 isEqual:[NSNull null]]) {

      startY = baseLineY - [number1 floatValue] / 100 * lineMaxH;
      endY = baseLineY - [number2 floatValue] / 100 * lineMaxH;

      [[Globle colorFromHexRGB:COLOR_MA_ORANGE] set];
      CGContextMoveToPoint(context, startX, startY);
      CGContextAddLineToPoint(context, endX, endY);
      CGContextStrokePath(context);
    }

    // adx
    number1 = point.adx;
    number2 = nextPoint.adx;

    if (![number1 isEqual:[NSNull null]] && ![number2 isEqual:[NSNull null]]) {

      startY = baseLineY - [number1 floatValue] / 100 * lineMaxH;
      endY = baseLineY - [number2 floatValue] / 100 * lineMaxH;

      [[Globle colorFromHexRGB:COLOR_MA_PURPLE] set];
      CGContextMoveToPoint(context, startX, startY);
      CGContextAddLineToPoint(context, endX, endY);
      CGContextStrokePath(context);
    }

    // adxr
    number1 = point.adxr;
    number2 = nextPoint.adxr;

    if (![number1 isEqual:[NSNull null]] && ![number2 isEqual:[NSNull null]]) {

      startY = baseLineY - [number1 floatValue] / 100 * lineMaxH;
      endY = baseLineY - [number2 floatValue] / 100 * lineMaxH;

      [[Globle colorFromHexRGB:COLOR_MA_GREEN] set];
      CGContextMoveToPoint(context, startX, startY);
      CGContextAddLineToPoint(context, endX, endY);
      CGContextStrokePath(context);
    }
  }

  // 80.0 50.0 20.0 标签
  for (NSInteger i = 0; i < 3; i++) {
    UILabel *minLabel =
        [[UILabel alloc] initWithFrame:CGRectMake(0, [infoLabelYArray[i] floatValue] - _volumeRectY - 11 / 2, _volumeRectX - 3, 11)];
    minLabel.text = [NSString stringWithFormat:@"+%.2f", 80.0f - i * 30.0f];
    minLabel.textAlignment = NSTextAlignmentRight;
    minLabel.textColor = [Globle colorFromHexRGB:Color_Dark];
    minLabel.backgroundColor = [UIColor clearColor];
    minLabel.font = UIScaleFont;
    minLabel.adjustsFontSizeToFitWidth = YES;
    [_indicatorInfoBackView addSubview:minLabel];
  }
}

#pragma mark 8⃣️画出BIAS
- (void)drawBIASLine:(CGContextRef)context {
  _biasPoints = [BIAS getBIASPoints:_kLineDataItemInfo.dataArray];

  NSInteger count = _biasPoints.count;

  if (count == 0) {
    return;
  }

  //需要循环的次数
  int needLoops = fmin(count, _screenStartIndex + _showedCount);

  // 1.先计算出最大刻度值，最小刻度值
  float maxScale = [[_biasPoints[needLoops - 1] bias3] floatValue];
  float minScale = maxScale;

  for (NSInteger i = _screenStartIndex; i < needLoops; i++) {

    BIASPoint *point = _biasPoints[i];

    //计算此区域内最大值来决定最大刻度
    float tempMax =
        fmaxf(fmaxf([point.bias1 floatValue], [point.bias2 floatValue]), [point.bias3 floatValue]);
    if (maxScale < tempMax) {
      maxScale = tempMax;
    }

    //最小
    float tempMin =
        fminf(fminf([point.bias1 floatValue], [point.bias2 floatValue]), [point.bias3 floatValue]);
    if (minScale > tempMin) {
      minScale = tempMin;
    }
  }

  //价格区间
  float scaleRange = maxScale - minScale;

  CGContextSetLineWidth(context, 1.0);

  float startX, startY, endX, endY;
  NSInteger kLineWidth = KLINE_WIDTH; //‼️注意，这是k线宽度的半径！

  //区域线最高高度,所有坐标向下偏移10，方便显示标签
  float lineMaxH = _volumeRectH - 10; //基准线上面最高高度

  //基准线Y坐标，0线
  float baseLineY = _volumeRectY + _volumeRectH - 1; //防止超界

  [[Globle colorFromHexRGB:COLOR_KLINE_SEPARATOR] set];

  //添加100%线
  startY = baseLineY - 100.f / 100 * lineMaxH;
  CGContextMoveToPoint(context, _volumeRectX, startY);
  CGContextAddLineToPoint(context, _volumeRectX + _volumeRectW, startY);
  CGContextStrokePath(context);

  //添加50%线
  startY = baseLineY - 50.f / 100 * lineMaxH;
  CGContextMoveToPoint(context, _volumeRectX, startY);
  CGContextAddLineToPoint(context, _volumeRectX + _volumeRectW, startY);
  CGContextStrokePath(context);

  //指标临时数值
  NSNumber *number1, *number2;

  //计算每个point相对于最大值的具体坐标
  for (NSInteger i = _screenStartIndex; i < needLoops - 1; i++) {

    if (scaleRange == 0) {
      return;
    }

    BIASPoint *point = _biasPoints[i];
    BIASPoint *nextPoint = _biasPoints[i + 1];

    startX = _volumeRectX + kLineWidth * 2 * (i - _screenStartIndex) + kLineWidth - 1; //向左移动1，恰好保证与k线对齐
    endX = startX + kLineWidth * 2;

    // bias1
    number1 = point.bias1;
    number2 = nextPoint.bias1;

    if (number1 && number2) {
      startY = baseLineY - ([number1 floatValue] - minScale) / scaleRange * lineMaxH;
      endY = baseLineY - ([number2 floatValue] - minScale) / scaleRange * lineMaxH;

      [[Globle colorFromHexRGB:COLOR_MA_BLUE] set];
      CGContextMoveToPoint(context, startX, startY);
      CGContextAddLineToPoint(context, endX, endY);
      CGContextStrokePath(context);
    }

    // bias2
    number1 = point.bias2;
    number2 = nextPoint.bias2;

    if (number1 && number2) {

      startY = baseLineY - ([number1 floatValue] - minScale) / scaleRange * lineMaxH;
      endY = baseLineY - ([number2 floatValue] - minScale) / scaleRange * lineMaxH;

      [[Globle colorFromHexRGB:COLOR_MA_ORANGE] set];
      CGContextMoveToPoint(context, startX, startY);
      CGContextAddLineToPoint(context, endX, endY);
      CGContextStrokePath(context);
    }

    // bias3
    number1 = point.bias3;
    number2 = nextPoint.bias3;

    if (number1 && number2) {

      startY = baseLineY - ([number1 floatValue] - minScale) / scaleRange * lineMaxH;
      endY = baseLineY - ([number2 floatValue] - minScale) / scaleRange * lineMaxH;

      [[Globle colorFromHexRGB:COLOR_MA_PURPLE] set];
      CGContextMoveToPoint(context, startX, startY);
      CGContextAddLineToPoint(context, endX, endY);
      CGContextStrokePath(context);
    }
  }

  //刻度标签Y坐标数组
  NSArray *infoLabelYArray = @[ @(10), @(10 + lineMaxH / 2 - 11 / 2), @(_volumeRectH - 11) ];
  // 刻度值
  NSArray *values = @[ @(maxScale), @((maxScale + minScale) / 2), @(minScale) ];
  // 100% 50% 0% 标签
  for (NSInteger i = 0; i < 3; i++) {
    UILabel *minLabel =
        [[UILabel alloc] initWithFrame:CGRectMake(0, [infoLabelYArray[i] floatValue], _volumeRectX - 3, 11)];
    minLabel.text = [NSString stringWithFormat:@"%.1f", [values[i] floatValue]];
    minLabel.textAlignment = NSTextAlignmentRight;
    minLabel.textColor = [Globle colorFromHexRGB:Color_Dark];
    minLabel.backgroundColor = [UIColor clearColor];
    minLabel.font = UIScaleFont;
    minLabel.adjustsFontSizeToFitWidth = YES;
    [_indicatorInfoBackView addSubview:minLabel];
  }
}

#pragma mark 9⃣️画出W&R
- (void)drawWRLine:(CGContextRef)context {
  _wrPoints = [WR getWRPoints:_kLineDataItemInfo.dataArray];

  NSInteger count = _wrPoints.count;

  if (count == 0) {
    return;
  }

  //需要循环的次数
  int needLoops = fmin(count, _screenStartIndex + _showedCount);

  CGContextSetLineWidth(context, 1.0);

  float startX, startY, endX, endY;
  NSInteger kLineWidth = KLINE_WIDTH; //‼️注意，这是k线宽度的半径！

  //区域线最高高度,所有坐标向下偏移10，方便显示标签
  // KD的取值范围都是0～100，分为 80 50 20 线，范围-10~110，30间隔
  float lineMaxH = _volumeRectH - 10; //基准线上面最高高度

  //基准线Y坐标，0线
  float baseLineY = _volumeRectY + _volumeRectH - 1; //防止超界

  [[Globle colorFromHexRGB:COLOR_KLINE_SEPARATOR] set];

  //刻度标签Y坐标数组
  NSMutableArray *infoLabelYArray = [[NSMutableArray alloc] init];

  //添加80线
  startY = baseLineY - 80.f / 100 * lineMaxH;
  CGContextMoveToPoint(context, _volumeRectX, startY);
  CGContextAddLineToPoint(context, _volumeRectX + _volumeRectW, startY);
  CGContextStrokePath(context);
  [infoLabelYArray addObject:@(startY)];

  //添加50线
  startY = baseLineY - 50.f / 100 * lineMaxH;
  CGContextMoveToPoint(context, _volumeRectX, startY);
  CGContextAddLineToPoint(context, _volumeRectX + _volumeRectW, startY);
  CGContextStrokePath(context);
  [infoLabelYArray addObject:@(startY)];

  //添加20线
  startY = baseLineY - 20.f / 100 * lineMaxH;
  CGContextMoveToPoint(context, _volumeRectX, startY);
  CGContextAddLineToPoint(context, _volumeRectX + _volumeRectW, startY);
  CGContextStrokePath(context);
  [infoLabelYArray addObject:@(startY)];

  //指标临时数值
  NSNumber *number1, *number2;

  //计算每个point相对于最大值的具体坐标
  for (NSInteger i = _screenStartIndex; i < needLoops - 1; i++) {

    WRPoint *point = _wrPoints[i];
    WRPoint *nextPoint = _wrPoints[i + 1];

    startX = _volumeRectX + kLineWidth * 2 * (i - _screenStartIndex) + kLineWidth - 1; //向左移动1，恰好保证与k线对齐
    endX = startX + kLineWidth * 2;

    // wr1
    number1 = point.wr1;
    number2 = nextPoint.wr1;

    if (![number1 isEqual:[NSNull null]] && ![number2 isEqual:[NSNull null]]) {
      startY = baseLineY - [number1 floatValue] / 100 * lineMaxH;
      endY = baseLineY - [number2 floatValue] / 100 * lineMaxH;

      [[Globle colorFromHexRGB:COLOR_MA_ORANGE] set];
      CGContextMoveToPoint(context, startX, startY);
      CGContextAddLineToPoint(context, endX, endY);
      CGContextStrokePath(context);
    }

    // wr2
    number1 = point.wr2;
    number2 = nextPoint.wr2;

    if (![number1 isEqual:[NSNull null]] && ![number2 isEqual:[NSNull null]]) {

      startY = baseLineY - [number1 floatValue] / 100 * lineMaxH;
      endY = baseLineY - [number2 floatValue] / 100 * lineMaxH;

      [[Globle colorFromHexRGB:COLOR_MA_BLUE] set];
      CGContextMoveToPoint(context, startX, startY);
      CGContextAddLineToPoint(context, endX, endY);
      CGContextStrokePath(context);
    }
  }

  // 80.0 50.0 20.0 标签
  for (NSInteger i = 0; i < 3; i++) {
    UILabel *minLabel =
        [[UILabel alloc] initWithFrame:CGRectMake(0, [infoLabelYArray[i] floatValue] - _volumeRectY - 11 / 2, _volumeRectX - 3, 11)];
    minLabel.text = [NSString stringWithFormat:@"%.1f", 80.0f - i * 30.0f];
    minLabel.textAlignment = NSTextAlignmentRight;
    minLabel.textColor = [Globle colorFromHexRGB:Color_Dark];
    minLabel.backgroundColor = [UIColor clearColor];
    minLabel.font = UIScaleFont;
    minLabel.adjustsFontSizeToFitWidth = YES;
    [_indicatorInfoBackView addSubview:minLabel];
  }
}

@end