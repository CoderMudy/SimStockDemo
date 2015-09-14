//
//  CPYieldCurve.m
//  SimuStock
//
//  Created by jhss_wyz on 15/7/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "CPYieldCurve.h"

@implementation CPYieldCurveData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  NSDictionary *resultDic = dic[@"result"];
  if (resultDic == nil) {
    return;
  }
  NSArray *resultArray = resultDic[@"assetsLine"];
  if (!resultArray) {
    return;
  }
  NSDictionary *planDic = resultDic[@"planAssistQuery"];
  if (planDic == nil) {
    return;
  }

  self.endDate = planDic[@"endDate"];
  self.tradeDays = [planDic[@"tradeDays"] integerValue];

  self.maxOrdinate = 0.1f;
  self.planYCArrayM = [NSMutableArray array];
  self.sseGainArrayM = [NSMutableArray array];
  self.sseArrayM = [NSMutableArray array];
  self.dateArrayM = [NSMutableArray array];
  if (resultArray.count < 1) {
    self.isBind = NO;
    return;
  } else {
    self.isBind = YES;
  }
  self.baseSSE = [((NSDictionary *)resultArray[0])[@"hzPrice"] doubleValue];

  if ([[((NSDictionary *)resultArray[0])[@"hzPrice"] stringValue]
          isEqualToString:@"0"]) {
    self.isBind = NO;
  }

  [self insertOneDateWithDic:resultArray[0] atIndex:0];
  for (NSInteger i = resultArray.count - 1; i > 0; i--) {
    [self insertOneDateWithDic:resultArray[i] atIndex:(resultArray.count - i)];
  }
}

- (void)insertOneDateWithDic:(NSDictionary *)dataDic atIndex:(NSInteger)index {
  [self.planYCArrayM insertObject:@([dataDic[@"profitRate"] doubleValue])
                          atIndex:index];
  [self setMaxWith:[dataDic[@"profitRate"] doubleValue]];
  [self.sseArrayM insertObject:dataDic[@"hzPrice"] atIndex:index];
  CGFloat sseGain = [dataDic[@"hzPrice"] doubleValue];
  sseGain = (sseGain - self.baseSSE) / self.baseSSE;
  [self.sseGainArrayM insertObject:@(sseGain) atIndex:index];
  [self setMaxWith:sseGain];
  [self.dateArrayM
      insertObject:
          [SimuUtil getDayDateFromCtime:@([dataDic[@"statDate"] doubleValue])]
           atIndex:index];
}

- (void)setMaxWith:(CGFloat)date {
  if (date > self.maxOrdinate) {
    self.maxOrdinate = (ceil(date * 5000) / 10000 + 0.02f) * 2;
    self.isChanged = YES;
  } else if ((-date) > self.maxOrdinate) {
    self.maxOrdinate = (ceil((-date) * 5000) / 10000 + 0.02f) * 2;
    self.isChanged = YES;
  }
}

@end

@implementation CPYieldCurve

+ (void)getCPYieldCurveDataWithPlanID:(NSString *)planID
                         andTargetUID:(NSString *)targetUID
                          andCallback:(HttpRequestCallBack *)callback {
  NSString *url = [CP_YieldCurve_Address
      stringByAppendingString:@"youguu/super_trade/"
      @"assets_query?accountId={accountId}&targetUid={" @"targetUid}"];

  NSDictionary *parametersDictionary = @{
    @"accountId" : planID,
    @"targetUid" : targetUID,
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:parametersDictionary
              withRequestObjectClass:[CPYieldCurveData class]
             withHttpRequestCallBack:callback];
}

@end
