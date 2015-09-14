//
//  PartTimeView.m
//  SimuStock
//
//  Created by Yuemeng on 15/4/14.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "PartTimeView.h"
#import "SimuStockInfoData.h"

///显示的交易的分钟数
static NSInteger TradeMinuteNum = 241;

///数据右侧显示的空白天数
static NSInteger TradeMinuteNumEmpty = 0;

///价格标签显示宽度
static CGFloat PriceScaleWidth = 35.f;

///价格涨跌幅标签显示宽度
static CGFloat PriceRisePercentScaleWidth = 35.f;

///数据日期标签显示高度
static CGFloat DateScaleHeight = 20.f;

///价格标签在横屏情况下与图形的间距
static CGFloat PriceScaleMargin = 3.f;

///价格涨跌幅标签在横屏情况下与图形的间距
static CGFloat PriceRisePercentScaleMargin = 3.f;

///标签显示高度
static CGFloat CommonLabelHeight = 10.f;

///横竖屏情况下左右两边的空白
static CGFloat CommonMarginLeftRight = 5.f;

///横竖屏情况下上边的空白
static CGFloat CommonMarginTop = 0.5f;

///横竖屏情况下下边的空白
static CGFloat CommonMarginButtom = 0.5f;

//从数组得到点
#define POINT(ARRAY, X) [[ARRAY objectAtIndex:X] CGPointValue]

@implementation PartTimeView

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self initVaribles];
    [self createGestureRecognizer];
  }
  return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];

  [self initVaribles];
  [self createGestureRecognizer];
}

- (void)initVaribles {
  _priceLabelArray = [[NSMutableArray alloc] initWithCapacity:0];
  _percentLabelArray = [[NSMutableArray alloc] initWithCapacity:0];
  _timeLabelArray = [[NSMutableArray alloc] initWithCapacity:0];
  _volumeLabelArray = [[NSMutableArray alloc] initWithCapacity:0];
  _averageLineDataArray =
      [[NSMutableArray alloc] initWithCapacity:TradeMinuteNum];
  _valueAndVolumeDataArray =
      [[NSMutableArray alloc] initWithCapacity:TradeMinuteNum];
  _trendLinePointArray = [[NSMutableArray alloc] initWithCapacity:482];
  _averagePointArray = [[NSMutableArray alloc] initWithCapacity:482];
  _volumePointArray = [[NSMutableArray alloc] initWithCapacity:TradeMinuteNum];
  _percentMarkArray = [[NSMutableArray alloc] initWithCapacity:5];
  _priceMarkArray = [[NSMutableArray alloc] initWithCapacity:5];
  _dealsMarkArray = [[NSMutableArray alloc] initWithCapacity:2];

  _trendDataPage = [[DataArray alloc] init];
}

- (CGFloat)trendStartX {
  return _isHorizontalMode ? PriceScaleWidth + PriceScaleMargin
                           : CommonMarginLeftRight;
}

- (CGFloat)trendStartY {
  return CommonMarginTop;
}

- (CGFloat)priceStartX {
  return _isHorizontalMode ? 0 : CommonMarginLeftRight + PriceScaleMargin;
}

- (CGFloat)pricePercentStartX {
  return _isHorizontalMode
             ? self.bounds.size.width - PriceRisePercentScaleWidth
             : self.bounds.size.width - CommonMarginLeftRight -
                   PriceRisePercentScaleWidth - PriceRisePercentScaleMargin;
}

- (CGFloat)trendSizeWidth {
  return _isHorizontalMode
             ? self.bounds.size.width - PriceScaleWidth -
                   PriceRisePercentScaleWidth - PriceScaleMargin -
                   PriceRisePercentScaleMargin
             : self.bounds.size.width - CommonMarginLeftRight * 2;
}

- (CGFloat)trendSizeHeight {
  return (self.bounds.size.height - DateScaleHeight - CommonMarginButtom -
          CommonMarginTop) *
         2.f / 3.f;
}

- (CGFloat)volumeStartY {
  return CommonMarginTop + self.trendSizeHeight + DateScaleHeight;
}

- (CGFloat)volumeSizeHeight {
  return (self.bounds.size.height - DateScaleHeight - CommonMarginButtom -
          CommonMarginTop) /
         3.f;
}

