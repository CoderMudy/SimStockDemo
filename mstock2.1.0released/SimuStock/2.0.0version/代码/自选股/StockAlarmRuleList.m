//
//  StockAlarmRuleList.m
//  SimuStock
//
//  Created by xuming tan on 15-3-24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "StockAlarmRuleList.h"
#import "StockAlarmList.h"

@implementation StockAlarmRule

- (void)jsonToObject:(NSDictionary *)dic {
  self.value = [dic[@"value"] stringValue];
  self.ruleType = (StockAlarmRuleType)[dic[@"ruleType"] integerValue];
  self.ruleId = [dic[@"ruleId"] stringValue];
}

@end

@implementation StockAlarmRuleList
//解析
- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  NSLog(@"股价提醒：%@", dic);
  self.ruleType2RuleDictionary = [[NSMutableDictionary alloc] init];
  NSArray *ruleOperationArray = dic[@"result"];
  for (NSDictionary *subDict in ruleOperationArray) {
    NSNumber *ruleType = subDict[@"ruleType"];
    if (![ruleType isKindOfClass:[NSNumber class]]) {
      [[NSException exceptionWithName:@"股价预警规则解析错误"
                               reason:@"错误的规则类型，非NSNumber类型"
                             userInfo:nil] raise];
    }
    StockAlarmRule *item = [[StockAlarmRule alloc] init];
    [item jsonToObject:subDict];
    self.ruleType2RuleDictionary[@(item.ruleType)] = item;
  }
}

//请求某只股票股价提醒所有设置规则
+ (void)requestStockRemindOperationRulesDataWithUid:(NSString *)userId
                                  withStockCodeLong:(NSString *)stockCodeLong
                                       withCallback:(HttpRequestCallBack *)callBack {
  NSString *url = [user_address stringByAppendingString:@"jhss/stockalarm/" @"getallrulesofastock?" @"userid={userid}&stockcode={stockcode}"];
  stockCodeLong = stockCodeLong ? stockCodeLong : @"";
  NSDictionary *dic = @{ @"userid" : userId, @"stockcode" : stockCodeLong };
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[StockAlarmRuleList class]
             withHttpRequestCallBack:callBack];
}
@end

#pragma 预警股票项 start

@implementation AlarmStockItem
- (void)jsonToObject:(NSDictionary *)dic {
  self.stockCodeLong = dic[@"stockCode"];
  self.expireDate = dic[@"expireDate"];
}

@end

#pragma 预警股票项 end

#pragma 设置过预警的股票列表 start

//返回设定提醒的股票列表类
@implementation SelfStockAlarmItems
//解析
- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.stockCodesArray = [[NSMutableArray alloc] init];
  NSArray *stockCodesArray = dic[@"result"];
  for (NSDictionary *subDic in stockCodesArray) {
    AlarmStockItem *item = [[AlarmStockItem alloc] init];
    [item jsonToObject:subDic];
    [self.stockCodesArray addObject:item];
  }
}

//请求设定股价提醒的股票列表
+ (void)requestStockListOfSettingAlarm {
  if ([@"-1" isEqualToString:[SimuUtil getUserID]]) {
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];

  callback.onSuccess = ^(NSObject *object) {
    SelfStockAlarmItems *selfStockAlarmItems = (SelfStockAlarmItems *)object;
    StockAlarmList *alarmList = [StockAlarmList stockAlarmListWithUserId:[SimuUtil getUserID]];
    alarmList.alarms = [[NSMutableSet alloc] init];
    [alarmList addSelfStockAlarms:selfStockAlarmItems.stockCodesArray];
    NSLog(@"股价预警数组");
  };

  NSString *url = [user_address stringByAppendingString:@"jhss/stockalarm/" @"getallalarmedcodes?" @"userid={userid}"];
  NSDictionary *dic = @{ @"userid" : [SimuUtil getUserID] };
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[SelfStockAlarmItems class]
             withHttpRequestCallBack:callback];
}
@end

#pragma 设置过预警的股票列表 end

#pragma 清空指定股票的预警信息 start

//清空某只股票的所有规则。
@implementation EmptyStockAlarmRules

+ (void)requestEmptyStockRulesWithUid:(NSString *)userId
                    withStockCodeLong:(NSString *)stockCodeLong
                         withCallback:(HttpRequestCallBack *)callBack {
  NSString *url = [user_address stringByAppendingString:@"jhss/stockalarm/" @"emptystockrules?" @"userid={userid}&stockcode={stockcode}"];
  NSDictionary *dic = @{ @"userid" : userId, @"stockcode" : stockCodeLong };
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[EmptyStockAlarmRules class]
             withHttpRequestCallBack:callBack];
}
@end

#pragma 清空指定股票的预警信息 end
