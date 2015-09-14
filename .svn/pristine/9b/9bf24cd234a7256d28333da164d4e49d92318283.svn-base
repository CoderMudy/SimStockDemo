//
//  SendVerifyCodeData.h
//  SimuStock
//
//  Created by Yuemeng on 15/5/22.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"
#import "JsonFormatRequester.h"

typedef NS_ENUM(NSUInteger, CodeType) {
  CodeTypeGetCash = 4,                     //提现
  CodeTypeUnBindPhone,                     //解绑手机号
  CodeTypeTeamMatchCreated,                //团队赛创建
  CodeTypeUnpackRedPacket,                 //拆红包
  CodeTypeFinancialSupermarketOpenAccount, //理财超市开户
  CodeTypeWithFundPhoneCertify,            //配资手机号验证
  CodeTypeFinancialSupermarketFindCode,    //理财超市找回交易密码
   CodeTypeChanagePassWord = 11,            //修改密码
   CodeTypeBindingPhoneNumber = 3,          //绑定手机号
  CodeTypeUserLoginLossPassword = 2,       //登陆页面忘记密码获取验证码
};

/*
 *  发送手机验证码
 */
@interface SendVerifyCodeData : JsonRequestObject

+ (void)requestPhoneVerifyCodeWithPhoneNumber:(NSString *)phoneNumber type:(CodeType)codeType callback:(HttpRequestCallBack *)callback;

@end
