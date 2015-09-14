//
//  AuthIsBindingPhoneData.m
//  SimuStock
//
//  Created by Yuemeng on 15/5/25.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "AuthIsBindingPhoneData.h"

@implementation AuthIsBindingPhoneData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
}

+ (void)requestAuthIsBindingPhoneData:(HttpRequestCallBack *)callback {
  NSString *url = [user_address
      stringByAppendingFormat:@"jhss/member/authIsBindingPhone?userid=%@",
                              [SimuUtil getUserID]];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];

  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[AuthIsBindingPhoneData class]
             withHttpRequestCallBack:callback];
}

@end