- (CGFloat)cursorPriceStartX {
  return _isHorizontalMode ? self.trendStartX - _currentPriceLabel.width
                           : CommonMarginLeftRight;
}

- (CGFloat)cursorPercentStartX {
  return _isHorizontalMode ? self.trendStartX + self.trendSizeWidth
                           : self.trendStartX + self.trendSizeWidth -
                                 _currentPercentLabel.width;
}

- (void)resetRectMembers {
  _isStraightLineTrend = NO;
  [self createUI];
}

- (void)createUI {

  //左侧5价格scale，Font10
  if (_priceLabelArray.count == 0) {
    for (NSInteger i = 0; i < 5; i++) {
      UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
      label.font = [UIFont systemFontOfSize:Font_Height_10_0];
      label.textAlignment = NSTextAlignmentRight;
      label.text = @"";
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
  }

  //右侧5百分比scale
  if (_percentLabelArray.count == 0) {
    for (NSInteger i = 0; i < 5; i++) {
      UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
      label.text = @"0.00%";
      label.font = [UIFont systemFontOfSize:Font_Height_10_0];
      label.textAlignment = NSTextAlignmentLeft;
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
  }
  //中间时间5个标签，H30
  if (_timeLabelArray.count == 0) {
    NSArray *times = @[ @"9:30", @"10:30", @"11:30/13:00", @"14:00", @"15:00" ];
    for (NSInteger i = 0; i < 5; i++) {
      UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
      label.text = times[i];
      label.font = [UIFont systemFontOfSize:Font_Height_10_0];
      label.textColor = [Globle colorFromHexRGB:Color_Gray];
      label.adjustsFontSizeToFitWidth = YES;
      if (i < 2) {
        label.textAlignment = NSTextAlignmentLeft;
      } else if (i > 2) {
        label.textAlignment = NSTextAlignmentRight;
      } else {
        label.textAlignment = NSTextAlignmentCenter;
      }
      label.backgroundColor = [UIColor clearColor];
      [self addSubview:label];
      [_timeLabelArray addObject:label];
    }
  }

  //左下角成交量和手
  if (_volumeLabelArray.count == 0) {
    for (NSInteger i = 0; i < 2; i++) {
      UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
      label.text = @"0";
      label.font = [UIFont systemFontOfSize:Font_Height_10_0];
      label.textAlignment = NSTextAlignmentRight;
      label.textColor = [Globle colorFromHexRGB:Color_Text_Common];
      label.adjustsFontSizeToFitWidth = YES;
      if (i == 1) {
        label.text = @"手";
      }
      label.backgroundColor = [UIColor clearColor];
      [_volumeLabelArray addObject:label];
      [self addSubview:label];
    }
  }

  //添加红色指标线
  if (_verticalLineView == nil) {
    _verticalLineView = [[UIView alloc] initWithFrame:CGRectZero];
    _verticalLineView.backgroundColor =
        [Globle colorFromHexRGB:COLOR_INDICATOR_LINE];
    [self addSubview:_verticalLineView];
    _verticalLineView.hidden = YES;
  }

  if (_horicalLineView == nil) {
    _horicalLineView = [[UIView alloc] initWithFrame:CGRectZero];
    _horicalLineView.backgroundColor =
        [Globle colorFromHexRGB:COLOR_INDICATOR_LINE];
    [self addSubview:_horicalLineView];
    _horicalLineView.hidden = YES;
  }

  //添加交叉点

  if (_crossDot == nil) {
    _crossDot = [[UIView alloc] initWithFrame:CGRectZero];
    _crossDot.backgroundColor = [Globle colorFromHexRGB:COLOR_INDICATOR_LINE];
    _crossDot.layer.cornerRadius = _crossDot.width / 2.0f;
    [self addSubview:_crossDot];
    _crossDot.hidden = YES;
  }

  //创建 价格、时间、涨幅 游标
  if (_currentPriceLabel == nil) {
    for (NSInteger i = 0; i < 3; i++) {
      //价格
      UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 65, (i == 1 ? 20 : 15))];
      label.layer.borderWidth = 0.5f;
      label.layer.borderColor = [[Globle colorFromHexRGB:Color_Gray] CGColor];
      label.layer.cornerRadius = 2;
      label.adjustsFontSizeToFitWidth = YES;
      label.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
      label.font = [UIFont systemFontOfSize:Font_Height_11_0];
      label.textColor = [Globle colorFromHexRGB:Color_Blue_but];
      label.hidden = YES;
      [self addSubview:label];
      if (i == 0) {
        label.textAlignment = NSTextAlignmentLeft;
        _currentPriceLabel = label;
      } else if (i == 1) {
        label.textAlignment = NSTextAlignmentCenter;
        _currentTimeLabel = label;
      } else {
        label.textAlignment = NSTextAlignmentRight;
        _currentPercentLabel = label;
      }
    }
  }

  CGFloat spaceHeight = (self.trendSizeHeight - CommonLabelHeight) / 4;
  [_priceLabelArray
      enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        label.frame = CGRectMake(self.priceStartX, idx * spaceHeight,
                                 PriceScaleWidth, CommonLabelHeight);
        label.textAlignment =
            _isHorizontalMode ? NSTextAlignmentRight : NSTextAlignmentLeft;
      }];
  //右侧5百分比标签
  [_percentLabelArray
      enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        label.frame = CGRectMake(self.pricePercentStartX, idx * spaceHeight,
                                 PriceRisePercentScaleWidth, CommonLabelHeight);
        label.textAlignment =
            _isHorizontalMode ? NSTextAlignmentLeft : NSTextAlignmentRight;
      }];

  //中间时间5个标签，H30
  CGFloat timeLabelWidth = 60;
  CGFloat spaceWidth = (self.trendSizeWidth - timeLabelWidth * 5) / 4;

  [_timeLabelArray enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx,
                                                BOOL *stop) {
    label.frame =
        CGRectMake(self.trendStartX + idx * (spaceWidth + timeLabelWidth),
                   self.trendSizeHeight + 5, timeLabelWidth, CommonLabelHeight);
    if (idx == 0) {
      label.left += 2;
    } else if (idx == _timeLabelArray.count - 1) {
      label.left -= 2;
    }
  }];

  //左下角成交量和手
  [_volumeLabelArray enumerateObjectsUsingBlock:^(UILabel *label,
                                                  NSUInteger idx, BOOL *stop) {

    label.frame = CGRectMake(
        self.priceStartX,
        self.volumeStartY + (self.volumeSizeHeight - CommonLabelHeight) * idx,
        PriceScaleWidth, CommonLabelHeight);
    label.textAlignment =
        _isHorizontalMode ? NSTextAlignmentRight : NSTextAlignmentLeft;
  }];

  //添加红色指标线
  _verticalLineView.frame = CGRectMake(
      self.trendStartX, CommonMarginTop, 1,
      self.trendSizeHeight + self.volumeSizeHeight + DateScaleHeight);
  _horicalLineView.frame = CGRectMake(0, 100, self.trendSizeWidth - 1, 1);

  //添加交叉点
  float crossDotWidth = _verticalLineView.width * 4;
  _crossDot.frame = CGRectMake(0, 0, crossDotWidth, crossDotWidth);
  _crossDot.layer.cornerRadius = _crossDot.width / 2.0f;
}

