//
//  WFBindBankRequestData.h
//  SimuStock
//
//  Created by moulin wang on 15/4/22.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonFormatRequester.h"
@class HttpRequestCallBack;

@interface WFBindBankRequestData : JsonRequestObject

/** 绑定银行卡请求 */
+ (void)requestBindBankWithRealName:(NSString *)realName
             withIdentityCardNumber:(NSString *)identityNumber
                 withBankCardNumber:(NSString *)bankCardNumber
                         withBankid:(int)bankID
                       withCallback:(HttpRequestCallBack *)callback;

@end
