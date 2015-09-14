//
//  SimuChechBoxView.m
//  SimuStock
//
//  Created by Mac on 13-8-26.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "SimuChechBoxView.h"
#import "Globle.h"

@implementation SimuChechBoxView

@synthesize row = scb_row;
@synthesize col = scb_col;
@synthesize isDown = scb_isDown;

- (void)awakeFromNib {
  UIColor *borderColor = [Globle colorFromHexRGB:@"d8d8d8"];
  UIColor *fillColor = [Globle colorFromHexRGB:@"f2f2f2"];

  [self setNeedLineTop:true left:true bottom:true right:true];
  [self setLineColorTop:borderColor
                   left:borderColor
                 bottom:borderColor
                  right:borderColor]; //用同一色边线
  [self setLineWidthTop:1
                   left:1
                 bottom:1
                  right:1]; //设置线的粗细，这里可以随意调整
  [self setBackgroundColor:fillColor];

  //对号
  int checkMarkWidth = 18;
  int checkMarkHeight = 16;
  checkMarkImageView = [[UIImageView alloc]
      initWithFrame:CGRectMake((self.frame.size.width - checkMarkWidth) / 2,
                               (self.frame.size.width - checkMarkHeight) / 2,
                               checkMarkWidth, checkMarkHeight)];
  checkMarkImageView.image = [UIImage imageNamed:@""];

  [self addSubview:checkMarkImageView];
  scb_isDown = NO;
  self.userInteractionEnabled = YES;
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    UIColor *borderColor = [Globle colorFromHexRGB:@"d8d8d8"];
    UIColor *fillColor = [Globle colorFromHexRGB:@"f2f2f2"];

    [self setNeedLineTop:true left:true bottom:true right:true];
    [self setLineColorTop:borderColor
                     left:borderColor
                   bottom:borderColor
                    right:borderColor]; //用同一色边线
    [self setLineWidthTop:1
                     left:1
                   bottom:1
                    right:1]; //设置线的粗细，这里可以随意调整
    [self setBackgroundColor:fillColor];

    //对号
    int checkMarkWidth = 18;
    int checkMarkHeight = 16;
    checkMarkImageView = [[UIImageView alloc]
        initWithFrame:CGRectMake((frame.size.width - checkMarkWidth) / 2,
                                 (frame.size.width - checkMarkHeight) / 2,
                                 checkMarkWidth, checkMarkHeight)];
    checkMarkImageView.image = [UIImage imageNamed:@""];

    [self addSubview:checkMarkImageView];
    scb_isDown = NO;
    self.userInteractionEnabled = YES;
  }
  return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  CGPoint pos = [[touches anyObject] locationInView:self];
  if (CGRectContainsPoint(self.bounds, pos)) {
    //修改状态
    if (scb_isDown == YES) {
      scb_isDown = NO;
    } else {
      scb_isDown = YES;
    }

    //修改按钮图片
    if (scb_isDown == YES) {
      checkMarkImageView.image =
          [UIImage imageNamed:@"Edit_item_checkbox_mark.png"];
    } else {
      checkMarkImageView.image = [UIImage imageNamed:@""];
    }

    if (_onSelectedCallback) {
      _onSelectedCallback(scb_isDown);
    }
  }
}

- (void)setSelected:(BOOL)isSelected {
  scb_isDown = isSelected;
  //修改按钮图片
  if (scb_isDown == YES) {
    checkMarkImageView.image =
        [UIImage imageNamed:@"Edit_item_checkbox_mark.png"];
  } else {
    checkMarkImageView.image = [UIImage imageNamed:@""];
  }
}

@end
