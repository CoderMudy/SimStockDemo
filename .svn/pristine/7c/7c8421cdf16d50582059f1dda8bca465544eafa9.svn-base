//
//  simuFundFowView.m
//  SimuStock
//
//  Created by Mac on 14-8-13.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "simuFundFowView.h"

#define PI 3.14159265358979323846

@implementation simuFundFowView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    self.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
    //昨日资金流动图形区域
    sffv_yesrect = CGRectMake(0, 0, self.bounds.size.width, 460 / 2);
    // 5日主力资金流向区域
    sffv_5dayrect = CGRectMake(0, 534 / 2, self.bounds.size.width, 465 / 2);
    //累计资金流向区域
    sffv_totolrect =
        CGRectMake(0, sffv_5dayrect.origin.y + sffv_5dayrect.size.height,
                   self.bounds.size.width, 310 / 2);

    //昨日资金流动数据
    sffv_yesfund = [[NSMutableArray alloc] init];
    // 5日资金流向数据
    sffv_5dayfund = [[NSMutableArray alloc] init];
    // 5日资金流向的日期数据
    sffv_fdaydate = [[NSMutableArray alloc] init];
    //累计资金流量数据
    sffv_totolfund = [[NSMutableArray alloc] init];
    //累计资金流量
    sffv_totollable = [[NSMutableArray alloc] init];

    //创建累计资金流向（最后的区域）
    [self creatTotolfundLable];

    for (int i = 0; i < 4; i++) {
      NSNumber *temp = @0;
      if (i == 1)
        temp = @0;
      [sffv_yesfund addObject:temp];
      [sffv_totolfund addObject:temp];
    }

    for (int i = 0; i < 5; i++) {
      if (i > 3)
        [sffv_5dayfund addObject:@0];
      else
        [sffv_5dayfund addObject:@(i * 0)];
      [sffv_fdaydate addObject:[NSString stringWithFormat:@"08-0%d", i]];
    }
  }
  return self;
}

- (void)clearData {
  [sffv_yesfund removeAllObjects];
  [sffv_5dayfund removeAllObjects];
  [sffv_fdaydate removeAllObjects];
  [sffv_totolfund removeAllObjects];
  for (int i = 0; i < 4; i++) {
    NSNumber *temp = @0;
    if (i == 1)
      temp = @0;
    [sffv_yesfund addObject:temp];
    [sffv_totolfund addObject:temp];
  }
  for (int i = 0; i < 5; i++) {
    if (i > 3)
      [sffv_5dayfund addObject:@0];
    else
      [sffv_5dayfund addObject:@(i * 0)];
    [sffv_fdaydate addObject:[NSString stringWithFormat:@"00-0%d", i]];
  }
  [self setNeedsDisplay];
}

