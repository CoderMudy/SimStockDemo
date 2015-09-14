//
//  ExpertScreenListWrapper.m
//  SimuStock
//
//  Created by jhss on 15/8/31.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ExpertFilterListWrapper.h"
#import "JsonFormatRequester.h"
#import "UserListItem.h"

@implementation ExpertFilterCondition : NSObject
@end

@implementation ExpertFilterListItem

- (void)jsonToObject:(NSDictionary *)dic {
  self.seqId = [dic[@"id"] longLongValue];
  self.accountId = dic[@"accountId"];
  self.uid = [dic[@"uid"] longLongValue];
  self.totalProfitRate = [dic[@"totalProfitRate"] floatValue];
  self.monthAvgProfitRate = [dic[@"monthAvgProfitRate"] floatValue];
  self.maxBackRate = [dic[@"maxBackRate"] floatValue];
  self.backRate = [dic[@"backRate"] floatValue];
  self.winRate = [dic[@"winRate"] floatValue];
  self.annualProfit = [dic[@"annualProfit"] floatValue];
  self.profitDaysRate = [dic[@"profitDaysRate"] floatValue];
  self.avgDays = [dic[@"avgDays"] floatValue];
  self.closeNum = [dic[@"closeNum"] longValue];
  self.sucRate = [dic[@"sucRate"] floatValue];
}

@end

@implementation ExpertFilterListWrapper

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];

  self.expertFilterListArray = [[NSMutableArray alloc] init];
  NSDictionary *result = dic[@"result"];

  /**userList节点解析*/
  UserListWrapper *userListWrapper = [[UserListWrapper alloc] init];
  [userListWrapper jsonToMap:result[@"userList"]];

  //账户资产信息
  NSArray *ratingList = result[@"ratingList"];

  for (NSDictionary *subDic in ratingList) {
    ExpertFilterListItem *item = [[ExpertFilterListItem alloc] init];
    //解析tmcList部分
    [item jsonToObject:subDic];
    //找到userList的uid
    NSString *uid = [SimuUtil changeIDtoStr:subDic[@"uid"]];
    item.writer = [userListWrapper getUserById:uid];
    [self.expertFilterListArray addObject:item];
  }
}

- (NSArray *)getArray {
  return _expertFilterListArray;
}

+ (void)requestExpertFilterListWithInput:(NSDictionary *)dic
                            withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [data_address
      stringByAppendingString:@"youguu/rating/"
      @"rate_filter?pageStart={pageStart}&pageSize={pageSize}&maxBackRate="
      @"{maxBackRate}&backRate={backRate}&winRate={winRate}&"
      @"annualProfit={annualProfit}&monthAvgProfitRate={monthAvgProfitRate}&profitDaysRate={"
      @"profitDaysRate}&sucRate={sucRate}&" @"avgDays={avgDays}&closeNum={closeNum}"];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[ExpertFilterListWrapper class]
             withHttpRequestCallBack:callback];
}
@end
