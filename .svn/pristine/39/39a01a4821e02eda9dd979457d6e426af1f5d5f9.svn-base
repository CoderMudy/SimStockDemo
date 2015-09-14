//
//  CollectTStockData.m
//  SimuStock
//
//  Created by Yuemeng on 14-12-9.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "CollectTStockData.h"
#import "JsonFormatRequester.h"

@implementation CollectTStockData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
}

+ (void)requestCollectTStockDataWithTStockId:(NSNumber *)tstockid
                                     withAct:(NSInteger)act
                                withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [istock_address
      stringByAppendingString:@"istock/talkstock/collecttstock/{ak}/"
      @"{sid}/{userid}/{tstockid}/{act}"];
  NSDictionary *dic = @{
    @"tstockid" : [tstockid stringValue],
    @"act" : [NSString stringWithFormat:@"%ld", (long)act]
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];

  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[CollectTStockData class]
             withHttpRequestCallBack:callback];
}

@end
