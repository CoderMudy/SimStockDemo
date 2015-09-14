//
//  CPBuyCattlePlanData.m
//  SimuStock
//
//  Created by jhss_wyz on 15/7/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "CPBuyCattlePlanData.h"

@implementation CPBuyCattlePlanData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
}

+ (void)buyCattlePlanWithAccountID:(NSString *)accountID
                      andTargetUID:(NSString *)targetUID
                       andCallBack:(HttpRequestCallBack *)callback {
  NSString *url = [CP_SuperTradeAction_Address
      stringByAppendingString:@"youguu/super_trade/"
      @"open_trace?accountId={accountId}&targetUid={targetUid}"];

  NSDictionary *dic = @{
    @"accountId" : accountID,
    @"targetUid" : targetUID
  };
  JsonFormatRequester *requset = [[JsonFormatRequester alloc] init];
  [requset asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[CPBuyCattlePlanData class]
             withHttpRequestCallBack:callback];
}

@end
