//
//  BlueViewAndArrow.m
//  SimuStock
//
//  Created by Yuemeng on 15/4/12.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BlueViewAndArrow.h"

#define BLUE_HEIGHT 36
#define ARC_RADIUS 5
#define TRANGLE_HEIGHT 9

@implementation BlueViewAndArrow

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = YES;
    self.onLeftOrRight = YES;
  }
  return self;
}

- (void)drawRect:(CGRect)rect {
  //提示框高度36，蓝色箭头宽度18，高度9

  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextBeginPath(context);

  CGFloat centerX = _width / 2.0f;

  //右上角圆弧开始画，起始点为右上角向左偏移5
  CGFloat originX = centerX * 2 - ARC_RADIUS;

  CGContextMoveToPoint(context, originX, 0);
  //画右上角圆弧
  CGContextAddArcToPoint(context, originX + ARC_RADIUS, 0, originX + ARC_RADIUS,
                         ARC_RADIUS, ARC_RADIUS);
  //画右侧边直线
  CGContextAddLineToPoint(context, originX + ARC_RADIUS,
                          BLUE_HEIGHT - ARC_RADIUS * 2);
  //画右下角圆弧
  CGContextAddArcToPoint(context, originX + ARC_RADIUS, BLUE_HEIGHT, originX,
                         BLUE_HEIGHT, ARC_RADIUS);
  //画右下画直线
  CGContextAddLineToPoint(context, centerX + TRANGLE_HEIGHT, BLUE_HEIGHT);
  //画三角右边
  CGContextAddLineToPoint(context, centerX, BLUE_HEIGHT + TRANGLE_HEIGHT);
  //画三角坐边
  CGContextAddLineToPoint(context, centerX - TRANGLE_HEIGHT, BLUE_HEIGHT);
  //画左下直线
  CGContextAddLineToPoint(context, 0 + ARC_RADIUS, BLUE_HEIGHT);
  //画左下角圆弧
  CGContextAddArcToPoint(context, 0, BLUE_HEIGHT, 0,
                         BLUE_HEIGHT - ARC_RADIUS, ARC_RADIUS);
  //画左侧边直线
  CGContextAddLineToPoint(context, 0, ARC_RADIUS);
  //画左上角圆弧
  CGContextAddArcToPoint(context, 0, 0, 0 + ARC_RADIUS, 0, ARC_RADIUS);

  CGContextClosePath(context);
  UIColor *color = [UIColor
      colorWithPatternImage:[UIImage imageNamed:@"长按拓展按钮方块"]];
  [color setFill];
  CGContextDrawPath(context, kCGPathFill);
}

- (void)reDrawRectWithWidth:(CGFloat)width {
  _width = width;

  //调整自身宽度
  CGRect frame = self.frame;
  frame.size.width = width;
  if (self.onLeftOrRight) {
    frame.origin.x = (WIDTH_OF_SCREEN - width) / 2.0f;
  }else{
    frame.origin.x = (WIDTH_OF_SCREEN - width) - 20.0f;
  }
  self.frame = frame;

  //清空当前画布，重新绘制
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextClearRect(context, self.bounds);
  [self setNeedsDisplay];
}

@end
