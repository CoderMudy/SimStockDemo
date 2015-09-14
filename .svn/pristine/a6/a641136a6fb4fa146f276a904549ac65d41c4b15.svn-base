//
//  HotStockTopicCell.m
//  SimuStock
//
//  Created by Yuemeng on 14-11-27.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "HotStockTopicCell.h"
#import "Globle.h"
#import "CellBottomLinesView.h"
#import "HotStockTopicListData.h"
#import "UIImageView+WebCache.h"
#import "StockUtil.h"

@implementation HotStockTopicCell

- (void)awakeFromNib {
  // Initialization code

  self.selectionStyle = UITableViewCellSelectionStyleNone;
  _whiteView.layer.borderWidth = 0.5;
  _whiteView.layer.borderColor =
      [[Globle colorFromHexRGB:Color_Gray_Edge] CGColor];
  self.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];

  [CellBottomLinesView addBottomLinesToCell:self];
}

- (NSString *)reuseIdentifier
{
  return _reuseId;
}

- (void)refreshCellInfoWithData:(HotStockTopicData *)hotStockTopicData
{
    //设置头像
  NSURL *logoUrl = [NSURL URLWithString:hotStockTopicData.logo];
  UIImage *normalLogo = [UIImage imageNamed:@"stockBarIcon"];
  [self.logoImageView setImageWithURL:logoUrl
                                  placeholderImage:normalLogo];
    //设置股票名称+股票代码
  NSString *stockName = hotStockTopicData.stockName;
  NSString *stockCode;
  if (hotStockTopicData.stockCode.length == 8) {
    stockCode = [hotStockTopicData.stockCode substringFromIndex:2];
  } else {
    stockCode = hotStockTopicData.stockCode;
  }
  
  NSMutableAttributedString *stockNameAndCode =
  [[NSMutableAttributedString alloc]
   initWithString:[NSString stringWithFormat:@"%@(%@)", stockName,
                   stockCode]];
  [stockNameAndCode addAttribute:NSForegroundColorAttributeName
                           value:[Globle colorFromHexRGB:Color_Text_Common]
                           range:NSMakeRange(0, stockName.length)];
  [stockNameAndCode
   addAttribute:NSForegroundColorAttributeName
   value:[Globle colorFromHexRGB:Color_Stock_Code]
   range:NSMakeRange(stockName.length,
                     stockNameAndCode.length - stockName.length)];
  [self.nameLabel setAttributedText:stockNameAndCode];
  
    //聊股数量
  NSInteger num = [[hotStockTopicData.postNum stringValue] integerValue];
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
  
    //张红跌绿
  UIColor *rateColor =
  [StockUtil getColorByChangePercent:hotStockTopicData.changeRate];
  
  self.priceLabel.text = hotStockTopicData.price;
  self.priceLabel.textColor = rateColor;
  self.changeRateLabel.text = hotStockTopicData.changeRate;
  self.changeRateLabel.textColor = rateColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
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
@end
