//
//  FirmBySellStatisticsInterface.m
//  SimuStock
//
//  Created by moulin wang on 15/5/14.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "FirmBySellStatisticsInterface.h"
#import "WFDataSharingCenter.h"
#import "RealTradeRequester.h"

@implementation FirmBySellStatisticsInterface

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
}

//实盘统计 买入卖出 统计接口 还有撤单界面
+ (void)
    requestFirmByOrSellStatisticeWithSotckName:(NSString *)stockName
                                 withStockCode:(NSString *)stockCode
                                withStockPrice:(NSString *)stockPrice
                               withStockAmount:(NSString *)stockAmount
                                  withByOrSell:(NSString *)isByOrSellOrChenchan
                                  withCallback:(HttpRequestCallBack *)callback {

  NSString *url = [NSString stringWithFormat:@"%@stat/stockOrderStat", stat_address];
  NSString *brokerUserId = [WFDataSharingCenter shareDataCenter].brokerUserId;
  NSString *brokerId =
      [RealTradeUrls singleInstance].apexSoftUrlFactory.brokerId;
  NSString *ursrID = [SimuUtil getUserID];
  NSDictionary *dic = nil;
  if ([isByOrSellOrChenchan isEqualToString:@"买入"] ||
      [isByOrSellOrChenchan isEqualToString:@"卖出"]) {
    NSString *byOrSell =
        [isByOrSellOrChenchan isEqualToString:@"买入"] ? @"1" : @"2";
    dic = @{
      @"type" : byOrSell,
      @"stockCode" : stockCode,
      @"stockName" : stockName,
      @"amount" : stockAmount,
      @"price" : stockPrice,
      @"brokerId" : brokerId,
      @"brokerUserId" : brokerUserId,
      @"userid" : ursrID
    };
  } else if ([isByOrSellOrChenchan isEqualToString:@"撤单"]) {
    NSString *chenchan = @"3";
    dic = @{
      @"type" : chenchan,
      @"brokerId" : brokerId,
      @"brokerUserId" : brokerUserId,
      @"userid" : ursrID
    };
  }

  RealTradeRequester *request = [[RealTradeRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"POST"
               withRequestParameters:dic
              withRequestObjectClass:[FirmBySellStatisticsInterface class]
             withHttpRequestCallBack:callback];
}

@end
