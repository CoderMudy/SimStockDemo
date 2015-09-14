//
//  SimuMatchGetInviteCodeData.m
//  SimuStock
//
//  Created by Yuemeng on 14-11-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SimuMatchGetInviteCodeData.h"
#import "JsonFormatRequester.h"

@implementation SimuMatchGetInviteCodeData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.dataArray = [[NSMutableArray alloc] init];
  [self.dataArray addObject:[SimuUtil changeIDtoStr:dic[@"userId"]]];
  [self.dataArray addObject:[SimuUtil changeIDtoStr:dic[@"inviteCode"]]];
}

+ (void)requestSimuMatchGetInviteCodeDataWithCallback:
            (HttpRequestCallBack *)callback {
  NSString *url =
      [data_address stringByAppendingString:@"youguu/match/getInviteCode"];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[SimuMatchGetInviteCodeData class]
             withHttpRequestCallBack:callback];
}

@end
