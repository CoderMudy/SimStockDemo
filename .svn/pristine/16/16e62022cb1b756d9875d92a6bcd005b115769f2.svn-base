//
//  MarketConst.m
//  SimuStock
//
//  Created by Mac on 15/4/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MarketConst.h"
#import "TrendViewController.h"

@implementation Securities

- (void)jsonToObject:(NSDictionary *)dic {
  self.code = dic[@"code"];

  self.stockCode = dic[@"stockCode"];
  self.name = dic[@"name"];
  self.marketId = [dic[@"marketId"] integerValue];

  self.firstType = [dic[@"firstType"] integerValue];
  self.secondType = [dic[@"secondType"] integerValue];
  self.decimalDigits = [dic[@"decimalDigits"] integerValue];
}

- (void)showDetail {
  [TrendViewController showDetailWithStockCode:_code
                                 withStockName:_name
                                 withFirstType:[@(_firstType) stringValue]
                                   withMatchId:@"1"];
}

- (BOOL)isMarketIndex {
  return [FIRST_TYPE_INDEX isEqualToString:[@(_firstType) stringValue]];
}

- (BOOL)isFund {
  return [FIRST_TYPE_FND isEqualToString:[@(_firstType) stringValue]];
}

@end

@implementation B5S5TradingInfo

- (void)jsonToObject:(NSDictionary *)dic {

  self.buyPriceArray = @[
    dic[@"buyPrice1"],
    dic[@"buyPrice2"],
    dic[@"buyPrice3"],
    dic[@"buyPrice4"],
    dic[@"buyPrice5"],
  ];
  self.buyAmountArray = @[
    dic[@"buyAmount1"],
    dic[@"buyAmount2"],
    dic[@"buyAmount3"],
    dic[@"buyAmount4"],
    dic[@"buyAmount5"],
  ];
  self.sellPriceArray = @[
    dic[@"sellPrice1"],
    dic[@"sellPrice2"],
    dic[@"sellPrice3"],
    dic[@"sellPrice4"],
    dic[@"sellPrice5"],
  ];
  self.sellAmountArray = @[
    dic[@"sellAmount1"],
    dic[@"sellAmount2"],
    dic[@"sellAmount3"],
    dic[@"sellAmount4"],
    dic[@"sellAmount5"],
  ];
}

@end

@implementation MarketConst

@end
