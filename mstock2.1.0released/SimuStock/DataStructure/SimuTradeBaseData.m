//
//  SimuTradeBaseData.m
//  SimuStock
//
//  Created by Yuemeng on 14-11-17.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SimuTradeBaseData.h"
#import "JsonFormatRequester.h"

@implementation SimuTradeBaseData

- (void)jsonToObject:(NSDictionary *)dic {

  [super jsonToObject:dic];
  self.token = dic[@"token"];
  NSLog(@"self.token = %@", self.token);
  NSMutableDictionary *dictionary = dic[@"result"];
  //可买数量
  self.stockamount = [dictionary[@"buyAble"] integerValue];
  //收盘价格
  self.closePrice = [dictionary[@"lastClosePrice"] doubleValue];
  //跌停
  self.downlimitedPrice = [dictionary[@"downLimit"] doubleValue];
  //可用资金
  self.fundsable = [dictionary[@"fundsAble"] doubleValue];
  //最高价
  self.highestPrice = [dictionary[@"highPrice"] doubleValue];
  //最低价
  self.lowestPrice = [dictionary[@"lowPrice"] doubleValue];
  //最新价
  self.newstockPrice = [dictionary[@"curPrice"] doubleValue];
  //成本价
  self.costPri = [dictionary[@"costPri"] doubleValue];
  //最新价
  self.profitRate = [dictionary[@"profitRate"] stringValue];
  //开盘价格
  self.openPrice = [dictionary[@"openPrice"] doubleValue];
  //股票代码
  self.stockCode = dictionary[@"stockCode"];
  //股票名称
  self.stockName = dictionary[@"stockName"];
  //涨停
  self.uplimitedPrice = [dictionary[@"upLimit"] doubleValue];
  //佣金
  self.commission = dictionary[@"feeRate"];

  //持股数
  self.holdstock = [dictionary[@"stockHolds"] stringValue];
  //佣金比例，按照万分之一处理
  self.feeRateInt = [dictionary[@"feeRateInt"] integerValue];
  //传入资金的最大可买
  self.maxBuy = [NSString
      stringWithFormat:@"%lld", [dictionary[@"maxBuy"] longLongValue]];
  //最小手续费
  self.minFee = [dictionary[@"minFee"] doubleValue];
  //买入价格
  self.buyPrice = [dictionary[@"buyPrice"] doubleValue];
  //买入价格
  self.salePrice = [dictionary[@"salePrice"] doubleValue];
  //交易类型
  self.tradeType = [dictionary[@"tradeType"] integerValue];
  //止盈价
  self.stopWinPri = [dictionary[@"stopWinPri"] stringValue];
  //止盈比例
  self.stopWinRate = [dictionary[@"stopWinRate"] stringValue];
  //止损价
  self.stopLosePri = [dictionary[@"stopLosePri"] stringValue];
  //止损比例
  self.stopLoseRate = [dictionary[@"stopLoseRate"] stringValue];

#pragma 卖股票查询
  //可卖股数
  self.sellable = [dictionary[@"sellAble"] stringValue];
  //印花税收
  self.tax = dictionary[@"taxRate"];
}

+ (void)requestSimuBuyQueryDataWithMatchId:(NSString *)matchId
                             withStockCode:(NSString *)stockCode
                            withStockPrice:(NSString *)stockPrice
                             withStockFund:(NSString *)stockFund
                              withCallback:(HttpRequestCallBack *)callback {

  NSString *url =
      [data_address stringByAppendingString:@"youguu/trade/buy/"
                    @"query?matchid={matchid}&stockcode={stockcode}&"
                    @"price={price}&fund={fund}&version=1"];

  NSDictionary *dic = @{
    @"matchid" : matchId,
    @"stockcode" : stockCode,
    @"price" : [@"" isEqualToString:stockPrice] ? @"0" : stockPrice,
    @"fund" : stockFund,
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[SimuTradeBaseData class]
             withHttpRequestCallBack:callback];
}

