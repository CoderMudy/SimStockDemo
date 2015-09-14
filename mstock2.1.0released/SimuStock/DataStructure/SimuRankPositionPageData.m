//
//  SimuRankPositionPageData.m
//  SimuStock
//
//  Created by moulin wang on 14-2-12.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SimuRankPositionPageData.h"
#import "JsonFormatRequester.h"

@implementation PositionInfo

- (void)jsonToObject:(NSDictionary *)dic {
  self.seqid = [dic[@"seqId"] stringValue];
  self.stockCode = dic[@"stockCode"];
  self.stockName = dic[@"stockName"];
  self.profit = [dic[@"profit"] doubleValue];

  if (self.profit < 0)
    self.bProfit = NO;
  else
    self.bProfit = YES;

  self.profitRate = dic[@"profitRate"];
  self.positionRate = dic[@"positionRate"];
  self.curPrice = [dic[@"curPrice"] doubleValue];
  self.amount = [dic[@"amount"] stringValue];
  self.changePercent = dic[@"changePercent"];
  self.costPrice = [dic[@"costPrice"] doubleValue];
  self.value = [dic[@"value"] doubleValue];
  self.sellableAmount = [dic[@"sellableAmount"] longLongValue];
  self.tradeType = [dic[@"tradeType"] integerValue];
}

@end

@implementation SimuRankPositionPageData

- (void)jsonToObject:(NSDictionary *)dictionary {
  [super jsonToObject:dictionary];
  self.positionList = [[NSMutableArray alloc] init];

  NSDictionary *dic = dictionary[@"result"];
  self.positionAmount = dic[@"num"];
  self.profit = [dic[@"profit"] doubleValue];
  self.traceFlag = [dic[@"traceFlag"] integerValue];
  self.value = [dic[@"value"] doubleValue];
  self.positionRate = dic[@"positionRate"];
  NSArray *array = dic[@"itemList"];

  for (NSDictionary *subdic in array) {
    PositionInfo *item = [[PositionInfo alloc] init];
    [item jsonToObject:subdic];
    [self.positionList addObject:item];
  }
}

- (NSArray *)getArray {
  return _positionList;
}

+ (void)requestPositionDataWithUid:(NSString *)uid
                       withMatchId:(NSString *)matchId
                        withReqnum:(NSString *)reqnum
                        withFormid:(NSString *)fromid
                      withCallback:(HttpRequestCallBack *)callback {
  NSString *url =
      [data_address stringByAppendingString:@"youguu/position/current/"
                    @"list?userid={userid}&matchid={matchid}"
                    @"&reqnum={reqnum}&fromid={fromid}&version=1"];

  NSDictionary *dic = @{
    @"userid" : uid,
    @"matchid" : matchId,
    @"reqnum" : reqnum,
    @"fromid" : fromid
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[SimuRankPositionPageData class]
             withHttpRequestCallBack:callback];
}

- (void)dealloc {
  [self.positionList removeAllObjects];
}

@end
