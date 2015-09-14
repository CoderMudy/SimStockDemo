//
//  ModifySelfGroupData.m
//  SimuStock
//
//  Created by Yuemeng on 15/6/17.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ModifySelfGroupData.h"
#import "JsonFormatRequester.h"

@implementation ModifySelfGroupData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
}

+ (void)requestSelfStockGroupListDataWithGroupId:(NSString *)groupId
                                   withGroupName:(NSString *)groupName
                                        Callback:
                                            (HttpRequestCallBack *)callback {
  NSString *url =
      [user_address stringByAppendingFormat:
                        @"jhss/portfolio/modifyGroup?groupId=%@&groupName=%@",
                        groupId, [CommonFunc base64StringFromText:groupName]];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];

  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[ModifySelfGroupData class]
             withHttpRequestCallBack:callback];
}

@end