+ (void)requestSimuDoSellQueryDataWithMatchId:(NSString *)matchId
                                withStockCode:(NSString *)stockCode
                                 withCatagory:(NSString *)catagory
                                 withCallback:(HttpRequestCallBack *)callback {
  // data_address  @"http://192.168.1.166:8080/"
  NSString *url =
      [data_address stringByAppendingString:@"youguu/trade/sell/"
                    @"query?matchid={matchid}&stockcode={stockCode}&"
                    @"category={category}&version=1"];

  NSDictionary *dic = @{
    @"matchid" : matchId,
    @"stockCode" : stockCode,
    @"category" : catagory
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[SimuTradeBaseData class]
             withHttpRequestCallBack:callback];
}

+ (void)requestProfitAndStopWithMatchId:(NSString *)matchId
                          withStockCode:(NSString *)stockCode
                             withAmount:(NSString *)amount
                              withToken:(NSString *)token
                           withCategory:(NSString *)category
                              withPrice:(NSString *)price
                           withCallback:(HttpRequestCallBack *)callback {

  NSString *url = [data_address stringByAppendingString:@"youguu/trade/sell/"
                                @"stop?matchid={matchid}&stockcode={stockcode}&"
                                @"amount={amount}&token={token}&category={"
                                @"category}&price={price}"];

  NSDictionary *dic = @{
    @"matchid" : matchId,
    @"stockcode" : stockCode,
    @"amount" : amount,
    @"token" : token,
    @"category" : category,
    @"price" : price
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[SimuTradeBaseData class]
             withHttpRequestCallBack:callback];
}

/** 牛人买入查询 */
+ (void)requestExpertPlanBuy:(NSString *)accountId
                withCategory:(NSString *)category
               withStockCode:(NSString *)stockCode
                   withPrice:(NSString *)price
                   withFunds:(NSString *)funds
                withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [CP_SuperTradeAction_Address
      stringByAppendingString:@"youguu/super_trade/"
      @"buy_query?accountId={accountId}&category={"
      @"category}&stockCode={stockCode}&price={price}&" @"funds={funds}"];
  NSDictionary *dic = @{
    @"accountId" : accountId,
    @"category" : category,
    @"price" : [@"" isEqualToString:price] ? @"0" : price,
    @"stockCode" : stockCode,
    @"funds" : funds
  };
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[SimuTradeBaseData class]
             withHttpRequestCallBack:callback];
}

/** 牛人卖出查询 */
+ (void)requestExpertPlanSell:(NSString *)accountId
                 withCategory:(NSString *)category
                withStockCode:(NSString *)stockCode
                 withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [CP_SuperTradeAction_Address
      stringByAppendingString:@"youguu/super_trade/"
      @"sell_query?accountId={accountId}&category={"
      @"category}&stockCode={stockCode}"];
  NSDictionary *dic = @{
    @"accountId" : accountId,
    @"category" : category,
    @"stockCode" : stockCode
  };
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[SimuTradeBaseData class]
             withHttpRequestCallBack:callback];
}

/** 牛人止盈止损 */
+ (void)requestExpertProfitAndStopWithAccountId:(NSString *)accountId
                                   withCategory:(NSString *)category
                                  withStockCode:(NSString *)stockCode
                                      withPrice:(NSString *)price
                                     withAmount:(NSString *)amount
                                      withToken:(NSString *)token
                                   withCallback:
                                       (HttpRequestCallBack *)callback {

  NSString *url = [CP_SuperTradeAction_Address
      stringByAppendingString:
          @"youguu/super_trade/sell?accountId={accountId}&category={"
      @"category}&stockCode={stockCode}&price={"
      @"price}&amount={amount}&token={token}"];

  NSDictionary *dic = @{
    @"accountId" : accountId,
    @"category" : category,
    @"price" : price,
    @"amount" : amount,
    @"stockCode" : stockCode,
    @"token" : token
  };
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[SimuTradeBaseData class]
             withHttpRequestCallBack:callback];
}

@end
