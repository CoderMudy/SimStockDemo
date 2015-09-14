//
//  FloatWindow4KLineView.m
//  SimuStock
//
//  Created by Yuemeng on 15/6/8.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "FloatWindow4KLineView.h"

@implementation FloatWindow4KLineView

- (void)awakeFromNib {
  ///设置当空间不足时，自动缩小字体填充
  _timeLabel.adjustsFontSizeToFitWidth = YES;
  _openPriceLabel.adjustsFontSizeToFitWidth = YES;
  _heightPriceLabel.adjustsFontSizeToFitWidth = YES;
  _lowPriceLabel.adjustsFontSizeToFitWidth = YES;
  _closePriceLabel.adjustsFontSizeToFitWidth = YES;
  _changePriceLabel.adjustsFontSizeToFitWidth = YES;

  [self setFloatWindowStyle];
}

- (void)setFloatWindowStyle {
  self.layer.cornerRadius = 5.f;
  // A thin border.
  self.layer.borderColor = [UIColor whiteColor].CGColor;
  self.layer.borderWidth = 0.3;

  // Drop shadow.
  self.layer.shadowColor = [UIColor blackColor].CGColor;
  self.layer.shadowOpacity = 0.5;
  self.layer.shadowRadius = 3;
  self.layer.shadowOffset = CGSizeMake(0, 2);
}

@end
