//
//  FindWindVaneData.m
//  SimuStock
//
//  Created by Yuemeng on 15/5/13.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "FindWindVaneData.h"

@implementation FindWindVaneData

- (id)valueForUndefinedKey:(NSString *)key {
  NSLog(@"FindWindVaneData's UndefinedKey is :%@", key);
  return nil;
}

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];

  [self setValuesForKeysWithDictionary:dic[@"result"]];
}

+ (void)requsetFindWindVaneData:(HttpRequestCallBack *)callback {
  NSString *url =
      [adData_address stringByAppendingString:@"asteroid/vote/findWindVane"];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[FindWindVaneData class]
             withHttpRequestCallBack:callback];
}

@end
