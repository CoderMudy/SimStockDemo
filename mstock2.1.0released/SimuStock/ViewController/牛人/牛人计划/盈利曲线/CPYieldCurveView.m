//
//  CPYieldCurveView.m
//  SimuStock
//
//  Created by jhss_wyz on 15/7/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "CPYieldCurveView.h"
#import "CPYieldCurve.h"

@implementation CPYieldCurveView

- (void)drawRect:(CGRect)rect {
  if (!self.yieldCurveData) {
    return;
  }

  if (!self.yieldCurveData.isBind) {
    return;
  }
  
  [self clearContext];

  [self drawLineWithDateArray:self.yieldCurveData.planYCArrayM
                 andLineColor:[Globle colorFromHexRGB:@"#0F9EE7"]];
  [self drawGradientRectWithDataArray:self.yieldCurveData.planYCArrayM];
  [self drawLineWithDateArray:self.yieldCurveData.sseGainArrayM
                 andLineColor:[Globle colorFromHexRGB:@"#FF8900"]];
}

- (void)drawLineWithDateArray:(NSArray *)dateArray
                 andLineColor:(UIColor *)lineColor {
  /// 获取上下文
  CGContextRef context = UIGraphicsGetCurrentContext();
  /// 保存一份图形上下文
  CGContextSaveGState(context);

  CGContextSetLineWidth(context, 1.f);
  [lineColor set];
  CGContextBeginPath(context);
  CGContextMoveToPoint(context, 0, self.height / 2);
  /// 画线
  [dateArray
      enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL *stop) {
        CGContextAddLineToPoint(context, [self linePointXWithIndex:idx],
                                [self linePointYWithRose:[obj doubleValue]]);
      }];

  CGContextStrokePath(context);
  /// 还原成保存的那份原始的图形上下文
  CGContextRestoreGState(context);
}

- (void)drawGradientRectWithDataArray:(NSArray *)dataArray {
  /// 获取上下文
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGMutablePathRef path = CGPathCreateMutable();
  /// 保存一份图形上下文
  CGContextSaveGState(context);

  CGContextSetLineWidth(context, 0.5f);
  [[Globle colorFromHexRGB:@"#0F9EE7"] set];
  CGContextBeginPath(context);
  CGPathMoveToPoint(path, NULL, 0, self.height / 2);
  for (NSInteger i = 1; i < dataArray.count; i++) {
    CGPathAddLineToPoint(
        path, NULL, [self linePointXWithIndex:i],
        [self linePointYWithRose:[((NSNumber *)dataArray[i])doubleValue]]);
  }
  CGPathAddLineToPoint(path, NULL, self.width / self.yieldCurveData.tradeDays *
                                       (dataArray.count - 1),
                       self.height / 2);
  CGPathCloseSubpath(path);

  //绘制渐变
  [self drawLinearGradient:context path:path];

  //注意释放CGMutablePathRef
  CGPathRelease(path);
}

- (CGFloat)linePointXWithIndex:(NSInteger)index {
  return self.width * index / self.yieldCurveData.tradeDays;
}

- (CGFloat)linePointYWithRose:(CGFloat)rose {
  if (rose == 0.f) {
    return self.height / 2;
  } else if (rose > 0.f) {
    return (1 - rose / self.yieldCurveData.maxOrdinate) * self.height / 2;
  } else {
    return (((-rose) / self.yieldCurveData.maxOrdinate + 1) * self.height / 2);
  }
}

- (void)drawLinearGradient:(CGContextRef)context path:(CGPathRef)path {
  CGRect pathRect = CGPathGetBoundingBox(path);
  //具体方向可根据需求修改
  CGPoint startPoint =
      CGPointMake(CGRectGetMidX(pathRect), CGRectGetMinY(pathRect));
  CGPoint endPoint =
      CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect));

  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  CGFloat locations[] = {
      0.0, (self.height / 2 - startPoint.y) / (endPoint.y - startPoint.y), 1.0};

  CGFloat highAlpha = 0.3f * (1.f - startPoint.y / self.height / 2);
  CGFloat lowAlpha = 0.3f * (endPoint.y * 2 / self.height - 1.f);

  NSArray *colors = @[
    (__bridge id)[Globle colorFromHexRGB:@"#0F9EE7" alpha:highAlpha]
        .CGColor,
    (__bridge id)[Globle colorFromHexRGB:@"#0F9EE7" alpha:0.f].CGColor,
    (__bridge id)[Globle colorFromHexRGB:@"#0F9EE7" alpha:lowAlpha].CGColor,
  ];

  CGGradientRef gradient = CGGradientCreateWithColors(
      colorSpace, (__bridge CFArrayRef)colors, locations);

  CGContextSaveGState(context);
  CGContextAddPath(context, path);
  CGContextClip(context);
  CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
  CGContextRestoreGState(context);

  CGGradientRelease(gradient);
  CGColorSpaceRelease(colorSpace);
}

- (void)clearContext {
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextClearRect(context, self.bounds);
}

@end
