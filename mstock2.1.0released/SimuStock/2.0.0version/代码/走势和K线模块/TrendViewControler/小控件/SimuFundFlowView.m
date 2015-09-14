//
//  simuFundFowView.m
//  SimuStock
//
//  Created by Mac on 14-8-13.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SimuFundFlowView.h"
#import "StockCapitalFlowsPie.h"

#define PI 3.14159265358979323846

@implementation SimuFundFlowView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 135, 21)];
    titleLabel.text = @"资金流向";
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:Font_Height_15_0];
    titleLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:titleLabel];

    // Initialization code
    self.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
    //昨日资金流动图形区域
    _yesRect = CGRectMake(0, 0, WIDTH_OF_SCREEN, 460 / 2);
    // 5日主力资金流向区域
    _5dayRect = CGRectMake(0, 534 / 2, WIDTH_OF_SCREEN, 465 / 2);
    //累计资金流向区域
    _totalRect = CGRectMake(0, _5dayRect.origin.y + _5dayRect.size.height, WIDTH_OF_SCREEN, 310 / 2);

    //昨日资金流动数据
    _yesFundArray = [[NSMutableArray alloc] init];
    // 5日资金流向数据
    _5DayFundArray = [[NSMutableArray alloc] init];
    // 5日资金流向的日期数据
    _5DayDateArray = [[NSMutableArray alloc] init];
    //累计资金流量数据
    _totalFundArray = [[NSMutableArray alloc] init];
    //累计资金流量
    _totalLabelArray = [[NSMutableArray alloc] init];

    //创建累计资金流向（最后的区域）
    [self creatTotolfundLabel];

    for (int i = 0; i < 5; i++) {
      if (i > 3) {
        [_5DayFundArray addObject:@0];
      } else {
        [_5DayFundArray addObject:@(i * 0)];
      }
      [_5DayDateArray addObject:[NSString stringWithFormat:@"08-0%d", i]];
    }
  }
  return self;
}

- (void)clearData {
  [_yesFundArray removeAllObjects];
  [_5DayFundArray removeAllObjects];
  [_5DayDateArray removeAllObjects];
  [_totalFundArray removeAllObjects];

  for (int i = 0; i < 5; i++) {
    if (i > 3) {
      [_5DayFundArray addObject:@0];
    } else {
      [_5DayFundArray addObject:@(i * 0)];
    }
    [_5DayDateArray addObject:[NSString stringWithFormat:@"00-0%d", i]];
  }
  [self setNeedsDisplay];
}

