//
//  BankCounterDrawData.h
//  SimuStock
//
//  Created by Yuemeng on 15/5/22.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"
#import "JsonFormatRequester.h"

/*
 *  申请提现接口
 */
@interface BankCounterDrawData : JsonRequestObject

+ (void)requestBankCounterDrawDataWithDic:(NSDictionary *)dic
                                 callback:(HttpRequestCallBack *)callback;

@end
