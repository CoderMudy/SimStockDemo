//
//  RemoveSelfGroupData.m
//  SimuStock
//
//  Created by Yuemeng on 15/6/17.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "RemoveSelfGroupData.h"
#import "JsonFormatRequester.h"

@implementation RemoveSelfGroupData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
}

+ (void)requestSelfStockGroupListDataWithGroupId:
            (NSString *)groupId callback:(HttpRequestCallBack *)callback {
  NSString *url = [user_address
      stringByAppendingFormat:@"jhss/portfolio/removeGroup?groupId=%@",
                              groupId];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];

  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[RemoveSelfGroupData class]
             withHttpRequestCallBack:callback];
}

@end
