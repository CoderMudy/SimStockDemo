//
//  RealTradeTodayEntrust.h
//  今日委托列表和撤单接口
//  SimuStock
//
//  Created by Mac on 14-9-19.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "RealTradeTodayEntrust.h"
#import "RealTradeRequester.h"

@implementation RealTradeTodayEntrustItem

- (void)jsonToObject:(NSDictionary *)dic {

  self.commissionId = dic[@"commissionID"];
  self.tradeExchange = dic[@"jys"];
  self.stockHolderId = dic[@"gdh"];
  self.stockName = dic[@"stockName"];
  self.stockCode = dic[@"stockCode"];
  self.price = dic[@"price"];
  self.amount = [dic[@"amount"] longLongValue];
  self.entrustDate = dic[@"wtrq"];
  self.time = dic[@"time"];
  self.type = dic[@"type"];
  self.status = dic[@"status"];
  self.flag = [dic[@"flag"] integerValue];
}

- (BOOL)canSelected {
  return _flag == REVOKE_ENABLE;
}

- (NSString *)amountString {
  return [NSString stringWithFormat:@"%lld", _amount];
}

- (NSString *)dateString {
  return _entrustDate;
}

- (NSString *)timeString {
  return _time;
}

- (NSString *)stockCode {
  if ([_stockCode length] == 8) {
    return [_stockCode substringFromIndex:2];
  }

  return _stockCode;
}

-(NSString *)catagoryMarketFiexd
{
  return @"";
}


@end

@implementation RevokeTodayEntrust

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
}

@end
@implementation RealTradeTodayEntrust

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.num = [dic[@"num"] integerValue];
  self.result = [[NSMutableArray alloc] init];
  NSArray *securitiesCompanies = dic[@"result"];

  for (NSDictionary *securitiesCompany in securitiesCompanies) {
    RealTradeTodayEntrustItem *company =
        [[RealTradeTodayEntrustItem alloc] init];
    [company jsonToObject:securitiesCompany];
    [self.result addObject:company];
  }
}

/**
 获取今日委托列表
 */
+ (void)loadTodayEntruestList:(HttpRequestCallBack *)callback {

  id urlFactory = [RealTradeUrls getRealTradeUrlFactory];
  NSString *url = [urlFactory getTodayentrustPath];
  NSDictionary *dic = @{ @"flag" : @"0" };
  RealTradeRequester *requester = [[RealTradeRequester alloc] init];
  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:[urlFactory getBrokerRequstMethod]
                 withRequestParameters:dic
                withRequestObjectClass:[RealTradeTodayEntrust class]
               withHttpRequestCallBack:callback];
}

/**
 撤销委托
 */
+ (void)revokeTodayEntrusts:(NSString *)entrusts
               withCallBack:(HttpRequestCallBack *)callback {
  id urlFactory = [RealTradeUrls getRealTradeUrlFactory];
  NSString *url = [urlFactory getRevokePath];
  NSDictionary *dic = @{ @"wths" : entrusts };
  RealTradeRequester *requester = [[RealTradeRequester alloc] init];
  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:[urlFactory getBrokerRequstMethod]
                 withRequestParameters:dic
                withRequestObjectClass:[RevokeTodayEntrust class]
               withHttpRequestCallBack:callback];
}

@end
