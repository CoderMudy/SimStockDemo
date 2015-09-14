//
//  HotRunInfoItem.m
//  SimuStock
//
//  Created by Jhss on 15/7/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "HotRunInfoItem.h"

@implementation HotRunInfoItem

- (void)jsonToObject:(NSDictionary *)dic {
  self.name = dic[@"name"];
  self.goalProfit = [dic[@"goalProfit"] stringValue];
  self.stopLossLine = [dic[@"stopLossLine"] stringValue];
  self.price = [dic[@"price"] stringValue];
  self.accountId = dic[@"accountId"];
  self.buystatus = [dic[@"buyStatus"] stringValue];
  self.buyStopTime = [@([dic[@"buyStatus"] intValue]) stringValue];
  self.buyerCount = [dic[@"buyerCount"] stringValue];
  self.buyerLimit = [dic[@"buyerLimit"] stringValue];
  self.desc = dic[@"desc"];
  self.goalMonths = [dic[@"goalMonths"] stringValue];
  self.profit = [dic[@"profit"] stringValue];
  self.runDay = [dic[@"runDay"] stringValue];
  self.uid = [dic[@"uid"] stringValue];
  self.status = [dic[@"status"] stringValue];
  self.profitRate = [dic[@"profitRate"] stringValue];
}

@end

@implementation HotRunInfoDataRequest

- (void)jsonToObject:(NSDictionary *)dic {
  if (dic[@"result"] == nil) {
    return;
  }
  self.dataArray = [[NSMutableArray alloc] init];
  NSDictionary *resultDic = dic[@"result"];
  NSArray *palnlist = resultDic[@"plans"];
  //遍历数组
  [palnlist enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx,
                                         BOOL *stop) {
    HotRunInfoItem *item = [[HotRunInfoItem alloc] init];
    [item jsonToObject:obj];
    ///判断是否是自己的计划。如果是自己的计划则放在第一位
    [self.dataArray addObject:item];
    if ([item.uid isEqualToString:[SimuUtil getUserID]]) {
      //先删除然后进行添加
      [self.dataArray removeObjectAtIndex:idx];
      [self.dataArray insertObject:item atIndex:0];
    }
  }];
}
- (NSArray *)getArray {
  return _dataArray;
}
- (NSDictionary *)mappingDictionary {
  return @{ @"dataArray" : NSStringFromClass([HotRunInfoItem class]) };
}

+ (void)hotRunPlanListRequest:(NSDictionary *)dic
                 withCallback:(HttpRequestCallBack *)callback {

  NSString *url = [istock_address
      stringByAppendingFormat:
          @"youguu/super_trade/run_plan?fromId={fromId}&reqNum={reqNum}"];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[HotRunInfoDataRequest class]
             withHttpRequestCallBack:callback];
}

@end
