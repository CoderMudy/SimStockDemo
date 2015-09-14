//
//  FollowStockBarData.m
//  SimuStock
//
//  Created by Yuemeng on 14-12-10.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "FollowStockBarData.h"
#import "JsonFormatRequester.h"

@implementation FollowStockBarData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];

  _remain = dic[@"remain"];
}

+ (void)requestFollowStockBarDataWithBarId:(NSNumber *)barId
                              withCallback:(HttpRequestCallBack *)callback {
  NSString *url =
      [istock_address stringByAppendingString:
                        @"istock/newTalkStock/followStockBar?barId={barId}"];
  NSDictionary *dic = @{ @"barId" : [barId stringValue] };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];

  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[FollowStockBarData class]
             withHttpRequestCallBack:callback];
}

@end
