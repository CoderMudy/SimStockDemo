//
//  ModifySelfStockData.m
//  SimuStock
//
//  Created by Yuemeng on 15/6/17.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ModifySelfStockData.h"
#import "JsonFormatRequester.h"
#import "QuerySelfStockData.h"

@implementation ModifySelfStockData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];

  _ver = [dic[@"ver"] stringValue];
  _portfolio = dic[@"portfolio"];

  if (_portfolio) {
    [_portfolio enumerateObjectsUsingBlock:^(NSDictionary *subDic,
                                             NSUInteger idx, BOOL *stop) {
      QuerySelfStockElement *element = [[QuerySelfStockElement alloc] init];
      [element jsonToObject:subDic];
      [_dataArray addObject:element];
    }];
  }
}

+ (void)requestModifySelfStockDataWithParams:(NSDictionary *)dic
                                    callback:(HttpRequestCallBack *)callback {
  NSString *URL = [user_address
      stringByAppendingString:@"jhss/portfolio/modifyPortfolioStock"];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:URL
                   WithRequestMethod:@"POST"
               withRequestParameters:dic
              withRequestObjectClass:[ModifySelfStockData class]
             withHttpRequestCallBack:callback];
}

@end
