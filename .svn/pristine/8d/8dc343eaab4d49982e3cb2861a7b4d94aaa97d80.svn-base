//
//  SimuMatchUsesData.m
//  SimuStock
//
//  Created by jhss on 15/8/11.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SimuMatchUsesData.h"
#import "JsonFormatRequester.h"

@implementation SimuMatchUsesData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  //获得比赛用途
  self.dataArray = dic[@"result"];
}

+ (void)requestSimuMatchUsesDataWithCallback:(HttpRequestCallBack *)callback {

  NSString *url =
      [school_match_uses stringByAppendingString:@"youguu/match/school_match_uses"];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];

  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[SimuMatchUsesData class]
             withHttpRequestCallBack:callback];
}

@end
