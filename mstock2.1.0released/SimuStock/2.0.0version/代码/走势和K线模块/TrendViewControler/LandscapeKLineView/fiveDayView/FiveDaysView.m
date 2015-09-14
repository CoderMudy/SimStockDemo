//
//  FiveDayView.m
//  SimuStock
//
//  Created by Yuemeng on 15/4/27.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "FiveDaysView.h"
#import "SimuStockInfoData.h"
#import "MobClick.h"
#import "event_view_log.h"
#import "LandscapeKLineViewController.h"

#define BORDER_LINE_WIDTH 0.5f
#define MULTIPLIER 100
#define TOTAL_MINUTES 305

//从数组得到点
#define POINT(ARRAY, X) [[ARRAY objectAtIndex:X] CGPointValue]

@implementation FiveDaysView

- (instancetype)initWithFrame:(CGRect)frame isLandScape:(BOOL)isLandScape {
  if (self = [super initWithFrame:frame]) {
    self.isLandScape = isLandScape;
    self.backgroundColor = [UIColor clearColor];
    [self initVaribles];
    [self createGestureRecognizer];
  }
  return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  // 8,73 445*240
  [self initVaribles];
  [self createGestureRecognizer];

  //纪录日志
  [[event_view_log sharedManager]
      addPVAndButtonEventToLog:Log_Type_PV
                       andCode:@"行情-横屏分时"];
  [MobClick beginLogPageView:@"行情-横屏分时"];
}

- (void)dealloc {
  [MobClick endLogPageView:@"行情-横屏分时"];
}

- (void)initVaribles {
  _originX = _isLandScape ? 43 : 4;
  _priceLabelArray = [[NSMutableArray alloc] initWithCapacity:0];
  _percentLabelArray = [[NSMutableArray alloc] initWithCapacity:0];
  _volumeLabelArray = [[NSMutableArray alloc] initWithCapacity:0];
  _averageLineDataArray =
      [[NSMutableArray alloc] initWithCapacity:TOTAL_MINUTES];
  _valueAndVolumeDataArray =
      [[NSMutableArray alloc] initWithCapacity:TOTAL_MINUTES];
  _trendLinePointArray =
      [[NSMutableArray alloc] initWithCapacity:TOTAL_MINUTES * 2];
  _averagePointArray =
      [[NSMutableArray alloc] initWithCapacity:TOTAL_MINUTES * 2];
  _volumePointArray = [[NSMutableArray alloc] initWithCapacity:TOTAL_MINUTES];
  _percentMarkArray = [[NSMutableArray alloc] initWithCapacity:5];
  _priceMarkArray = [[NSMutableArray alloc] initWithCapacity:5];
  _dealsMarkArray = [[NSMutableArray alloc] initWithCapacity:2];
  _detailInfoLabelArray = [[NSMutableArray alloc] initWithCapacity:5];
  _detailStringArray = [[NSMutableArray alloc] initWithCapacity:5];
  _dateMarkArray = [[NSMutableArray alloc] initWithCapacity:5];
  _trendDataPage = [[TrendDataPage alloc] init];
}

#pragma mark 创建手势
- (void)createGestureRecognizer {
  //创建长按手势
  _longPressRecognizer = [[UILongPressGestureRecognizer alloc]
      initWithTarget:self
              action:@selector(longPressToDo:)];
  [_longPressRecognizer setDelegate:self];
  _longPressRecognizer.allowableMovement = 12;
  [self addGestureRecognizer:_longPressRecognizer];

  if (!_isLandScape) {
    return;
  }
  //双击退出手势
  UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]
      initWithTarget:self
              action:@selector(sendLandscapeVCExit)];
  doubleTap.numberOfTapsRequired = 2;
  [self addGestureRecognizer:doubleTap];
}

- (void)resetRectMembers {
  //⭐️趋势线区，其他控件均根据此关联
  float trendRectWidth =
      _isLandScape ? HEIGHT_OF_SCREEN - 90 : WIDTH_OF_SCREEN - _originX * 2;
  float trendRectHeight = _isLandScape ? self.height * 8.f / 12.f : 115;

  _trendRect =
      CGRectMake(_originX, BORDER_LINE_WIDTH, trendRectWidth, trendRectHeight);
  //量线区
  _volumeRect =
      CGRectMake(_originX, _trendRect.size.height + 20 - BORDER_LINE_WIDTH,
                 trendRectWidth, self.height - _trendRect.size.height - 20);

  _trendOriginX = _trendRect.origin.x;
  _trendOriginY = _trendRect.origin.y;
  _trendSizeWidth = _trendRect.size.width;
  _trendSizeHeight = _trendRect.size.height;

  _volumeOriginX = _volumeRect.origin.x;
  _volumeOriginY = _volumeRect.origin.y;
  _volumeSizeWidth = _volumeRect.size.width;
  _volumeSizeHeight = _volumeRect.size.height;

  [self createUI];
}

