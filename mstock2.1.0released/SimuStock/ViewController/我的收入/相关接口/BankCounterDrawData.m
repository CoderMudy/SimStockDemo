//
//  BankCounterDrawData.m
//  SimuStock
//
//  Created by Yuemeng on 15/5/22.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BankCounterDrawData.h"

@implementation BankCounterDrawData

- (void)jsonToObject:(NSDictionary *)dic
{
    [super jsonToObject:dic];
}

+ (void)requestBankCounterDrawDataWithDic:(NSDictionary *)dic callback:(HttpRequestCallBack *)callback
{
    NSString *url =
    [pay_address stringByAppendingString:@"pay/bank/counter/draw"];
    
    JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
    
    [request asynExecuteWithRequestUrl:url
                     WithRequestMethod:@"POST"
                 withRequestParameters:dic
                withRequestObjectClass:[BankCounterDrawData class]
               withHttpRequestCallBack:callback];
}

@end
