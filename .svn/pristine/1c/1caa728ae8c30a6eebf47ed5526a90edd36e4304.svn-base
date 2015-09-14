//
//  WFFinancingParse.m
//  SimuStock
//
//  Created by Jhss on 15/4/17.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "WFFinancingParse.h"

// 1.1用户是否已经实名认证
@implementation WFIsRealNameAuth
- (void)jsonToObject:(NSDictionary *)dic {
  self.authFlag = [dic[@"authFlag"] boolValue];
  //[SimuUtil setHsUserID:self.authFlag];
}
@end
#pragma mark
// 1.2实名认证接口
@implementation WFRealNameAuthRequest

@end
#pragma mark
//配资短信验证，绑定手机号
@implementation WFBindMobilePhone
- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
}
@end

// 1.4查询实名认证
@implementation WFgetRealNameAuth
- (void)jsonToObject:(NSDictionary *)dic {
}
@end

#pragma mark

@implementation WFFinancingParse

// 1.1用户是否已经实名认证
+ (void)wfIsRealNameAuthenticationWithCallback:(HttpRequestCallBack *)callback {
  NSString *url =
      [NSString stringWithFormat:@"%@jhss/member/isAuthRNA", user_address];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[WFIsRealNameAuth class]
             withHttpRequestCallBack:callback];
}

// 1.2实名认证接口
+ (void)wfUserRealNameAuthenticationWithRealName:(NSString *)realName
                                    withCertType:(NSString *)certType
                                      withCertNo:(NSString *)certNo
                                    withCallback:
                                        (HttpRequestCallBack *)callback {

  NSString *url = [user_address stringByAppendingFormat:@"jhss/member/authRNA"];
  NSDictionary *jsonDictionary = @{
    @"realName" : realName,
    @"certType" : certType,
    @"certNo" : certNo,
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"POST"
               withRequestParameters:jsonDictionary
              withRequestObjectClass:[WFRealNameAuthRequest class]
             withHttpRequestCallBack:callback];
}

// 1.3短信验证码接口,绑定手机号
+ (void)bindMobileCodeWithPhone:(NSString *)phone
                 withVerifycode:(NSString *)verifycode
                   withCallback:(HttpRequestCallBack *)callback {

  NSString *url =
      [user_address stringByAppendingFormat:@"jhss/member/bindPhone"];

  NSDictionary *jsonDictionary = @{
    @"phone" : phone,
    @"verifycode" : verifycode,
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"POST"
               withRequestParameters:jsonDictionary
              withRequestObjectClass:[WFBindMobilePhone class]
             withHttpRequestCallBack:callback];
}

// 1.4查询实名认证信息
+ (void)wfgetRealNameAuthenticationWithCallback:
    (HttpRequestCallBack *)callback {
  NSString *url =
      [NSString stringWithFormat:@"%@jhss/member/getRNA", user_address];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[WFgetRealNameAuth class]
             withHttpRequestCallBack:callback];
}

@end