- (void)createUI {
  if (_verticalLineView) {
    return;
  }

  if (_isLandScape) {
    //创建分时具体信息背景视图
    _detailInfoBackView = [[UIView alloc]
        initWithFrame:CGRectMake(-8, -37, HEIGHT_OF_SCREEN, 30)];
    _detailInfoBackView.backgroundColor = [UIColor clearColor];
    _detailInfoBackView.alpha = 0;
    [self addSubview:_detailInfoBackView];

    //创建分时信息标签
    NSInteger num = _isIndexStock ? 4 : 5; //大盘不显示均价
    CGFloat spaceOfLabel = (HEIGHT_OF_SCREEN - 20) / num;
    for (NSInteger i = 0; i < num; i++) {
      UILabel *label = [[UILabel alloc]
          initWithFrame:CGRectMake(20 + spaceOfLabel * i, 0, spaceOfLabel, 30)];
      label.font = [UIFont systemFontOfSize:14];
      label.textColor = [Globle colorFromHexRGB:COLOR_KLINE_INFO_TITLE];
      label.textAlignment = NSTextAlignmentLeft;
      [_detailInfoBackView addSubview:label];
      [_detailInfoLabelArray addObject:label];
    }
  }

  //创建所有标签
  //标签高度
  CGFloat labelHeight = 10;
  //间距
  CGFloat spaceHeight = (_trendSizeHeight - labelHeight) / 4;
  //左侧5价格标签 W30，Font10
  for (NSInteger i = 0; i < 5; i++) {
    UILabel *label = [[UILabel alloc]
        initWithFrame:CGRectMake(_isLandScape ? _trendOriginX - 40 - 3
                                              : _trendOriginX,
                                 i * spaceHeight, 40, labelHeight)];
    label.text = @"0.00";
    label.font = [UIFont systemFontOfSize:Font_Height_10_0];
    label.textAlignment =
        _isLandScape ? NSTextAlignmentRight : NSTextAlignmentLeft;
    label.adjustsFontSizeToFitWidth = YES;
    if (i < 2) {
      label.textColor = [Globle colorFromHexRGB:Color_Red];
    } else if (i > 2) {
      label.textColor = [Globle colorFromHexRGB:Color_Green];
    } else {
      label.textColor = [Globle colorFromHexRGB:Color_Text_Common];
    }
    label.backgroundColor = [UIColor clearColor];
    [_priceLabelArray addObject:label];
    [self addSubview:label];
  }

  //右侧5百分比标签
  for (NSInteger i = 0; i < 5; i++) {
    UILabel *label = [[UILabel alloc]
        initWithFrame:CGRectMake(_originX + _trendSizeWidth +
                                     (_isLandScape ? 3 : -42),
                                 i * spaceHeight, 42, labelHeight)];
    label.text = @"0.00%";
    label.font = [UIFont systemFontOfSize:Font_Height_10_0];
    label.textAlignment =
        _isLandScape ? NSTextAlignmentLeft : NSTextAlignmentRight;
    label.adjustsFontSizeToFitWidth = YES;
    if (i < 2) {
      label.textColor = [Globle colorFromHexRGB:Color_Red];
    } else if (i > 2) {
      label.textColor = [Globle colorFromHexRGB:Color_Green];
    } else {
      label.textColor = [Globle colorFromHexRGB:Color_Text_Common];
    }
    label.backgroundColor = [UIColor clearColor];
    [_percentLabelArray addObject:label];
    [self addSubview:label];
  }

  //中间日期5个标签，H30，格式:12-09
  CGFloat spaceWidth = _trendRect.size.width / 5;
  for (NSInteger i = 0; i < 5; i++) {
    UILabel *label =
        [[UILabel alloc] initWithFrame:CGRectMake(_originX + i * spaceWidth,
                                                  _trendSizeHeight + 5,
                                                  spaceWidth, labelHeight)];
    label.text = @"";
    label.font = [UIFont systemFontOfSize:Font_Height_10_0];
    label.textColor = [Globle colorFromHexRGB:Color_Gray];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [self addSubview:label];
    [_dateMarkArray addObject:label];
  }

  //左下角成交量和手
  for (NSInteger i = 0; i < 2; i++) {
    UILabel *label = [[UILabel alloc]
        initWithFrame:CGRectMake(
                          _trendOriginX + (_isLandScape ? -43 : 0),
                          _volumeRect.origin.y +
                              i * (_volumeRect.size.height - labelHeight),
                          40, labelHeight)];
    label.text = @"0";
    label.font = [UIFont systemFontOfSize:Font_Height_10_0];
    label.textAlignment =
        _isLandScape ? NSTextAlignmentRight : NSTextAlignmentLeft;

    label.textColor = [Globle colorFromHexRGB:Color_Text_Common];
    if (i == 1) {
      label.text = @"手";
    }
    label.backgroundColor = [UIColor clearColor];
    [_volumeLabelArray addObject:label];
    [self addSubview:label];
  }

  //添加红色指标线
  CGRect rectV = CGRectMake(100, _trendOriginY, 1,
                            _trendSizeHeight + _volumeSizeHeight + 19);
  _verticalLineView = [[UIView alloc] initWithFrame:rectV];
  _verticalLineView.backgroundColor =
      [Globle colorFromHexRGB:COLOR_INDICATOR_LINE];
  [self addSubview:_verticalLineView];
  _verticalLineView.hidden = YES;

  CGRect rectH = CGRectMake(0, 100, _trendSizeWidth - 1, 1);
  _horicalLineView = [[UIView alloc] initWithFrame:rectH];
  _horicalLineView.backgroundColor =
      [Globle colorFromHexRGB:COLOR_INDICATOR_LINE];
  [self addSubview:_horicalLineView];
  _horicalLineView.hidden = YES;
  //添加交叉点
  float crossDotWidth = _verticalLineView.width * 4;
  _crossDot = [[UIView alloc]
      initWithFrame:CGRectMake(0, 0, crossDotWidth, crossDotWidth)];
  _crossDot.backgroundColor = [Globle colorFromHexRGB:COLOR_INDICATOR_LINE];
  _crossDot.layer.cornerRadius = _crossDot.width / 2.0f;
  [self addSubview:_crossDot];
  _crossDot.hidden = YES;

  if (_isLandScape) {
    //创建 价格、时间、涨幅 游标
    for (NSInteger i = 0; i < 3; i++) {
      //价格
      UILabel *label =
          [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 17)];
      label.layer.borderWidth = 0.5f;
      label.layer.borderColor = [[Globle colorFromHexRGB:Color_Gray] CGColor];
      label.layer.cornerRadius = 2;
      label.textAlignment = NSTextAlignmentCenter;
      label.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
      label.font = [UIFont systemFontOfSize:Font_Height_11_0];
      label.textColor = [Globle colorFromHexRGB:Color_Blue_but];
      label.hidden = YES;
      [self addSubview:label];
      if (i == 0) {
        _currentPriceLabel = label;
      } else if (i == 1) {
        _currentTimeLabel = label;
      } else {
        _currentPercentLabel = label;
      }
    }
  }
}

