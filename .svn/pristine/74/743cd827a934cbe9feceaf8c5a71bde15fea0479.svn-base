//
//  UnFollowStockBarData.m
//  SimuStock
//
//  Created by Yuemeng on 14-12-10.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "UnFollowStockBarData.h"
#import "JsonFormatRequester.h"

@implementation UnFollowStockBarData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
}

+ (void)requestUnFollowStockBarDataWithBarId:(NSNumber *)barId
                                withCallback:(HttpRequestCallBack *)callback {
  NSString *url =
      [istock_address stringByAppendingString:
                        @"istock/newTalkStock/unFollowStockBar?barId={barId}"];
  NSDictionary *dic = @{ @"barId" : [barId stringValue] };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];

  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[UnFollowStockBarData class]
             withHttpRequestCallBack:callback];
}

@end