- (void)setPageData:(FundsFlowData *)pagedata {
  // return;
  if (pagedata == Nil)
    return;
  totalfund = 0;
  [_yesFundArray removeAllObjects];
  [_5DayFundArray removeAllObjects];
  [_5DayDateArray removeAllObjects];
  [_totalFundArray removeAllObjects];
  //得到昨日资金流向表格
  for (PacketTableData *obj in pagedata.dataArray) {
    if ([obj.tableName isEqualToString:@"YestodayMoneyFlow"]) {
      //昨日资金流向
      NSDictionary *dic = obj.tableItemDataArray[0];
      //主力资金净流入
      NSNumber *main_fundin = dic[@"mainForceFlowIn"];
      //散户资金净流入
      NSNumber *retailerflowIn = dic[@"retailerFlowIn"];
      //散户资金净流出
      NSNumber *retailerflowOut = dic[@"retailerFlowOut"];
      //主力资金净流出
      NSNumber *mainForceFlowOut = dic[@"mainForceFlowOut"];
      totalfund = [main_fundin longValue] + [retailerflowIn longValue] +
                  [retailerflowOut longValue] + [mainForceFlowOut longValue];

      if (main_fundin) {
        StockCapitalFlowsPie *pie = [[StockCapitalFlowsPie alloc] init];
        pie.color = [Globle colorFromHexRGB:@"#fe0000"];
        pie.title = @"主力流入";
        pie.funds = [main_fundin stringValue];
        pie.percentage = [main_fundin floatValue] / totalfund;
        [_yesFundArray addObject:pie];
      }
      if (retailerflowIn) {
        StockCapitalFlowsPie *pie = [[StockCapitalFlowsPie alloc] init];
        pie.color = [Globle colorFromHexRGB:@"#f36e14"];
        pie.title = @"散户流入";
        pie.funds = [retailerflowIn stringValue];
        pie.percentage = [retailerflowIn floatValue] / totalfund;
        [_yesFundArray addObject:pie];
      }
      if (retailerflowOut) {
        StockCapitalFlowsPie *pie = [[StockCapitalFlowsPie alloc] init];
        pie.color = [Globle colorFromHexRGB:@"#50bc15"];
        pie.title = @"散户流出";
        pie.funds = [retailerflowOut stringValue];
        pie.percentage = [retailerflowOut floatValue] / totalfund;
        [_yesFundArray addObject:pie];
      }
      if (mainForceFlowOut) {
        StockCapitalFlowsPie *pie = [[StockCapitalFlowsPie alloc] init];
        pie.color = [Globle colorFromHexRGB:@"#359301"];
        pie.title = @"主力流出";
        pie.funds = [mainForceFlowOut stringValue];
        pie.percentage = [mainForceFlowOut floatValue] / totalfund;
        [_yesFundArray addObject:pie];
      }
      if (_yesFundArray.count > 0) {
        NSInteger index = [self SelectTheSmallestValue:_yesFundArray];
        NSMutableArray *midArray = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < _yesFundArray.count; i++) {
          NSInteger j = (index + i) % _yesFundArray.count;
          StockCapitalFlowsPie *pie = _yesFundArray[j];
          if (pie) {
            [midArray addObject:pie];
          }
        }
        [_yesFundArray removeAllObjects];
        [_yesFundArray addObjectsFromArray:midArray];
      }
    } else if ([obj.tableName isEqualToString:@"RecentDaysTotalNetVals"]) {
      // 1,3,5,10日，总资金净额
      NSDictionary *dic = obj.tableItemDataArray[0];
      //一日总资金净额
      NSNumber *oneDayTotalNetVal = dic[@"oneDayTotalNetVal"];
      if (oneDayTotalNetVal) {
        [_totalFundArray addObject:oneDayTotalNetVal];
      }
      //三日总资金净额
      NSNumber *threeDaysTotalNetVal = dic[@"threeDaysTotalNetVal"];
      if (threeDaysTotalNetVal) {
        [_totalFundArray addObject:threeDaysTotalNetVal];
      }
      //无日总资金净额
      NSNumber *fiveDaysTotalNetVal = dic[@"fiveDaysTotalNetVal"];
      if (fiveDaysTotalNetVal) {
        [_totalFundArray addObject:fiveDaysTotalNetVal];
      }
      //一日总资金净额
      NSNumber *tenDaysTotalNetVal = dic[@"tenDaysTotalNetVal"];
      if (tenDaysTotalNetVal) {
        [_totalFundArray addObject:tenDaysTotalNetVal];
      }
    } else if ([obj.tableName isEqualToString:@"FiveDaysMFNetVals"]) {
      //五日逐日主力资金净流入

      if (obj.tableItemDataArray.count != 0) {
        for (NSDictionary *dic in obj.tableItemDataArray) {
          NSString *date = dic[@"date"];
          if (date) {
            [_5DayDateArray insertObject:date atIndex:0];
          }
          NSNumber *netVal = dic[@"netVal"];
          if (netVal) {
            [_5DayFundArray insertObject:netVal atIndex:0];
          }
        }
      } else { //数组为空时，也需要显示柱状图，所以需要加加入假数据
        _5DayDateArray = [NSMutableArray arrayWithArray:@[ @"--", @"--", @"--", @"--", @"--" ]];
        _5DayFundArray = [NSMutableArray arrayWithArray:@[ @0, @0, @0, @0, @0 ]];
      }
    }
  }
  [self setNeedsDisplay];
}

///判断哪个数据最小
- (NSInteger)SelectTheSmallestValue:(NSMutableArray *)array {
  for (NSInteger i = 0; i < array.count; i++) {
    StockCapitalFlowsPie *pie = array[i];
    BOOL issmall = [self ISsmallObject:pie];
    if (issmall) {
      NSInteger index1 = i > 0 ? i - 1 : array.count - 1;
      NSInteger index2 = (i == array.count - 1) ? 0 : i + 1;
      StockCapitalFlowsPie *pie1 = array[index1];
      StockCapitalFlowsPie *pie2 = array[index2];
      if (pie1.percentage < pie2.percentage) {
        return i;
      } else
        return i + 1;
    }
  }
  return 0;
}
- (BOOL)ISsmallObject:(StockCapitalFlowsPie *)pie {
  for (int j = 0; j < _yesFundArray.count; j++) {
    StockCapitalFlowsPie *pie2 = _yesFundArray[j];
    if (pie.percentage > pie2.percentage) {
      return NO;
    }
  }
  return YES;
}

