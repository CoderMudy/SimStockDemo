//
//  MessageCenterTableViewCell.m
//  SimuStock
//
//  Created by jhss on 15/7/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MessageCenterTableViewCell.h"
#import "Globle.h"

@implementation MessageCenterTableViewCell

- (void)awakeFromNib {
  self.redDotImage.backgroundColor = [Globle colorFromHexRGB:@"#dd2526"];
  [self.redDotImage.layer setMasksToBounds:YES];
  [self.redDotImage.layer setCornerRadius:10.0f];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
  if (highlighted) {
    self.backgroundColor = [Globle colorFromHexRGB:@"d9ecf2"];
  } else {
    self.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  }
}
- (void)setUnReadMessageNum:(NSInteger)unReadMessageNum {
  _redDotLabel.hidden = unReadMessageNum <= 0;
  _redDotImage.hidden = unReadMessageNum <= 0;
  [self.redDotImage.layer setCornerRadius:10.0f];

  if (unReadMessageNum < 100) {
    _redDotLabel.text =
        [NSString stringWithFormat:@"%ld", (long)unReadMessageNum];
    _redDotLabel.font = [UIFont systemFontOfSize:13];
  } else {
    _redDotLabel.text = @"99+";
    _redDotLabel.font = [UIFont systemFontOfSize:9];
  }
}

- (void)setUnReadDot:(NSInteger)unReadMessageNum {
  _redDotImage.hidden = unReadMessageNum <= 0;
  _redDotLabel.hidden = YES;
  _redDotHeight.constant = 10.0f;
  _redDotWidth.constant = 10.0f;
  [self.redDotImage.layer setCornerRadius:5.0f];
}

@end
