//
//  GetBarTopListData.m
//  SimuStock
//
//  Created by Yuemeng on 14-12-2.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "GetBarTopListData.h"
#import "JsonFormatRequester.h"

@implementation BarTopTweetData
@end

@implementation GetBarTopListData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.dataArray = [[NSMutableArray alloc] init];

  NSArray *topListArray = dic[@"result"];
  for (NSDictionary *subDic in topListArray) {
    BarTopTweetData *barTopTweetData = [[BarTopTweetData alloc] init];
    [barTopTweetData setValuesForKeysWithDictionary:subDic];
    [self.dataArray addObject:barTopTweetData];
  }
}

+ (void)requestGetBarTopListDataWithBarId:(NSNumber *)barId
                             withCallback:(HttpRequestCallBack *)callback {
  NSString *url =
      [istock_address stringByAppendingString:
                        @"istock/newTalkStock/getBarTopList?barId={barId}"];

  NSDictionary *dic = @{ @"barId" : [barId stringValue] };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];

  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[GetBarTopListData class]
             withHttpRequestCallBack:callback];
}

@end
