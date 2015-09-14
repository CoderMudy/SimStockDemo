//
//  SimuTradeRevokeWrapper.m
//  SimuStock
//
//  Created by Mac on 14-9-3.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SimuTradeRevokeWrapper.h"
#import "StockUtil.h"

@implementation TradeRevokeElment

- (void)jsonToObject:(NSDictionary *)obj {
  self.catagory = [obj[@"category"] intValue];
  self.commissionId = obj[@"commissionId"];
  self.stockName = obj[@"stockName"];
  self.stockCode = obj[@"stockCode"];
  self.tradeType = [obj[@"tradeType"] integerValue];
  self.commissionPrice =
      [self formatPriceWithDictionary:obj withKey:@"commissionPrice"];
  self.commissionAmount = [obj[@"commissionAmount"] stringValue];
  self.state = [obj[@"state"] intValue];
  self.time = obj[@"commissionTime"];
  self.commissionType = [obj[@"commissionType"] intValue];

  self.concludePrice =
      [self formatPriceWithDictionary:obj withKey:@"concludePrice"];
  self.concludeAmount = [obj[@"concludeAmount"] stringValue];
  self.concludeTime = obj[@"concludeTime"];
}

- (NSString *)formatPriceWithDictionary:(NSDictionary *)dic
                                withKey:(NSString *)key {
  if (dic[key] == nil) {
    return @"0.00";
  }
  NSString *format = [StockUtil getPriceFormatWithTradeType:self.tradeType];
  return [NSString stringWithFormat:format, [dic[key] floatValue]];
}

- (NSString *)price {
  if (self.catagory == EntrustPriceMarket) {
    return EntrustStateDealDone == self.state ? self.concludePrice : @"--";
  } else {
    return self.commissionPrice;
  }
}

- (NSString *)amountString {
  if (self.catagory == EntrustPriceMarket) {
    return EntrustStateDealDone == self.state
               ? self.concludeAmount
               : self.commissionType == EntrustSellStock ? self.commissionAmount
                                                         : @"--";
  } else {
    return self.commissionAmount;
  }
}

- (NSString *)catagoryMarketFiexd {
  switch (self.catagory) {
  case EntrustPriceLimit:
    return @"限价";
  case EntrustPriceMarket:
    return @"市价";
  case EntrustPriceLimitProfit:
    return @"止盈";
  case EntrustPriceLimitLoss:
    return @"止损";
  }
  return @"";
}

- (NSString *)type {
  return self.commissionType == EntrustBuyStock ? @"买入" : @"卖出";
}

- (NSString *)status {
  switch (self.state) {
  case EntrustStateSubmited:
    return @"已报";

  case EntrustStateToRevoke:
    return @"待撤";

  case EntrustStateRevoked:
    return @"已撤";

  case EntrustStateDealDone:
    return @"已成";
  }
  return @"";
}

- (BOOL)canSelected {
  return EntrustStateSubmited == self.state;
}

- (NSString *)dateString {
  return [_time componentsSeparatedByString:@" "][0];
}

- (NSString *)timeString {
  return [_time componentsSeparatedByString:@" "][1];
}

- (NSString *)stockCode {
  if ([_stockCode length] == 8) {
    return [_stockCode substringFromIndex:2];
  }

  return _stockCode;
}

@end

@implementation SimuTradeRevokeWrapper

- (void)jsonToObject:(NSDictionary *)dictionary {
  [super jsonToObject:dictionary];
  NSArray *dataarray = dictionary[@"result"];
  if (dataarray == nil)
    return;
  for (NSDictionary *obj in dataarray) {
    TradeRevokeElment *elment = [[TradeRevokeElment alloc] init];
    if (elment) {
      [elment jsonToObject:obj];
      [self.dataArray addObject:elment];
    }
  }
}

- (id)init {
  self = [super init];
  if (self) {
    _dataArray = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)dealloc {

  [self.dataArray removeAllObjects];
}

+ (void)queryTradeCancleInfoesWithMatchId:(NSString *)matchId
                            withPageIndex:(NSString *)page
                             withCallBack:(HttpRequestCallBack *)callback {
  NSDictionary *parameters = @{
    @"matchid" : matchId,
    @"pagenum" : page,
    @"pagesize" : @"30"
  };

  NSString *url = [data_address
      stringByAppendingString:@"youguu/trade/commission/"
      @"query?matchid={matchid}&pagenum=" @"{pagenum}&pagesize={pagesize}"];

  JsonFormatRequester *requester = [[JsonFormatRequester alloc] init];
  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:@"GET"
                 withRequestParameters:parameters
                withRequestObjectClass:[SimuTradeRevokeWrapper class]
               withHttpRequestCallBack:callback];
}
/** 牛人计划查看委托 */
+ (void)requestTradeCancleInfoesWithAccountId:(NSString *)accoundId
                                 withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [CP_SuperTradeAction_Address
      stringByAppendingString:
          @"youguu/super_trade/commission_query?accountId={accountId}"];
  NSDictionary *dic = @{ @"accountId" : accoundId };

  JsonFormatRequester *requester = [[JsonFormatRequester alloc] init];
  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:@"GET"
                 withRequestParameters:dic
                withRequestObjectClass:[SimuTradeRevokeWrapper class]
               withHttpRequestCallBack:callback];
}
@end
