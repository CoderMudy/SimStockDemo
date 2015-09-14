//
//  MessageCenterListWrapper.m
//  SimuStock
//
//  Created by moulin wang on 14-11-25.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "MessageCenterListWrapper.h"
#import "JsonFormatRequester.h"

@implementation MessageListItem

- (void)jsonToObject:(NSDictionary *)dic {
  self.content = dic[@"content"];
  self.des = dic[@"des"];
  self.uid = dic[@"uid"];
  self.ctime = dic[@"ctime"];
  self.msgid = dic[@"msgid"];
  self.relateid = dic[@"relateid"];
  self.stype = [dic[@"stype"] intValue];
  self.tweetid = dic[@"tweetid"];
  self.type = [dic[@"type"] intValue];
}

@end

@implementation MessageCenterListWrapper

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];

  NSLog(@"---------------@我%@---------------", dic);

  self.userListsArray = [[NSMutableArray alloc] init];
  NSDictionary *resultDict = dic[@"result"];

  /**userList节点解析*/
  UserListWrapper *userListWrapper = [[UserListWrapper alloc] init];
  NSArray *userLists = resultDict[@"userList"];
  [userListWrapper jsonToMap:userLists];

  /**tmcList节点解析*/
  self.messageListArray = [[NSMutableArray alloc] init];
  NSDictionary *resultDic = dic[@"result"];
  NSArray *array = resultDic[@"tmcList"];
  for (NSDictionary *subDic in array) {
    MessageListItem *item = [[MessageListItem alloc] init];
    //解析tmcList部分
    [item jsonToObject:subDic];
    //找到userList的uid
    NSString *uid = [SimuUtil changeIDtoStr:subDic[@"uid"]];
    item.writer = [userListWrapper getUserById:uid];
    //通过共同的uidtmcList,userList共同加到messageListArray
    [self.messageListArray addObject:item];
  }
}

- (NSArray *)getArray {
  return self.messageListArray;
}
+ (void)requestPositionDataWithInput:(NSDictionary *)dic
                       withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [istock_address
      stringByAppendingFormat:@"istock/newTalkStock/"
                              @"msgCenterType?type={type}&fromId={fromId}&"
                              @"reqNum={reqNum}"];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[MessageCenterListWrapper class]
             withHttpRequestCallBack:callback];
}

@end
