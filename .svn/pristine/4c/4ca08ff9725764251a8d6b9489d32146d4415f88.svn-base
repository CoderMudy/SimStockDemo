//
//  MyInformationCenterData.h
//  SimuStock
//
//  Created by jhss on 14-11-17.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

@class HttpRequestCallBack;
/**-----------------*/
/** 类说明：获取邀请码*/
@interface GetInviteCode : JsonRequestObject
@property(copy, nonatomic) NSString *backMessage;
/** 获取邀请码*/
+ (void)getInviteCodeWithCallBack:(HttpRequestCallBack *)callback;
@end

/**-----------------*/
/**类说明:绑定手机号*/
@interface BindingPhone : JsonRequestObject
/**绑定手机号*/
+ (void)bindingPhoneWithPhoneNumber:(NSString *)phoneNumber
                       withCallback:(HttpRequestCallBack *)callback;
@end

/**-----------------*/
/**类说明:更换手机号*/
@interface ChangePhoneNumber : JsonRequestObject
/** 更换手机号*/
+ (void)changeBindingPhoneWithNewPhoneNumber:(NSString *)newPhoneNumber
                          withOldPhoneNumber:(NSString *)oldPhoneNumber
                                withCallBack:(HttpRequestCallBack *)callback;
@end

/**-----------------*/
/**类说明:解绑手机号或三方id*/
@interface UnbindingPhoneOrThirdPart : JsonRequestObject
/**解绑手机号*/
+ (void)unbindingPhoneOrThirdPartWithPhoneNumberOrOpenID:
            (NSString *)phoneNumOrThirdID withCallback:
                (HttpRequestCallBack *)callback;
@end

/**-----------------*/
/** 类说明:三方绑定处理三方数据 */
@interface BindingMyAccount : JsonRequestObject
/** 绑定我的账户*/
+ (void)bindingMyAccountWithToken:(NSString *)token
                       withOpenId:(NSString *)openId
                     withNickName:(NSString *)nickName
                         withType:(NSString *)type
                     withCallback:(HttpRequestCallBack *)callback;
@end

/**-----------------*/
/** 类说明:绑定手机号 */
@interface PhoneNumberRegister : JsonRequestObject
/** 获取验证码 */
+ (void)phoneNumberRegisterWithPhoneNumber:(NSString *)phoneNumber
                                  withType:(NSString *)type
                              withCallback:(HttpRequestCallBack *)callback;
/**验证码、手机号验证*/
+ (void)
    phoneNumberRegisterWithAuthCodeVerifyWithPhoneNumber:(NSString *)phoneNumber
                                            withAuthCode:(NSString *)authCode
                                                withType:(NSString *)type
                                            withCallback:
                                                (HttpRequestCallBack *)callback;
@end

/**-----------------*/
/** 类说明:修改密码 */
@interface ChangePassword : JsonRequestObject
/** 修改密码 */
+ (void)changePasswordWithPassword:(NSString *)password
                  withOncePassword:(NSString *)oncePassword
                   withOldPassword:(NSString *)oldPassword
                      withCallback:(HttpRequestCallBack *)callback;
@end