#pragma mark
#pragma mark 画图函数
- (void)drawRect:(CGRect)rect {
  // Drawing code.
  CGContextRef context = UIGraphicsGetCurrentContext();
  //  if ([_yesfund count] == 0)
  //    return;
  [self drawYesterdayFoundFlow:context];
  [self drawFiveDaysFoundFlow:context];
  [self drawTotolFundFlow:context];
}

#pragma mark -画出昨日资金流向
- (void)drawYesterdayFoundFlow:(CGContextRef)context {
  //设定圆心
  CGPoint center = CGPointMake(self.width / 2, 120);
  if (totalfund == 0) {
    ///等于0时,  先画出顶部圆圈
    totalfund = 1;
    UIColor *aColor = [Globle colorFromHexRGB:@"#cccde7"];
    CGContextSetFillColorWithColor(context, aColor.CGColor);
    CGContextSetStrokeColorWithColor(context, [Globle colorFromHexRGB:@"#cccde7"].CGColor);
    //计算角度
    //填充颜色
    //以10为半径围绕圆心画指定角度扇形
    CGContextMoveToPoint(context, center.x, center.y);
    CGContextAddArc(context, center.x, center.y, 75, 0 * PI / 180.f, 360 * PI / 180.f, 0);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    //画出圆形图形
  } else {
    int i = 0;
    CGFloat startAngle = 90.0;

    for (int j = 0; j < [_yesFundArray count]; j++) {
      StockCapitalFlowsPie *pie = _yesFundArray[j];
#pragma mark 关键参数
      CGFloat endAngle = startAngle + 360 * pie.percentage;
      CGContextSetFillColorWithColor(context, pie.color.CGColor);
      CGContextSetStrokeColorWithColor(context, [Globle colorFromHexRGB:Color_BG_Common].CGColor);
      //计算角度
      //填充颜色
      //以75为半径围绕圆心画指定角度扇形
      CGContextMoveToPoint(context, center.x, center.y);
      CGContextAddArc(context, center.x, center.y, 75, startAngle * PI / 180, endAngle * PI / 180, 0);
      CGContextClosePath(context);
      CGContextDrawPath(context, kCGPathFillStroke);
      //绘制路径
      //写出昨日资金流向文字
      if (startAngle != endAngle) {
        ///扇形的中心的角度
        CGFloat centerAngle = startAngle + 360 * pie.percentage / 2;
        CGFloat m_x = 90 * cos(centerAngle * PI / 180) + center.x;
        CGFloat m_y = 90 * sin(centerAngle * PI / 180) + center.y;

        /// YL, 修改原先，扇形面积太小时，文字重叠问题
        CGFloat YL_x = 75 * cos(centerAngle * PI / 180) + center.x;
        CGFloat YL_y = 75 * sin(centerAngle * PI / 180) + center.y;

        if (lastcenterAngle != 0 && centerAngle - lastcenterAngle < 60) {
          if (centerAngle > 90 && centerAngle < 180) {
            m_y -= 15 * ((60 - (centerAngle - lastcenterAngle)) / 60.0);
            CGFloat yl_x = m_x - ((60 - (centerAngle - lastcenterAngle)) / 60.0) * 50;
            if (YL_x > 60) {
              m_x = yl_x;
            } else
              m_x = 60;
          } else {
            m_y += 18;
          }
        }

        lastcenterAngle = centerAngle;

        //画线
        CGContextSetLineWidth(context, 1.0); //线宽
        CGContextSetAllowsAntialiasing(context, YES);
        CGContextSetStrokeColorWithColor(context, pie.color.CGColor);
        CGContextSetFillColorWithColor(context, pie.color.CGColor);
        CGContextBeginPath(context);
        //起点坐标
        CGContextMoveToPoint(context, YL_x, YL_y);
        //终点坐标
        CGContextAddLineToPoint(context, m_x, m_y);
        CGFloat m_titelx = m_x;
        CGFloat m_linex;
        if (m_x < center.x) {
          m_titelx = m_x - 43;
          m_linex = m_x - 48;
        } else {
          m_linex = m_x + 48;
        }

        CGContextMoveToPoint(context, m_x, m_y);
        CGContextAddLineToPoint(context, m_linex, m_y);
        CGContextClosePath(context);
        CGContextStrokePath(context);
        //添加圆圈
        [[Globle colorFromHexRGB:Color_White] setFill];
        CGContextAddArc(context, m_linex, m_y, 3.5f, 0, 2 * M_PI, 0);
        CGContextDrawPath(context, kCGPathFillStroke);

        //百分比
        CGContextSetFillColorWithColor(context, pie.color.CGColor);

        NSString *temp_str = [NSString stringWithFormat:@"%.2f", pie.percentage * 100];
        temp_str = [temp_str stringByAppendingString:@"%"];
        [temp_str drawInRect:CGRectMake(m_titelx + 3, m_y - 14, 50, 14)
                    withFont:[UIFont boldSystemFontOfSize:11]];
        CGContextSetStrokeColorWithColor(context, [Globle colorFromHexRGB:Color_Gray].CGColor);
        CGContextSetFillColorWithColor(context, [Globle colorFromHexRGB:Color_Gray].CGColor);
        [pie.title drawInRect:CGRectMake(m_titelx + 3, m_y, 50, 15)
                     withFont:[UIFont boldSystemFontOfSize:10]];
      }
      startAngle = endAngle;
      i++;
    }
  }
  lastcenterAngle = 0;
  //画出圆形图形
  UIColor *aColor = [Globle colorFromHexRGB:Color_BG_Common];
  CGContextSetFillColorWithColor(context, aColor.CGColor);
  CGContextSetStrokeColorWithColor(context, [Globle colorFromHexRGB:Color_BG_Common].CGColor);
  //计算角度
  //填充颜色
  //中心白色圆形
  CGContextMoveToPoint(context, center.x, center.y);
  CGContextAddArc(context, center.x, center.y, 35.5, 0 * PI / 180, 360 * PI / 180, 0);
  CGContextClosePath(context);
  CGContextDrawPath(context, kCGPathFillStroke);
  //绘制路径

  //写 昨日资金 标题
  UIColor *aColor_title = [Globle colorFromHexRGB:Color_Blue_but];
  CGContextSetFillColorWithColor(context, aColor_title.CGColor);
  CGContextSetStrokeColorWithColor(context, aColor_title.CGColor);
  NSString *title_top = @"昨日";
  NSString *title_woen = @"资金";
  [title_top drawInRect:CGRectMake(center.x - 13, center.y - 15, 75, 15)
               withFont:[UIFont boldSystemFontOfSize:15]];
  [title_woen drawInRect:CGRectMake(center.x - 13, center.y, 75, 15)
                withFont:[UIFont boldSystemFontOfSize:15]];

  //画出表格之间的分割线
  UIColor *aColor_line = [Globle colorFromHexRGB:Color_Cell_Line];
  CGContextSetLineWidth(context, 1); //线宽
  CGContextSetAllowsAntialiasing(context, YES);
  CGContextSetStrokeColorWithColor(context, aColor_line.CGColor);
  CGContextSetFillColorWithColor(context, aColor_line.CGColor);
  CGContextBeginPath(context);
  //起点坐标
  CGContextMoveToPoint(context, _yesRect.origin.x + 5, _yesRect.origin.y + _yesRect.size.height + 15 - 2);
  //终点坐标
  CGContextAddLineToPoint(context, _yesRect.origin.x + _yesRect.size.width - 10,
                          _yesRect.origin.y + _yesRect.size.height + 15 - 2);
  CGContextClosePath(context);
  CGContextStrokePath(context);
  
  //画出下面的分割线
  aColor_line = [Globle colorFromHexRGB:Color_White];
  CGContextSetLineWidth(context, 1); //线宽
  CGContextSetAllowsAntialiasing(context, YES);
  CGContextSetStrokeColorWithColor(context, aColor_line.CGColor);
  CGContextSetFillColorWithColor(context, aColor_line.CGColor);
  CGContextBeginPath(context);
  //起点坐标
  CGContextMoveToPoint(context, _yesRect.origin.x + 5, _yesRect.origin.y + _yesRect.size.height + 15 - 1);
  //终点坐标
  CGContextAddLineToPoint(context, _yesRect.origin.x + _yesRect.size.width - 10,
                          _yesRect.origin.y + _yesRect.size.height + 15 - 1);
  CGContextClosePath(context);
  CGContextStrokePath(context);
}

