//
//  UnTopTweetStockData.m
//  SimuStock
//
//  Created by Yuemeng on 14-12-9.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "UnTopTweetStockData.h"
#import "JsonFormatRequester.h"

@implementation UnTopTweetStockData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
}

+ (void)requestUnTopTweetStockWithBarId:(NSNumber *)barId
                            withTweetId:(NSNumber *)tweetId
                               withType:(NSInteger)type
                           withCallback:(HttpRequestCallBack *)callback {

  NSString *url =
      barId ? [istock_address stringByAppendingString:@"istock/newACLTalkStock/"
                            @"unTopTweet?barId={barId}&"
                            @"tweetId={tweetId}&type={type}"]
            : [istock_address stringByAppendingString:@"istock/newACLTalkStock/"
                            @"unTopTweet?tweetId={tweetId}&type={type}"];

  NSDictionary *dic;
  if (barId) {
    dic = @{
      @"barId" : [barId stringValue],
      @"tweetId" : [tweetId stringValue],
      @"type" : [NSString stringWithFormat:@"%ld", (long)type]
    };
  } else {
    dic = @{
      @"tweetId" : [tweetId stringValue],
      @"type" : [NSString stringWithFormat:@"%ld", (long)type]
    };
  }

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];

  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[UnTopTweetStockData class]
             withHttpRequestCallBack:callback];
}

@end
