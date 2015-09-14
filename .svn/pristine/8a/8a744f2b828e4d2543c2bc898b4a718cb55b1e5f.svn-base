//
//  EPCloseExpertPlanRequest.m
//  SimuStock
//
//  Created by 刘小龙 on 15/7/16.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "EPCloseExpertPlanRequest.h"
#import "JsonFormatRequester.h"

@implementation EPCloseExpertPlanRequest

- (void)jsonToObject:(NSDictionary *)dic {
  NSLog(@"计划关闭成功!!!");
}

/** 关闭计划请求 */
+ (void)requestClosePlanWithAccountId:(NSString *)accountId
                         withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [CP_SuperTradeAction_Address
      stringByAppendingString:
          @"youguu/super_trade/close_plan?accountId={accountId}"];
  NSDictionary *dic = @{ @"accountId" : accountId };
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[EPCloseExpertPlanRequest class]
             withHttpRequestCallBack:callback];
}
@end
