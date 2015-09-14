//
//  RealTradeLoginResponse.h
//  SimuStock
//
//  Created by Mac on 14-9-19.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

@class HttpRequestCallBack;

@interface RealTradeLoginResponse : JsonRequestObject

/**
 客户号
 */
@property(nonatomic, strong) NSString *customerId;

/**
 客户姓名
 */
@property(nonatomic, strong) NSString *customerName;

/**
 令牌
 */
@property(nonatomic, strong) NSString *customerToken;

/**
 jsessionid
 */
@property(nonatomic, strong) NSString *customerSessionId;

+ (void)loginWithUrl:(NSString *)url
         withCaptcha:(NSString *)catcheCode
     withAccountType:(NSString *)accountType
         withAccount:(NSString *)account
        withPassword:(NSString *)password
        withCallback:(HttpRequestCallBack *)callback;

@end
