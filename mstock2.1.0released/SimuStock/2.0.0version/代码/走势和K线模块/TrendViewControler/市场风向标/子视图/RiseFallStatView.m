//
//  RiseFallStatView.m
//  SimuStock
//
//  Created by Yuemeng on 15/5/13.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "RiseFallStatView.h"
#import "Globle.h"
#import "IndexCurpriceData.h"

@implementation RiseFallStatView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
    UILabel *titleLabel =
        [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 135, 21)];
    titleLabel.text = @"涨跌数统计";
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:Font_Height_15_0];
    titleLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:titleLabel];
  }
  return self;
}

- (void)drawRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();
  [self drawYesterdayFoundFlow:context];
}

#pragma mark -画出昨日资金流向
- (void)drawYesterdayFoundFlow:(CGContextRef)context {
  //画出扇形图形
  NSArray *colors = @[ @"#fe0000", @"#f36e14", @"#359301" ]; //橙，红，深绿
  NSArray *title_array = @[ @"上涨家数", @"平盘家数", @"下跌家数" ];

  //设定圆心
  CGPoint center = CGPointMake(self.bounds.size.width / 2, 150);
  long totalNumber = 0;

  totalNumber += _indexCurpriceData.up;
  totalNumber += _indexCurpriceData.equ;
  totalNumber += _indexCurpriceData.down;

  //各个百分比占比
  NSArray *percents = @[
    @((float)_indexCurpriceData.up / totalNumber),
    @((float)_indexCurpriceData.equ / totalNumber),
    @((float)_indexCurpriceData.down / totalNumber)
  ];

  if (totalNumber == 0) {
    totalNumber = 1;
    UIColor *aColor = [Globle colorFromHexRGB:@"#cccde7"]; //浅紫色
    CGContextSetFillColorWithColor(context, aColor.CGColor);
    CGContextSetStrokeColorWithColor(
        context, [Globle colorFromHexRGB:@"#cccde7"].CGColor);
    //计算角度
    //填充颜色
    //以10为半径围绕圆心画指定角度扇形
    CGContextMoveToPoint(context, center.x, center.y);
    CGContextAddArc(context, center.x, center.y, 75, 0 * M_PI / 180,
                    360 * M_PI / 180, 0);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    //画出圆形图形
  } else {
    int i = 0;
    float startAngle = 180.0;

    for (int j = 0; j < percents.count; j++) {

      float percent = [percents[j] floatValue];
      float endAngle = startAngle + 360 * percent;

      UIColor *aColor = [Globle colorFromHexRGB:[colors objectAtIndex:i]];
      CGContextSetFillColorWithColor(context, aColor.CGColor);
      CGContextSetStrokeColorWithColor(
          context, [Globle colorFromHexRGB:Color_BG_Common].CGColor);
      //计算角度
      //填充颜色
      //以75为半径围绕圆心画指定角度扇形
      CGContextMoveToPoint(context, center.x, center.y);
      CGContextAddArc(context, center.x, center.y, 75, startAngle * M_PI / 180,
                      endAngle * M_PI / 180, 0);
      CGContextClosePath(context);
      CGContextDrawPath(context, kCGPathFillStroke);
      //绘制路径
      //写出昨日资金流向文字
      if (startAngle != endAngle) {
        float m_x =
            90 * cosf((startAngle + 360 * percent / 2) * M_PI / 180) + center.x;
        float m_y =
            90 * sinf((startAngle + 360 * percent / 2) * M_PI / 180) + center.y;

        /// YL, 修改原先，扇形面积太小时，文字重叠问题
        float YL_x =
            75 * cosf((startAngle + 360 * percent / 2) * M_PI / 180) + center.x;
        float YL_y =
            75 * sinf((startAngle + 360 * percent / 2) * M_PI / 180) + center.y;

        if (m_y - YL_y > 0 && m_y - YL_y < 15) {
          m_y += 15;
        } else if (m_y - YL_y < 0 && m_y - YL_y > (-15)) {
          m_y -= 15;
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
        float m_titleX = m_x;
        float m_linex = m_x;
        if (m_x < center.x) {
          m_titleX = m_x - 60;
          m_linex = m_x - 65;
        } else {
          m_linex = m_x + 65;
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
        CGContextSetFillColorWithColor(context, aColor.CGColor);

        NSString *temp_str = [NSString stringWithFormat:@"%.2f", percent * 100];
        temp_str = [temp_str stringByAppendingString:@"%"];
        [temp_str drawInRect:CGRectMake(m_titleX, m_y - 19, 100, 18)
                    withFont:[UIFont boldSystemFontOfSize:17.5]];
        CGContextSetStrokeColorWithColor(
            context, [Globle colorFromHexRGB:Color_Gray].CGColor);
        CGContextSetFillColorWithColor(
            context, [Globle colorFromHexRGB:Color_Gray].CGColor);
        NSString *name_title = [title_array objectAtIndex:i];
        [name_title drawInRect:CGRectMake(m_titleX, m_y, 100, 15)
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
  CGContextAddArc(context, center.x, center.y, 35.5, 0 * M_PI / 180,
                  360 * M_PI / 180, 0);
  CGContextClosePath(context);
  CGContextDrawPath(context, kCGPathFillStroke);
  //绘制路径

  //写 昨日资金 标题
  UIColor *aColor_title = [Globle colorFromHexRGB:Color_Blue_but];
  CGContextSetFillColorWithColor(context, aColor_title.CGColor);
  CGContextSetStrokeColorWithColor(context, aColor_title.CGColor);
  NSString *title_top = @"上市";
  NSString *title_woen = @"公司";
  [title_top drawInRect:CGRectMake(center.x - 13, center.y - 15, 75, 15)
               withFont:[UIFont boldSystemFontOfSize:15]];
  [title_woen drawInRect:CGRectMake(center.x - 13, center.y, 75, 15)
                withFont:[UIFont boldSystemFontOfSize:15]];
}

- (void)requestRiseFallStatData {

  __weak RiseFallStatView *weakSelf = self;
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onCheckQuitOrStopProgressBar = ^{
    RiseFallStatView *strongSelf = weakSelf;
    if (strongSelf) {
      //
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *object) {
    RiseFallStatView *strongSelf = weakSelf;
    if (strongSelf) {
      //绑定数据重新绘图
      _indexCurpriceData = (IndexCurpriceData *)object;
      [strongSelf setNeedsDisplay];
    }
  };

  callback.onError = ^(BaseRequestObject *obj, NSException *ex) {
    [NewShowLabel setMessageContent:obj.message];
  };

  [IndexCurpriceData requestIndexCurpriceDataWithCode:@"10000001"
                                         withCallback:callback];
}
@end