#pragma mark - ⭐️画线部分
- (void)drawRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();
  //    CGContextClearRect(context, self.bounds);

  //画边框和分割线
  [self drawBorders];

  if (_trendLinePointArray.count < 2)
    return;

  CGContextSaveGState(context);
  //设置画笔粗细
  float lineWidth = [SimuUtil getFloatWithFloat:self.spaceWidth * 0.8f
                                           bits:2]; // 0.8f,方便量线阅读
  CGContextSetLineWidth(context, lineWidth);

  CGFloat endY = CommonMarginTop + self.trendSizeHeight;
  //横向绘制，从左至右
  if (_trendLinePointArray.count > 0) {
    NSInteger linePointNum = _trendLinePointArray.count - 1;
    for (int i = 0; i < linePointNum; i++) {
      CGPoint startPoint = POINT(_trendLinePointArray, i);
      CGPoint endPoint = POINT(_trendLinePointArray, i + 1);
      //深蓝色粗线
      [[Globle colorFromHexRGB:Color_Blue_but] set];
      CGContextMoveToPoint(context, startPoint.x, startPoint.y);
      CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
      CGContextStrokePath(context);
      //浅蓝色区域
      [[Globle colorFromHexRGB:Color_Blue_but alpha:0.15] set];
      //每根线其实是个长方形
      CGContextBeginPath(context);
      CGContextMoveToPoint(context, startPoint.x, startPoint.y);
      CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
      CGContextAddLineToPoint(context, endPoint.x, endY);
      CGContextAddLineToPoint(context, startPoint.x, endY);
      CGContextFillPath(context);
    }
  }

  //画出均线
  [[Globle colorFromHexRGB:COLOR_AVERAGE_LINE] set]; //金黄色均线
  if (_averagePointArray.count > 0 && !_isStraightLineTrend) {
    NSInteger linePointNum = _averagePointArray.count - 1;
    for (int i = 0; i < linePointNum; i++) {
      CGPoint startPoint = POINT(_averagePointArray, i);
      CGPoint endPoint = POINT(_averagePointArray, i + 1);
      CGContextMoveToPoint(context, startPoint.x, startPoint.y);
      CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
      CGContextStrokePath(context);
    }
  }

  //画出量线(红绿线）
  NSInteger i = 0;
  for (DrawVolumeElement *element in _volumePointArray) {
    if (i < TradeMinuteNum) {
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
  CGContextRestoreGState(context);
}

#pragma mark - 画边框
- (void)drawBorders {
  CGContextRef context = UIGraphicsGetCurrentContext();

  //趋势与量线边界
  CGRect tempTrendRect =
      CGRectMake(self.trendStartX, CommonMarginTop, self.trendSizeWidth - 1,
                 self.trendSizeHeight);

  CGRect tempVolumeRect =
      CGRectMake(self.trendStartX, self.volumeStartY, self.trendSizeWidth,
                 self.volumeSizeHeight);

  //画k线和交易量两个区域边框
  [[Globle colorFromHexRGB:COLOR_KLINE_BORDER] set];
  CGContextSetLineWidth(context, 0.5f);
  CGContextAddRect(context, tempTrendRect);
  CGContextAddRect(context, tempVolumeRect);
  CGContextStrokePath(context);

  //趋势区3条横线
  CGFloat spaceY = self.trendSizeHeight / 4;
  for (NSInteger i = 1; i <= 3; i++) {
    CGContextMoveToPoint(context, self.trendStartX - 0.5f, i * spaceY);
    CGContextAddLineToPoint(context, self.trendStartX - 1 + self.trendSizeWidth,
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

  //趋势区3条竖线
  for (NSInteger i = 1; i <= 3; i++) {
    CGContextMoveToPoint(context,
                         self.trendStartX + i * self.trendSizeWidth / 4,
                         CommonMarginTop);
    CGContextAddLineToPoint(context,
                            self.trendStartX + i * self.trendSizeWidth / 4,
                            self.trendSizeHeight + 0.5f);
    CGContextStrokePath(context);
  }

  //交易量区3条竖线
  CGFloat _amountYtoHeight = self.volumeStartY + self.volumeSizeHeight;
  for (NSInteger i = 1; i <= 3; i++) {
    CGContextMoveToPoint(context,
                         self.trendStartX + i * self.trendSizeWidth / 4,
                         self.volumeStartY);
    CGContextAddLineToPoint(context,
                            self.trendStartX + i * self.trendSizeWidth / 4,
                            _amountYtoHeight);
    CGContextStrokePath(context);
  }
}

#pragma mark - ⭐️重画k线和量线，两侧价格
- (void)setTrendData:(TrendData *)trendData
      securitiesInfo:(SecuritiesInfo *)securitiesInfo {
  if (trendData == nil) {
    [self clearView];
    return;
  }

  _securitiesInfo = securitiesInfo;
  NSString *firstType = _securitiesInfo.securitiesFirstType();
  _isIndexStock = [StockUtil isMarketIndex:firstType];

  //切换股票后重置显示区域，并区分大盘、个股
  [self resetRectMembers];

  [_trendDataPage reset];
  _trendDataPage.dataBinded = YES;
  [_trendDataPage.array addObjectsFromArray:trendData.stockTrendArray];
  //给横屏视图传递时间
  if (_passTimeLabelText) {
    _passTimeLabelText([@"时间 "
        stringByAppendingString:
            [StockUtil getCurrentTime:trendData.stockTrendArray.count - 1]]);
  }

  //设置昨收价格
  _lastClosePrice = trendData.lastClosePrice * 100000; //保证7位
  //是否停牌
  _isListed = trendData.isListed;

  //重新计算均线数据
  [self calculateData];
  //重新计算所有数据
  [self calPricesAndPercentsArray];
  //重新计算所有刻度线
  [self calScalesData];
  //重新画图
  [self setNeedsDisplay];
}

- (void)clearView {
  [_trendDataPage reset];
  [_averageLineDataArray removeAllObjects];
  [_valueAndVolumeDataArray removeAllObjects];
  [_trendLinePointArray removeAllObjects];
  [_averagePointArray removeAllObjects];
  [_volumePointArray removeAllObjects];

  [_priceLabelArray
      enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        label.text = @"";
      }];
  [_percentLabelArray
      enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        label.text = @"";
      }];
  [_volumeLabelArray
      enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        label.text = @"";
      }];

  [self setNeedsDisplay];
}

