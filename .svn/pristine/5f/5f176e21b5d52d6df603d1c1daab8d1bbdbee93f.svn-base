//
//  GetMyStockBarListData.m
//  SimuStock
//
//  Created by Yuemeng on 14-12-10.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "GetMyStockBarListData.h"
#import "JsonFormatRequester.h"

@implementation BarInfo
@end

@implementation GetMyStockBarListData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  _myBars = [[NSMutableArray alloc] init];

  _hasNew = (BOOL)dic[@"result"][@"hasNew"];
  NSArray *mybarsList = dic[@"result"][@"myBars"];

  for (NSDictionary *mybarDic in mybarsList) {
    BarInfo *barInfo = [[BarInfo alloc] init];
    [barInfo setValuesForKeysWithDictionary:mybarDic];
    [_myBars addObject:barInfo];
  }
}

+ (void)requestGetMyStockBarListDataWithTweetId:
            (NSNumber *)tweetId withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [istock_address
      stringByAppendingString:
          @"istock/newTalkStock/getMyStockBarList?tweetId={tweetId}"];
  NSDictionary *dic = @{ @"barId" : [tweetId stringValue] };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];

  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[GetMyStockBarListData class]
             withHttpRequestCallBack:callback];
}

@end
