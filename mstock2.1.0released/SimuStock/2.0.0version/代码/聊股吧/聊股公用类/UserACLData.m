//
//  UserACLData.m
//  SimuStock
//
//  Created by Yuemeng on 14/12/26.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "UserACLData.h"
#import "JsonFormatRequester.h"

@implementation UserACLData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];

  [self setValuesForKeysWithDictionary:dic[@"result"]];

  NSDictionary *actionList = dic[@"result"][@"actionList"];
  for (NSDictionary *subDic in actionList) {
    NSString *numStr = [subDic valueForKey:@"num"];
    NSInteger strNum = [numStr intValue];
    switch (strNum) {
    case 1001: {
      //能否全局置顶
      _enableGlobleTop = YES;
    } break;
    case 2001: {
      //能否取消全局置顶
      _enableUnGlobleTop = YES;
    } break;
    case 1002: {
      // 能否置顶
      _enableTop = YES;
    } break;
    case 2002: {
      // 能否取消置顶
      _enableUnTop = YES;
    } break;
    case 1003: {
      // 能否加精
      _enableElite = YES;
    } break;
    case 2003: {
      // 能否取消加精
      _enableUnElite = YES;
    } break;
    case 1004: {
      // 能否删除
      _enableDelete = YES;
    } break;

    default:
      break;
    }
  }
}

+ (void)requestUserACLDataWithCallback:(HttpRequestCallBack *)callback {
  NSString *url =
      [istock_address stringByAppendingString:@"istock/newTalkStock/getUserACL"];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[UserACLData class]
             withHttpRequestCallBack:callback];
}

@end
