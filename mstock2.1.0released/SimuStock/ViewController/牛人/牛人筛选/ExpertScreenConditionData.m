//
//  ExpertScreenConditionData.m
//  SimuStock
//
//  Created by jhss_wyz on 15/8/31.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ExpertScreenConditionData.h"
#import "JsonFormatRequester.h"

@implementation ESConditionInterval

+ (instancetype)conditioningIntervalWithArray:(NSArray *)array {
  if (!array && array.count < 3) {
    return nil;
  }
  ESConditionInterval *conditionInterval = [[ESConditionInterval alloc] init];
  conditionInterval.leftInterval = [array[0] floatValue];
  conditionInterval.rightInterval = [array[1] floatValue];
  conditionInterval.defaultValue = [array[2] floatValue];
  return conditionInterval;
}

@end

@implementation ExpertScreenConditionData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  NSDictionary *resultDic = dic[@"result"];
  if (resultDic == nil) {
    return;
  }

  /// 盈利能力
  self.winRate = [ESConditionInterval conditioningIntervalWithArray:resultDic[@"winRate"]];
  self.annualProfit =
      [ESConditionInterval conditioningIntervalWithArray:resultDic[@"annualProfit"]];
  self.monthAvgProfitRate =
      [ESConditionInterval conditioningIntervalWithArray:resultDic[@"monthAvgProfitRate"]];

  /// 抗风险能力
  self.maxBackRate = [ESConditionInterval conditioningIntervalWithArray:resultDic[@"maxBackRate"]];
  self.backRate = [ESConditionInterval conditioningIntervalWithArray:resultDic[@"backRate"]];

  /// 选股能力
  self.profitDaysRate =
      [ESConditionInterval conditioningIntervalWithArray:resultDic[@"profitDaysRate"]];
  self.sucRate = [ESConditionInterval conditioningIntervalWithArray:resultDic[@"sucRate"]];
  self.avgDays = [ESConditionInterval conditioningIntervalWithArray:resultDic[@"avgDays"]];

  /// 数据准确性
  self.closeNum = [ESConditionInterval conditioningIntervalWithArray:resultDic[@"closeNum"]];

  /// 所有数据数组
  self.dataArray = @[
    self.winRate,
    self.annualProfit,
    self.monthAvgProfitRate,
    self.maxBackRate,
    self.backRate,
    self.profitDaysRate,
    self.sucRate,
    self.avgDays,
    self.closeNum
  ];
}

/** 请求筛选牛人条件区间 */
+ (void)requetExpertScreenConditionDataWithCallback:(HttpRequestCallBack *)callback {
  NSString *url = [data_address stringByAppendingString:@"youguu/rating/rate_filter_condition"];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[ExpertScreenConditionData class]
             withHttpRequestCallBack:callback];
}

@end
