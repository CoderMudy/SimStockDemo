//
//  Circle.m
//  SimuStock
//
//  Created by Yuemeng on 15/5/14.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "Circle.h"

@implementation Circle

- (instancetype)initWithFrame:(CGRect)frame
                      isSolid:(BOOL)isSolid
                        color:(UIColor *)color {
  if (self = [super initWithFrame:frame]) {
    self.backgroundColor = [UIColor clearColor];
    _isSolid = isSolid;
    _color = color;
  }
  return self;
}

- (void)drawRect:(CGRect)rect {

  CGContextRef context = UIGraphicsGetCurrentContext();

  [_color set];

  CGContextSetLineWidth(context, 1.f);

  CGFloat radius = self.width / 2;

  CGContextAddArc(context, radius, radius, radius - .5f, 0, 2 * M_PI,
                  0); //必须-.5f，否则被边界截断！

  if (_isSolid) {
    CGContextDrawPath(context, kCGPathFillStroke);
  } else {
    CGContextDrawPath(context, kCGPathStroke);
  }
}

@end
