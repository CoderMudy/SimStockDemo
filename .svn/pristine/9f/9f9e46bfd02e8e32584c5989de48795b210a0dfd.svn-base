//
//  SimuDoBuyQueryData.m
//  SimuStock
//
//  Created by Yuemeng on 14-11-17.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

@implementation SimuDoBuyQueryData

- (void)jsonToObject:(NSDictionary *)dic
{
    
}

+ (void)requestSimuDoBuyQueryDataWithStockCode:(NSString *)stockCode
                                  withCallback:(HttpRequestCallBack *)callback
{
    
    NSString *url = data_address;
    NSString *noparamURL =
    [url stringByAppendingString:@"youguu/simtrade/dobuyquery/"];

    
    NSString *m_stockCode = [NSString stringWithString:stockCode];
    if ([stockCode length] == 8) {
        m_stockCode = [NSString stringWithString:[stockCode substringFromIndex:2]];
    }

    
}

@end