#pragma mark - ⭐️画线部分
- (void)drawRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();
  //    CGContextClearRect(context, self.bounds);

  //画边框和分割线
  [self drawBorders];

  if (_trendLinePointArray.count < 2)
    return;

  //设置画笔粗细
  float lineWidth =
      [SimuUtil getFloatWithFloat:(_trendSizeWidth / TOTAL_MINUTES) * 0.8f
                             bits:2]; // 0.8f,方便量线阅读
  CGContextSetLineWidth(context, lineWidth);

  CGFloat endY = _trendOriginY + _trendSizeHeight;
  //横向绘制，从左至右
  if (_trendLinePointArray.count > 0) {
    NSInteger linePointNum = _trendLinePointArray.count - 1;
    for (int i = 0; i < linePointNum; i++) {
      CGPoint startPoint = POINT(_trendLinePointArray, i);
      CGPoint endPoint = POINT(_trendLinePointArray, i + 1);
      //浅蓝色区域
      [[Globle colorFromHexRGB:Color_Blue_but alpha:.15f] set];
      //每根线其实是个长方形
      CGContextBeginPath(context);
      CGContextMoveToPoint(context, startPoint.x, startPoint.y);
      // 120、242、364、486水平平移，用来分割日期
      if (i == 120 || i == 242 || i == 364 || i == 486) {
        CGContextAddLineToPoint(context, endPoint.x, startPoint.y);
      } else {
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
      }
      CGContextAddLineToPoint(context, endPoint.x, endY);
      CGContextAddLineToPoint(context, startPoint.x, endY);
      CGContextFillPath(context);
      //深蓝色粗线
      [[Globle colorFromHexRGB:Color_Blue_but] set];
      CGContextMoveToPoint(context, startPoint.x, startPoint.y);
      if (i == 120 || i == 242 || i == 364 || i == 486) {
        CGContextAddLineToPoint(context, endPoint.x, startPoint.y);
      } else {
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
      }
      CGContextStrokePath(context);
    }
  }

  //画出均线
  [[Globle colorFromHexRGB:COLOR_AVERAGE_LINE] set]; //金黄色均线
  if (_averagePointArray.count > 0) {
    NSInteger linePointNum = _averagePointArray.count - 1;
    for (int i = 0; i < linePointNum; i++) {
      CGPoint startPoint = POINT(_averagePointArray, i);
      CGPoint endPoint = POINT(_averagePointArray, i + 1);
      CGContextMoveToPoint(context, startPoint.x, startPoint.y);
      // 122、244、366、488水平平移，用来分割日期
      if (i == 122 || i == 244 || i == 366 || i == 488) {
        CGContextAddLineToPoint(context, endPoint.x, startPoint.y);
      } else {
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
      }
      CGContextStrokePath(context);
    }
  }

  //画出量线(红绿线）
  NSInteger i = 0;
  for (DrawVolumeElement *element in _volumePointArray) {
    if (i < TOTAL_MINUTES) {
      CGPoint startPoint = element.startPoint;
      CGPoint endPoint = element.endPoint;
      [element.color set];
      CGContextMoveToPoint(context, startPoint.x, startPoint.y);
      CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
      CGContextStrokePath(context);
      ++i;
    } else
      break;
  }
}