//画出近五日主力资金流向
- (void)drawFiveDaysFoundFlow:(CGContextRef)context {
  //写标题 近五日资金流量
  CGPoint center = CGPointMake((self.width - 155) / 2, _5dayRect.origin.y + 14);
  UIColor *aColor_title = [Globle colorFromHexRGB:Color_Blue_but];
  CGContextSetFillColorWithColor(context, aColor_title.CGColor);
  CGContextSetStrokeColorWithColor(context, aColor_title.CGColor);
  NSString *title_top = @"近5日主力资金净流向";
  [title_top drawInRect:CGRectMake(center.x, center.y - 10, 155, 17)
               withFont:[UIFont boldSystemFontOfSize:Font_Height_16_0]];

  //画出中间标准线
  UIColor *aColor_line = [Globle colorFromHexRGB:COLOR_KLINE_BORDER];
  CGContextSetLineWidth(context, 1.0); //线宽
  CGContextSetAllowsAntialiasing(context, YES);
  CGContextSetStrokeColorWithColor(context, aColor_line.CGColor);
  CGContextSetFillColorWithColor(context, aColor_line.CGColor);
  CGContextBeginPath(context);
  //起点坐标
  CGContextMoveToPoint(context, 13, _5dayRect.origin.y + 112);
  //终点坐标
  CGContextAddLineToPoint(context, self.width - 13, _5dayRect.origin.y + 112);
  CGContextClosePath(context);
  CGContextStrokePath(context);

  //画出5日资金流向矩形
  long max_fund = 0;
  long min_fund = 0;
  int i = 0;
  for (NSNumber *obj in _5DayFundArray) {
    if (i == 0) {
      max_fund = [obj longValue];
      min_fund = [obj longValue];
    }
    if (max_fund < [obj longValue])
      max_fund = [obj longValue];
    if (min_fund > [obj longValue])
      min_fund = [obj longValue];
    i++;
  }

  if (max_fund < 0)
    max_fund = -max_fund;
  if (min_fund < 0)
    min_fund = -min_fund;
  if (max_fund < min_fund)
    max_fund = min_fund;
  i = 0;
  CGFloat left = self.width / 11.f;
  CGFloat width = self.width / 11.f;
  CGFloat space = self.width / 11.f;
  CGFloat totol_height = 125;

  for (NSNumber *obj in _5DayFundArray) {
    //画出背景矩形
    UIColor *back_Color = [Globle colorFromHexRGB:@"#ebedef"];
    CGContextSetFillColorWithColor(context, back_Color.CGColor);
    CGContextSetStrokeColorWithColor(context, back_Color.CGColor);
    CGFloat height2 = totol_height;
    CGRect rect2 =
        CGRectMake(left + i * (width + space), _5dayRect.origin.y + 112 - height2 / 2, width, height2);
    CGContextAddRect(context, rect2);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径

    //画出资金流向矩形
    long cor_fund = [obj longValue];
    CGFloat percent;
    if (max_fund == 0) {
      percent = 0;
    } else {
      percent = ((double)cor_fund) / ((double)2 * max_fund);
    }
    UIColor *aColor = [Globle colorFromHexRGB:@"#359301"];
    if (cor_fund > 0) {
      aColor = [Globle colorFromHexRGB:@"#fe0000"];
    } else if (cor_fund == 0) {
      aColor = [Globle colorFromHexRGB:Color_Text_Common]; //如果为0则为默认文字颜色
    }
    CGContextSetFillColorWithColor(context, aColor.CGColor);
    CGContextSetStrokeColorWithColor(context, aColor.CGColor);
    //计算角度
    //填充颜色
    CGContextMoveToPoint(context, center.x, center.y);
    CGFloat height = percent * totol_height;
    CGRect rect;
    if (cor_fund == 0) { //资金为0时不绘画
      rect = CGRectMake(left + i * (width + space), _5dayRect.origin.y + 112 - height, 0, 0);
    } else {
      rect = CGRectMake(left + i * (width + space), _5dayRect.origin.y + 112 - height, width, height);
    }

    CGContextAddRect(context, rect);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径
    //写出资金流量文字
    NSString *amount_money = [NSString stringWithFormat:@"%ld", cor_fund];
    NSString *str_fundLow = amount_money;
    if (cor_fund >= 0) {

      [str_fundLow drawInRect:CGRectMake(rect.origin.x, _5dayRect.origin.y + 112 + 3, 180, 13)
                     withFont:[UIFont boldSystemFontOfSize:Font_Height_12_0]];
    } else {
      [str_fundLow drawInRect:CGRectMake(rect.origin.x, _5dayRect.origin.y + 112 - 13 - 3, 180, 13)
                     withFont:[UIFont boldSystemFontOfSize:Font_Height_12_0]];
    }

    //写日期
    if (i < [_5DayDateArray count]) {
      UIColor *aColor = [Globle colorFromHexRGB:Color_Gray];
      CGContextSetFillColorWithColor(context, aColor.CGColor);
      CGContextSetStrokeColorWithColor(context, aColor.CGColor);
      NSString *date = _5DayDateArray[i];
      [date drawInRect:CGRectMake(rect.origin.x, _5dayRect.origin.y + _5dayRect.size.height - 22 - 3 - 14, 180, 13)
              withFont:[UIFont boldSystemFontOfSize:Font_Height_12_0]];
    }
    i++;
  }

  //写小标题 资金累计净流入
  NSArray *array = @[ @"资金净流入", @"资金净流出" ];
  NSArray *array_cor = @[ @"#fe0000", @"#359301" ];
  for (int i = 0; i < 2; i++) {
    //写文字
    CGPoint center = CGPointMake(20, _5dayRect.origin.y + _5dayRect.size.height - 14);
    UIColor *aColor_title = [Globle colorFromHexRGB:array_cor[i]];
    CGContextSetFillColorWithColor(context, aColor_title.CGColor);
    CGContextSetStrokeColorWithColor(context, aColor_title.CGColor);
    NSString *title_top = array[i];
    [title_top drawInRect:CGRectMake(center.x + i * 85, center.y, 100, 13)
                 withFont:[UIFont boldSystemFontOfSize:Font_Height_12_0]];
    //画圆
    CGContextAddArc(context, center.x - 6 + i * 85, center.y + 7, 5, 0 * PI / 180, 360 * PI / 180, 0);

    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
  }
  //写单位万元标题
  center = CGPointMake(17, _5dayRect.origin.y + _5dayRect.size.height - 14);
  aColor_title = [Globle colorFromHexRGB:Color_Text_Common];
  CGContextSetFillColorWithColor(context, aColor_title.CGColor);
  CGContextSetStrokeColorWithColor(context, aColor_title.CGColor);
  NSString *title = @"单位：万元";
  [title drawInRect:CGRectMake(self.width - 70, center.y, 100, 13)
           withFont:[UIFont boldSystemFontOfSize:Font_Height_12_0]];
  //画出表格之间的分割线
  aColor_line = [Globle colorFromHexRGB:Color_Cell_Line];
  CGContextSetLineWidth(context, 1); //线宽
  CGContextSetAllowsAntialiasing(context, YES);
  CGContextSetStrokeColorWithColor(context, aColor_line.CGColor);
  CGContextSetFillColorWithColor(context, aColor_line.CGColor);
  CGContextBeginPath(context);
  //起点坐标
  CGContextMoveToPoint(context, _5dayRect.origin.x + 5, _5dayRect.origin.y + _5dayRect.size.height + 2);
  //终点坐标
  CGContextAddLineToPoint(context, _5dayRect.origin.x + _5dayRect.size.width - 10,
                          _5dayRect.origin.y + _5dayRect.size.height + 2);
  CGContextClosePath(context);
  CGContextStrokePath(context);

  //画出下分割线
  aColor_line = [Globle colorFromHexRGB:Color_White];
  CGContextSetLineWidth(context, 1); //线宽
  CGContextSetAllowsAntialiasing(context, YES);
  CGContextSetStrokeColorWithColor(context, aColor_line.CGColor);
  CGContextSetFillColorWithColor(context, aColor_line.CGColor);
  CGContextBeginPath(context);
  //起点坐标
  CGContextMoveToPoint(context, _5dayRect.origin.x + 5, _5dayRect.origin.y + _5dayRect.size.height + 3);
  //终点坐标
  CGContextAddLineToPoint(context, _5dayRect.origin.x + _5dayRect.size.width - 10,
                          _5dayRect.origin.y + _5dayRect.size.height + 3);
  CGContextClosePath(context);
  CGContextStrokePath(context);
}

