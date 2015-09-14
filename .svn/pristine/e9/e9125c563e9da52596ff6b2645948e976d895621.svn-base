//
//  UserAssetsData.m
//  SimuStock
//
//  Created by 刘小龙 on 15/7/6.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "UserAssetsData.h"
#import "JsonFormatRequester.h"
@implementation UserAssetsData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  NSDictionary *result = dic[@"result"];
  NSDictionary *account = result[@"account"];
  self.amount = [account[@"amount"] integerValue];
}

+ (void)requestUserAssetsWithCallback:(HttpRequestCallBack *)callback {
  NSString *url =
      [data_address stringByAppendingString:@"payment/account/asset_stat"];
  JsonFormatRequester *requset = [[JsonFormatRequester alloc] init];
  [requset asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[UserAssetsData class]
             withHttpRequestCallBack:callback];
}

@end
