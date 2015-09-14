//
//  RealTradeTodayDeals.m
//  SimuStock
//
//  Created by Mac on 14-9-22.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "RealTradeDealList.h"
#import "RealTradeRequester.h"

@implementation RealTradeTodayDealItem

- (void)jsonToObject:(NSDictionary *)dic {
  self.stockName = dic[@"stockName"];
  self.stockCode = dic[@"stockCode"];
  self.totalMoney = dic[@"cjje"];
  self.price = dic[@"price"];
  self.amount = dic[@"amount"];
  self.date = dic[@"cjrq"];
  self.time = dic[@"time"];
  self.type = dic[@"type"];

  self.stampTax = dic[@"yinhuashui"];
  self.commission = dic[@"yongjin"];
  self.seq = [NSString stringWithFormat:@"%@", dic[@"seq"]];
}
@end

@implementation RealTradeDealList

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  NSLog(@"%@", dic);
  self.num = [dic[@"num"] intValue];
  self.list = [[NSMutableArray alloc] init];
  NSArray *dealItemArray = dic[@"result"];

  for (NSDictionary *dicDealItem in dealItemArray) {
    RealTradeTodayDealItem *dealItem = [[RealTradeTodayDealItem alloc] init];
    [dealItem jsonToObject:dicDealItem];
    [self.list addObject:dealItem];
  }
}

+ (void)loadTodayDealListWithCallback:(HttpRequestCallBack *)callback {
  RealTradeRequester *requester = [[RealTradeRequester alloc] init];
  id urlFactory = [RealTradeUrls getRealTradeUrlFactory];
  NSString *url = [urlFactory getTodaytransactionPath];
  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:[urlFactory getBrokerRequstMethod]
                 withRequestParameters:nil
                withRequestObjectClass:[RealTradeDealList class]
               withHttpRequestCallBack:callback];
}

/**加载历史成交列表 */
+ (void)loadHistoryDealListWithStartDate:(NSString *)startDate
                             withEndData:(NSString *)endDate
                            withPageSize:(NSString *)pageSize
                                 withSeq:(NSString *)seq
                            WithCallback:(HttpRequestCallBack *)callback {
  NSDictionary *dic = @{
    @"startdate" : startDate,
    @"enddate" : endDate,
    @"pagesize" : pageSize,
    @"seq" : seq
  };
  RealTradeRequester *requester = [[RealTradeRequester alloc] init];
  id urlFactory = [RealTradeUrls getRealTradeUrlFactory];
  NSString *url = [urlFactory getHistransactionPath];
  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:[urlFactory getBrokerRequstMethod]
                 withRequestParameters:dic
                withRequestObjectClass:[RealTradeDealList class]
               withHttpRequestCallBack:callback];
}
@end
