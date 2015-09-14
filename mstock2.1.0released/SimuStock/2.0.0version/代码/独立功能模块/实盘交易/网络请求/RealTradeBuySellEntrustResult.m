//
//  RealTradeBuySellEntrustResult.m
//  SimuStock
//
//  Created by Mac on 14-9-22.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "RealTradeBuySellEntrustResult.h"
#import "RealTradeRequester.h"

@implementation RealTradeBuySellEntrustResult

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.commissionid = dic[@"commissionid"];
}
/** 买入下单操作 */
+ (void)buyStockWithStockCode:(NSString *)stockCode
                    withPrice:(NSString *)price
                   withAmount:(NSString *)amount
                 WithCallback:(HttpRequestCallBack *)callback {
  NSDictionary *dic = @{
    @"zqdm" : stockCode,
    @"wtjg" : price,
    @"wtsl" : amount,
    @"wtlb" : @"1"
  };
  RealTradeRequester *requester = [[RealTradeRequester alloc] init];
  id urlFactory = [RealTradeUrls getRealTradeUrlFactory];
  NSString *url = [urlFactory getEntrustorderPath];
  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:[urlFactory getBrokerRequstMethod]
                 withRequestParameters:dic
                withRequestObjectClass:[RealTradeBuySellEntrustResult class]
               withHttpRequestCallBack:callback];
}
/** 卖出下单操作 */
+ (void)sellStockWithStockCode:(NSString *)stockCode
                     withPrice:(NSString *)price
                    withAmount:(NSString *)amount
                  WithCallback:(HttpRequestCallBack *)callback {
  NSDictionary *dic = @{
    @"zqdm" : stockCode,
    @"wtjg" : price,
    @"wtsl" : amount,
    @"wtlb" : @"2"
  };
  RealTradeRequester *requester = [[RealTradeRequester alloc] init];
  id urlFactory = [RealTradeUrls getRealTradeUrlFactory];
  NSString *url = [urlFactory getEntrustorderPath];
  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:[urlFactory getBrokerRequstMethod]
                 withRequestParameters:dic
                withRequestObjectClass:[RealTradeBuySellEntrustResult class]
               withHttpRequestCallBack:callback];
}

@end
