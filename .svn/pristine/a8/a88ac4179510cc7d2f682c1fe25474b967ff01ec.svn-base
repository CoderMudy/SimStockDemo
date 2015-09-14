//
//  PriceBuySellTool.m
//  SimuStock
//
//  Created by 刘小龙 on 15/7/27.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "PriceBuySellTool.h"
#import "StockUtil.h"
#import "SimuTradeBaseData.h"
#import "StockBuySellView.h"

@implementation PriceBuySellTool

/** 市价计算方法 或 限价计算方法*/
+ (NSInteger)
marketFixedFoundsShowLableWithSimuTradeData:(SimuTradeBaseData *)data
                            withBuySellType:(MarketFixedPriceType)type {
  //最大可买数
  NSInteger buyMaxAmount = [data.maxBuy longLongValue];
  //股票类型 1 基金 0 股票
  NSString *format = [StockUtil getPriceFormatWithTradeType:data.tradeType];
  //区分 市价 和 限价
  NSString *stockPrice = nil;
  if (type == MarketPriceType) {
    stockPrice = [NSString stringWithFormat:format, data.uplimitedPrice];
  } else if (type == FixedPriceType) {
    stockPrice = [NSString stringWithFormat:format, data.buyPrice];
  }
  //手续费
  CGFloat amountInt =
      ([stockPrice floatValue] * buyMaxAmount * data.feeRateInt) / 10000;
  if (amountInt < data.minFee) {
    amountInt = data.minFee;
  }
  if (buyMaxAmount) {
    return amountInt + [stockPrice floatValue] * buyMaxAmount + 0.5;
  } else {
    return 0;
  }
}

/** 滑块 滑动时 计算市价 限价 金额 */
+ (NSInteger)fixedSliederFoundsWithNewPrice:(NSString *)price
                                 withAmount:(NSInteger)amount
                          withSimuTradeData:(SimuTradeBaseData *)data
                            withBuySellType:(MarketFixedPriceType)type {

  //股票类型 1 基金 0 股票
  NSString *format = [StockUtil getPriceFormatWithTradeType:data.tradeType];
  NSString *priceFloat = 0;
  if (type == MarketPriceType) {
    priceFloat = [NSString stringWithFormat:format, data.uplimitedPrice];
  } else if (type == FixedPriceType) {
    priceFloat = price;
  }
  CGFloat amountInt =
      ([priceFloat floatValue] * amount * data.feeRateInt) / 10000;
  if (amountInt < data.minFee) {
    amountInt = data.minFee;
  }
  if (amount > 0) {
    return amountInt + [priceFloat floatValue] * amount + 0.5;
  } else {
    return 0;
  }
}

/** 资金选择按钮点击后计算滑块值 */
+ (NSInteger)moneryFoundsForSliederValueWithFunds:(NSInteger)funds
                                withSimuTradeData:(SimuTradeBaseData *)data
                        withStockBuySellTextFiled:
                            (StockBuySellView *)buySellView {
  CGFloat price = [buySellView.buyPriceTF.text doubleValue];
  NSInteger number =
      (10000 * funds) / (price * data.feeRateInt + (10000 * price));
  return number / 100;
}

/** 资金选择后 计算 限价市值 */
+ (NSInteger)moreFundsButtonDownWithSimuTradeData:(SimuTradeBaseData *)data
                             withStockBuySellView:
                                 (StockBuySellView *)buySellView
                                       withAmount:(NSInteger)amount {
  CGFloat price = [buySellView.buyPriceTF.text doubleValue];
  CGFloat amountInt = (price * amount * data.feeRateInt) / 10000;
  if (amountInt < data.minFee) {
    amountInt = data.minFee;
  }
  if (amount) {
    return amountInt + price * amount + 0.5;
  } else {
    return 0;
  }
}

/** 判断价格是否合理 */
+ (NSString *)reasonablePrice:(NSString *)price
              withBuySellType:(BuySellType)type
            withSimuTradeData:(SimuTradeBaseData *)data {
  NSString *content = nil;
  NSString *buySell = nil;

  double lowPrice = 0.0f;
  double highPrice = 0.0f;
  double inputPrice = [price doubleValue];
  //股票类型 1 基金 0 股票
  NSString *format = [StockUtil getPriceFormatWithTradeType:data.tradeType];
  if (data) {
    lowPrice =
        [[NSString stringWithFormat:format, data.downlimitedPrice] doubleValue];
    highPrice =
        [[NSString stringWithFormat:format, data.uplimitedPrice] doubleValue];
  }
  if (type == StockBuyType) {
    buySell = @"买入";
  } else if (type == StockSellType) {
    buySell = @"卖出";
  }
  if (inputPrice < lowPrice || inputPrice > highPrice) {
    NSString *format = [StockUtil getPriceFormatWithTradeType:data.tradeType];
    content = [NSString
        stringWithFormat:@"%@价格只能在%@元和%@元之间，请重新输入", buySell,
                         [NSString stringWithFormat:format, lowPrice],
                         [NSString stringWithFormat:format, highPrice]];
    return content;
  }
  return @"";
}

/** 根据价格变化 来计算 资金值 */
+ (NSInteger)priceChangeCalculationFundsWihtPrcie:(NSString *)price
                                       withAmount:(NSInteger)amout
                                withSimuTradeData:(SimuTradeBaseData *)data {
  CGFloat tempPrice = [price doubleValue];
  //手续费
  CGFloat amountInt = (tempPrice * amout * data.feeRateInt) / 10000;
  if (amountInt < data.minFee) {
    amountInt = data.minFee;
  }
  if (tempPrice > 0) {
    return amountInt + tempPrice * amout + 0.5;
  } else {
    return 0;
  }
}

@end
