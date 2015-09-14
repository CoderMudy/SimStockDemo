//
//  SimuDoDealSubmitData.m
//  SimuStock
//
//  Created by Yuemeng on 14-11-17.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SimuDoDealSubmitData.h"
#import "JsonFormatRequester.h"

@implementation SimuDoDealSubmitData

- (void)jsonToObject:(NSDictionary *)dic {
  //[super jsonToObject:dic];
  NSLog(@"买入卖出 请求成功");
}

/** 市价买入  */
+ (void)requestMarketBuyStockMatchID:(NSString *)mathcId
                       withStockCode:(NSString *)stockCode
                      withFrozenFund:(NSString *)frozenFund
                           withToken:(NSString *)token
                       withTradeType:(NSString *)tradeType
                        withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [data_address stringByAppendingString:@"youguu/trade/buy/"
                                @"submit_cur?matchid={matchid}&stockcode={"
                                @"stockcode}&frozenfund={frozenfund}&token={"
                                @"token}&trade_type={trade_type}"];
  NSDictionary *dic = @{
    @"matchid" : mathcId,
    @"stockcode" : stockCode,
    @"frozenfund" : frozenFund,
    @"token" : token,
    @"trade_type" : tradeType
  };
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[SimuDoDealSubmitData class]
             withHttpRequestCallBack:callback];
}

/** 市价卖出  */
+ (void)requestMarketSellMatchID:(NSString *)mathcID
                   withStockCode:(NSString *)stockCode
                      withAmount:(NSString *)amount
                       withToken:(NSString *)token
                   withTradeType:(NSString *)tradeType
                    withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [data_address
      stringByAppendingString:@"youguu/trade/sell/"
                              @"submit_cur?matchid={matchid}&stockcode={"
                              @"stockcode}&amount={amount}&token={token}&"
                              @"trade_type={trade_type}"];
  NSDictionary *dic = @{
    @"matchid" : mathcID,
    @"stockcode" : stockCode,
    @"amount" : amount,
    @"token" : token,
    @"trade_type" : tradeType
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[SimuDoDealSubmitData class]
             withHttpRequestCallBack:callback];
}

/** 限价买入  */
+ (void)requestBuyStockWithMatchId:(NSString *)matchId
                     withStockCode:(NSString *)stockCode
                    withStockPrice:(NSString *)stockPrice
                  withStockAmounts:(NSString *)stockAmounts
                         withToken:(NSString *)token
                      withCallback:(HttpRequestCallBack *)callback {

  NSString *url =
      [data_address stringByAppendingString:@"youguu/trade/buy/"
                    @"submit?matchid={matchid}&stockcode={stockcode}"
                    @"&price={price}&amount={amount}&token={token}"];

  NSDictionary *dic = @{
    @"matchid" : matchId,
    @"stockcode" : stockCode,
    @"price" : stockPrice,
    @"amount" : stockAmounts,
    @"token" : token
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[SimuDoDealSubmitData class]
             withHttpRequestCallBack:callback];
}

/** 限价卖出  */
+ (void)requestSellWithMatchId:(NSString *)matchId
                 withStockCode:(NSString *)stockCode
                withStockPrice:(NSString *)stockPrice
              withStockAmounts:(NSString *)stockAmounts
                     withToken:(NSString *)token
                  withCallback:(HttpRequestCallBack *)callback {

  NSString *url =
      [data_address stringByAppendingString:@"youguu/trade/sell/"
                    @"submit?matchid={matchid}&stockcode={stockcode}"
                    @"&price={price}&amount={amount}&token={token}"];

  NSDictionary *dic = @{
    @"matchid" : matchId,
    @"stockcode" : stockCode,
    @"price" : stockPrice,
    @"amount" : stockAmounts,
    @"token" : token
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[SimuDoDealSubmitData class]
             withHttpRequestCallBack:callback];
}

/** 牛人买入  */
+ (void)requestBuyAccountId:(NSString *)accountId
              withSctokCode:(NSString *)stockCode
               withCategory:(NSString *)category
                  withPrice:(NSString *)price
                   withFund:(NSString *)funds
                 withAmount:(NSString *)amount
                  withToken:(NSString *)token
               withCallback:(HttpRequestCallBack *)callback {

  NSString *url = [CP_SuperTradeAction_Address
      stringByAppendingString:@"youguu/super_trade/"
                              @"buy?accountId={accountId}&category={category}&"
                              @"stockCode={stockCode}&price={price}&funds={"
                              @"funds}&amount={amount}&token={token}"];
  NSDictionary *dic = @{
    @"accountId" : accountId,
    @"category" : category,
    @"stockCode" : stockCode,
    @"price" : price,
    @"funds" : funds,
    @"amount" : amount,
    @"token" : token
  };
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[SimuDoDealSubmitData class]
             withHttpRequestCallBack:callback];
}

/** 牛人卖出 */
+ (void)requestSellAccountId:(NSString *)accountId
               withSctokCode:(NSString *)stockCode
                withCategory:(NSString *)category
                   withPrice:(NSString *)price
                  withAmount:(NSString *)amount
                   withToken:(NSString *)token
                withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [CP_SuperTradeAction_Address
      stringByAppendingString:@"youguu/super_trade/"
                              @"sell?accountId={accountId}&category={category}"
                              @"&stockCode={stockCode}&price={price}&amount={"
                              @"amount}&token={token}"];
  NSDictionary *dic = @{
    @"accountId" : accountId,
    @"category" : category,
    @"stockCode" : stockCode,
    @"price" : price,
    @"amount" : amount,
    @"token" : token
  };
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[SimuDoDealSubmitData class]
             withHttpRequestCallBack:callback];
}

@end
