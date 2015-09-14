//
//  ExchangeDiamondData.h
//  SimuStock
//
//  Created by Yuemeng on 15/5/25.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"
#import "JsonFormatRequester.h"

/*
 *  兑换钻石接口
 */
@interface ExchangeDiamondData : JsonRequestObject

+ (void)requestExchangeDiamondDataWithUserName:(NSString *)userName
                                      nickName:(NSString *)nickName
                                       diamond:(NSString *)diamond
                                           fee:(NSString *)fee
                                      callback:(HttpRequestCallBack *)callback;
@end
