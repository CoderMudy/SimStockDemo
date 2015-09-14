//
//  SiuSellStockViewCell.m
//  SimuStock
//
//  Created by Mac on 13-12-18.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "SiuSellStockViewCell.h"
#import "SimuUtil.h"
#import "StockUtil.h"


@implementation SiuSellStockViewCell

-(void)awakeFromNib{
  
  
  self.selectionStyle = UITableViewCellSelectionStyleDefault;
  //取消选中效果
  self.backgroundColor = [Globle colorFromHexRGB:@"f7f7f7"];
  self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
  self.selectedBackgroundView.backgroundColor =
  [Globle colorFromHexRGB:@"#d9ecf2"];
}
- (void)setCellData:(PositionInfo *)element {
  if (element == nil)
    return;

  _stockName.text = element.stockName;
  _stockNum.text = element.stockCode;
  _stockPorfit.text = element.profitRate;
  _stockPorfit.textColor = [StockUtil getColorByText:element.profitRate];
  _stockSellVlom.text = [NSString stringWithFormat:@"%lld",element.sellableAmount];
}

-(void)layoutSubviews
{
  [super layoutSubviews];
  [self.bottomLines resetViewWidth:self.width];
}

@end
