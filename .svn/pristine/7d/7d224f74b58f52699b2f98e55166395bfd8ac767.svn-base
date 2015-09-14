//
//  PlusButtonView.m
//  SimuStock
//
//  Created by Mac on 15/4/26.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "PlusButtonView.h"
#import "Globle.h"

@implementation PlusButtonView {
  BOOL normalState;
  UIColor *normalColor;
  UIColor *highlightColor;
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self _init];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self _init];
  }
  return self;
}

- (void)_init {
  normalState = YES;
  normalColor = [Globle colorFromHexRGB:@"#086dae"];
  highlightColor = [UIColor whiteColor];
}

///描边线宽
static float Stroke_Line_Width = 4.0;

///内部加号的线宽
static float Plus_Line_Width = 8.0;
///内部加号距边框的距离
static float Plus_Line_Gap = 15.0;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
  [super drawRect:rect];

  CGContextRef context = UIGraphicsGetCurrentContext();

  //绘制背景:按下态时，绘制反色的背景（normal)
  if (!normalState) {
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 0.0);
    CGContextSetFillColorWithColor(context, normalColor.CGColor);
    CGContextFillRect(context, rect);
    CGContextRestoreGState(context);
  }

  CGFloat left = rect.origin.x;
  CGFloat top = rect.origin.y;
  CGFloat right = rect.origin.x + rect.size.width;
  CGFloat buttom = rect.origin.y = rect.size.height;

  //绘制描边：正常态下绘制蓝色的描边
  if (normalState) {
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, normalColor.CGColor);
    CGContextSetLineWidth(context, Stroke_Line_Width);
    CGFloat lengths[] = {5, 5};
    CGContextSetLineDash(context, 0, lengths, 2);

    // 绘制正方形边框
    CGPoint addLines[] = {CGPointMake(left, top), CGPointMake(right, top), CGPointMake(right, buttom),
                          CGPointMake(left, buttom), CGPointMake(left, top)};
    CGContextAddLines(context, addLines, sizeof(addLines) / sizeof(addLines[0]));
    CGContextStrokePath(context);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
  }

  // 绘制加号

  UIColor *color = normalState ? normalColor : highlightColor;
  CGContextSetStrokeColorWithColor(context, color.CGColor);
  CGContextSetLineWidth(context, Plus_Line_Width);
  CGContextMoveToPoint(context, (right) / 2, Plus_Line_Gap);
  CGContextAddLineToPoint(context, (right) / 2, buttom - Plus_Line_Gap);
  CGContextStrokePath(context);

  CGContextMoveToPoint(context, Plus_Line_Gap, buttom / 2);
  CGContextAddLineToPoint(context, right - Plus_Line_Gap, buttom / 2);

  CGContextStrokePath(context);
  CGContextClosePath(context);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesBegan:touches withEvent:event];
  normalState = NO;
  [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesCancelled:touches withEvent:event];
  normalState = YES;
  [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesEnded:touches withEvent:event];
  normalState = YES;
  [self setNeedsDisplay];
}

@end
