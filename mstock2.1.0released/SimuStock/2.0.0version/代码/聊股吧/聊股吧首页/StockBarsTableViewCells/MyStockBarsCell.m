
//  MyStockBarsCell.m
//  SimuStock
//
//  Created by Yuemeng on 14-11-27.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "MyStockBarsCell.h"
#import "Globle.h"
#import "CellBottomLinesView.h"
#import "HotStockBarListData.h"
#import "UIImageView+WebCache.h"

@implementation MyStockBarsCell

- (void)awakeFromNib {
  // Initialization code

  self.selectionStyle = UITableViewCellSelectionStyleNone;
  
  _whiteView.layer.borderWidth = 0.5;
  _whiteView.layer.borderColor =
      [[Globle colorFromHexRGB:Color_Gray_Edge] CGColor];
  self.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];

  _cellBottomLinesView = [CellBottomLinesView addBottomLinesToCell:self];
}

- (NSString *)reuseIdentifier
{
  return _reuseId;
}

  ///隐藏底线方法
- (void)hideCellBottomLinesView:(BOOL)hide
{
  hide ? (_cellBottomLinesView.hidden = YES) : (_cellBottomLinesView.hidden = NO);
}

- (void)refreshCellInfoWithData:(HotStockBarData *)hotStockBarData
{
    //设置头像
  NSURL *logoUrl = [NSURL URLWithString:hotStockBarData.logo];
  UIImage *normalLogo = [UIImage imageNamed:@"stockBarIcon"];
  [self.logoImageView setImageWithURL:logoUrl
                                placeholderImage:normalLogo];
  
  self.nameLabel.text = hotStockBarData.name;
  self.desLabel.text = hotStockBarData.des;
  
  NSInteger num = [[hotStockBarData.postNum stringValue] integerValue];
  NSString *numStr;
  if (num >= 100000) {
    numStr = [NSString stringWithFormat:@"%ld万+", (long)num / 10000];
  } else {
    numStr = [NSString stringWithFormat:@"%ld", (long)num];
  }
  
  NSMutableAttributedString *postAttr = [[NSMutableAttributedString alloc]
                                         initWithString:[NSString stringWithFormat:@"%@ 聊股", numStr]];
  [postAttr addAttribute:NSForegroundColorAttributeName
                   value:[Globle colorFromHexRGB:Color_Blue_but]
                   range:NSMakeRange(0, postAttr.length - 3)];
  self.postNumLabel.attributedText = postAttr;

}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
  if (highlighted) {
    self.backgroundColor = [Globle colorFromHexRGB:@"d9d9d9"];
  }else
  {
    self.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

@end
