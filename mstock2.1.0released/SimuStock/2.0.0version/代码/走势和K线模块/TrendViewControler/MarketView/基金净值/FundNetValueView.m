//
//  FundNetValueView.m
//  SimuStock
//
//  Created by Mac on 15/5/29.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "FundNetValueView.h"

///显示的基金天数
static NSInteger FundDayNum = 201;

///基金数据右侧显示的空白天数
static NSInteger FundDayNumEmpty = 0;

///基金净值标签显示宽度
static CGFloat NetWorthScaleWidth = 35.f;

///基金净值涨跌幅标签显示宽度
static CGFloat NetWorthRisePercentScaleWidth = 45.f;

///基金净值日期标签显示高度
static CGFloat NetWorthDateScaleHeight = 20.f;

///基金净值标签在横屏情况下与图形的间距
static CGFloat NetWorthScaleMargin = 3.f;

///基金净值涨跌幅标签在横屏情况下与图形的间距
static CGFloat NetWorthRisePercentScaleMargin = 3.f;

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

@implementation FundNetValueView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _isHorizontalMode = YES;
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
  _dataArray = [[DataArray alloc] init];
  _trendLinePointArray = [[NSMutableArray alloc] initWithCapacity:482];
  _percentMarkArray = [[NSMutableArray alloc] initWithCapacity:5];
  _priceMarkArray = [[NSMutableArray alloc] initWithCapacity:5];
  _dateLabelArray = [[NSMutableArray alloc] initWithCapacity:5];
  _dateMarkArray = [[NSMutableArray alloc] initWithCapacity:5];
}

- (CGFloat)trendStartX {
  return _isHorizontalMode ? NetWorthScaleWidth + NetWorthScaleMargin
                           : CommonMarginLeftRight;
}

- (CGFloat)priceStartX {
  return _isHorizontalMode ? 0 : CommonMarginLeftRight + NetWorthScaleMargin;
}

- (CGFloat)pricePercentStartX {
  return _isHorizontalMode
             ? HEIGHT_OF_SCREEN - 16 - NetWorthRisePercentScaleWidth
             : self.bounds.size.width - CommonMarginLeftRight -
                   NetWorthRisePercentScaleWidth -
                   NetWorthRisePercentScaleMargin;
}

- (CGFloat)trendSizeWidth {
  return _isHorizontalMode
             ? HEIGHT_OF_SCREEN - 16 - NetWorthScaleWidth -
                   NetWorthRisePercentScaleWidth - NetWorthScaleMargin -
                   NetWorthRisePercentScaleMargin
             : self.bounds.size.width - CommonMarginLeftRight * 2;
}

- (CGFloat)trendSizeHeight {
  return self.bounds.size.height - NetWorthDateScaleHeight -
         CommonMarginButtom - CommonMarginTop;
}

- (void)resetRectMembers {

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
  if (_dateLabelArray.count == 0) {
    for (NSInteger i = 0; i < 5; i++) {
      UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
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
      [_dateLabelArray addObject:label];
    }
  }

  //添加蓝色指标线
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
    [self addSubview:_crossDot];
    _crossDot.hidden = YES;
  }

  //创建 价格、时间、涨幅 游标
  if (_currentPriceLabel == nil) {
    for (NSInteger i = 0; i < 3; i++) {
      //价格
      UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 65, 15)];
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

  //创建所有标签
  //标签高度

  //间距
  CGFloat spaceHeight = (self.trendSizeHeight - CommonLabelHeight) / 4;
  [_priceLabelArray
      enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        label.frame = CGRectMake(self.priceStartX, idx * spaceHeight,
                                 NetWorthScaleWidth, CommonLabelHeight);
        label.textAlignment =
            _isHorizontalMode ? NSTextAlignmentRight : NSTextAlignmentLeft;
      }];
  //右侧5百分比标签
  [_percentLabelArray enumerateObjectsUsingBlock:^(UILabel *label,
                                                   NSUInteger idx, BOOL *stop) {
    label.frame = CGRectMake(self.pricePercentStartX, idx * spaceHeight,
                             NetWorthRisePercentScaleWidth, CommonLabelHeight);
    label.textAlignment =
        _isHorizontalMode ? NSTextAlignmentLeft : NSTextAlignmentRight;
  }];

  //中间时间5个标签，H30
  CGFloat timeLabelWidth = 60;
  CGFloat spaceWidth = (self.trendSizeWidth - timeLabelWidth * 5) / 4;

  [_dateLabelArray enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx,
                                                BOOL *stop) {
    label.frame =
        CGRectMake(self.trendStartX + idx * (spaceWidth + timeLabelWidth),
                   self.trendSizeHeight + 5, timeLabelWidth, CommonLabelHeight);
    if (idx == 0) {
      label.left += 2;
    } else if (idx == _dateLabelArray.count - 1) {
      label.left -= 2;
    }
  }];

  //添加红色指标线
  _verticalLineView.frame =
      CGRectMake(self.trendStartX, CommonMarginTop, 1, self.trendSizeHeight);
  _horicalLineView.frame = CGRectMake(0, 100, self.trendSizeWidth - 1, 1);

  //添加交叉点
  float crossDotWidth = _verticalLineView.width * 4;
  _crossDot.frame = CGRectMake(0, 0, crossDotWidth, crossDotWidth);
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
}