#pragma mark - 画边框
- (void)drawBorders {

  CGContextRef context = UIGraphicsGetCurrentContext();

  //趋势与量线边界
  CGRect tempTrendRect = _trendRect;
  tempTrendRect.origin.x -= 0.5f;
  tempTrendRect.origin.y -= 0.5f;
  tempTrendRect.size.width -= 1;
  tempTrendRect.size.height += 1;

  CGRect tempVolumeRect = _volumeRect;
  tempVolumeRect.origin.x -= 0.5f;
  tempVolumeRect.origin.y -= 0.5f;
  tempVolumeRect.size.width -= 1;
  tempVolumeRect.size.height += 1;

  //画k线和交易量两个区域边框
  [[Globle colorFromHexRGB:COLOR_KLINE_BORDER] set];
  CGContextSetLineWidth(context, 0.5f);
  CGContextAddRect(context, tempTrendRect);
  CGContextAddRect(context, tempVolumeRect);
  CGContextStrokePath(context);

  //趋势区3条横线
  CGFloat spaceY = _trendSizeHeight / 4;
  for (NSInteger i = 1; i <= 3; i++) {
    CGContextMoveToPoint(context, _originX - 0.5f, i * spaceY);
    CGContextAddLineToPoint(context, _originX - 1 + _trendSizeWidth,
                            i * spaceY);
    //中间波折线（虚线）
    if (i == 2) {
      CGContextSaveGState(context);
      [[Globle colorFromHexRGB:Color_Dark alpha:0.35f] set];
      CGContextSetLineWidth(context, 1);
      CGFloat lengths[] = {4, 2};
      CGContextSetLineDash(context, 0, lengths, 2);
    }
    CGContextStrokePath(context);
    if (i == 2) {
      CGContextRestoreGState(context);
    }
  }

  //趋势区4条竖线
  for (NSInteger i = 1; i <= 4; i++) {
    CGContextMoveToPoint(context, _originX + i * _trendSizeWidth / 5,
                         BORDER_LINE_WIDTH);
    CGContextAddLineToPoint(context, _originX + i * _trendSizeWidth / 5,
                            _trendSizeHeight + 0.5f);
    CGContextStrokePath(context);
  }

  //交易量区4条竖线
  CGFloat _amountYtoHeight = _volumeRect.origin.y + _volumeRect.size.height;
  for (NSInteger i = 1; i <= 4; i++) {
    CGContextMoveToPoint(context, _originX + i * _trendSizeWidth / 5,
                         _volumeRect.origin.y);
    CGContextAddLineToPoint(context, _originX + i * _trendSizeWidth / 5,
                            _amountYtoHeight);
    CGContextStrokePath(context);
  }
}

#pragma mark - ⭐️重画k线和量线，两侧价格
- (void)setStock5DaysData:(Stock5DayStatusInfo *)info
             isIndexStock:(BOOL)isIndexStock {
  //数据未下载完时就点击横屏
  if (!info) {
    return;
  }
  _isIndexStock = isIndexStock;
  _maxPrice = info.maxPrice * MULTIPLIER;
  _minPrice = info.minPrice * MULTIPLIER;
  _maxAmount = info.maxAmount;

  //切换股票后重置显示区域，并区分大盘、个股
  [self resetRectMembers];

  [_trendDataPage.stockTrendArray removeAllObjects];
  [_trendDataPage.stockTrendArray addObjectsFromArray:info.stockTrendArray];

  //计算返回的天数，防止超界，尤其每日新股票返回的肯定是小于5天的
  NSUInteger maxIdx = (_trendDataPage.stockTrendArray.count + 60) / 61;

  [_dateMarkArray
      enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        if (idx < maxIdx) {
          StockTrendItemInfo *info = _trendDataPage.stockTrendArray[idx * 61];
          label.text = [StockUtil dateFromNSInteger:info.date];
        }
      }];

  //设置昨收价格
  _lastClosePrice = info.lastClosePrice * 100000; //保证7位
  //是否停牌
  _isListed = info.isListed;

  //重新计算均线数据
  [self calculateData];
  //重新计算所有数据
  [self calPricesAndPercentsArray];
  //重新计算所有刻度线
  [self calScalesData];
  //重新画图
  [self setNeedsDisplay];
}

#pragma mark - 计算均线数据：平均价格，总分钟数，总交易量
- (void)calculateData {
  if (_trendDataPage.stockTrendArray.count == 0)
    return;

  [_averageLineDataArray removeAllObjects];
  [_valueAndVolumeDataArray removeAllObjects];
  [_trendLinePointArray removeAllObjects];
  [_averagePointArray removeAllObjects];
  [_volumePointArray removeAllObjects];

  int64_t allDeals = 0;
  for (StockTrendItemInfo *info in _trendDataPage.stockTrendArray) {
    allDeals += info.amount; //交易量
    [_averageLineDataArray
        addObject:@(info.avgPrice * MULTIPLIER)]; //均价19484 5位变7位
    //价格和交易量数据
    SMinDateElement *elment =
        [[SMinDateElement alloc] initWithPrice:info.price * MULTIPLIER
                                        volume:info.amount];
    [_valueAndVolumeDataArray addObject:elment];
  }
  //当前分钟数
  _dataMinutes = _trendDataPage.stockTrendArray.count;
  //当前总手
  _totalDeals = allDeals;
}