#pragma mark - 计算均线数据：平均价格，总分钟数，总交易量
- (void)calculateData {
  [_averageLineDataArray removeAllObjects];
  [_valueAndVolumeDataArray removeAllObjects];
  [_trendLinePointArray removeAllObjects];
  [_averagePointArray removeAllObjects];
  [_volumePointArray removeAllObjects];

  int64_t allDeals = 0;
  for (StockTrendItemInfo *info in _trendDataPage.array) {
    allDeals += info.amount; //交易量
    [_averageLineDataArray
        addObject:@(info.avgPrice * 100)]; //均价19484 5位变7位
    //价格和交易量数据
    SMinDateElement *elment =
        [[SMinDateElement alloc] initWithPrice:info.price * 100
                                        volume:info.amount];
    [_valueAndVolumeDataArray addObject:elment];
  }
  //当前分钟数
  _dataMinutes = _trendDataPage.array.count;
  //当前总手
  _totalDeals = allDeals;
}

#pragma mark - 解析数据成价格曲线点和均线曲线点
- (void)calPricesAndPercentsArray {
  if (_valueAndVolumeDataArray.count == 0) {
    return;
  }
  //解析所有价格点和当时成交量
  NSInteger lastClosePrice = _lastClosePrice;

  if (lastClosePrice == 0) {
    lastClosePrice =
        ((StockTrendItemInfo *)_trendDataPage.array[0]).currentPrice * 100;
    if (lastClosePrice == 0) {
      lastClosePrice = 1;
    }
  }

  //价格刻度
  int64_t maxPrice = ((SMinDateElement *)_valueAndVolumeDataArray[0]).price;
  int64_t minPrice = maxPrice;
  int64_t maxVolume = ((StockTrendItemInfo *)_trendDataPage.array[0]).amount;

  //计算最高、最低价和最大交易量
  for (SMinDateElement *element in _valueAndVolumeDataArray) {
    if (element.price > maxPrice) {
      maxPrice = element.price;
    }
    if (element.price < minPrice) {
      minPrice = element.price;
    }
    if (element.volume > maxVolume) {
      maxVolume = element.volume;
    }
  }

  //涨停或跌停，不画趋势线
  if (maxPrice == minPrice) {
    _isStraightLineTrend = YES;
  }

  //停牌股票处理，因为趋势图是直线，所以刻度坐标直接按10%涨跌停计算
  if (_totalDeals == 0) {
    maxPrice = _lastClosePrice * 1.1;
    minPrice = _lastClosePrice * 0.9;
    //不画均线
    _isStraightLineTrend = YES;
  }

  //计算最大百分比刻度
  float maxPercent =
      ((maxPrice - lastClosePrice) > (lastClosePrice - minPrice))
          ? ((float)(maxPrice - lastClosePrice) * 100 / (float)lastClosePrice)
          : ((float)(lastClosePrice - minPrice) * 100 / (float)lastClosePrice);

  //绑定百分比和价格刻度数值
  [_percentMarkArray removeAllObjects];
  [_priceMarkArray removeAllObjects];
  for (NSInteger i = 0; i < 5; i++) {
    [_percentMarkArray
        addObject:@(maxPercent *
                    ((4 - i) / 2.f - 1))]; //((4-i)/2 - 1)即：1, 0.5,
    // 0, -0.5,
    //-1，用于求百分比刻度值
    [_priceMarkArray addObject:@((1 + [_percentMarkArray[i] floatValue] / 100) *
                                 lastClosePrice)]; //高到低
  }

  //绑定交易量刻度数值
  [_dealsMarkArray removeAllObjects];
  for (NSInteger i = 1; i <= 2; i++) {
    [_dealsMarkArray addObject:@(maxVolume * (i * 0.5))]; // 0.5 1
  }

  //计算点
  CGFloat trendYaddHeight = CommonMarginTop + self.trendSizeHeight;
  CGFloat startX, startY, endX, endY;

  //蓝色粗线的坐标
  for (NSInteger i = 0; i < _valueAndVolumeDataArray.count - 1; i++) {
    SMinDateElement *element = _valueAndVolumeDataArray[i];
    SMinDateElement *elementNext = _valueAndVolumeDataArray[i + 1];

    NSInteger price = element.price;
    NSInteger priceNext = elementNext.price;

    //停牌
    if (_totalDeals == 0) {
      price = _lastClosePrice;
      priceNext = price;
    }

    startX = self.trendStartX + self.spaceWidth * i;
    //（当前价-最低价）/（最高价-最低价）即是所占百分比，数组坐标0最高价，4最低价
    startY = trendYaddHeight -
             self.trendSizeHeight *
                 (price - [_priceMarkArray[4] integerValue]) /
                 ([_priceMarkArray[0] integerValue] -
                  [_priceMarkArray[4] integerValue]);

    endX = self.trendStartX + self.spaceWidth * (i + 1);
    endY = trendYaddHeight -
           self.trendSizeHeight *
               (priceNext - [_priceMarkArray[4] integerValue]) /
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

    //最多480个点
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

  //加入黄色均线，指数股票、停牌不加入平均移动线
  if (!_isIndexStock || !_isStraightLineTrend) {
    for (NSInteger i = 0; i < _averageLineDataArray.count - 1; i++) //
    {
      NSInteger number = [_averageLineDataArray[i] integerValue];
      NSInteger numberNext = [_averageLineDataArray[i + 1] integerValue];
      //停牌
      if (_totalDeals == 0) {
        //总成交量为0，则把昨收价格，付给当前价格
        number = _lastClosePrice;
        numberNext = number;
      }

      startX = self.trendStartX + self.spaceWidth * i;
      startY = trendYaddHeight -
               self.trendSizeHeight *
                   (number - [_priceMarkArray[4] integerValue]) /
                   ([_priceMarkArray[0] integerValue] -
                    [_priceMarkArray[4] integerValue]);

      endX = self.trendStartX + self.spaceWidth * (i + 1);
      endY = trendYaddHeight -
             self.trendSizeHeight *
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

  CGFloat volumeYaddHeight = self.volumeStartY + self.volumeSizeHeight;

  if ([_valueAndVolumeDataArray count] > 1) {

    //量线点
    for (NSInteger i = 0; i < _valueAndVolumeDataArray.count; i++) {
      SMinDateElement *element = _valueAndVolumeDataArray[i];

      startX = self.trendStartX + self.spaceWidth * i;
      startY = volumeYaddHeight;
      endX = startX;
      endY = volumeYaddHeight -
             element.volume / [_dealsMarkArray[1] floatValue] *
                 self.volumeSizeHeight;

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

- (NSString *)priceFormat {
  return _securitiesInfo
             ? [StockUtil
                   getPriceFormatWithFirstType:_securitiesInfo
                                                   .securitiesFirstType()]
             : @"%.2f";
}

#pragma mark - 纵轴刻度及提示框
- (void)calScalesData {
  if (_priceMarkArray.count == 0) {
    return;
  }
  for (int i = 0; i < 5; i++) {

    //价格标签
    NSNumber *price = _priceMarkArray[i];
    NSString *text =
        [NSString stringWithFormat:self.priceFormat,
                                   (float)[price integerValue] / 100000];

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
      text = [NSString stringWithFormat:@" %0.2f%% ", [percent floatValue]];
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

#pragma mark 创建手势
- (void)createGestureRecognizer {
  //创建长按手势
  _longPressRecognizer = [[UILongPressGestureRecognizer alloc]
      initWithTarget:self
              action:@selector(longPressToDo:)];
  [_longPressRecognizer setDelegate:self];
  _longPressRecognizer.allowableMovement = 12;
  [self addGestureRecognizer:_longPressRecognizer];

  //双击退出手势
  UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]
      initWithTarget:self
              action:@selector(sendLandscapeVCExit)];
  doubleTap.numberOfTapsRequired = 2;
  [self addGestureRecognizer:doubleTap];
}

- (void)sendLandscapeVCExit {
  //发送通知退出横屏视图
  [[NSNotificationCenter defaultCenter]
      postNotificationName:LandscapeVCExitNotification
                    object:nil];
}

- (CGFloat)spaceWidth {
  return (self.trendSizeWidth / (TradeMinuteNum + TradeMinuteNumEmpty));
}

#pragma mark 长按手势回调函数
- (void)longPressToDo:(UILongPressGestureRecognizer *)gesture {
  //用户按下
  if (gesture.state == UIGestureRecognizerStateBegan) {

    if (_lastPositon.y < self.volumeStartY) {
      _lastPositon.y = self.volumeStartY;
    }

    //驻点判断
    _lastPositon = [gesture locationInView:self];

    for (NSInteger i = 0; i < _dataMinutes; i++) {
      CGRect rect =
          CGRectMake(self.trendStartX + i * self.spaceWidth, CommonMarginTop,
                     self.spaceWidth, HEIGHT_OF_VIEW + 7);
      if (CGRectContainsPoint(rect, _lastPositon)) {
        NSInteger index = i;
        if (index >= _dataMinutes) {
          index = _dataMinutes - 1;

          //防止超当前界限
          if (_lastPositon.x >
              self.volumeStartY + _dataMinutes * self.spaceWidth) {
            _lastPositon.x = self.volumeStartY + _dataMinutes * self.spaceWidth;
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
    CGFloat spaceWidth = (self.trendSizeWidth / (CGFloat)count);
    _lastPositon = [gesture locationInView:self];

    if (_lastPositon.y < self.volumeStartY) {
      _lastPositon.y = self.volumeStartY;
    }
    if (_lastPositon.x >
        self.trendStartX + _trendDataPage.array.count * spaceWidth) {
      _lastPositon.x =
          self.trendStartX + _trendDataPage.array.count * spaceWidth;
    }

    [self touchBeganAndMoved:_lastPositon];

    //松手
  } else if (gesture.state == UIGestureRecognizerStateEnded) {

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

  //宽度
  _dataMinutes = [_trendDataPage.array count];
  if (_dataMinutes == 0)
    return;
  if (_dataMinutes > TradeMinuteNum)
    _dataMinutes = TradeMinuteNum;

  for (NSInteger i = 0; i < _dataMinutes; i++) {
    CGRect rect =
        CGRectMake(self.trendStartX + i * self.spaceWidth, CommonMarginTop,
                   self.spaceWidth, HEIGHT_OF_VIEW + 7);
    if (CGRectContainsPoint(rect, currentPoint)) {

      [self drawIndexLine:i];
      return;
    }
  }
}

#pragma mark - 设置红色指标线
- (void)drawIndexLine:(NSInteger)index {

  _verticalLineView.hidden = NO;
  _horicalLineView.hidden = NO;
  _crossDot.hidden = NO;
  _currentPriceLabel.hidden = NO;
  _currentTimeLabel.hidden = NO;
  _currentPercentLabel.hidden = NO;

  float trendVolumeHeight = self.trendSizeHeight + self.volumeSizeHeight + 19;

  float currentWidth = self.spaceWidth * (float)index;

  //纵线重设中点
  _verticalLineView.center =
      CGPointMake(self.trendStartX + currentWidth,
                  (CommonMarginTop + 0.5f + trendVolumeHeight) / 2.f);

  //横线重设中点
  _horicalLineView.center =
      CGPointMake(self.trendStartX - 0.5f + self.trendSizeWidth / 2.f,
                  POINT(_trendLinePointArray, index * 2).y);

  //交叉点重设中点
  CGRect intersectionRect =
      CGRectIntersection(_verticalLineView.frame, _horicalLineView.frame);
  if (!CGRectIsNull(intersectionRect)) {
    _crossDot.center = CGPointMake(CGRectGetMidX(intersectionRect),
                                   CGRectGetMidY(intersectionRect));
  }

  StockTrendItemInfo *itemInfo = _trendDataPage.array[index];
  NSString *priceFormat = [StockUtil
      getPriceFormatWithFirstType:_securitiesInfo.securitiesFirstType()];

  //价格游标
  CGFloat currentPrice = itemInfo.price / 1000.f;
  NSString *currentPriceStr =
      [NSString stringWithFormat:priceFormat, currentPrice];
  _currentPriceLabel.text = currentPriceStr;
  [SimuUtil widthOfLabel:_currentPriceLabel font:Font_Height_11_0];
  _currentPriceLabel.center =
      CGPointMake(self.trendStartX - _currentPriceLabel.width / 2 - 1,
                  _horicalLineView.centerY);
  if (_currentPriceLabel.top < CommonMarginTop) {
    _currentPriceLabel.top = CommonMarginTop;
  } else if (_currentPriceLabel.top > CommonMarginTop + self.trendSizeHeight) {
    _currentPriceLabel.top = CommonMarginTop + self.trendSizeHeight;
  }
  if (_currentPriceLabel.width > PriceScaleWidth + PriceScaleMargin) {
    _currentPriceLabel.width = PriceScaleWidth + PriceScaleMargin;
    _currentPriceLabel.adjustsFontSizeToFitWidth = YES;
  }
  _currentPriceLabel.left = self.cursorPriceStartX;

  //时间游标
  NSString *currentTime = [StockUtil getCurrentTime:index];
  _currentTimeLabel.text = currentTime;
  [SimuUtil widthOfLabel:_currentTimeLabel font:Font_Height_11_0];
  _currentTimeLabel.center = CGPointMake(
      _verticalLineView.centerX, CommonMarginTop + self.trendSizeHeight +
                                     _currentTimeLabel.height / 2);
  if (_currentTimeLabel.left < self.trendStartX) {
    _currentTimeLabel.left = self.trendStartX;
  } else if (_currentTimeLabel.right > self.trendStartX + self.trendSizeWidth) {
    _currentTimeLabel.right = self.trendStartX + self.trendSizeWidth;
  }

  //涨幅游标
  float lastClosePrice = _lastClosePrice / 100000.f;
  float priceRise = (currentPrice - lastClosePrice) / lastClosePrice;
  NSString *currentRise =
      [NSString stringWithFormat:@"%.2f%%", priceRise * 100];
  _currentPercentLabel.text = currentRise;
  [SimuUtil widthOfLabel:_currentPercentLabel font:Font_Height_11_0];
  _currentPercentLabel.center =
      CGPointMake(self.trendStartX + self.trendSizeWidth +
                      _currentPercentLabel.width / 2 - 1,
                  _horicalLineView.centerY);
  if (_currentPercentLabel.top < CommonMarginTop) {
    _currentPercentLabel.top = CommonMarginTop;
  } else if (_currentPercentLabel.top >
             CommonMarginTop + self.trendSizeHeight) {
    _currentPercentLabel.top = CommonMarginTop + self.trendSizeHeight;
  }
  if (_currentPercentLabel.width >
      PriceRisePercentScaleWidth + PriceRisePercentScaleMargin) {
    _currentPercentLabel.width =
        PriceRisePercentScaleWidth + PriceRisePercentScaleMargin;
    _currentPercentLabel.adjustsFontSizeToFitWidth = YES;
  }
  _currentPercentLabel.left = self.cursorPercentStartX;

  //传递浮窗数据
  PartTimeFloatData *partTimeFloatData = [[PartTimeFloatData alloc] init];
  partTimeFloatData.index = index;
  partTimeFloatData.range = TradeMinuteNum;
  partTimeFloatData.time = [StockUtil getCurrentTime:index];
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

@end
