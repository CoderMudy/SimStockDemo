//
//  DropTStockData.m
//  SimuStock
//
//  Created by Yuemeng on 14-12-9.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "DropTStockData.h"
#import "JsonFormatRequester.h"

@implementation DropTStockData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
}

+ (void)requestDropTStockDataWithBarId:(NSNumber *)barId
                           withTweetId:(NSNumber *)tweetId
                          withCallback:(HttpRequestCallBack *)callback {
  NSString *url =
      barId ? [istock_address stringByAppendingString:@"istock/newACLTalkStock/"
                            @"dropTStock?barId={barId}&tweetId={tweetId}"]
            : [istock_address stringByAppendingString:@"istock/newACLTalkStock/"
                            @"dropTStock?tweetId={tweetId}"];

    NSDictionary *dic;
    if (barId) {
      dic = @{
        @"barId" : [barId stringValue],
        @"tweetId" : [tweetId stringValue]
      };
    } else {
      dic = @{ @"tweetId" : [tweetId stringValue] };
    }

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];

  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[DropTStockData class]
             withHttpRequestCallBack:callback];
}

@end