#pragma mark - 解析数据成价格曲线点和均线曲线点
- (void)calPricesAndPercentsArray {
  if (_trendDataPage.stockTrendArray.count == 0)
    return;

  //解析所有价格点和当时成交量
  NSInteger lastClosePrice = _lastClosePrice;

  if (lastClosePrice == 0) {
    lastClosePrice =
        ((StockTrendItemInfo *)_trendDataPage.stockTrendArray[0]).currentPrice *
        MULTIPLIER;
    if (lastClosePrice == 0) {
      lastClosePrice = 1;
    }
  }

  //涨停或跌停，不画趋势线
  if (_maxPrice == _minPrice) {
  }

  //停牌股票处理，因为趋势图是直线，所以刻度坐标直接按10%涨跌停计算
  if (_totalDeals == 0) {
    _maxPrice = _lastClosePrice * 1.1;
    _minPrice = _lastClosePrice * 0.9;
  }

  //计算最大百分比刻度
  float maxPercent = ((_maxPrice - lastClosePrice) > (lastClosePrice - _minPrice))
                         ? ((float)(_maxPrice - lastClosePrice) * MULTIPLIER /
                            (float)lastClosePrice)
                         : ((float)(lastClosePrice - _minPrice) * MULTIPLIER /
                            (float)lastClosePrice);

  //绑定百分比和价格刻度数值
  [_percentMarkArray removeAllObjects];
  [_priceMarkArray removeAllObjects];
  for (NSInteger i = 0; i < 5; i++) {
    [_percentMarkArray
        addObject:@(maxPercent *
                    ((4 - i) / 2.0f - 1))]; //((4-i)/2 - 1)即：1, 0.5,
    // 0, -0.5,
    //-1，用于求百分比刻度值
    [_priceMarkArray addObject:@((1 + [_percentMarkArray[i] floatValue] / 100) *
                                 lastClosePrice)]; //高到低
  }

  //绑定交易量刻度数值
  [_dealsMarkArray removeAllObjects];
  for (NSInteger i = 1; i <= 2; i++) {
    [_dealsMarkArray addObject:@(_maxAmount * (i * 0.5))]; // 0.5 1
  }

  //计算点
  NSInteger minutes = TOTAL_MINUTES;
  CGFloat spaceWidth = (_trendSizeWidth / (CGFloat)minutes);
  CGFloat trendYaddHeight = _trendOriginY + _trendSizeHeight;
  CGFloat startX, startY, endX, endY;

  //蓝色粗线的坐标
  for (NSInteger i = 0; i < _valueAndVolumeDataArray.count - 1; i++) //
  {
    SMinDateElement *element = _valueAndVolumeDataArray[i];
    SMinDateElement *elementNext = _valueAndVolumeDataArray[i + 1];

    NSInteger price = element.price;
    NSInteger priceNext = elementNext.price;

    //停牌
    if (_totalDeals == 0) {
      price = _lastClosePrice;
      priceNext = price;
    }

    startX = _trendOriginX + spaceWidth * i;
    //（当前价-最低价）/（最高价-最低价）即是所占百分比，数组坐标0最高价，4最低价
    startY = trendYaddHeight -
             _trendSizeHeight * (price - [_priceMarkArray[4] integerValue]) /
                 ([_priceMarkArray[0] integerValue] -
                  [_priceMarkArray[4] integerValue]);

    endX = _trendOriginX + spaceWidth * (i + 1);
    endY = trendYaddHeight -
           _trendSizeHeight * (priceNext - [_priceMarkArray[4] integerValue]) /
               ([_priceMarkArray[0] integerValue] -
                [_priceMarkArray[4] integerValue]);

    //如果Y坐标在边界，则向内0.5f
    if (startY == 1.0f) {
      startY += 0.5f;
    } else if (startY == trendYaddHeight) {
      startY -= 0.5f;
    }

    if (endY == 1.0f) {
      endY += 0.5f;
    } else if (endY == trendYaddHeight) {
      endY -= 0.5f;
    }

    [_trendLinePointArray
        addObject:[NSValue valueWithCGPoint:CGPointMake(startX, startY)]];
    [_trendLinePointArray
        addObject:[NSValue valueWithCGPoint:CGPointMake(endX, endY)]];

    //添加最后一个点，否则刻度线超界崩溃
    if ((i + 1) == _valueAndVolumeDataArray.count - 1) {
      [_trendLinePointArray
          addObject:[NSValue valueWithCGPoint:CGPointMake(endX, endY)]];
      [_trendLinePointArray
          addObject:[NSValue valueWithCGPoint:CGPointMake(endX, endY)]];
    }
  }

  //加入黄色均线，指数股票不加入平均移动线
  if (_isIndexStock == NO) {
    for (NSInteger i = 0; i < _averageLineDataArray.count - 1; i++) //
    {
      NSInteger number = [_averageLineDataArray[i] integerValue];
      NSInteger numberNext = [_averageLineDataArray[i + 1] integerValue];
      //停牌
      if (_totalDeals == 0) {
        //总成交量为0，则把昨收价格，赋给当前价格
        number = _lastClosePrice;
        numberNext = number;
      }

      startX = _trendOriginX + spaceWidth * i;
      startY = trendYaddHeight -
               _trendSizeHeight * (number - [_priceMarkArray[4] integerValue]) /
                   ([_priceMarkArray[0] integerValue] -
                    [_priceMarkArray[4] integerValue]);

      endX = _trendOriginX + spaceWidth * (i + 1);
      endY = trendYaddHeight -
             _trendSizeHeight *
                 (numberNext - [_priceMarkArray[4] integerValue]) /
                 ([_priceMarkArray[0] integerValue] -
                  [_priceMarkArray[4] integerValue]);

      //均线第一个点
      if (i == 0) {
        [_averagePointArray
            addObject:[NSValue valueWithCGPoint:CGPointMake(startX, startY)]];
        [_averagePointArray
            addObject:[NSValue valueWithCGPoint:CGPointMake(startX, startY)]];
      }

      [_averagePointArray
          addObject:[NSValue valueWithCGPoint:CGPointMake(startX, startY)]];
      [_averagePointArray
          addObject:[NSValue valueWithCGPoint:CGPointMake(endX, endY)]];
    }
  }

  //计算成交量线
  //如果交易数为0，则不用计算了
  if (_totalDeals == 0) {
    return;
  }

  CGFloat volumeYaddHeight = _volumeOriginY + _volumeSizeHeight;

  if ([_valueAndVolumeDataArray count] > 1) {

    //量线点
    for (NSInteger i = 0; i < _valueAndVolumeDataArray.count; i++) {
      SMinDateElement *element = _valueAndVolumeDataArray[i];

      startX = _volumeOriginX + spaceWidth * i;
      startY = volumeYaddHeight;
      endX = startX;
      endY =
          volumeYaddHeight -
          element.volume / [_dealsMarkArray[1] floatValue] * _volumeSizeHeight;

      UIColor *color;
      if (i > 0) {
        SMinDateElement *elementLast = _valueAndVolumeDataArray[i - 1];
        color = [StockUtil
            getColorByFloatAndLastColor:(element.price - elementLast.price)];
      } else {
        color = [StockUtil
            getColorByFloatAndLastColor:(element.price - _lastClosePrice)];
      }

      DrawVolumeElement *elment = [[DrawVolumeElement alloc]
          initWithStartPoint:CGPointMake(startX, startY)
                    endPoint:CGPointMake(endX, endY)
                       color:color];
      [_volumePointArray addObject:elment];
    }
  }
}

