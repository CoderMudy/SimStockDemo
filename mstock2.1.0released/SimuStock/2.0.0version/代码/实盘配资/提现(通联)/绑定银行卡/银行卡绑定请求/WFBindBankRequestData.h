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

@interface WFBindCardNumRequest : JsonRequestObject


@end


@interface WFBindBankRequestData : NSObject

/** 绑定银行卡请求 */
+ (void)requestBindBankWithChannel:(NSString *)channel
                        withCardNo:(NSString *)cardNo
                        withBankid:(NSString *)bankId
                      withCallback:(HttpRequestCallBack *)callback;

@end
