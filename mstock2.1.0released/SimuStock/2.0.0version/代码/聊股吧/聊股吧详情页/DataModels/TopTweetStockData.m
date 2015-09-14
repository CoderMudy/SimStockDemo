//
//  TopTweetStockData.m
//  SimuStock
//
//  Created by Yuemeng on 14-12-9.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "TopTweetStockData.h"
#import "JsonFormatRequester.h"

@implementation TopTweetStockData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
}

+ (void)requestTopTweetStockDataWithBarId:(NSNumber *)barId
                              withTweetId:(NSNumber *)tweetId
                                 withType:(NSInteger)type
                             withCallback:(HttpRequestCallBack *)callback {

  NSString *url =
      barId ? [istock_address stringByAppendingString:@"istock/newACLTalkStock/"
                            @"topTweet?barId={barId}&tweetId={"
                            @"tweetId}&type={type}"]
            : [istock_address stringByAppendingString:@"istock/newACLTalkStock/"
                            @"topTweet?tweetId={" @"tweetId}&type={type}"];

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
              withRequestObjectClass:[TopTweetStockData class]
             withHttpRequestCallBack:callback];
}

@end
