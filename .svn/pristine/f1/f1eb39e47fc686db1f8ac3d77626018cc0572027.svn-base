//
//  RealTradeStockPriceInfo.m
//  SimuStock
//
//  Created by Mac on 14-9-22.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "RealTradeStockPriceInfo.h"
#import "RealTradeRequester.h"

@implementation RealTradeStockPriceInfo

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.stockName = dic[@"stockName"];
  self.stockCode = dic[@"stockCode"];
  self.suspend = [dic[@"tpbz"] intValue];
  self.entrustAmount = dic[@"wtsl"];

  self.latestPrice = dic[@"newPrice"];
  self.highPrice = dic[@"highPrice"];
  self.lowPrice = dic[@"lowPrice"];
  self.closePrice = dic[@"closePrice"];
  self.openPrice = dic[@"openPrice"];
  self.entrustPrice = dic[@"wtjg"];
  self.tradePrice = dic[@"jyjw"];

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

/**可买可卖数量计算,接口名称: plancount*/
+ (void)computeEntrustAmountWithStockCode:(NSString *)stockCode
                         withEntrustPrice:(NSString *)entrustPrice
                                    isBuy:(BOOL)isBuy
                             WithCallback:(HttpRequestCallBack *)callback {
  RealTradeRequester *requester = [[RealTradeRequester alloc] init];
  // wtlb: 委托类别， entrustCategory: 委托类别（1买，2卖）wtjg: 委托价格
  NSDictionary *dic = @{
    @"zqdm" : stockCode,
    @"wtlb" : (isBuy ? @"1" : @"2"),
    @"wtjg" : entrustPrice
  };
  id urlFactory = [RealTradeUrls getRealTradeUrlFactory];
  NSString *url = [urlFactory getPlancountPath];
  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:[urlFactory getBrokerRequstMethod]
                 withRequestParameters:dic
                withRequestObjectClass:[RealTradeStockPriceInfo class]
               withHttpRequestCallBack:callback];
}

@end