- (void)setPageData:(FundsFlowData *)pagedata {
  // return;
  if (pagedata == Nil)
    return;
  [sffv_yesfund removeAllObjects];
  [sffv_5dayfund removeAllObjects];
  [sffv_fdaydate removeAllObjects];
  [sffv_totolfund removeAllObjects];
  //得到昨日资金流向表格
  for (PacketTableData *obj in pagedata.DataArray) {
    if ([obj.tableName isEqualToString:@"YestodayMoneyFlow"] == YES) {
      //昨日资金流向
      NSDictionary *dic = obj.tableItemDataArray[0];
      //主力资金净流入
      NSNumber *main_fundin = dic[@"mainForceFlowIn"];
      if (main_fundin) {
        [sffv_yesfund addObject:main_fundin];
      }
      //散户资金净流入
      NSNumber *retailerflowIn = dic[@"retailerFlowIn"];
      if (retailerflowIn) {
        [sffv_yesfund addObject:retailerflowIn];
      }
      //散户资金净流出
      NSNumber *retailerflowOut = dic[@"retailerFlowOut"];
      if (retailerflowOut) {
        [sffv_yesfund addObject:retailerflowOut];
      }
      //主力资金净流出
      NSNumber *mainForceFlowOut = dic[@"mainForceFlowOut"];
      if (mainForceFlowOut) {
        [sffv_yesfund addObject:mainForceFlowOut];
      }
    } else if ([obj.tableName isEqualToString:@"RecentDaysTotalNetVals"] ==
               YES) {
      // 1,3,5,10日，总资金净额
      NSDictionary *dic = obj.tableItemDataArray[0];
      //一日总资金净额
      NSNumber *oneDayTotalNetVal = dic[@"oneDayTotalNetVal"];
      if (oneDayTotalNetVal) {
        [sffv_totolfund addObject:oneDayTotalNetVal];
      }
      //三日总资金净额
      NSNumber *threeDaysTotalNetVal =
          dic[@"threeDaysTotalNetVal"];
      if (threeDaysTotalNetVal) {
        [sffv_totolfund addObject:threeDaysTotalNetVal];
      }
      //无日总资金净额
      NSNumber *fiveDaysTotalNetVal = dic[@"fiveDaysTotalNetVal"];
      if (fiveDaysTotalNetVal) {
        [sffv_totolfund addObject:fiveDaysTotalNetVal];
      }
      //一日总资金净额
      NSNumber *tenDaysTotalNetVal = dic[@"tenDaysTotalNetVal"];
      if (tenDaysTotalNetVal) {
        [sffv_totolfund addObject:tenDaysTotalNetVal];
      }
    } else if ([obj.tableName isEqualToString:@"FiveDaysMFNetVals"] == YES) {
      //五日逐日主力资金净流入

      if (obj.tableItemDataArray.count != 0) {
        for (NSDictionary *dic in obj.tableItemDataArray) {
          NSString *date = dic[@"date"];
          if (date) {
            [sffv_fdaydate insertObject:date atIndex:0];
          }
          NSNumber *netVal = dic[@"netVal"];
          if (netVal) {
            [sffv_5dayfund insertObject:netVal atIndex:0];
          }
        }
      } else { //数组为空时，也需要显示柱状图，所以需要加加入假数据
        sffv_fdaydate = [NSMutableArray
            arrayWithArray:@[ @"--", @"--", @"--", @"--", @"--" ]];
        sffv_5dayfund = [NSMutableArray arrayWithArray:@[ @0, @0, @0, @0, @0 ]];
      }
    }
  }
  [self setNeedsDisplay];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark
#pragma mark 画图函数
- (void)drawRect:(CGRect)rect {
  // Drawing code.
  CGContextRef context = UIGraphicsGetCurrentContext();
  //  if ([sffv_yesfund count] == 0)
  //    return;
  [self drawyestodayfoundLow:context];
  [self drawfiveDaysfoundLow:context];
  [self drawtotolfundLow:context];
}

#pragma mark -画出昨日资金流向
- (void)drawyestodayfoundLow:(CGContextRef)context {
  //画出扇形图形
  NSArray *colors =
      @[ @"#fe0000", @"#f36e14", @"#50bc15", @"#359301" ]; //橙，红，深绿，浅绿
  NSArray *title_array =
      @[ @"主力流入", @"散户流入", @"散户流出", @"主力流出" ];

  //设定圆心
  CGPoint center = CGPointMake(self.bounds.size.width / 2, 120);
  long totolfund = 0;

  for (NSNumber *obj in sffv_yesfund) {
    totolfund += [obj longValue];
  }

  if (totolfund == 0) {
    totolfund = 1;
    UIColor *aColor = [Globle colorFromHexRGB:@"#cccde7"];
    CGContextSetFillColorWithColor(context, aColor.CGColor);
    CGContextSetStrokeColorWithColor(
        context, [Globle colorFromHexRGB:@"#cccde7"].CGColor);
    //计算角度
    //填充颜色
    //以10为半径围绕圆心画指定角度扇形
    CGContextMoveToPoint(context, center.x, center.y);
    CGContextAddArc(context, center.x, center.y, 75, 0 * PI / 180,
                    360 * PI / 180, 0);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    //画出圆形图形
  } else {
    int i = 0;
    float startAngle = 180.0;

    for (int j=0;j<[sffv_yesfund count];j++) {
      
      NSNumber * obj=(NSNumber *) sffv_yesfund[i];
      
      long cor_fund = [obj longValue];

      float percent = ((double)cor_fund) / ((double)totolfund);
#pragma mark 关键参数
      float endAngle = startAngle + 360 * percent;

      UIColor *aColor = [Globle colorFromHexRGB:colors[i]];
      CGContextSetFillColorWithColor(context, aColor.CGColor);
      CGContextSetStrokeColorWithColor(
          context, [Globle colorFromHexRGB:Color_BG_Common].CGColor);
      //计算角度
      //填充颜色
      //以75为半径围绕圆心画指定角度扇形
      CGContextMoveToPoint(context, center.x, center.y);
      CGContextAddArc(context, center.x, center.y, 75, startAngle * PI / 180,
                      endAngle * PI / 180, 0);
      CGContextClosePath(context);
      CGContextDrawPath(context, kCGPathFillStroke);
      //绘制路径
      //写出昨日资金流向文字
      if (startAngle != endAngle) {
        float m_x =
            90 * cosf((startAngle + 360 * percent / 2) * PI / 180) + center.x;
        float m_y =
            90 * sinf((startAngle + 360 * percent / 2) * PI / 180) + center.y;

        ///YL, 修改原先，扇形面积太小时，文字重叠问题
        float YL_x=75 * cosf((startAngle + 360 * percent / 2) * PI / 180) + center.x;
        float YL_y=75 * sinf((startAngle + 360 * percent / 2) * PI / 180) + center.y;
        
        if (m_y-YL_y>0 && m_y-YL_y<15)
        {
          m_y+=15;
        }
        else if (m_y-YL_y<0 && m_y-YL_y>(-15))
        {
          m_y-=15;
        }
        
        //画线
        CGContextSetLineWidth(context, 1.0); //线宽
        CGContextSetAllowsAntialiasing(context, YES);
        CGContextSetStrokeColorWithColor(context, aColor.CGColor);
        CGContextSetFillColorWithColor(context, aColor.CGColor);
        CGContextBeginPath(context);
        //起点坐标
        CGContextMoveToPoint(context, YL_x, YL_y);
        //终点坐标
        CGContextAddLineToPoint(context, m_x, m_y);
        float m_titelx = m_x;
        float m_linex = m_x;
        if (m_x < center.x) {
          m_titelx = m_x - 60;
          m_linex = m_x - 60;
        } else {
          m_linex = m_x + 60;
        }
        
        CGContextMoveToPoint(context, m_x, m_y);
        CGContextAddLineToPoint(context, m_linex, m_y);
        CGContextClosePath(context);
        CGContextStrokePath(context);
        NSString *temp_str = [NSString stringWithFormat:@"%.2f", percent * 100];
        temp_str = [temp_str stringByAppendingString:@"%"];
        [temp_str drawInRect:CGRectMake(m_titelx, m_y - 19, 100, 18)
                    withFont:[UIFont boldSystemFontOfSize:17.5]];
        CGContextSetStrokeColorWithColor(
            context, [Globle colorFromHexRGB:Color_Gray].CGColor);
        CGContextSetFillColorWithColor(
            context, [Globle colorFromHexRGB:Color_Gray].CGColor);
        NSString *name_title = title_array[i];
        [name_title drawInRect:CGRectMake(m_titelx, m_y, 100, 15)
                      withFont:[UIFont boldSystemFontOfSize:14]];
      }
      startAngle = endAngle;
      i++;
    }
  }

  //画出圆形图形
  UIColor *aColor = [Globle colorFromHexRGB:Color_BG_Common];
  CGContextSetFillColorWithColor(context, aColor.CGColor);
  CGContextSetStrokeColorWithColor(
      context, [Globle colorFromHexRGB:Color_BG_Common].CGColor);
  //计算角度
  //填充颜色
  //中心白色圆形
  CGContextMoveToPoint(context, center.x, center.y);
  CGContextAddArc(context, center.x, center.y, 35.5, 0 * PI / 180,
                  360 * PI / 180, 0);
  CGContextClosePath(context);
  CGContextDrawPath(context, kCGPathFillStroke);
  //绘制路径

  //写 昨日资金 标题
  UIColor *aColor_title = [Globle colorFromHexRGB:@"#086dae"];
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
  CGContextMoveToPoint(context, sffv_yesrect.origin.x + 5,
                       sffv_yesrect.origin.y + sffv_yesrect.size.height+15 - 2);
  //终点坐标
  CGContextAddLineToPoint(context,
                          sffv_yesrect.origin.x + sffv_yesrect.size.width - 10,
                          sffv_yesrect.origin.y + sffv_yesrect.size.height+15 - 2);
  CGContextStrokePath(context);
  //画出下面的分割线
  aColor_line = [Globle colorFromHexRGB:Color_White];
  CGContextSetLineWidth(context, 1); //线宽
  CGContextSetAllowsAntialiasing(context, YES);
  CGContextSetStrokeColorWithColor(context, aColor_line.CGColor);
  CGContextSetFillColorWithColor(context, aColor_line.CGColor);
  CGContextBeginPath(context);
  //起点坐标
  CGContextMoveToPoint(context, sffv_yesrect.origin.x + 5,
                       sffv_yesrect.origin.y + sffv_yesrect.size.height+15 - 1);
  //终点坐标
  CGContextAddLineToPoint(context,
                          sffv_yesrect.origin.x + sffv_yesrect.size.width - 10,
                          sffv_yesrect.origin.y + sffv_yesrect.size.height+15 - 1);
  CGContextStrokePath(context);
}
//画出近五日主力资金流向
- (void)drawfiveDaysfoundLow:(CGContextRef)context {
  //写标题 近五日资金流量
  CGPoint center = CGPointMake(84, sffv_5dayrect.origin.y + 14);
  UIColor *aColor_title = [Globle colorFromHexRGB:@"#086dae"];
  CGContextSetFillColorWithColor(context, aColor_title.CGColor);
  CGContextSetStrokeColorWithColor(context, aColor_title.CGColor);
  NSString *title_top = @"近5日主力资金净流向";
  [title_top drawInRect:CGRectMake(center.x, center.y, 180, 17)
               withFont:[UIFont boldSystemFontOfSize:Font_Height_16_0]];

  //画出中间标准线
  UIColor *aColor_line = [Globle colorFromHexRGB:@"#cad2d8"];
  CGContextSetLineWidth(context, 1.0); //线宽
  CGContextSetAllowsAntialiasing(context, YES);
  CGContextSetStrokeColorWithColor(context, aColor_line.CGColor);
  CGContextSetFillColorWithColor(context, aColor_line.CGColor);
  CGContextBeginPath(context);
  //起点坐标
  CGContextMoveToPoint(context, 13, sffv_5dayrect.origin.y + 112);
  //终点坐标
  CGContextAddLineToPoint(context, self.bounds.size.width - 13,
                          sffv_5dayrect.origin.y + 112);
  CGContextStrokePath(context);

  //画出5日资金流向矩形
  long max_fund = 0;
  long min_fund = 0;
  int i = 0;
  for (NSNumber *obj in sffv_5dayfund) {
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
  float left = 13 + 13;
  float width = 57 / 2;
  float space = 30;
  float totol_height = 125;
  for (NSNumber *obj in sffv_5dayfund) {
    //画出背景矩形
    UIColor *back_Color = [Globle colorFromHexRGB:@"#ebedef"];
    CGContextSetFillColorWithColor(context, back_Color.CGColor);
    CGContextSetStrokeColorWithColor(context, back_Color.CGColor);
    float height2 = totol_height;
    CGRect rect2 =
        CGRectMake(left + i * (width + space),
                   sffv_5dayrect.origin.y + 112 - height2 / 2, width, height2);
    CGContextAddRect(context, rect2);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径

    //画出资金流向矩形
    long cor_fund = [obj longValue];
    float percent;
    if (max_fund == 0) {
      percent = 0;
    } else {
      percent = ((double)cor_fund) / ((double)2 * max_fund);
    }
    UIColor *aColor = [Globle colorFromHexRGB:@"#359301"];
    if (cor_fund > 0) {
      aColor = [Globle colorFromHexRGB:@"#fe0000"];
    } else if (cor_fund == 0) {
      aColor =
          [Globle colorFromHexRGB:Color_Text_Common]; //如果为0则为默认文字颜色
    }
    CGContextSetFillColorWithColor(context, aColor.CGColor);
    CGContextSetStrokeColorWithColor(context, aColor.CGColor);
    //计算角度
    //填充颜色
    CGContextMoveToPoint(context, center.x, center.y);
    float height = percent * totol_height;
    CGRect rect;
    if (cor_fund == 0) { //资金为0时不绘画
      rect = CGRectMake(left + i * (width + space),
                        sffv_5dayrect.origin.y + 112 - height, 0, 0);
    } else {
      rect = CGRectMake(left + i * (width + space),
                        sffv_5dayrect.origin.y + 112 - height, width, height);
    }

    CGContextAddRect(context, rect);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径
    //写出资金流量文字
    NSString *amount_money = [NSString stringWithFormat:@"%ld", cor_fund];
    NSString *str_fundLow = amount_money;
    if (cor_fund >= 0) {

      [str_fundLow
          drawInRect:CGRectMake(rect.origin.x, sffv_5dayrect.origin.y + 112 + 3,
                                180, 13)
            withFont:[UIFont boldSystemFontOfSize:Font_Height_12_0]];
    } else {
      [str_fundLow
          drawInRect:CGRectMake(rect.origin.x,
                                sffv_5dayrect.origin.y + 112 - 13 - 3, 180, 13)
            withFont:[UIFont boldSystemFontOfSize:Font_Height_12_0]];
    }

    //写日期
    if (i < [sffv_fdaydate count]) {
      UIColor *aColor = [Globle colorFromHexRGB:Color_Gray];
      CGContextSetFillColorWithColor(context, aColor.CGColor);
      CGContextSetStrokeColorWithColor(context, aColor.CGColor);
      NSString *date = sffv_fdaydate[i];
      [date drawInRect:CGRectMake(rect.origin.x,
                                  sffv_5dayrect.origin.y +
                                      sffv_5dayrect.size.height - 22 - 3 - 14,
                                  180, 13)
              withFont:[UIFont boldSystemFontOfSize:Font_Height_12_0]];
    }
    i++;
  }

  //写小标题 资金累计净流入
  NSArray *array = @[@"资金净流入", @"资金净流出"];
  NSArray *array_cor = @[@"#fe0000", @"#359301"];
  for (int i = 0; i < 2; i++) {
    //写文字
    CGPoint center = CGPointMake(20, sffv_5dayrect.origin.y +
                                         sffv_5dayrect.size.height - 14);
    UIColor *aColor_title =
        [Globle colorFromHexRGB:array_cor[i]];
    CGContextSetFillColorWithColor(context, aColor_title.CGColor);
    CGContextSetStrokeColorWithColor(context, aColor_title.CGColor);
    NSString *title_top = array[i];
    [title_top drawInRect:CGRectMake(center.x + i * 85, center.y, 100, 13)
                 withFont:[UIFont boldSystemFontOfSize:Font_Height_12_0]];
    //画圆
    CGContextAddArc(context, center.x - 6 + i * 85, center.y + 7, 5,
                    0 * PI / 180, 360 * PI / 180, 0);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
  }
  //写单位万元标题
  center =
      CGPointMake(17, sffv_5dayrect.origin.y + sffv_5dayrect.size.height - 14);
  aColor_title = [Globle colorFromHexRGB:Color_Text_Common];
  CGContextSetFillColorWithColor(context, aColor_title.CGColor);
  CGContextSetStrokeColorWithColor(context, aColor_title.CGColor);
  NSString *title = @"单位：万元";
  [title drawInRect:CGRectMake(self.bounds.size.width - 70, center.y, 100, 13)
           withFont:[UIFont boldSystemFontOfSize:Font_Height_12_0]];
  //画出表格之间的分割线
  aColor_line = [Globle colorFromHexRGB:Color_Cell_Line];
  CGContextSetLineWidth(context, 1); //线宽
  CGContextSetAllowsAntialiasing(context, YES);
  CGContextSetStrokeColorWithColor(context, aColor_line.CGColor);
  CGContextSetFillColorWithColor(context, aColor_line.CGColor);
  CGContextBeginPath(context);
  //起点坐标
  CGContextMoveToPoint(context, sffv_5dayrect.origin.x + 5,
                       sffv_5dayrect.origin.y + sffv_5dayrect.size.height + 2);
  //终点坐标
  CGContextAddLineToPoint(
      context, sffv_5dayrect.origin.x + sffv_5dayrect.size.width - 10,
      sffv_5dayrect.origin.y + sffv_5dayrect.size.height + 2);
  CGContextStrokePath(context);

  //画出下分割线
  aColor_line = [Globle colorFromHexRGB:Color_White];
  CGContextSetLineWidth(context, 1); //线宽
  CGContextSetAllowsAntialiasing(context, YES);
  CGContextSetStrokeColorWithColor(context, aColor_line.CGColor);
  CGContextSetFillColorWithColor(context, aColor_line.CGColor);
  CGContextBeginPath(context);
  //起点坐标
  CGContextMoveToPoint(context, sffv_5dayrect.origin.x + 5,
                       sffv_5dayrect.origin.y + sffv_5dayrect.size.height + 3);
  //终点坐标
  CGContextAddLineToPoint(
      context, sffv_5dayrect.origin.x + sffv_5dayrect.size.width - 10,
      sffv_5dayrect.origin.y + sffv_5dayrect.size.height + 3);
  CGContextStrokePath(context);
}

//画出资金近期累计流向
- (void)drawtotolfundLow:(CGContextRef)context {
  //写标题 资金近期累计流向
  CGPoint center = CGPointMake(84, sffv_totolrect.origin.y + 14);
  UIColor *aColor_title = [Globle colorFromHexRGB:@"#086dae"];
  CGContextSetFillColorWithColor(context, aColor_title.CGColor);
  CGContextSetStrokeColorWithColor(context, aColor_title.CGColor);
  NSString *title = @"资金近期累计净流向";
  [title drawInRect:CGRectMake(center.x, center.y, 180, 17)
           withFont:[UIFont boldSystemFontOfSize:Font_Height_16_0]];

  //画出纵向分割线
  UIColor *aColor_line = [Globle colorFromHexRGB:@"#cad2d8"];
  CGContextSetLineWidth(context, 1.0); //线宽
  CGContextSetAllowsAntialiasing(context, YES);
  CGContextSetStrokeColorWithColor(context, aColor_line.CGColor);
  CGContextSetFillColorWithColor(context, aColor_line.CGColor);
  CGContextBeginPath(context);
  //起点坐标
  CGContextMoveToPoint(context,
                       sffv_totolrect.origin.x + sffv_totolrect.size.width / 2,
                       sffv_totolrect.origin.y + 53);
  //终点坐标
  CGContextAddLineToPoint(
      context, sffv_totolrect.origin.x + sffv_totolrect.size.width / 2,
      sffv_totolrect.origin.y + sffv_totolrect.size.height - 13);
  CGContextStrokePath(context);

  //写出资金净流向文字
  NSArray *fund_dayArray =
      @[@"1日", @"3日", @"5日", @"10日"];
  CGRect day_rect = CGRectMake(62, sffv_totolrect.origin.y + 53, 35, 16);
  int i = 0;
  for (NSNumber *number in sffv_totolfund) {
    long cor_fund = [number longValue];
    //写出资金流量文字
    NSString *amount_money = [NSString stringWithFormat:@"%ld万元", cor_fund];
    ;
    //设定资金净流入
    if (sffv_totollable && [sffv_totollable count] > i) {
      if (cor_fund >= 0) {
        UILabel *lable = sffv_totollable[i];
        lable.textColor = [Globle colorFromHexRGB:@"#fe0000"];
        lable.text = amount_money;
      } else {
        UILabel *lable = sffv_totollable[i];
        lable.textColor = [Globle colorFromHexRGB:@"#359301"];
        lable.text = amount_money;
      }
    }
    UIColor *aColor_line = [Globle colorFromHexRGB:Color_Gray];
    CGContextSetStrokeColorWithColor(context, aColor_line.CGColor);
    CGContextSetFillColorWithColor(context, aColor_line.CGColor);
    CGRect rect = CGRectZero;
    if (i == 0) {
      rect = CGRectOffset(day_rect, 0, 0);
    } else if (i == 1) {
      rect = CGRectOffset(day_rect, sffv_totolrect.size.width / 2, 0);
    } else if (i == 2) {
      rect = CGRectOffset(day_rect, 0, 48);
    } else {
      rect = CGRectOffset(day_rect, sffv_totolrect.size.width / 2, 48);
    }
    NSString *daydate = fund_dayArray[i];
    [daydate drawInRect:rect
               withFont:[UIFont boldSystemFontOfSize:Font_Height_16_0]];
    i++;
  }
}
- (void)creatTotolfundLable {
  for (int i = 0; i < 4; i++) {
    CGRect rect = CGRectZero;
    if (i == 0) {
      rect = CGRectMake(sffv_totolrect.origin.x, sffv_totolrect.origin.y + 75,
                        sffv_totolrect.size.width / 2, 22);
    } else if (i == 1) {
      rect = CGRectMake(sffv_totolrect.origin.x + sffv_totolrect.size.width / 2,
                        sffv_totolrect.origin.y + 75,
                        sffv_totolrect.size.width / 2, 22);
    } else if (i == 2) {
      rect = CGRectMake(sffv_totolrect.origin.x, sffv_totolrect.origin.y + 125,
                        sffv_totolrect.size.width / 2, 22);
    } else if (i == 3) {
      rect = CGRectMake(sffv_totolrect.origin.x + sffv_totolrect.size.width / 2,
                        sffv_totolrect.origin.y + 125,
                        sffv_totolrect.size.width / 2, 22);
    }
    UILabel *lable = [[UILabel alloc] initWithFrame:rect];
    lable.backgroundColor = [UIColor clearColor];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.font = [UIFont boldSystemFontOfSize:Font_Height_21_0];
    [sffv_totollable addObject:lable];
    [self addSubview:lable];
  }
}

@end