//画出资金近期累计流向
- (void)drawTotolFundFlow:(CGContextRef)context {
  //写标题 资金近期累计流向
  CGPoint center = CGPointMake((self.width - 144) / 2, _totalRect.origin.y + 14);
  UIColor *aColor_title = [Globle colorFromHexRGB:Color_Blue_but];
  CGContextSetFillColorWithColor(context, aColor_title.CGColor);
  CGContextSetStrokeColorWithColor(context, aColor_title.CGColor);
  NSString *title = @"资金近期累计净流向";
  [title drawInRect:CGRectMake(center.x, center.y, 144, 17)
           withFont:[UIFont boldSystemFontOfSize:Font_Height_16_0]];

  //画出纵向分割线
  UIColor *aColor_line = [Globle colorFromHexRGB:COLOR_KLINE_BORDER];
  CGContextSetLineWidth(context, 1.0); //线宽
  CGContextSetAllowsAntialiasing(context, YES);
  CGContextSetStrokeColorWithColor(context, aColor_line.CGColor);
  CGContextSetFillColorWithColor(context, aColor_line.CGColor);
  CGContextBeginPath(context);
  //起点坐标
  CGContextMoveToPoint(context, _totalRect.origin.x + _totalRect.size.width / 2, _totalRect.origin.y + 53);
  //终点坐标
  CGContextAddLineToPoint(context, _totalRect.origin.x + _totalRect.size.width / 2,
                          _totalRect.origin.y + _totalRect.size.height - 13);
  CGContextClosePath(context);
  CGContextStrokePath(context);

  //写出资金净流向文字
  NSArray *fund_dayArray = @[ @"1日", @"3日", @"5日", @"10日" ];
  CGRect day_rect = CGRectMake(self.width / 4 - 8, _totalRect.origin.y + 53, 35, 16);
  int i = 0;
  for (NSNumber *number in _totalFundArray) {
    long cor_fund = [number longValue];
    //写出资金流量文字
    NSString *amount_money = [NSString stringWithFormat:@"%ld万元", cor_fund];
    ;
    //设定资金净流入
    if (_totalLabelArray && [_totalLabelArray count] > i) {
      if (cor_fund >= 0) {
        UILabel *label = _totalLabelArray[i];
        label.textColor = [Globle colorFromHexRGB:@"#fe0000"];
        label.text = amount_money;
      } else {
        UILabel *label = _totalLabelArray[i];
        label.textColor = [Globle colorFromHexRGB:@"#359301"];
        label.text = amount_money;
      }
    }
    UIColor *aColor_line = [Globle colorFromHexRGB:Color_Gray];
    CGContextSetStrokeColorWithColor(context, aColor_line.CGColor);
    CGContextSetFillColorWithColor(context, aColor_line.CGColor);
    CGRect rect;
    if (i == 0) {
      rect = CGRectOffset(day_rect, 0, 0);
    } else if (i == 1) {
      rect = CGRectOffset(day_rect, _totalRect.size.width / 2, 0);
    } else if (i == 2) {
      rect = CGRectOffset(day_rect, 0, 48);
    } else {
      rect = CGRectOffset(day_rect, _totalRect.size.width / 2, 48);
    }
    NSString *daydate = fund_dayArray[i];
    [daydate drawInRect:rect withFont:[UIFont boldSystemFontOfSize:Font_Height_16_0]];
    i++;
  }
}

- (void)creatTotolfundLabel {
  for (int i = 0; i < 4; i++) {
    CGRect rect = CGRectZero;
    if (i == 0) {
      rect = CGRectMake(_totalRect.origin.x, _totalRect.origin.y + 75, _totalRect.size.width / 2, 22);
    } else if (i == 1) {
      rect = CGRectMake(_totalRect.origin.x + _totalRect.size.width / 2, _totalRect.origin.y + 75,
                        _totalRect.size.width / 2, 22);
    } else if (i == 2) {
      rect = CGRectMake(_totalRect.origin.x, _totalRect.origin.y + 125, _totalRect.size.width / 2, 22);
    } else if (i == 3) {
      rect = CGRectMake(_totalRect.origin.x + _totalRect.size.width / 2, _totalRect.origin.y + 125,
                        _totalRect.size.width / 2, 22);
    }
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:Font_Height_21_0];
    [_totalLabelArray addObject:label];
    [self addSubview:label];
  }
}

@end
