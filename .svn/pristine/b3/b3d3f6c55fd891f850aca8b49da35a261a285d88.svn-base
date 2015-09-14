//
//  LossPassword.m
//  SimuStock
//
//  Created by jhss on 14-11-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "LossPassword.h"

@implementation LossPassword
+ (void)lossPasswordMakeForgotPwdPinWithPhoneNumber:(NSString *)phoneNumber
                                       withCallback:
                                           (HttpRequestCallBack *)callback {
  NSString *url =
      [NSString stringWithFormat:@"%@jhss/sms/makeForgotPwdPin/%@/%@",
                                 user_address, phoneNumber, @"2"];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[LossPassword class]
             withHttpRequestCallBack:callback];
}
+ (void)lossPasswordAuthSmsCodeWithPhoneNumber:(NSString *)phoneNumber
                                  withAuthCode:(NSString *)authcode
                                  withCallback:(HttpRequestCallBack *)callback {
  //解析数据
  NSString *url =
      [NSString stringWithFormat:@"%@jhss/sms/authsmscode/%@/%@/%@",
                                 user_address, phoneNumber, authcode, @"2"];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[LossPassword class]
             withHttpRequestCallBack:callback];
}
@end
