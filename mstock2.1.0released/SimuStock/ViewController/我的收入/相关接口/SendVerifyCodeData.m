//
//  SendVerifyCodeData.m
//  SimuStock
//
//  Created by Yuemeng on 15/5/22.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SendVerifyCodeData.h"

@implementation SendVerifyCodeData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
}

+ (void)requestPhoneVerifyCodeWithPhoneNumber:(NSString *)phoneNumber
                                         type:(CodeType)codeType
                                     callback:(HttpRequestCallBack *)callback {
  NSString *url = [NSString
      stringWithFormat:@"%@jhss/sms/getPin?phone=%@&type=%@", user_address,
                       phoneNumber,
                       [NSString
                           stringWithFormat:@"%lu", (unsigned long)codeType]];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[SendVerifyCodeData class]
             withHttpRequestCallBack:callback];
}

@end
