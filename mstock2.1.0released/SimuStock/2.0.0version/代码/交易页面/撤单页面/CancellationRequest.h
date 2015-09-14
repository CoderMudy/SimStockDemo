//
//  CancellationRequest.h
//  SimuStock
//
//  Created by 刘小龙 on 15/7/15.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"
@class HttpRequestCallBack;

//撤单类
@interface CancellationRequest : JsonRequestObject

/** 用户撤单 */
+ (void)requstUserCancellation:(NSString *)mathcId
                    withEntrus:(NSString *)entrus
                  withCallback:(HttpRequestCallBack *)callback;

/** 牛人撤单 */
+ (void)requestExpertCancellation:(NSString *)accountId
                 withCommissionId:(NSString *)commissionId
                     withCallback:(HttpRequestCallBack *)callback;

@end
