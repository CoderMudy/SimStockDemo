//
//  UnEliteTweetStockData.m
//  SimuStock
//
//  Created by Yuemeng on 14-12-9.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "UnEliteTweetStockData.h"
#import "JsonFormatRequester.h"

@implementation UnEliteTweetStockData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
}

+ (void)requestUnEliteTweetStockWithBarId:(NSNumber *)barId
                              withTweetId:(NSNumber *)tweetId
                             withCallback:(HttpRequestCallBack *)callback {

  NSString *url =
      barId ? [istock_address stringByAppendingString:@"istock/newACLTalkStock/"
                            @"unEliteTweet?barId={barId}&tweetId={tweetId}"]
            : [istock_address stringByAppendingString:@"istock/newACLTalkStock/"
                            @"unEliteTweet?tweetId={tweetId}"];

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
              withRequestObjectClass:[UnEliteTweetStockData class]
             withHttpRequestCallBack:callback];
}

@end
