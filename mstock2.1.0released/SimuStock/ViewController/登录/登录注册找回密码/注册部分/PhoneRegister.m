//
//  PhoneRegister.m
//  SimuStock
//
//  Created by jhss on 14-11-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "PhoneRegister.h"

@implementation PhoneRegister

+ (void)phoneRegisterMakeRegisterPinWithPhoneNumber:(NSString *)phoneNumber
                                           withType:(sendSmsType)type
                                       withCallback:
                                           (HttpRequestCallBack *)callback {
  NSString *url =
      [NSString stringWithFormat:@"%@jhss/sms/makeRegisterPin/%@/%ld",
                                 user_address, phoneNumber, (long)type];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[PhoneRegister class]
             withHttpRequestCallBack:callback];
}

+ (void)phoneRegisterAuthSmsCodeWithPhoneNumber:(NSString *)phoneNumber
                                   withAuthCode:(NSString *)authcode
                                   withCallback:
                                       (HttpRequestCallBack *)callback {
  //解析数据
  NSString *url =
      [NSString stringWithFormat:@"%@jhss/sms/authsmscode/%@/%@/%@",
                                 user_address, phoneNumber, authcode, @"1"];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[PhoneRegister class]
             withHttpRequestCallBack:callback];
}

+ (void)mobilePhoneBindPhoneWithPhoneNumber:(NSString *)phone
                                withVerifyCode:(NSString *)verifyCode
                                   WithUserPwd:(NSString *)userPwd
                             WithVerifyUserPwd:(NSString *)verifyUserPwd
                                      withFlag:(NSString *)flag
                                  WithCallback:(HttpRequestCallBack *)callback {
  NSString *url =
      [NSString stringWithFormat:@"%@jhss/member/doBindingPhoneForm",user_address];
  NSDictionary *dic = @{
    @"phone" : phone,
    @"verifyCode" : verifyCode,
    @"userPwd" : userPwd,
    @"verifyUserPwd" : verifyUserPwd,
    @"flag" : flag
  };
   JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"POST"
               withRequestParameters:dic
              withRequestObjectClass:[PhoneRegister class]
             withHttpRequestCallBack:callback];
}

+ (void)mobilePhoneModifyPasswordWithPhoneNUmber:(NSString *)phone
                                withVerifyCode:(NSString *)verifyCode
                                   WithUserPwd:(NSString *)userPwd
                             WithVerifyUserPwd:(NSString *)verifyUserPwd
                                      withFlag:(NSString *)flag
                                  WithCallback:(HttpRequestCallBack *)callback {
  NSString *url =
  [NSString stringWithFormat:@"%@jhss/member/modifyPwdByPhone",user_address];
  NSDictionary *dic = @{
                        @"phone" : phone,
                        @"verifyCode" : verifyCode,
                        @"userPwd" : userPwd,
                        @"verifyUserPwd" : verifyUserPwd,
                        @"flag" : flag
                        };
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"POST"
               withRequestParameters:dic
              withRequestObjectClass:[PhoneRegister class]
             withHttpRequestCallBack:callback];
}

+(void)userLoginIntoModifyPasswordWithPhoneNUmber:(NSString *)phone
                                   withVerifyCode:(NSString *)verifyCode
                                      WithUserPwd:(NSString *)userPwd
                                WithVerifyUserPwd:(NSString *)verifyUserPwd
                                         withFlag:(NSString *)flag
                                     WithCallback:(HttpRequestCallBack *)callback{

  NSString *url =
  [NSString stringWithFormat:@"%@jhss/member/doRetrievePwdForm",user_address];
  NSDictionary *dic = @{
                        @"phone" : phone,
                        @"verifyCode" : verifyCode,
                        @"userPwd" : userPwd,
                        @"verifyUserPwd" : verifyUserPwd,
                        @"flag" : flag
                        };
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"POST"
               withRequestParameters:dic
              withRequestObjectClass:[PhoneRegister class]
             withHttpRequestCallBack:callback];

}


@end
