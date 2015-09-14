//
//  ExchangeDiamondData.m
//  SimuStock
//
//  Created by Yuemeng on 15/5/25.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ExchangeDiamondData.h"

@implementation ExchangeDiamondData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
}

+ (void)requestExchangeDiamondDataWithUserName:(NSString *)userName
                                      nickName:(NSString *)nickName
                                       diamond:(NSString *)diamond
                                           fee:(NSString *)fee
                                      callback:(HttpRequestCallBack *)callback {
  NSString *url =
      [pay_address stringByAppendingString:@"pay/bank/counter/exDiamond"];

  NSDictionary *dic = @{
    @"userName" : userName,
    @"nickName" : nickName,
    @"diamond" : diamond,
    @"fee" : fee
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];

  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"POST"
               withRequestParameters:dic
              withRequestObjectClass:[ExchangeDiamondData class]
             withHttpRequestCallBack:callback];
}

@end
