//
//  AuthIsBindingPhoneData.h
//  SimuStock
//
//  Created by Yuemeng on 15/5/25.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"
#import "JsonFormatRequester.h"

/*
 *  验证用户手机是否绑定
 */
@interface AuthIsBindingPhoneData : JsonRequestObject
//status:   0000：已绑定手机  0022：未绑定手机

+ (void)requestAuthIsBindingPhoneData:(HttpRequestCallBack *)callback;

@end
