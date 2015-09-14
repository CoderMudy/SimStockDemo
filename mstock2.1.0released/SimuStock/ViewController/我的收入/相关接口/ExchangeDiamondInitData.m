
//
//  ExchangeDiamondInitData.m
//  SimuStock
//
//  Created by Yuemeng on 15/5/25.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ExchangeDiamondInitData.h"

@implementation ExchangeDiamondInitData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];

  [self setValuesForKeysWithDictionary:dic[@"result"]];
}

+ (void)requestExchangeDiamondInitData:(HttpRequestCallBack *)callback {
  NSString *url =
      [pay_address stringByAppendingString:@"pay/bank/counter/initExDiamond"];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];

  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[ExchangeDiamondInitData class]
             withHttpRequestCallBack:callback];
}

@end
