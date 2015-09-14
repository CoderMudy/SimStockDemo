
//
//  NewSelfGroupData.m
//  SimuStock
//
//  Created by Yuemeng on 15/6/17.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "NewSelfGroupData.h"
#import "JsonFormatRequester.h"

@implementation NewSelfGroupData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
   self.dic = dic;
}

+ (void)requestNewSelfGroupName:(NSString *)groupName
                   WithCallback:(HttpRequestCallBack *)callback {
  NSString *url = [user_address
      stringByAppendingFormat:@"jhss/portfolio/newGroup?groupName=%@",
                              [CommonFunc base64StringFromText:groupName]];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];

  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[NewSelfGroupData class]
             withHttpRequestCallBack:callback];
}

@end
