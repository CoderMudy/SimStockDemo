//
//  ApplicationRecomendListWrapper.m
//  SimuStock
//
//  Created by moulin wang on 14-11-19.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "ApplicationRecomendListWrapper.h"
#import "JsonFormatRequester.h"
@implementation ApplicationRecomendListWrapper

- (void)jsonToObject:(NSDictionary *)dic {
  NSLog(@"----------dic----------%@", dic);
  [super jsonToObject:dic];
  ApplicationRecomendListWrapper *item =
      [[ApplicationRecomendListWrapper alloc] init];
  self.AppDataArray = [[NSMutableArray alloc] init];
  NSArray *array = dic[@"result"];
  for (NSDictionary *subDict in array) {
    item.appUrl = subDict[@"apk_url"];
    item.appName = subDict[@"name"];
    item.appDetail = subDict[@"desc"];
    item.appNameSpace = subDict[@"namespace"];
    item.appVersion = subDict[@"version"];
    item.appLogo = subDict[@"logo_url"];
    item.appStatus = dic[@"status"];
    item.appMessage = dic[@"message"];
    [self.AppDataArray addObject:item];
  }
}
+ (void)requestPositionDataWithGetAK:(NSString *)GetAK
                     withGetSesionID:(NSString *)GetSesionID
                        withCallback:(HttpRequestCallBack *)callback {
  NSString *url =
      [NSString stringWithFormat:@"%@jhss/common/moreapp/%@/%@", user_address,
                                 [SimuUtil getAK], [SimuUtil getSesionID]];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[ApplicationRecomendListWrapper class]
             withHttpRequestCallBack:callback];
}
@end
