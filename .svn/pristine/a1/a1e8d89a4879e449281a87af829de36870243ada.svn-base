//
//  HeadImageList.m
//  SimuStock
//
//  Created by jhss on 14-11-17.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "HeadImageList.h"
#import "HeadItem.h"

@implementation HeadImageList
- (void)jsonToObject:(NSDictionary *)obj {
  [super jsonToObject:obj];
  self.headArray = [[NSMutableArray alloc] init];
  NSArray *array = obj[@"result"];
  if (array == nil)
    return;
  for (NSDictionary *subDict in array) {
    HeadItem *item = [[HeadItem alloc] init];
    item.mID = subDict[@"id"];
    item.mRank = subDict[@"rank"];
    item.mType = subDict[@"type"];
    item.mUrl = subDict[@"url"];
    [self.headArray addObject:item];
  }
}
+ (void)getUserIconListWithCallBack:(HttpRequestCallBack *)callback {
  NSString *url = [NSString
      stringWithFormat:@"%@jhss/member/usericonlist/%@/%@", user_address,
                       [SimuUtil getAK], [SimuUtil getSesionID]];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[HeadImageList class]
             withHttpRequestCallBack:callback];
}

@end
