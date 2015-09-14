//
//  CPInquireCattleNumData.m
//  SimuStock
//
//  Created by jhss_wyz on 15/7/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "CPInquireCattleNumData.h"

@implementation CPInquireCattleNumData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.propId = dic[@"propId"];
  self.cowNum = [dic[@"cowNum"] integerValue];
}

@end

@implementation CPInquireCattleNumRequest

+ (void)requestCPSendCattleWithCallback:(HttpRequestCallBack *)callback {
  NSString *url = [mall_address stringByAppendingString:@"pay/cow/myCow"];
  JsonFormatRequester *requset = [[JsonFormatRequester alloc] init];
  [requset asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[CPInquireCattleNumData class]
             withHttpRequestCallBack:callback];
}

@end