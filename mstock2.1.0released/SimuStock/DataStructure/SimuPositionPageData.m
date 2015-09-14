//
//  SimuPositionPageData.m
//  SimuStock
//
//  Created by Mac on 13-8-15.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "SimuPositionPageData.h"
#import "JsonFormatRequester.h"
#import "StockUtil.h"
#import "SimuRankPositionPageData.h"

@implementation SimuPositionPageData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.dataArray = [[NSMutableArray alloc] init];
  NSDictionary *result = dic[@"result"];
  NSArray *itemList = result[@"itemList"];
  
  for (NSDictionary *dic in itemList) {
    PositionInfo *psotitonItem = [[PositionInfo alloc] init];
    // id
    psotitonItem.seqid = [dic[@"seqId"] stringValue];
    //代码
    psotitonItem.stockCode = dic[@"stockCode"];
    //股票名称
    psotitonItem.stockName = dic[@"stockName"];
    //盈亏
    psotitonItem.profit = [dic[@"profit"] doubleValue];
    if (psotitonItem.profit < 0) {
      psotitonItem.bProfit = NO;
    } else {
      psotitonItem.bProfit = YES;
    }
    //盈亏率
    psotitonItem.profitRate = dic[@"profitRate"];
    //持仓比率
    psotitonItem.positionRate = dic[@"positionRate"];
    //当前价格
    psotitonItem.curPrice = [dic[@"curPrice"] doubleValue];
    //持股市值
    psotitonItem.value = [dic[@"value"] doubleValue];
    //持股数量
    psotitonItem.amount = [dic[@"amount"] stringValue];
    //涨幅
    psotitonItem.changePercent = dic[@"changePercent"];
    //成本价格
    psotitonItem.costPrice = [dic[@"costPrice"] doubleValue];
    //可卖数量
    psotitonItem.sellableAmount = [dic[@"sellableAmount"] integerValue];
    //类型
    psotitonItem.tradeType = [dic[@"tradeType"] integerValue];
    
    if (psotitonItem.sellableAmount != 0) {
      [self.dataArray addObject:psotitonItem];
    }
  }
}
-(NSArray *)getArray{

  return _dataArray;
}
+ (void)requestPositionDataWithDic:(NSDictionary *)dic 
                      withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [data_address
      stringByAppendingString:
          @"youguu/position/current/list?userid={userid}&matchid={matchid}"];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[SimuPositionPageData class]
             withHttpRequestCallBack:callback];
}

+ (void)requestPositionDataWithUid:(NSString *)uid
                       withMatchId:(NSString *)matchId
                      withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [data_address
                   stringByAppendingString:
                   @"youguu/position/current/list?userid={userid}&matchid={matchid}"];
  NSDictionary *dic = @{ @"userid" : uid, @"matchid" : matchId };
  
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[SimuPositionPageData class]
             withHttpRequestCallBack:callback];
}

/** 牛人可卖持仓数据请求 */
+ (void)requestExpertSellStockPosition:(NSString *)accountId
                         withTargetUid:(NSString *)targetUid
                          withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [CP_SuperTradeAction_Address
      stringByAppendingString:@"youguu/super_trade/"
                              @"position_stat_query?accountId={accountId}&"
                              @"targetUid={targetUid}"];
  NSDictionary *dic = @{ @"accountId" : accountId, @"targetUid" : targetUid };
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[SimuPositionPageData class]
             withHttpRequestCallBack:callback];
}

static SimuPositionPageData *instance = nil;

+ (SimuPositionPageData *)myPostion {
  static dispatch_once_t predicate;
  dispatch_once(&predicate, ^{
    instance = [[SimuPositionPageData alloc] init];
  });
  return instance;
}


+ (void)updatePostion {
  if (![SimuUtil isLogined]) {
    return;
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];

  callback.onSuccess = ^(NSObject *obj) {
    [SimuPositionPageData myPostion].dataArray =
        ((SimuPositionPageData *)obj).dataArray;
  };
  
  
  [SimuPositionPageData requestPositionDataWithUid:[SimuUtil getUserID]
                                       withMatchId:@"1"
                                      withCallback:callback];
}

+ (NSArray *)getSellableStocks {
  NSMutableArray *data = [SimuPositionPageData myPostion].dataArray;
  if (data) {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (PositionInfo *item in data) {
      if (item.sellableAmount > 0) {
        [array addObject:item.stockCode];
      }
    }
    return array;
  };
  return nil;
}

+ (BOOL)isStockSellable:(NSString *)stockCode {
  NSString *sixStockCode = [StockUtil sixStockCode:stockCode];
  NSMutableArray *data = [SimuPositionPageData myPostion].dataArray;
  if (data) {
    for (PositionInfo *item in data) {
      if ([sixStockCode isEqualToString:item.stockCode] &&
          (item.sellableAmount > 0)) {
        return YES;
      }
    }
  };
  return NO;
}

@end
