//
//  SimuStockInfoView.m
//  SimuStock
//
//  Created by Mac on 13-8-29.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "SimuStockInfoView.h"
#import "StockUtil.h"

@implementation SimuStockInfoView {
  NSArray *array;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  array = @[
    _curPriceValueLable,
    _riseLimitValueLable,
    _highestPriceValueLable,
    _downLimitValueLable,
    _lowestPriceValueLable,
    _aumoutValueLable,
    _moneyValueLable
  ];
}

//设定买卖状态
- (void)setTradeType:(BOOL)isBuyType {
  if (isBuyType) {
    //买入
    _aumoutLable.text = @"可买数:";
    _moneyLable.text = @"可用资金:";

  } else {
    //卖出
    _aumoutLable.text = @"可卖:";
    _moneyLable.text = @"持股数:";
  }
}

- (void)setUserPageData:(SimuTradeBaseData *)stockInfo isBuy:(BOOL)isBuy {
  if (stockInfo == nil)
    return;
  for (UILabel *label in array) {
    label.textAlignment = NSTextAlignmentLeft;
  }
  CGFloat closeprice = stockInfo.closePrice;
  NSString *format =
      [StockUtil getPriceFormatWithTradeType:stockInfo.tradeType];
  //最新价格
  CGFloat m_newprice = stockInfo.newstockPrice;
  _curPriceValueLable.text =
      [NSString stringWithFormat:format, stockInfo.newstockPrice];
  _curPriceValueLable.textColor =
      [StockUtil getColorByFloat:(m_newprice - closeprice)];

  //最高价格
  _highestPriceValueLable.text =
      [NSString stringWithFormat:format, stockInfo.highestPrice];
  _highestPriceValueLable.textColor =
      [StockUtil getColorByFloat:(stockInfo.highestPrice - closeprice)];

  //涨停
  _riseLimitValueLable.text =
      [NSString stringWithFormat:format, stockInfo.uplimitedPrice];
  _riseLimitValueLable.textColor =
      [StockUtil getColorByFloat:(stockInfo.uplimitedPrice - closeprice)];

  //跌停
  _downLimitValueLable.text =
      [NSString stringWithFormat:format, stockInfo.downlimitedPrice];
  _downLimitValueLable.textColor =
      [StockUtil getColorByFloat:(stockInfo.downlimitedPrice - closeprice)];

  //最低
  _lowestPriceValueLable.text =
      [NSString stringWithFormat:format, stockInfo.lowestPrice];
  _lowestPriceValueLable.textColor =
      [StockUtil getColorByFloat:(stockInfo.lowestPrice - closeprice)];

  if (isBuy) {
    //买入页面
    //可买
    _aumoutValueLable.text = stockInfo.maxBuy;
    //可用资金
    _moneyValueLable.text =
        [NSString stringWithFormat:format, stockInfo.fundsable];
  } else {
    //卖出
    //可卖
    _aumoutValueLable.text = stockInfo.sellable;
    //持股数
    _moneyValueLable.text = stockInfo.holdstock;
  }
}
//设定可买数量
- (void)setBuyAmount:(NSString *)amount {
  _aumoutValueLable.text = amount;
}
//清除所有数据
- (void)clearControlData {
  UIColor *color = [StockUtil getColorByText:@"--"];
  for (UILabel *label in array) {
    label.text = @"--";
    label.textColor = color;
    label.textAlignment = NSTextAlignmentCenter;
  }
}

@end
