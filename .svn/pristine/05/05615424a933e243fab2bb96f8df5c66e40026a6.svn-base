//
//  MoreSelectedTableViewCell.m
//  SimuStock
//
//  Created by jhss on 15/6/29.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MoreSelectedTableViewCell.h"
#import "Globle.h"

@implementation MoreSelectedTableViewCell

- (void)awakeFromNib {
  // Initialization code
  //分割线
  UIView *blackLine =
      [[UIView alloc] initWithFrame:CGRectMake(13, self.bottom - 1, 54, 0.5f)];
  blackLine.backgroundColor = [Globle colorFromHexRGB:Color_Black alpha:0.5f];
  blackLine.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
  [self addSubview:blackLine];

  UIView *whiteLine = [[UIView alloc]
      initWithFrame:CGRectMake(13, self.bottom - 0.5f, 54, 0.5f)];
  whiteLine.backgroundColor = [Globle colorFromHexRGB:Color_White alpha:0.08f];
  whiteLine.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
  [self addSubview:whiteLine];
  
  _selectedNameLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  self.contentView.backgroundColor =
      [Globle colorFromHexRGB:(selected ? Color_Black : Color_Little_Black)
                        alpha:0.85f];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
  self.contentView.backgroundColor =
      [Globle colorFromHexRGB:(highlighted ? Color_Black : Color_Little_Black)
                        alpha:0.85f];
}
@end
