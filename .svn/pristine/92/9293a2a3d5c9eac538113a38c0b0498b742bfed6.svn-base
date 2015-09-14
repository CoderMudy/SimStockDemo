//
//  Flowers.m
//  SimuStock
//
//  Created by Yuemeng on 15/3/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "Flowers.h"
#import "Globle.h"

#define BEZIER_OFFSET_RATE_X (8.0f / 14.0f)
#define BEZIER_OFFSET_RATE_Y (9.0f / 14.0f)

@implementation Flowers

- (instancetype)initWithRating:(NSString *)rating {

  if (self = [super initWithFrame:CGRectMake(0, 0, 14, 14)]) {
    _rating = rating;
    self.backgroundColor = [UIColor clearColor];
    self.hidden = (rating.length == 0);
  }
  return self;
}

- (instancetype)initBigFlowerWithRating:(NSString *)rating
                              withFrame:(CGRect)frame {

  if (self = [super initWithFrame:frame]) {
    _rating = rating;
    self.backgroundColor = [UIColor clearColor];
    self.hidden = (rating.length == 0);
  }
  return self;
}

/** 清除并重新绘制 */
- (void)resetWithRating:(NSString *)rating {
  _rating = rating;

  [self setNeedsDisplay];
  self.hidden = (rating.length == 0);
}

- (void)drawRect:(CGRect)rect {

  if (_rating.length == 0) {
    return;
  }
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextClearRect(context, self.bounds);

  //取中心点，切勿用center！
  CGPoint centerPoint =
      CGPointMake(WIDTH_OF_VIEW * 0.5f, HEIGHT_OF_VIEW * 0.5f);
  //获取当前上下文环境，即画布

  //贝塞尔基准点x偏移量, 贝塞尔基准点y偏移量
  CGFloat offsetX = BEZIER_OFFSET_RATE_X * WIDTH_OF_VIEW;
  CGFloat offsetY = BEZIER_OFFSET_RATE_Y * HEIGHT_OF_VIEW;

  //创建三次贝塞尔曲线的两个控制点，花瓣形状就是靠此形成
  CGPoint point1 =
      CGPointMake(centerPoint.x - offsetX, centerPoint.y - offsetY);
  CGPoint point2 =
      CGPointMake(centerPoint.x + offsetX, centerPoint.y - offsetY);

  //花瓣颜色数组
  NSArray *flowerColors = @[
    [Globle colorFromHexRGB:@"#F45145"], // E 红
    [Globle colorFromHexRGB:@"#FFA914"], // D 黄
    [Globle colorFromHexRGB:@"#77D568"], // C 绿
    [Globle colorFromHexRGB:@"#23BDEC"], // B 蓝
    [Globle colorFromHexRGB:@"#AE92FC"], // A 紫
    [Globle colorFromHexRGB:@"#C6C6C6"]  //灰色
  ];

  //评级转数字0~4
  NSInteger ratingNumber = [_rating characterAtIndex:0] - 65;

  for (NSInteger i = 0; i < 5; i++) {
    CGContextSaveGState(context); //先保存当前画布，保证每次都从同一个点开始旋转

    //变换画布坐标矩阵为中心，即以中心点旋转，否则旋转时将按左上角起点。转完必须恢复坐标矩阵
    CGContextTranslateCTM(context, centerPoint.x, centerPoint.y + 0.5);
    CGContextRotateCTM(context, (-72 * i) * M_PI / 180); // 72°=360°/5
    CGContextTranslateCTM(context, -centerPoint.x, -centerPoint.y - 0.5);

    //创建贝塞尔曲线
    UIBezierPath *flowerPath = [UIBezierPath bezierPath];

    //取色并设置填充色
    if (i <= 4 - ratingNumber) {
      [flowerColors[i] setFill];
    } else {
      [flowerColors[5] setFill];
    }

    [flowerPath moveToPoint:centerPoint]; //设置贝塞尔曲线起始点

    //设置终点及两个控制点
    [flowerPath addCurveToPoint:centerPoint
                  controlPoint1:point1
                  controlPoint2:point2];

    [flowerPath fill]; //画线（由于花瓣是封闭的，所以不需要closePath方法）

    CGContextRestoreGState(context); //恢复上面保存的画布
  }
}

@end
