//
//  SimuOpenAccountData.m
//  SimuStock
//
//  Created by Yuemeng on 14-11-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SimuOpenAccountData.h"
#import "JsonFormatRequester.h"

@implementation SimuOpenAccountData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];

  if (dic == nil) {
    return;
  }
}

+ (void)requestSimuOpenAccountDataWithMatchId:(NSString *)matchId
                                     withType:(NSInteger)type
                                 withCallback:(HttpRequestCallBack *)callback {

  NSString *url = data_address;
  url = [url
      stringByAppendingFormat:@"youguu/match/openAccount?matchId=%@&type=%ld",
                              matchId, (long)type];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[SimuOpenAccountData class]
             withHttpRequestCallBack:callback];
}

@end
