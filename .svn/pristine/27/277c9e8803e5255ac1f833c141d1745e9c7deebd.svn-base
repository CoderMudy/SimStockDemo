//
//  GetUserBandPhoneNumber.m
//  SimuStock
//
//  Created by Mac on 15/4/28.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "GetUserBandPhoneNumber.h"

@implementation WFRealUserRNA
- (void)jsonToObject:(NSDictionary *)dic {
  NSString *userName = dic[@"realName"];
  NSString *usercertNo = dic[@"certNo"];
  if (userName && usercertNo) {
    [SimuUtil setUserCertName:userName];
    [SimuUtil setUserCertNo:usercertNo];
  }
}
@end

@implementation GetUserBandPhoneNumber
- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.phoneNumber = dic[@"phone"];
  [SimuUtil setUserPhone:self.phoneNumber];
}

+ (void)checkUserBindPhonerWithCallback:(HttpRequestCallBack *)callback {
  NSString *url =
      [user_address stringByAppendingString:@"jhss/member/findUserPhone"];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[GetUserBandPhoneNumber class]
             withHttpRequestCallBack:callback];
}

@end
