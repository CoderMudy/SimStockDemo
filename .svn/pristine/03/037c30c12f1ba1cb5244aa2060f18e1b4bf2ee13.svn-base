//
//  StockBarDetailHeaderView.m
//  SimuStock
//
//  Created by Yuemeng on 14-12-1.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "StockBarDetailHeaderView.h"
#import "Globle.h"
#import "FTCoreTextView.h"

@implementation StockBarDetailHeaderView

- (void)awakeFromNib {
  // Initialization code
  _whiteView.layer.borderWidth = 0.5;
  _whiteView.layer.borderColor =
      [[Globle colorFromHexRGB:Color_Gray_Edge] CGColor];
  [_coreTextView setTextColor:[Globle colorFromHexRGB:Color_Icon_Title]];

  _selfHeight = self.height;
  self.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];

  [_coreTextView setNumberOfLines:2];
  [_coreTextView setTextSize:14];
}

// 关注按钮回调
- (IBAction)followButtonClick:(UIButton *)sender {
  _followButtonClickBlock();
}

- (void)resetHeight {
  _coreTextViewHeight.constant = 14;
  self.height = _selfHeight;
}

- (void)setNewHeight {
  [self addHeight:(_coreTextViewHeight.constant - 14)];
}

@end
