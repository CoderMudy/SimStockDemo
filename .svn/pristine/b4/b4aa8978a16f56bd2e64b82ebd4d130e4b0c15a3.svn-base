//
//  RadioButton.m
//  SimuStock
//
//  Created by jhss_wyz on 15/4/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "RadioButton.h"
#import "Globle.h"

@interface RadioButton ()

@property(weak, nonatomic) CAShapeLayer *shapeLayer;

@end

@implementation RadioButton

- (instancetype)init {
  if (self = [super init]) {
    [self setTitle:@"" forState:UIControlStateNormal];
    [self setTitle:@"" forState:UIControlStateSelected];
    [self setTitle:@"" forState:UIControlStateHighlighted];
  }
  return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  [self setTintColor:[UIColor clearColor]];
  [self setTitle:@"" forState:UIControlStateNormal];
  [self setTitle:@"" forState:UIControlStateSelected];
  [self setTitle:@"" forState:UIControlStateHighlighted];
}

- (void)drawRect:(CGRect)rect {
  self.layer.cornerRadius = self.width / 2;
  self.layer.borderWidth = 1.0;
  self.layer.borderColor =
      [Globle colorFromHexRGB:Color_TooltipSureButton].CGColor;
}

- (void)setRadioBtnSelected:(BOOL)radioBtnSelected {
  _radioBtnSelected = radioBtnSelected;

  if (radioBtnSelected) {
    self.shapeLayer.hidden = NO;
  } else {
    self.shapeLayer.hidden = YES;
  }

  self.selected = _radioBtnSelected;
}

- (CAShapeLayer *)shapeLayer {
  if (_shapeLayer == nil) {
    UIBezierPath *temp_bezierpath = [UIBezierPath
        bezierPathWithArcCenter:CGPointMake(self.width / 2, self.height / 2)
                         radius:self.width / 2 / 25 * 13
                     startAngle:0
                       endAngle:M_PI * 2
                      clockwise:YES];

    CAShapeLayer *temp_shapeLayer = [CAShapeLayer layer];
    temp_shapeLayer.path = temp_bezierpath.CGPath;
    temp_shapeLayer.fillColor =
        [[Globle colorFromHexRGB:Color_TooltipSureButton] CGColor];
    _shapeLayer = temp_shapeLayer;
    [self.layer addSublayer:_shapeLayer];
  }
  return _shapeLayer;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
  [super setTitle:@"" forState:state];
}

@end
