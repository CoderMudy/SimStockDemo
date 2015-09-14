//
//  RealTradeFundTransferHistory.m
//  SimuStock
//
//  Created by Mac on 14-9-22.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "RealTradeFundTransferHistory.h"
#import "RealTradeRequester.h"

@implementation RealTradeFundTransferHistoryItem

- (void)jsonToObject:(NSDictionary *)dic {
  self.bank = dic[@"yh"];
  self.date = dic[@"rq"];
  self.time = dic[@"sj"];
  self.moneyAmount = dic[@"je"];
  self.transferDirection = dic[@"zzfx"];
  self.status = dic[@"zt"];
}
@end

@implementation RealTradeFundTransferHistory

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.history = [[NSMutableArray alloc] init];
  NSArray *historyItemArray = dic[@"result"];

  for (NSDictionary *dicHistoryItem in historyItemArray) {
    RealTradeFundTransferHistoryItem *historyItem =
        [[RealTradeFundTransferHistoryItem alloc] init];
    [historyItem jsonToObject:dicHistoryItem];
    [self.history addObject:historyItem];
  }
}

+ (void)loadFundTransferHistoryWithCallback:(HttpRequestCallBack *)callback {
  RealTradeRequester *requester = [[RealTradeRequester alloc] init];
  id urlFactory = [RealTradeUrls getRealTradeUrlFactory];
  NSString *url = [urlFactory getTransaccountDetail];
  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:[urlFactory getBrokerRequstMethod]
                 withRequestParameters:nil
                withRequestObjectClass:[RealTradeFundTransferHistory class]
               withHttpRequestCallBack:callback];
}

@end
