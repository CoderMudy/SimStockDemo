//
//  StockTradeDetailCell.m
//  SimuStock
//
//  Created by Yuemeng on 15/4/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "StockTradeDetailCell.h"
#import "CustomPageData.h"
#import "StockUtil.h"

@implementation StockTradeDetailCell

- (NSString *)reuseIdentifier {
  return _reuseId;
}

- (void)bindStockTradeDetailData:(StockTradeDetailData *)data
                  lastClosePrice:(float)lastClosePrice
                     priceFormat:(NSString *)priceFormat {
  //时间
  _timeLabel.text = [StockUtil timeFromNSIntegerWithSec:data.time];
  //价格
  _priceLabel.textColor =
      [StockUtil getColorByFloat:(data.price - lastClosePrice)];
  _priceLabel.text = [NSString stringWithFormat:priceFormat, data.price];
  //成交量
  NSString *wind = data.wind;
  if ([wind isEqualToString:@"B"]) {
    _amountLabel.textColor = [Globle colorFromHexRGB:Color_Red];
  } else if ([wind isEqualToString:@"S"]) {
    _amountLabel.textColor = [Globle colorFromHexRGB:Color_Green];
  } else {
    _amountLabel.textColor = [Globle colorFromHexRGB:Color_Text_Common];
  }
  _amountLabel.text = [NSString stringWithFormat:@"%lld", data.amount];
}

@end
