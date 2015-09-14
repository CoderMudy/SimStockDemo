//
//  VerticalLine.m
//  SimuStock
//
//  Created by Mac on 15/4/28.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SeperatorLine.h"
#import "Globle.h"

@implementation VerticalSeperatorLine

- (void)drawRect:(CGRect)rect {
  [super drawRect:rect];

  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetLineWidth(context, self.width/2.0);

  //绘制白线
  CGContextSetStrokeColorWithColor(context,
                                   [Globle colorFromHexRGB:@"#ffffff"].CGColor);
  CGContextMoveToPoint(context, self.width/4.0f, 0.0f);
  CGContextAddLineToPoint(context,self.width/4.0f, rect.size.height);
  CGContextStrokePath(context);

  //绘制灰线
  CGContextSetStrokeColorWithColor(context,
                                   [Globle colorFromHexRGB:@"#d7d8dc"].CGColor);
  CGContextMoveToPoint(context,self.width*3/4.0f, 0.0f);
  CGContextAddLineToPoint(context,self.width*3/4.0f, rect.size.height);
  CGContextStrokePath(context);
}

@end

@implementation HorizontalSeperatorLine

- (void)drawRect:(CGRect)rect {
  [super drawRect:rect];

  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetLineWidth(context, self.height/2.0f);

  //绘制白线
  CGContextSetStrokeColorWithColor(context,
                                   [Globle colorFromHexRGB:Color_White].CGColor);
  CGContextMoveToPoint(context, 0.0f, self.height*3/4.0f);
  CGContextAddLineToPoint(context, rect.size.width, self.height*3/4.0f);
  CGContextStrokePath(context);

  //绘制灰线
  CGContextSetStrokeColorWithColor(context,
                                   [Globle colorFromHexRGB:Color_Cell_Line].CGColor);
  CGContextMoveToPoint(context, 0.0f, self.height/4.0f);
  CGContextAddLineToPoint(context, rect.size.width, self.height/4.0f);
  CGContextStrokePath(context);
}

@end

/* 自选股表格头部垂直分割线 */
@implementation SelfStockVerticalSeperatorLine

- (void)drawRect:(CGRect)rect {
  [super drawRect:rect];

  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetLineWidth(context, 0.5f);

  //绘制白线
  CGContextSetStrokeColorWithColor(context,
                                   [Globle colorFromHexRGB:@"#f2f3f6"].CGColor);
  CGContextMoveToPoint(context, 0.25f, 0.0f);
  CGContextAddLineToPoint(context, 0.25f, rect.size.height);
  CGContextStrokePath(context);

  //绘制灰线
  CGContextSetStrokeColorWithColor(context,
                                   [Globle colorFromHexRGB:@"#d1d3d8"].CGColor);
  CGContextMoveToPoint(context, 0.75f, 0.0f);
  CGContextAddLineToPoint(context, 0.75f, rect.size.height);
  CGContextStrokePath(context);
}

@end

///个股详情页的渐变分割线
@implementation StockVerticalSeperatorLine

- (void)drawRect:(CGRect)rect {
  [super drawRect:rect];

  CGContextRef context = UIGraphicsGetCurrentContext();

  CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
  CGContextSaveGState(context);
  CGContextAddRect(context, CGRectMake(0.f, 0.f, 1.f, rect.size.height));
  CGContextClip(context);
  CGPoint startPoint = CGPointMake(0.f, 0.f);
  CGPoint endPoint = CGPointMake(0.f, rect.size.height);

  size_t num_locations = 3;
  CGFloat locations[3] = {0.0, 0.5, 1.0};
  CGFloat components[12] = {1.0,   1.0,   1.0,   1.0,  // Start color
                            0.835, 0.835, 0.835, 1.0,  // Middle color
                            1.0,   1.0,   1.0,   1.0}; // End color

  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

  CGGradientRef myGradient = CGGradientCreateWithColorComponents(
      colorSpace, components, locations, num_locations);

  CGContextDrawLinearGradient(context, myGradient, startPoint, endPoint, 0);
  CGContextRestoreGState(context);
  CGGradientRelease(myGradient);
  CGColorSpaceRelease(colorSpace);
}

@end
