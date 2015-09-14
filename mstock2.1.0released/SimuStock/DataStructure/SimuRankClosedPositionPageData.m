//
//  SimuRankClosedPositionPageData.m
//  SimuStock
//
//  Created by moulin wang on 14-2-12.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SimuRankClosedPositionPageData.h"
#import "JsonFormatRequester.h"
#import "StockUtil.h"

@implementation ClosedPositionInfo

- (void)jsonToObject:(NSDictionary *)dic {
  self.seqID = [dic[@"seqId"] stringValue];
  self.positionID = [dic[@"positionId"] stringValue];
  self.stockCode = dic[@"stockCode"];
  self.stockName = dic[@"stockName"];
  self.createAt = dic[@"createAt"];
  self.closeAt = dic[@"closeAt"];
  self.totalDays = [dic[@"totalDays"] stringValue];
  self.profitRate = dic[@"profitRate"];
  NSString *firstType = [StockUtil queryFirstTypeWithStockCode:_stockCode
                                                 withStockName:_stockName];
  NSString *format = [StockUtil getPriceFormatWithFirstType:firstType];

  self.profit = [NSString stringWithFormat:format, [dic[@"profit"] floatValue]];
  if (self.profit) {
    if ([self.profit floatValue] < 0)
      self.bProfit = NO;
    else
      self.bProfit = YES;
  }
  self.tradeTimes = [dic[@"tradeTimes"] stringValue];
}

@end

@implementation SimuRankClosedPositionPageData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.closedPositionList = [[NSMutableArray alloc] init];
  NSArray *array = dic[@"result"];
  for (NSDictionary *subdic in array) {
    ClosedPositionInfo *item = [[ClosedPositionInfo alloc] init];
    [item jsonToObject:subdic];
    [self.closedPositionList addObject:item];
  }
}

- (NSArray *)getArray {
  return _closedPositionList;
}

/**请求清仓股票列表 */
+ (void)requestClosedPositionDataWithUid:(NSString *)uid
                             withMatchId:(NSString *)matchId
                              withReqnum:(NSString *)reqnum
                              withFromid:(NSString *)fromid
                            withCallback:(HttpRequestCallBack *)callback {
  NSDictionary *dic = @{
    @"userid" : uid,
    @"matchid" : matchId,
    @"reqnum" : reqnum,
    @"fromid" : fromid
  };
  [SimuRankClosedPositionPageData requestClosedPositionWithParameters:dic
                                                         withCallback:callback];
}

/**请求清仓股票列表 */
+ (void)requestClosedPositionWithParameters:(NSDictionary *)dic
                               withCallback:(HttpRequestCallBack *)callback {

  NSString *url =
      [data_address stringByAppendingString:@"youguu/position/closed/"
                    @"list?userid={userid}&matchid={matchid}"
                    @"&reqnum={reqnum}&fromid={fromid}"];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[SimuRankClosedPositionPageData class]
             withHttpRequestCallBack:callback];
}

- (void)dealloc {
  [self.closedPositionList removeAllObjects];
}
@end

@implementation SimuRankClosedPositionNumber

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.closeStockNumber = [SimuUtil changeIDtoStr:dic[@"cpNum"]];
}

/**请求清仓数量*/
+ (void)requestClosedPositionNumberWithUid:(NSString *)uid
                               withMatchId:(NSString *)matchId
                              wichCallback:(HttpRequestCallBack *)callback {
  NSString *url = [data_address
      stringByAppendingString:
          @"youguu/position/closed/num?userid={userid}&matchid={matchid}"];
  NSDictionary *dic = @{ @"userid" : uid, @"matchid" : matchId };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[SimuRankClosedPositionNumber class]
             withHttpRequestCallBack:callback];
}

@end
