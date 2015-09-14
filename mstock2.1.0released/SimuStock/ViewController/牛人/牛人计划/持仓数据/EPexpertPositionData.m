//
//  EPexpertPositionData.m
//  SimuStock
//
//  Created by 刘小龙 on 15/7/8.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "EPexpertPositionData.h"
#import "JsonFormatRequester.h"

@implementation EPexpertPositionData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];

  _stockPositionArray = [NSMutableArray array];

  NSDictionary *result = dic[@"result"];
  NSArray *positionList = result[@"itemList"];

  for (NSDictionary *stockDict in positionList) {
    PositionInfo *stockPosition = [[PositionInfo alloc] init];
    // id
    stockPosition.seqid = stockDict[@"positionId"];
    //代码
    stockPosition.stockCode = stockDict[@"stockCode"];
    //股票名称
    stockPosition.stockName = stockDict[@"stockName"];
    //盈亏
    stockPosition.profit = [stockDict[@"profit"] doubleValue];
    if (stockPosition.profit < 0) {
      stockPosition.bProfit = NO;
    } else {
      stockPosition.bProfit = YES;
    }
    //盈亏率
    stockPosition.profitRate = stockDict[@"profitRate"];
    //持仓比率
    stockPosition.positionRate = stockDict[@"positionRate"];
    //当前价格
    stockPosition.curPrice = [stockDict[@"curPrice"] doubleValue];
    //持股市值
    stockPosition.value = [stockDict[@"value"] doubleValue];
    //持股数量
    stockPosition.amount = [stockDict[@"amount"] stringValue];
    //涨幅
    stockPosition.changePercent = stockDict[@"changePercent"];
    //成本价格
    stockPosition.costPrice = [stockDict[@"costPrice"] doubleValue];
    //可卖数量
    stockPosition.sellableAmount = [stockDict[@"sellableAmount"] integerValue];
    //类型
    stockPosition.tradeType = [stockDict[@"tradeType"] integerValue];

    [self.stockPositionArray addObject:stockPosition];
  }

  _stockProfitRate = [result[@"profitRate"] doubleValue];
  _stockProfit = [result[@"stockProfit"] doubleValue];
  _stockAssets = [result[@"stockAssets"] doubleValue];
  _positionRate = [result[@"positionRate"] doubleValue];
  _currentBalance = [result[@"currentBalance"] doubleValue];
  _totalAssets = [result[@"totalAssets"] doubleValue];
}

- (NSArray *)getArray {
  return _stockPositionArray;
}

+ (void)requetPositionDataWithDic:(NSDictionary *)dic
                     withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [data_address stringByAppendingString:@"youguu/super_trade/"
                                @"position_stat_query?accountId={accountId}&"
                                @"targetUid={targetUid}"];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[EPexpertPositionData class]
             withHttpRequestCallBack:callback];
}

@end