#pragma mark - 纵轴刻度及提示框
- (void)calScalesData {
  if (_priceMarkArray.count == 0) {
    return;
  }

  for (int i = 0; i < 5; i++) {

    //价格标签
    NSNumber *price = _priceMarkArray[i];
    NSString *text = [NSString
        stringWithFormat:@"%.2f", (float)[price integerValue] / 100000];

    UILabel *priceLabel = _priceLabelArray[i];

    //竖屏幕
    priceLabel.text = text;
    if (i < 2) {
      priceLabel.textColor = [Globle colorFromHexRGB:Color_Red];
    } else if (i == 2) {
      priceLabel.textColor = [Globle colorFromHexRGB:Color_Text_Common];
    } else {
      priceLabel.textColor = [Globle colorFromHexRGB:Color_Green];
    }

    //百分比标签
    NSNumber *percent = _percentMarkArray[i];
    //与负号对齐
    if (i < 4) {
      text = [NSString stringWithFormat:@"% 0.2f%% ", [percent floatValue]];
    } else {
      text = [NSString stringWithFormat:@"%0.2f%% ", [percent floatValue]];
    }
    priceLabel = _percentLabelArray[i];

    priceLabel.text = text;
    if (i < 2) {
      priceLabel.textColor = [Globle colorFromHexRGB:Color_Red];
    } else if (i == 2) {
      priceLabel.textColor = [Globle colorFromHexRGB:Color_Text_Common];
    } else {
      priceLabel.textColor = [Globle colorFromHexRGB:Color_Green];
    }
  }

  //量线标签
  UILabel *handsLabel = _volumeLabelArray[1];
  int64_t deals = [_dealsMarkArray[1] integerValue];
  //对量进行判断
  NSString *volume;
  if (deals >= 100000000) {
    //大于亿，以亿为单位
    volume = [SimuUtil formatDecimal:(deals / 100000)ForDeciNum:2 ForSign:YES];
    handsLabel.text = @"亿手";
  } else if (deals >= 10000) {
    //大于万，以万为单位
    volume = [SimuUtil formatDecimal:(deals / 10)ForDeciNum:2 ForSign:YES];
    handsLabel.text = @"万手";
  } else {
    volume = [NSString stringWithFormat:@"%lld", deals];
  }

  NSString *text = volume;
  UILabel *volumeLabel = _volumeLabelArray[0];

  if (_totalDeals == 0) {
    //停牌股票处理
    text = @"0";
  }

  volumeLabel.text = text;
}

#pragma mark - 手势相关
#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
  if (gestureRecognizer == _longPressRecognizer) {
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
      return NO;
    } else {
      return YES;
    }
  } else {
    return YES;
  }
  return NO;
}

- (void)sendLandscapeVCExit {
  //发送通知退出横屏视图
  [[NSNotificationCenter defaultCenter]
      postNotificationName:LandscapeVCExitNotification
                    object:nil];
}

#pragma mark 长按手势回调函数
- (void)longPressToDo:(UILongPressGestureRecognizer *)gesture {
  //用户按下
  if (gesture.state == UIGestureRecognizerStateBegan) {

    //发送通知隐藏横屏K线选择segment
    [[NSNotificationCenter defaultCenter]
        postNotificationName:LandscapeSegmentShouldHideNotification
                      object:@(YES)];
    [UIView animateWithDuration:0.25
                     animations:^{
                       _detailInfoBackView.alpha = 1;
                     }];
    NSInteger minutes = TOTAL_MINUTES; // 4*60+1

    CGFloat spaceWidth = (_trendSizeWidth / (CGFloat)minutes);

    if (_lastPositon.y < _trendOriginY) {
      _lastPositon.y = _trendOriginY;
    }

    //驻点判断
    _lastPositon = [gesture locationInView:self];

    for (NSInteger i = 0; i < minutes; i++) {
      CGRect rect = CGRectMake(_trendOriginX + i * spaceWidth, _trendOriginY,
                               spaceWidth, HEIGHT_OF_VIEW + 7);
      if (CGRectContainsPoint(rect, _lastPositon)) {
        NSInteger index = i;
        if (index >= _dataMinutes) {
          index = _dataMinutes - 1;

          //防止超当前界限
          if (_lastPositon.x > _trendOriginX + _dataMinutes * spaceWidth) {
            _lastPositon.x = _trendOriginX + _dataMinutes * spaceWidth;
          }
        }

        if (index < _dataMinutes) {
          //画红色指标线
          [self drawIndexLine:index];
        }
        return;
      }
    }

    //手指移动
  } else if (gesture.state == UIGestureRecognizerStateChanged) {

    NSInteger count = _averageLineDataArray.count;
    CGFloat spaceWidth = (_trendSizeWidth / (CGFloat)count);
    _lastPositon = [gesture locationInView:self];

    if (_lastPositon.y < _trendOriginY) {
      _lastPositon.y = _trendOriginY;
    }
    if (_lastPositon.x >
        _trendOriginX + _trendDataPage.stockTrendArray.count * spaceWidth) {
      _lastPositon.x =
          _trendOriginX + _trendDataPage.stockTrendArray.count * spaceWidth;
    }

    [self touchBeganAndMoved:_lastPositon];

    //松手
  } else if (gesture.state == UIGestureRecognizerStateEnded) {
    if (_isLandScape) {
      //发送通知显示横屏K线选择segment
      [[NSNotificationCenter defaultCenter]
          postNotificationName:LandscapeSegmentShouldHideNotification
                        object:@(NO)];
      [UIView animateWithDuration:0.25
                       animations:^{
                         _detailInfoBackView.alpha = 0;
                       }];
    } else {
      CGRect rect = CGRectMake(0, 0, 20, 100);
      TrendFloatViewMsg *newmsg =
          [[TrendFloatViewMsg alloc] init:rect
                              forShowMode:MOD_TREND_NOFLWindows
                               forMsgType:Type_TREND_TO_FloatView];
      [[NSNotificationCenter defaultCenter]
          postNotificationName:SYS_VAR_NAME_SHOWFLOATVIWE_MSG
                        object:newmsg];
    }
    //竖屏则显示浮窗

    _verticalLineView.hidden = YES;
    _horicalLineView.hidden = YES;
    _crossDot.hidden = YES;
    _currentPriceLabel.hidden = YES;
    _currentTimeLabel.hidden = YES;
    _currentPercentLabel.hidden = YES;

    if (_onPartTimeSelected) {
      _onPartTimeSelected(nil);
    }
  }
}

