//
//  ColorBackgroundImageButton.m
//  SimuStock
//
//  Created by Mac on 14-8-19.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "ColorBackgroundImageButton.h"

@implementation ColorBackgroundImageButton

@synthesize highlightBgColor = _highlightBgColor;
@synthesize normalBgColor = _normalBgColor;

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    //设置按下态的触发事件
    [self addTarget:self
                  action:@selector(buttonHighlight)
        forControlEvents:UIControlEventTouchDown];
    //设置松开情况的触发事件
    [self addTarget:self
                  action:@selector(buttonNormal)
        forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self
                  action:@selector(buttonNormal)
        forControlEvents:UIControlEventTouchUpOutside];
  }
  return self;
}

- (void)setHighlightBgColor:(UIColor *)highlightColor
              normalBgColor:(UIColor *)normalColor {
  self.highlightBgColor = highlightColor;
  self.normalBgColor = normalColor;
  [self buttonNormal];
}

- (void)buttonHighlight {
  [self setBackgroundColor:_highlightBgColor];
}

- (void)buttonNormal {
  [self setBackgroundColor:_normalBgColor];
}

@end
