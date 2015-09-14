//
//  MyChatStockListWrapper.m
//  SimuStock
//
//  Created by moulin wang on 14-12-15.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "MyChatStockListWrapper.h"


@implementation MyChatStockListWrapper

- (void)jsonToObject:(NSDictionary *)dic {
  //NSLog(@"%@",dic);
  [super jsonToObject:dic];
  self.tweetListArray = [[NSMutableArray alloc] init];
  /**UserListWrapper方法类*/
  UserListWrapper *userListW = [[UserListWrapper alloc] init];
  /**userList节点解析*/
  NSDictionary *resultDict = dic[@"result"];
  NSArray *userLists = resultDict[@"userList"];
  [userListW jsonToMap:userLists];

  /**tweetList节点解析*/
  self.messageListArray = [[NSMutableArray alloc] init];
  NSDictionary *resultDic = dic[@"result"];
  NSArray *array = resultDic[@"tweetList"];
  for (NSDictionary *subDic in array) {
    TweetListItem *item = [[TweetListItem alloc] init];
    item.writer = [[UserListItem alloc] init];
    //解析tweetList部分
    [item jsonToObject:subDic];
    //找到userList的uid
    NSString *uid = [SimuUtil changeIDtoStr:subDic[@"uid"]];
    item.writer = [userListW getUserById:uid];
    //通过共同的uidtmcList,userList共同加到messageListArray
    [self.messageListArray addObject:item];
  }
}

+ (void)requestPositionDataWithCallback:(HttpRequestCallBack *)callback
                          requestUserID:(NSString *)userID
                          requestFromID:(NSString *)fromID
                          requestReqNum:(NSString *)reqNum {
  NSString *url = [istock_address
      stringByAppendingFormat:
          @"istock/newTalkStock/myTweets?userid=%@&fromId=%@&reqNum=%@", userID,
          fromID, reqNum];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[MyChatStockListWrapper class]
             withHttpRequestCallBack:callback];
}

@end