#pragma mark 手指移动
- (void)touchBeganAndMoved:(CGPoint)currentPoint {
  //得到总分钟数
  NSInteger minutes = TOTAL_MINUTES;
  //宽度
  _dataMinutes = [_trendDataPage.stockTrendArray count];
  if (_dataMinutes == 0)
    return;
  if (_dataMinutes > TOTAL_MINUTES)
    _dataMinutes = TOTAL_MINUTES;

  CGFloat spaceWidth = (_trendSizeWidth / (CGFloat)minutes);

  for (NSInteger i = 0; i < _dataMinutes; i++) {
    CGRect rect = CGRectMake(_trendOriginX + i * spaceWidth, _trendOriginY,
                             spaceWidth + 0.5f, HEIGHT_OF_VIEW + 7);
    if (CGRectContainsPoint(rect, currentPoint)) {

      [self drawIndexLine:i];
      return;
    }
  }
}

#pragma mark - 设置红色指标线
- (void)drawIndexLine:(NSInteger)index {

  if (!_isLandScape) {
    //显示浮窗
    [self showFloatViewWithIndex:index];
  }

  _verticalLineView.hidden = NO;
  _horicalLineView.hidden = NO;
  _crossDot.hidden = NO;
  _currentPriceLabel.hidden = NO;
  _currentTimeLabel.hidden = NO;
  _currentPercentLabel.hidden = NO;

  float trendVolumeHeight = _trendSizeHeight + _volumeSizeHeight + 19;

  NSInteger minutes = TOTAL_MINUTES;

  CGFloat spaceWidth = _trendSizeWidth / (float)minutes;
  float currentWidth = spaceWidth * (float)index;

  //纵线重设中点
  _verticalLineView.center =
      CGPointMake(_trendOriginX + currentWidth,
                  (_trendOriginY + 0.5f + trendVolumeHeight) / 2.f);

  //横线重设中点
  _horicalLineView.center =
      CGPointMake(_trendOriginX - 0.5f + _trendSizeWidth / 2.f,
                  POINT(_trendLinePointArray, index * 2).y);

  //交叉点重设中点
  CGRect intersectionRect =
      CGRectIntersection(_verticalLineView.frame, _horicalLineView.frame);
  if (!CGRectIsNull(intersectionRect)) {
    _crossDot.center = CGPointMake(CGRectGetMidX(intersectionRect),
                                   CGRectGetMidY(intersectionRect));
  }

  if (!_isLandScape) {
    return;
  }

  //设置详细数据
  [_detailStringArray removeAllObjects];

  StockTrendItemInfo *itemInfo = _trendDataPage.stockTrendArray[index];

  //时间
  NSString *currentTime = [StockUtil timeFromNSIntegerWithoutSec:itemInfo.time];
  [_detailStringArray addObject:[@"时间 " stringByAppendingString:currentTime]];

  //价格
  CGFloat currentPrice = itemInfo.price / 1000.f;
  NSString *currentPriceStr = [NSString stringWithFormat:@"%.2f", currentPrice];
  [_detailStringArray
      addObject:[@"价格 " stringByAppendingString:currentPriceStr]];

  //涨跌
  float lastClosePrice = _lastClosePrice / 100000.f;
  float priceRise = (currentPrice - lastClosePrice) / lastClosePrice;
  NSString *currentRise =
      [NSString stringWithFormat:@"%.2f%%", priceRise * 100];
  [_detailStringArray addObject:[@"涨跌 " stringByAppendingString:currentRise]];

  //成交
  int64_t deals = itemInfo.amount;
  NSString *dealsStr;
  if (deals >= 100000000) {
    //大于亿，以亿为单位
    dealsStr = [SimuUtil formatDecimal:deals / 100000 ForDeciNum:2 ForSign:YES];
    dealsStr = [dealsStr stringByAppendingString:@"亿手"];
  } else if (deals >= 10000) {
    //大于万，以万为单位
    dealsStr = [SimuUtil formatDecimal:deals / 10 ForDeciNum:2 ForSign:YES];
    dealsStr = [dealsStr stringByAppendingString:@"万手"];
  } else {
    dealsStr =
        (deals == 0) ? @"0" : [NSString stringWithFormat:@"%lld手", deals];
  }
  [_detailStringArray addObject:[@"成交 " stringByAppendingString:dealsStr]];

  //均价
  NSString *avgPrice = [NSString
      stringWithFormat:@"%.2f",
                       [_averageLineDataArray[index] integerValue] / 100000.f];
  [_detailStringArray addObject:[@"均价 " stringByAppendingString:avgPrice]];

  //赋值并设置颜色
  UIColor *color = [StockUtil getColorByFloat:(currentPrice - lastClosePrice)];

  [_detailInfoLabelArray
      enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        NSString *str = _detailStringArray[idx];
        //设置属性字符串
        NSMutableAttributedString *attr =
            [[NSMutableAttributedString alloc] initWithString:str];
        if (idx != 0 && idx != 3) {
          [attr addAttribute:NSForegroundColorAttributeName
                       value:color
                       range:NSMakeRange(2, str.length - 2)];
        } else {
          //黑色
          [attr addAttribute:NSForegroundColorAttributeName
                       value:[Globle colorFromHexRGB:Color_Text_Common]
                       range:NSMakeRange(2, str.length - 2)];
        }
        label.attributedText = attr;
      }];

  //价格游标
  _currentPriceLabel.text = currentPriceStr;
  [SimuUtil widthOfLabel:_currentPriceLabel font:Font_Height_11_0];
  _currentPriceLabel.center =
      CGPointMake(_trendOriginX - _currentPriceLabel.width / 2 - 1,
                  _horicalLineView.centerY);
  if (_currentPriceLabel.top < _trendOriginY) {
    _currentPriceLabel.top = _trendOriginY;
  } else if (_currentPriceLabel.top > _trendOriginY + _trendSizeHeight) {
    _currentPriceLabel.top = _trendOriginY + _trendSizeHeight;
  }

  //时间游标
  StockTrendItemInfo *info = _trendDataPage.stockTrendArray[index];
  NSString *date = [StockUtil dateFromNSInteger:info.date];
  _currentTimeLabel.text = [date stringByAppendingFormat:@" %@", currentTime];
  [SimuUtil widthOfLabel:_currentTimeLabel font:Font_Height_11_0];
  _currentTimeLabel.center = CGPointMake(_verticalLineView.centerX,
                                         _trendOriginY + _trendSizeHeight +
                                             _currentTimeLabel.height / 2 + 1);
  if (_currentTimeLabel.left < _trendOriginX) {
    _currentTimeLabel.left = _trendOriginX;
  } else if (_currentTimeLabel.right > _trendOriginX + _trendSizeWidth) {
    _currentTimeLabel.right = _trendOriginX + _trendSizeWidth;
  }

  //涨幅游标
  _currentPercentLabel.text = currentRise;
  [SimuUtil widthOfLabel:_currentPercentLabel font:Font_Height_11_0];
  _currentPercentLabel.center = CGPointMake(
      _trendOriginX + _trendSizeWidth + _currentPercentLabel.width / 2 - 1,
      _horicalLineView.centerY);
  if (_currentPercentLabel.top < _trendOriginY) {
    _currentPercentLabel.top = _trendOriginY;
  } else if (_currentPercentLabel.top > _trendOriginY + _trendSizeHeight) {
    _currentPercentLabel.top = _trendOriginY + _trendSizeHeight;
  }
}

