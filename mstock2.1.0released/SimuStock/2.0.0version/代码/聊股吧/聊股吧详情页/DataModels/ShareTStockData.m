//
//  ShareTStockData.m
//  SimuStock
//
//  Created by Yuemeng on 14-12-9.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "ShareTStockData.h"
#import "JsonFormatRequester.h"

@implementation ShareTStockData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
}

+ (void)requestShareTStockWithTid:(NSNumber *)tid
                     withCallback:(HttpRequestCallBack *)callback {
  NSString *url =
      [istock_address stringByAppendingString:
                        @"istock/talkstock/share/{ak}/{sid}/{userid}/{tid}"];
  NSDictionary *dic = @{ @"tid" : [tid stringValue] };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];

  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[ShareTStockData class]
             withHttpRequestCallBack:callback];
}

@end
