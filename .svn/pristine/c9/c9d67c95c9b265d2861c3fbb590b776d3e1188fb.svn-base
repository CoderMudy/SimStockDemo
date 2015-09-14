//
//  UserTradeGradeItem.m
//  SimuStock
//
//  Created by Yuemeng on 15/3/8.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "UserTradeGradeItem.h"
#import "JsonFormatRequester.h"


@implementation UserTradeGradeItem

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
  NSLog(@"👽! UserTradeGradeItem类发现不明key：%@", key);
}

- (void)jsonToObject:(NSDictionary *)dic
{
  [super jsonToObject:dic];
  NSDictionary *subDic = dic[@"result"];
  if (subDic) {
    [self setValuesForKeysWithDictionary:subDic];
  } else {
    self.isNil = YES;
  }
}

+(void)requestUserTradeGradeItemWithUID:(NSString *)uid withCallback:(HttpRequestCallBack *)callback
{
  NSString *url = [data_address stringByAppendingFormat:@"youguu/rating/score?userid={userid}&matchid={matchid}"];
  
  NSDictionary *dic = @{@"userid": uid, @"matchid": @"1"};
  
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[UserTradeGradeItem class]
             withHttpRequestCallBack:callback];
}

@end
