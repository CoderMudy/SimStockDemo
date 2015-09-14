//
//  StockPriceStateCell.m
//  SimuStock
//
//  Created by Yuemeng on 15/4/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "StockPriceStateCell.h"
#import "CustomPageData.h"
#import "StockUtil.h"

@implementation StockPriceStateCell

- (NSString *)reuseIdentifier {
  return _reuseId;
}

- (void)bindStockPriceStateData:(StockPriceStateData *)data
                 lastClosePrice:(CGFloat)lastClosePrice
                    totalAmount:(long)totalAmount
                    priceFormat:(NSString *)priceFormat {
  _priceLabel.text = [NSString stringWithFormat:priceFormat, data.price];
  _priceLabel.textColor =
      [StockUtil getColorByFloat:(data.price - lastClosePrice)];
  _amountLabel.text = [NSString stringWithFormat:@"%lld", data.amount];
  _percentLabel.text =
      totalAmount == 0
          ? @"0"
          : [NSString stringWithFormat:@"%.2f%%",
                                       (float)data.amount / totalAmount * 100];
}

@end
