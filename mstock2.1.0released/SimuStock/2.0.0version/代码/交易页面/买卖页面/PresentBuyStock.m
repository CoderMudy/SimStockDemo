//
//  PresentBuyStock.m
//  SimuStock
//
//  Created by Mac on 15/7/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "PresentBuyStock.h"
#import "SimuTradeBaseData.h"
#import "StockUtil.h"

@implementation PresentBuyStockCommon {
  /** 买入查询数据 */
  SimuTradeBaseData *simuBuyQueryData;
}

- (BOOL)validateStockSelected {
  if (self.buySellView.stockCodeTF.text.length == 0) {
    [self alertShow:@"请先输入股票代码"];
    return NO;
  }
  return YES;
}

//判断输入的价格是否在正确的价格区间
- (BOOL)validateBuyPrice:(NSString *)priceStr {
  NSString *content;
  CGFloat lowPrice = 0.0f;
  CGFloat highPrice = 0.0f;
  CGFloat inputPrice = [priceStr doubleValue];
  if (simuBuyQueryData) {
    lowPrice = simuBuyQueryData.lowestPrice;
    highPrice = simuBuyQueryData.uplimitedPrice;
  }
  if (inputPrice < lowPrice || inputPrice > highPrice) {
    NSString *format =
        [StockUtil getPriceFormatWithTradeType:simuBuyQueryData.tradeType];
    content = [NSString
        stringWithFormat:
            @"买入价格只能在%@元和%@元之间，请重新输入",
            [NSString stringWithFormat:format, lowPrice],
            [NSString stringWithFormat:format, highPrice]];

    [self alertShow:content];
    return NO;
  }
  return YES;
}

- (void)alertShow:(NSString *)message {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                  message:message
                                                 delegate:nil
                                        cancelButtonTitle:@"确定"
                                        otherButtonTitles:nil, nil];
  [alert show];
}

@end

@implementation PresentBuyStock

-(void)doBuyStockRequest{
  [self.buySellView endEditing:YES];
  

}

@end
