//
//  AddTitleData.m
//  SimuStock
//
//  Created by Yuemeng on 14/12/30.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "AddTitleData.h"
#import "JsonFormatRequester.h"

@implementation AddTitleData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
}

+ (void)requestAddTitleDataWithTweetId:(NSNumber *)tid
                             withTitle:(NSString *)title
                          withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [istock_address
      stringByAppendingString:
          @"istock/newTalkStock/addTitle?tweetId={tweetid}&title={title}"];
  NSDictionary *dic = @{
    @"tweetid" : [tid stringValue],
    @"title" :
        [title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];

  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[AddTitleData class]
             withHttpRequestCallBack:callback];
}

@end
