//
//  MyWalletData.m
//  SimuStock
//
//  Created by Yuemeng on 15/5/25.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MyWalletData.h"

@implementation MyWalletData

- (void)jsonToObject:(NSDictionary *)dic
{
    [super jsonToObject:dic];
    [self setValuesForKeysWithDictionary:dic];
}

+ (void)requestMyWalletDataWithCallback:(HttpRequestCallBack *)callback
{
    NSString *url =
    [pay_address stringByAppendingString:@"pay/bank/counter/myWallet"];
    
    JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
    
    [request asynExecuteWithRequestUrl:url
                     WithRequestMethod:@"GET"
                 withRequestParameters:nil
                withRequestObjectClass:[MyWalletData class]
               withHttpRequestCallBack:callback];
}

@end
