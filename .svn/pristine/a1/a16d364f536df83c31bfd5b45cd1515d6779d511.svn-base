//
//  StockBuySellView.m
//  SimuStock
//
//  Created by 刘小龙 on 15/6/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

@interface StockBuySellView () {
  //记录 位置 价格 和 数量
  CGRect priceRect;
  CGRect amountRect;

  BOOL _oldBuySell;
  BOOL _oldMarketFixed;
}

@end

@implementation StockBuySellView

+ (StockBuySellView *)staticInitalizationStockBuySellView {
  NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"StockBuySellView"
                                                 owner:self
                                               options:nil];
  return [array lastObject];
}

// XIB 在这里设置
- (void)awakeFromNib {
  [super awakeFromNib];
  //设置背景框
  self.stockNameBackView.layer.borderColor =
      [[Globle colorFromHexRGB:@"#d5d5d5"] CGColor];
  self.stockNameBackView.layer.borderWidth = 0.5f;
  self.stockNameBackView.layer.masksToBounds = YES;

  //价格背景框
  self.buyPriceBackView.layer.borderColor =
      [[Globle colorFromHexRGB:@"#d5d5d5"] CGColor];
  self.buyPriceBackView.layer.borderWidth = 0.5f;
  self.buyPriceBackView.layer.masksToBounds = YES;

  //数量背景框
  self.buyAmountBackView.layer.borderColor =
      [[Globle colorFromHexRGB:@"#d5d5d5"] CGColor];
  self.buyAmountBackView.layer.borderWidth = 0.5f;
  self.buyAmountBackView.layer.masksToBounds = YES;
  //输入框
  self.stockCodeTF.contentVerticalAlignment =
      UIControlContentVerticalAlignmentCenter;
  self.stockCodeTF.adjustsFontSizeToFitWidth = YES;
  
  [self.stockCodeTF setValue:[Globle colorFromHexRGB:@"#939393"] forKeyPath:@"_placeholderLabel.textColor"];
  

  self.stockNameTF.contentVerticalAlignment =
      UIControlContentVerticalAlignmentCenter;
  self.stockNameTF.adjustsFontSizeToFitWidth = YES;

  self.buyAmountTF.contentVerticalAlignment =
      UIControlContentVerticalAlignmentCenter;
  self.buyAmountTF.adjustsFontSizeToFitWidth = YES;

  self.buyAmountTF.contentVerticalAlignment =
      UIControlContentVerticalAlignmentCenter;
  self.buyAmountTF.adjustsFontSizeToFitWidth = YES;

  //记录价格
  priceRect = self.buyPriceBackView.frame;
  amountRect = self.buyAmountBackView.frame;
}

///区别买入卖出 YES 为买 NO 为卖  YES 为市价 NO 为限价
- (void)accordingIncomingParametersShowBuyOrSell:(BOOL)buySell
                                 withMarketFixed:(BOOL)marketFixed {
  _oldBuySell = buySell;
  _oldMarketFixed = marketFixed;
  if (buySell) {
    //卖
    self.buyPrice.text = @"买入价格";
    self.buyAmount.text = @"买入数量";
    if (marketFixed) {
      //市价
      self.buyPrice.hidden = marketFixed;
      self.buyPriceBackView.hidden = marketFixed;
      self.buyAmount.hidden = marketFixed;
      self.buyAmountBackView.hidden = marketFixed;
    } else {
      self.buyPrice.hidden = marketFixed;
      self.buyPriceBackView.hidden = marketFixed;
      self.buyAmount.hidden = marketFixed;
      self.buyAmountBackView.hidden = marketFixed;
    }

  } else {
    //卖
    self.buyPrice.text = @"卖出价格";
    self.buyAmount.text = @"卖出数量";
    if (marketFixed) {
      //市价
      self.buyPrice.text = @"卖出数量";
      self.buyPriceBackView.hidden = marketFixed;
      self.buyAmount.hidden = marketFixed;
      self.buyAmountBackView.frame = priceRect;
      //[[self.buyAmountBackView superview] setNeedsLayout];
    } else {
      //限价
      self.buyPrice.text = @"卖出价格";
      self.buyAmount.hidden = marketFixed;
      self.buyPriceBackView.hidden = marketFixed;
      self.buyAmountBackView.frame = amountRect;
      //[[self.buyAmountBackView superview] setNeedsLayout];
    }
  }
}

- (void)layoutSubviews {
  [super layoutSubviews];
  if (_oldBuySell == NO) {
    [self accordingIncomingParametersShowBuyOrSell:_oldBuySell
                                   withMarketFixed:_oldMarketFixed];
  }
}
/** 绑定数据  */
- (void)bindData:(NSArray *)array {
  if (array.count > 0 && array) {
    self.stockCodeTF.text = array[0];
    self.stockNameTF.text = array[1];
    self.buyPriceTF.text = array[2];
    self.buyAmountTF.text = array[3];
  }
}
/** 清楚数据 */
- (void)clearData {
  self.stockNameTF.text = @"";
  self.stockCodeTF.text = @"";
  self.buyAmountTF.text = @"";
  self.buyPriceTF.text = @"";
}
@end
