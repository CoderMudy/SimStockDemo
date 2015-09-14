//
//  WFFinancingParse.h
//  SimuStock
//
//  Created by Jhss on 15/4/17.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonFormatRequester.h"

/** 1.1是否进行了实名认证 */
@interface WFIsRealNameAuth : JsonRequestObject

///是否进行了实名认证,true:已认证，false:未认证
@property(nonatomic, assign) BOOL authFlag;

@end

/** 1.2实名认证*/
@interface WFRealNameAuthRequest : JsonRequestObject

@end

/** 1.3绑定手机号接口 */
@interface WFBindMobilePhone : JsonRequestObject

@end

@interface WFgetRealNameAuth : JsonRequestObject

@end

#pragma mark

@interface WFFinancingParse : NSObject

/** 1.1用户是否已经实名认证 */
+ (void)wfIsRealNameAuthenticationWithCallback:(HttpRequestCallBack *)callback;

#pragma mark
/** 1.2实名认证接口 */
+ (void)wfUserRealNameAuthenticationWithRealName:(NSString *)realName
                                    withCertType:(NSString *)certType
                                      withCertNo:(NSString *)certNo
                                    withCallback:
                                        (HttpRequestCallBack *)callback;
/** 1.3 绑定手机号接口 */
+ (void)bindMobileCodeWithPhone:(NSString *)phone
                 withVerifycode:(NSString *)verifycode
                   withCallback:(HttpRequestCallBack *)callback;

// 1.4查询实名认证信息
+ (void)wfgetRealNameAuthenticationWithCallback:(HttpRequestCallBack *)callback;

@end