#pragma mark - 画边框
- (void)drawBorders {
  CGContextRef context = UIGraphicsGetCurrentContext();

  //趋势与量线边界
  CGRect tempTrendRect = CGRectMake(self.trendStartX, CommonMarginTop,
                                    self.trendSizeWidth, self.trendSizeHeight);

  //画k线和交易量两个区域边框
  [[Globle colorFromHexRGB:COLOR_KLINE_BORDER] set];
  CGContextSetLineWidth(context, 0.5f);
  CGContextAddRect(context, tempTrendRect);
  CGContextStrokePath(context);

  CGContextMoveToPoint(context, self.trendStartX,
                       CommonMarginTop + self.trendSizeHeight);
  CGContextAddLineToPoint(context, self.trendStartX,
                          CommonMarginTop + self.trendSizeHeight +
                              NetWorthDateScaleHeight);
  CGContextAddLineToPoint(context, self.trendStartX + self.trendSizeWidth,
                          CommonMarginTop + self.trendSizeHeight +
                              NetWorthDateScaleHeight);

  CGContextAddLineToPoint(context, self.trendStartX + self.trendSizeWidth,
                          CommonMarginTop + self.trendSizeHeight);
  CGContextStrokePath(context);

  //趋势区3条横线
  CGFloat spaceY = self.trendSizeHeight / 4;
  for (NSInteger i = 1; i <= 3; i++) {
    CGContextMoveToPoint(context, self.trendStartX - 0.5f, i * spaceY);
    CGContextAddLineToPoint(context, self.trendStartX - 1 + self.trendSizeWidth,
                            i * spaceY);
    CGContextStrokePath(context);
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
}

#pragma mark - 计算均线数据：平均价格，总分钟数，总交易量

#pragma mark - 解析数据成价格曲线点和均线曲线点
- (void)calPricesAndPercentsArray {
  //解析所有价格点和当时成交量
  NSInteger lastClosePrice = ((FundNav *)_dataArray.array[0]).fundUnitNav;

  //价格刻度
  int64_t maxPrice = ((FundNav *)_dataArray.array[0]).fundUnitNav;
  int64_t minPrice = maxPrice;

  //计算最高、最低价和最大交易量
  for (FundNav *element in _dataArray.array) {
    if (element.fundUnitNav > maxPrice) {
      maxPrice = element.fundUnitNav;
    }
    if (element.fundUnitNav < minPrice) {
      minPrice = element.fundUnitNav;
    }
  }

  [_dateMarkArray removeAllObjects];
  for (int i = 0; i < 5; i++) {
    if (i * 50 < _dataArray.array.count) {
      [_dateMarkArray addObject:((FundNav *)_dataArray.array[i * 50]).monthStr];
    }
  }

  //计算最大百分比刻度
  float maxPercent =
      ((maxPrice - lastClosePrice) > (lastClosePrice - minPrice))
          ? ((float)(maxPrice - lastClosePrice) * 100 / (float)lastClosePrice)
          : ((float)(lastClosePrice - minPrice) * 100 / (float)lastClosePrice);
  maxPercent = 1.1 * maxPercent; //放大10%，以留出上下的空白

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

  //计算点
  CGFloat trendYaddHeight = CommonMarginTop + self.trendSizeHeight;
  CGFloat startX, startY, endX, endY;
  CGFloat spaceWidth = self.spaceWidth;

  //蓝色粗线的坐标
  for (NSInteger i = 0; i < _dataArray.array.count - 1; i++) {
    FundNav *element = _dataArray.array[i];
    FundNav *elementNext = _dataArray.array[i + 1];

    NSInteger price = element.fundUnitNav;
    NSInteger priceNext = elementNext.fundUnitNav;

    startX = self.trendStartX + spaceWidth * i;
    //（当前价-最低价）/（最高价-最低价）即是所占百分比，数组坐标0最高价，4最低价
    startY = trendYaddHeight -
             self.trendSizeHeight *
                 (price - [_priceMarkArray[4] integerValue]) /
                 ([_priceMarkArray[0] integerValue] -
                  [_priceMarkArray[4] integerValue]);

    endX = self.trendStartX + spaceWidth * (i + 1);
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
    if ((i + 1) == _dataArray.array.count - 1) {
      [_trendLinePointArray
          addObject:[NSValue valueWithCGPoint:CGPointMake(endX, endY)]];
      [_trendLinePointArray
          addObject:[NSValue valueWithCGPoint:CGPointMake(endX, endY)]];
    }
  }
}

#pragma mark - 纵轴刻度及提示框
- (void)calScalesData {

  for (int i = 0; i < 5; i++) {
    //价格标签
    NSNumber *price = _priceMarkArray[i];
    NSString *text = [NSString
        stringWithFormat:@"%.3f", (float)[price integerValue] / 10000];

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

  [_dateLabelArray
      enumerateObjectsUsingBlock:^(UILabel *lbl, NSUInteger idx, BOOL *stop) {
        if (idx < _dateMarkArray.count) {
          lbl.text = _dateMarkArray[idx];
        } else {
          lbl.text = @"";
        }
      }];
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

#pragma mark 长按手势回调函数
- (void)longPressToDo:(UILongPressGestureRecognizer *)gesture {
  //用户按下
  if (gesture.state == UIGestureRecognizerStateBegan) {

    CGFloat spaceWidth = self.spaceWidth;

    if (_lastPositon.y < CommonMarginTop) {
      _lastPositon.y = CommonMarginTop;
    }

    //驻点判断
    _lastPositon = [gesture locationInView:self];

    for (NSInteger i = 0; i < FundDayNum; i++) {
      CGRect rect = CGRectMake(self.trendStartX + i * spaceWidth,
                               CommonMarginTop, spaceWidth, HEIGHT_OF_VIEW + 7);
      if (CGRectContainsPoint(rect, _lastPositon)) {
        NSInteger index = i;
        if (index >= _dataMinutes) {
          index = _dataMinutes - 1;

          //防止超当前界限
          if (_lastPositon.x > self.trendStartX + _dataMinutes * spaceWidth) {
            _lastPositon.x = self.trendStartX + _dataMinutes * spaceWidth;
          }
        }

        if (0 <= index && index < _dataMinutes) {
          //画红色指标线
          [self drawIndexLine:index];
        }
        return;
      }
    }

    //手指移动
  } else if (gesture.state == UIGestureRecognizerStateChanged) {

    NSInteger count = _dataArray.array.count;
    CGFloat spaceWidth = (self.trendSizeWidth / (CGFloat)count);
    _lastPositon = [gesture locationInView:self];

    if (_lastPositon.y < CommonMarginTop) {
      _lastPositon.y = CommonMarginTop;
    }
    if (_lastPositon.x >
        self.trendStartX + _dataArray.array.count * spaceWidth) {
      _lastPositon.x = self.trendStartX + _dataArray.array.count * spaceWidth;
    }

    [self touchBeganAndMoved:_lastPositon];

    //松手
  } else if (gesture.state == UIGestureRecognizerStateEnded) {
    if (_onFundNavSelected) {
      _onFundNavSelected(nil, -1, FundDayNum);
    }

    _verticalLineView.hidden = YES;
    _horicalLineView.hidden = YES;
    _crossDot.hidden = YES;
    _currentPriceLabel.hidden = YES;
    _currentTimeLabel.hidden = YES;
    _currentPercentLabel.hidden = YES;
  }
}

#pragma mark 手指移动
- (void)touchBeganAndMoved:(CGPoint)currentPoint {

  //宽度
  _dataMinutes = [_dataArray.array count];
  if (_dataMinutes == 0)
    return;
  if (_dataMinutes > FundDayNum)
    _dataMinutes = FundDayNum;

  CGFloat spaceWidth = self.spaceWidth;

  for (NSInteger i = 0; i < _dataMinutes; i++) {
    CGRect rect = CGRectMake(self.trendStartX + i * spaceWidth, CommonMarginTop,
                             spaceWidth + 0.5f, HEIGHT_OF_VIEW + 7);
    if (CGRectContainsPoint(rect, currentPoint)) {

      [self drawIndexLine:i];
      return;
    }
  }
}

- (CGFloat)spaceWidth {
  return self.trendSizeWidth / (FundDayNum + FundDayNumEmpty - 1);
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

#pragma mark - 设置红色指标线
- (void)drawIndexLine:(NSInteger)index {

  _verticalLineView.hidden = NO;
  _horicalLineView.hidden = NO;
  _crossDot.hidden = NO;
  _currentPriceLabel.hidden = NO;
  _currentTimeLabel.hidden = NO;
  _currentPercentLabel.hidden = NO;

  float currentWidth = self.spaceWidth * (float)index;

  //纵线重设中点
  _verticalLineView.center =
      CGPointMake(self.trendStartX + currentWidth,
                  (CommonMarginTop + self.trendSizeHeight) / 2.f);

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
    _crossDot.layer.cornerRadius = _crossDot.width / 2.0f;
  }

  //价格
  FundNav *itemInfo = _dataArray.array[index];
  if (_onFundNavSelected) {
    _onFundNavSelected(itemInfo, index, FundDayNum);
  }

  //价格游标
  _currentPriceLabel.text = itemInfo.fundUnitNavStr;
  [SimuUtil widthOfLabel:_currentPriceLabel font:Font_Height_11_0];
  _currentPriceLabel.center =
      CGPointMake(self.cursorPriceStartX + _currentPriceLabel.width / 2,
                  _horicalLineView.centerY);
  if (_currentPriceLabel.top < CommonMarginTop) {
    _currentPriceLabel.top = CommonMarginTop;
  } else if (_currentPriceLabel.top > CommonMarginTop + self.trendSizeHeight) {
    _currentPriceLabel.top = CommonMarginTop + self.trendSizeHeight;
  }
  if (_currentPriceLabel.width > NetWorthScaleWidth + NetWorthScaleMargin) {
    _currentPriceLabel.width = NetWorthScaleWidth + NetWorthScaleMargin;
    _currentPriceLabel.adjustsFontSizeToFitWidth = YES;
  }
  _currentPriceLabel.left = self.cursorPriceStartX;

  //时间游标
  _currentTimeLabel.text = itemInfo.dateStr;
  _currentTimeLabel.center = CGPointMake(
      _verticalLineView.centerX, CommonMarginTop + self.trendSizeHeight +
                                     _currentTimeLabel.height / 2 + 1);
  if (_currentTimeLabel.left < self.trendStartX) {
    _currentTimeLabel.left = self.trendStartX;
  } else if (_currentTimeLabel.right > self.trendStartX + self.trendSizeWidth) {
    _currentTimeLabel.right = self.trendStartX + self.trendSizeWidth;
  }

  NSInteger lastClosePrice = ((FundNav *)_dataArray.array[0]).fundUnitNav;

  float priceRise =
      (itemInfo.fundUnitNav - lastClosePrice) / ((CGFloat)lastClosePrice);
  NSString *currentRise =
      [NSString stringWithFormat:@"%.2f%%", priceRise * 100.f];

  //涨幅游标
  _currentPercentLabel.text = currentRise;
  [SimuUtil widthOfLabel:_currentPercentLabel font:Font_Height_11_0];
  _currentPercentLabel.center =
      CGPointMake(self.cursorPercentStartX + _currentPercentLabel.width / 2,
                  _horicalLineView.centerY);
  if (_currentPercentLabel.top < CommonMarginTop) {
    _currentPercentLabel.top = CommonMarginTop;
  } else if (_currentPercentLabel.top >
             CommonMarginTop + self.trendSizeHeight) {
    _currentPercentLabel.top = CommonMarginTop + self.trendSizeHeight;
  }
  if (_currentPercentLabel.width >
      NetWorthRisePercentScaleWidth + NetWorthRisePercentScaleMargin) {
    _currentPercentLabel.width =
        NetWorthRisePercentScaleWidth + NetWorthRisePercentScaleMargin;
    _currentPercentLabel.adjustsFontSizeToFitWidth = YES;
  }
  _currentPercentLabel.left = self.cursorPercentStartX;
}

#pragma mark - ⭐️重画k线和量线，两侧价格
- (void)bindFundNetWorthList:(FundNetWorthList *)list {
  //数据未下载完时就点击横屏
  if (list.fundInfoList.count == 0) {
    return;
  }

  _dataArray.dataBinded = YES;
  [_dataArray.array removeAllObjects];
  [_trendLinePointArray removeAllObjects];
  [_dataArray.array addObjectsFromArray:list.fundInfoList];

  //当前分钟数
  _dataMinutes = _dataArray.array.count;

  //切换股票后重置显示区域，并区分大盘、个股
  [self resetRectMembers];

  //重新计算所有数据
  [self calPricesAndPercentsArray];

  //重新计算所有刻度线
  [self calScalesData];
  //重新画图
  [self setNeedsDisplay];
}

- (void)clearData {
  [_dataArray reset];
  [_trendLinePointArray removeAllObjects];
  [self setNeedsDisplay];
}

@end
