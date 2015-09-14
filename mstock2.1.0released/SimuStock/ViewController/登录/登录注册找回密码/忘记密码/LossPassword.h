//
//  LossPassword.h
//  SimuStock
//
//  Created by jhss on 14-11-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"
#import "JsonFormatRequester.h"
@interface LossPassword : JsonRequestObject

/** 忘记密码_获取验证码 */
+ (void)lossPasswordAuthSmsCodeWithPhoneNumber:(NSString *)phoneNumber
                                  withAuthCode:(NSString *)authcode
                                  withCallback:(HttpRequestCallBack *)callback;
/** 忘记密码_下一步 */
+ (void)lossPasswordMakeForgotPwdPinWithPhoneNumber:(NSString *)phoneNumber
                                       withCallback:
                                           (HttpRequestCallBack *)callback;

@end
