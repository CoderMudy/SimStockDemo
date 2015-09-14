//
//  PhoneRegister.h
//  SimuStock
//
//  Created by jhss on 14-11-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"
#import "JsonFormatRequester.h"

typedef enum : NSUInteger {
  phoneRegister = 1 ,//注册
  WFbindPhone = 3,  //配资手机绑定
} sendSmsType;


@interface PhoneRegister : JsonRequestObject

/** 手机号注册_下一步 */
+ (void)phoneRegisterAuthSmsCodeWithPhoneNumber:(NSString *)phoneNumber
                                   withAuthCode:(NSString *)authcode
                                   withCallback:(HttpRequestCallBack *)callback;
/** 手机号注册_获取验证码 */
+ (void)phoneRegisterMakeRegisterPinWithPhoneNumber:(NSString *)phoneNumber withType:(sendSmsType )type
                                       withCallback:(HttpRequestCallBack *)callback;

/** 新版绑定手机号接口 */
+ (void)mobilePhoneBindPhoneWithPhoneNumber:(NSString *)phone withVerifyCode:(NSString *)verifyCode WithUserPwd:(NSString *)userPwd WithVerifyUserPwd:(NSString *)verifyUserPwd withFlag:(NSString *)flag WithCallback:(HttpRequestCallBack *)callback;
/** 新版修改密码接口 */
+ (void)mobilePhoneModifyPasswordWithPhoneNUmber:(NSString *)phone
                                  withVerifyCode:(NSString *)verifyCode
                                     WithUserPwd:(NSString *)userPwd
                               WithVerifyUserPwd:(NSString *)verifyUserPwd
                                        withFlag:(NSString *)flag
                                    WithCallback:(HttpRequestCallBack *)callback;
/** 新版根据登录界面使用根据手机号修改密码 */
+(void)userLoginIntoModifyPasswordWithPhoneNUmber:(NSString *)phone
                               withVerifyCode:(NSString *)verifyCode
                                  WithUserPwd:(NSString *)userPwd
                            WithVerifyUserPwd:(NSString *)verifyUserPwd
                                     withFlag:(NSString *)flag
                                 WithCallback:(HttpRequestCallBack *)callback;



@end