#pragma mark - 显示浮窗
- (void)showFloatViewWithIndex:(NSInteger)index {
  StockTrendItemInfo *itemInfo = _trendDataPage.stockTrendArray[index];

  NSString *priceFormat = @"%.2f";

  CGFloat lastClosePrice = _lastClosePrice / 100000.f;
  CGFloat currentPrice = itemInfo.price / 1000.f;
  NSString *currentPriceStr =
      [NSString stringWithFormat:priceFormat, currentPrice];
  CGFloat priceRise = (currentPrice - lastClosePrice) / lastClosePrice;
  NSString *currentRise =
      [NSString stringWithFormat:@"%.2f%%", priceRise * 100];

  //传递浮窗数据
  PartTimeFloatData *partTimeFloatData = [[PartTimeFloatData alloc] init];
  partTimeFloatData.index = index;
  partTimeFloatData.range = TOTAL_MINUTES;
  partTimeFloatData.time =
      [StockUtil timeFromNSIntegerWithoutSec:itemInfo.time];
  partTimeFloatData.curPrice = currentPriceStr;
  partTimeFloatData.riseValue = currentRise;
  partTimeFloatData.color =
      [StockUtil getColorByFloat:(currentPrice - lastClosePrice)];

  partTimeFloatData.curAmount =
      [StockUtil handsStringFromVolume:itemInfo.amount needsHand:YES];

  partTimeFloatData.avgPrice = [NSString
      stringWithFormat:priceFormat,
                       [_averageLineDataArray[index] integerValue] / 100000.f];

  if (_onPartTimeSelected) {
    _onPartTimeSelected(partTimeFloatData);
  }
}

- (void)clearView {
}

@end
