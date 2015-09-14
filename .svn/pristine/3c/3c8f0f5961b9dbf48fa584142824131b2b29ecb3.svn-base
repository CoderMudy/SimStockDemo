//
//  ShowBarInfoData.m
//  SimuStock
//
//  Created by Yuemeng on 14-12-1.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "ShowBarInfoData.h"
#import "JsonFormatRequester.h"

@implementation ModeratorInfoData
@end

@implementation ShowBarInfoData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];

  [self setValuesForKeysWithDictionary:dic[@"result"]];

  self.moderators = [[NSMutableArray alloc] init];
  NSArray *moderators = dic[@"result"][@"moderators"];
  for (NSDictionary *subDic in moderators) {
    ModeratorInfoData *moderatorInfoData = [[ModeratorInfoData alloc] init];
    [moderatorInfoData setValuesForKeysWithDictionary:subDic];
    [self.moderators addObject:moderatorInfoData];
  }
}

+ (void)requestShowBarInfoDataWithBarId:(NSNumber *)barId
                           withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [istock_address
      stringByAppendingString:
          @"istock/newTalkStock/showBarInfo?barId={barId}"]; // 1415943612555480

  NSDictionary *dic = @{ @"barId" : [barId stringValue] };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];

  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[ShowBarInfoData class]
             withHttpRequestCallBack:callback];
}

@end
