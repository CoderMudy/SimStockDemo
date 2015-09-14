//
//  CancellationRequest.m
//  SimuStock
//
//  Created by 刘小龙 on 15/7/15.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "CancellationRequest.h"
#import "RealTradeRequester.h"

@implementation CancellationRequest

- (void)jsonToObject:(NSDictionary *)dic {
  NSLog(@"撤单成功");
}

/** 用户撤单 */
+ (void)requstUserCancellation:(NSString *)mathcId
                    withEntrus:(NSString *)entrus
                  withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [data_address stringByAppendingString:@"youguu/trade/cancel/"
                                @"submit?matchid={matchid}&cid={cid}"];
  NSDictionary *dic = @{ @"cid" : entrus, @"matchid" : mathcId };
  RealTradeRequester *requester = [[RealTradeRequester alloc] init];
  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:@"GET"
                 withRequestParameters:dic
                withRequestObjectClass:[CancellationRequest class]
               withHttpRequestCallBack:callback];
}

/** 牛人撤单 */
+ (void)requestExpertCancellation:(NSString *)accountId
                 withCommissionId:(NSString *)commissionId
                     withCallback:(HttpRequestCallBack *)callback;
{
  NSString *url =
      [NSString stringWithFormat:
                    @"%@youguu/super_trade/cancel?accountId=%@&commissionId=%@",
                    CP_SuperTradeAction_Address, accountId, commissionId];

  RealTradeRequester *requester = [[RealTradeRequester alloc] init];
  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:@"GET"
                 withRequestParameters:nil
                withRequestObjectClass:[CancellationRequest class]
               withHttpRequestCallBack:callback];
}

@end
