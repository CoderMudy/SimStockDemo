//
//  MyInformationCenterData.m
//  SimuStock
//
//  Created by jhss on 14-11-17.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "MyInformationCenterData.h"
#import "JsonFormatRequester.h"

@implementation GetInviteCode
- (void)jsonToObject:(NSDictionary *)obj {
  [super jsonToObject:obj];
  //获取邀请码
  self.message = obj[@"inviteCode"];
}
+ (void)getInviteCodeWithCallBack:(HttpRequestCallBack *)callback {
  NSString *url =
      [NSString stringWithFormat:@"%@jhss/member/getInviteCode", user_address];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[GetInviteCode class]
             withHttpRequestCallBack:callback];
}

@end

@implementation BindingPhone

+ (void)bindingPhoneWithPhoneNumber:(NSString *)phoneNumber
                       withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [NSString
      stringWithFormat:@"%@jhss/member/doBindingPhone/%@/%@", user_address,
                       phoneNumber, [SimuUtil getUserID]];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[BindingPhone class]
             withHttpRequestCallBack:callback];
}

@end

@implementation ChangePhoneNumber

+ (void)changeBindingPhoneWithNewPhoneNumber:(NSString *)newPhoneNumber
                          withOldPhoneNumber:(NSString *)oldPhoneNumber
                                withCallBack:(HttpRequestCallBack *)callback {
  NSString *url =
      [NSString stringWithFormat:@"%@jhss/member/doChangePhone/%@/%@/%@",
                                 user_address, [SimuUtil getUserID],
                                 oldPhoneNumber, newPhoneNumber];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[ChangePhoneNumber class]
             withHttpRequestCallBack:callback];
}
@end

@implementation UnbindingPhoneOrThirdPart
+ (void)unbindingPhoneOrThirdPartWithPhoneNumberOrOpenID:
            (NSString *)phoneNumOrThirdID withCallback:
                (HttpRequestCallBack *)callback {
  NSString *url = [NSString
      stringWithFormat:@"%@jhss/member/doUnbindingPhone/%@/%@", user_address,
                       phoneNumOrThirdID, [SimuUtil getUserID]];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[UnbindingPhoneOrThirdPart class]
             withHttpRequestCallBack:callback];
}

@end

@implementation BindingMyAccount

+ (void)bindingMyAccountWithToken:(NSString *)token
                       withOpenId:(NSString *)openId
                     withNickName:(NSString *)nickName
                         withType:(NSString *)type
                     withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [NSString
      stringWithFormat:@"%@jhss/member/bindMyAccount"
                       @"?token=%@&openid=%@&thirdNickname=%@&type=%@",
                       user_address, token, openId,
                       [CommonFunc base64StringFromText:nickName], type];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[BindingMyAccount class]
             withHttpRequestCallBack:callback];
}

@end

@implementation PhoneNumberRegister

+ (void)phoneNumberRegisterWithPhoneNumber:(NSString *)phoneNumber
                                  withType:(NSString *)type
                              withCallback:(HttpRequestCallBack *)callback {
  NSString *verifyCodeUrl =
      [NSString stringWithFormat:@"%@jhss/sms/makeRegisterPin/%@/%@",
                                 user_address, phoneNumber, @"3"];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:verifyCodeUrl
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[PhoneNumberRegister class]
             withHttpRequestCallBack:callback];
}

+ (void)
phoneNumberRegisterWithAuthCodeVerifyWithPhoneNumber:(NSString *)phoneNumber
                                        withAuthCode:(NSString *)authCode
                                            withType:(NSString *)type
                                        withCallback:
                                            (HttpRequestCallBack *)callback {
  NSString *writeVerifyCodeUrl =
      [NSString stringWithFormat:@"%@jhss/sms/authsmscode/%@/%@/%@",
                                 user_address, phoneNumber, authCode, type];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:writeVerifyCodeUrl
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[PhoneNumberRegister class]
             withHttpRequestCallBack:callback];
}
@end

@implementation ChangePassword

+ (void)changePasswordWithPassword:(NSString *)password
                  withOncePassword:(NSString *)oncePassword
                   withOldPassword:(NSString *)oldPassword
                      withCallback:(HttpRequestCallBack *)callback {
  NSString *url =
      [NSString stringWithFormat:@"%@jhss/member/doeditpwd/%@/%@/%@/%@/%@/%@",
                                 user_address, [SimuUtil getAK],
                                 [SimuUtil getSesionID], [SimuUtil getUserID],
                                 password, oncePassword, oldPassword];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[ChangePassword class]
             withHttpRequestCallBack:callback];
}
@end
