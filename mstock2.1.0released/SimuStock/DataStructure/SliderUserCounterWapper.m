//
//  SliderUserCounterWapper.m
//  SimuStock
//
//  Created by Mac on 14-10-30.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SliderUserCounterWapper.h"
#import "JsonFormatRequester.h"


@implementation SliderCounterItem

- (void)jsonToObject:(NSDictionary *)dic {
  self.totalNum = [SimuUtil changeIDtoStr:dic[@"num"]];
  self.percentage = dic[@"rate"];
}

@end

@implementation SliderUserCounterWapper

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];

  NSDictionary *resultDic = dic[@"result"];

  self.mytrace = [[SliderCounterItem alloc] init];
  [self.mytrace jsonToObject:resultDic[@"mytrace"]];

  self.myfollow = [[SliderCounterItem alloc] init];
  [self.myfollow jsonToObject:resultDic[@"myfollow"]];

  self.myfans = [[SliderCounterItem alloc] init];
  [self.myfans jsonToObject:resultDic[@"myfans"]];

  self.mytrade = [[SliderCounterItem alloc] init];
  [self.mytrade jsonToObject:resultDic[@"mytrade"]];

  self.myistock = [[SliderCounterItem alloc] init];
  [self.myistock jsonToObject:resultDic[@"myistock"]];

  self.mycollect = [[SliderCounterItem alloc] init];
  [self.mycollect jsonToObject:resultDic[@"mycollect"]];
}



/** 请求用户计数信息 */
+ (void)requestUserCounterWithCallback:(HttpRequestCallBack *)callback {

  NSString *url =
      [data_address stringByAppendingString:@"youguu/simtrade/getUserCounter"];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[SliderUserCounterWapper class]
             withHttpRequestCallBack:callback];
}

@end
