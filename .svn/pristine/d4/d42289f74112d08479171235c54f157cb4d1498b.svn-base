//
//  MyStockBarListData.m
//  SimuStock
//
//  Created by Yuemeng on 14-11-24.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "MyStockBarListData.h"
#import "JsonFormatRequester.h"
#import "HotStockBarListData.h"

//@implementation MyBarsData
//@end

@implementation MyStockBarListData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.myBars = [[NSMutableArray alloc] init];

  NSArray *myBarsList = dic[@"result"][@"myBars"];
  for (NSDictionary *subDic in myBarsList) {
    HotStockBarData *myBarsData = [[HotStockBarData alloc] init];
    [myBarsData setValuesForKeysWithDictionary:subDic];
    [self.myBars addObject:myBarsData];
  }

  self.hasNew = [dic[@"result"][@"hasNew"] boolValue];
}

+ (void)requestMyStockBarListDataWithCallback:(HttpRequestCallBack *)callback {

  NSString *url =
      [istock_address stringByAppendingString:
                        @"istock/newTalkStock/getMyStockBarList?tweetId=0"];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[MyStockBarListData class]
             withHttpRequestCallBack:callback];
}

@end
