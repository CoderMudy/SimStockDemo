//
//  InvieFriendListWarpper.m
//  SimuStock
//
//  Created by moulin wang on 14-11-19.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "InvieFriendListWarpper.h"
#import "JsonFormatRequester.h"

@implementation InvieFriendListWarpper

- (void)jsonToObject:(NSDictionary *)dic {
  //邀请好友
  [super jsonToObject:dic];
  self.InvieFriendDataArray = [[NSMutableArray alloc] init];
  NSArray *array = dic[@"result"];
  for (NSDictionary *obj in array) {
    InvieFriendListWarpper *item = [[InvieFriendListWarpper alloc] init];
    item.userId = [SimuUtil changeIDtoStr:obj[@"userId"]];
    item.nickName = obj[@"nickName"];
    item.headPic = obj[@"headPic"];
    item.flag = [obj[@"flag"] boolValue];
    [self.InvieFriendDataArray addObject:item];
  }
  NSLog(@"这个是dic----------%@", dic);
}

+ (void)requestPositionDataWithCallback:(HttpRequestCallBack *)callback {
  NSString *url = [user_address
      stringByAppendingString:@"jhss/member/queryInviteFriendList/"];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[InvieFriendListWarpper class]
             withHttpRequestCallBack:callback];
}

@end





