//
//  ArcAndNumberView.m
//  SimuStock
//
//  Created by Yuemeng on 15/3/6.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ArcAndNumberView.h"
#import "Globle.h"

@implementation ArcAndNumberView

- (instancetype)initWithFrame:(CGRect)frame
                    withTitle:(NSString *)title
                      withNum:(NSNumber *)num
                    withColor:(UIColor *)color {
  // self 63*30
  if (self = [super initWithFrame:frame]) {
    self.backgroundColor = [UIColor clearColor];
    _title = title;
    _num = (int)([num floatValue]*2);
    _color = color;
    _incrementNum = 0;
  }
  return self;
}

- (void)drawRect:(CGRect)rect {

  //画背景圆 半径15，坐标15，15
  UIBezierPath *circlePath =
      [UIBezierPath bezierPathWithArcCenter:CGPointMake(15, 15)
                                     radius:15
                                 startAngle:0
                                   endAngle:2 * M_PI
                                  clockwise:YES];
  [_color setFill];
  [circlePath fill];

  //画弧线
  UIBezierPath *arcPath =
      [UIBezierPath bezierPathWithArcCenter:CGPointMake(15, 15)
                                     radius:10
                                 startAngle:0
                                   endAngle:(36 * _num * M_PI / 180)
                                  clockwise:YES];

  CAShapeLayer *arcLayer = [CAShapeLayer layer];

  arcLayer.path = arcPath.CGPath;
  arcLayer.fillColor = [[UIColor clearColor] CGColor];
  arcLayer.strokeColor = [[UIColor whiteColor] CGColor];
  arcLayer.lineWidth = 2;
  arcLayer.frame = CGRectMake(0, 0, 30, 30);
  [self.layer addSublayer:arcLayer];

  CABasicAnimation *baseAni =
      [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
  baseAni.duration = 0.1 * _num; //时间根据num大小决定
  baseAni.fromValue = @0;
  baseAni.toValue = @1;
  [arcLayer addAnimation:baseAni forKey:@"strokeEnd"];

  //滚动的数字0~10 坐标：37，0 20号字
  if (!_numlabel) {
    _numlabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 30, 20)];
    _numlabel.textColor = _color;
    _numlabel.font = [UIFont systemFontOfSize:Font_Height_20_0];
    _numlabel.textAlignment = NSTextAlignmentCenter;
    _numlabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_numlabel];
  }

  //开启定时器计数
  [NSTimer scheduledTimerWithTimeInterval:0.1
                                   target:self
                                 selector:@selector(updateNum:)
                                 userInfo:nil
                                  repeats:YES];

  //名字label 9号字
  if (!_titleLabel) {
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 23, 30, 9)];
    _titleLabel.text = _title;
    _titleLabel.textColor = [Globle colorFromHexRGB:Color_Gray];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont systemFontOfSize:Font_Height_09_0];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
  }
}

- (void)updateNum:(NSTimer *)timer {
  _numlabel.text = [NSString stringWithFormat:@"%d", _incrementNum];
  if (_incrementNum >= _num) {
    [timer invalidate];
    timer = nil;
    _incrementNum = 0;
  }
  _incrementNum++;
}

/** 清除并重新绘制 */
- (void)resetWithNum:(NSNumber *)num {
  _num = (int)([num floatValue]*2);
  _incrementNum = 0;

  //清除弧线
  for (CALayer *layer in self.layer.sublayers) {
    if ([layer.class isSubclassOfClass:[CAShapeLayer class]]) {
      [layer removeFromSuperlayer];
      break;
    }
  }

  [self setNeedsDisplay];
}

@end
