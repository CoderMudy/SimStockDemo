//
//  MyWalletFlowData.m
//  SimuStock
//
//  Created by Yuemeng on 15/5/25.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MyWalletFlowData.h"

@implementation MyWalletFlowData

- (void)jsonToObject:(NSDictionary *)dic {

  self.dataArray = [[NSMutableArray alloc] init];

  [super jsonToObject:dic];
  NSArray *results = dic[@"result"];

  [results enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx,
                                        BOOL *stop) {
    MyWalletFlowElement *element = [[MyWalletFlowElement alloc] init];
    [element setValuesForKeysWithDictionary:dic];
    [self.dataArray addObject:element];
  }];
}

- (NSArray *)getArray {
  return _dataArray;
}

+ (void)requestMyWalletFlowDataWithStart:(NSDictionary *)dic
                            withCallback:(HttpRequestCallBack *)callback {
  NSString *url =
      [pay_address stringByAppendingString:
                       @"pay/bank/counter/queryMyWalletFlow?start={start}"];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[MyWalletFlowData class]
             withHttpRequestCallBack:callback];
}

@end

@implementation MyWalletFlowElement
@end