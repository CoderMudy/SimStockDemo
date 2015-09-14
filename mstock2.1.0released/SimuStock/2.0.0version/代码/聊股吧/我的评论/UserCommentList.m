//
//  UserCommentList.m
//  SimuStock
//
//  Created by jhss_wyz on 15/5/25.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "UserCommentList.h"
#import "JsonFormatRequester.h"
#import "TweetListItem.h"

@implementation UserCommentList

- (void)jsonToObject:(NSDictionary *)dic {
  // NSLog(@"%@",dic);
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
    NSInteger type = [subDic[@"type"] integerValue];
    if (type != 3) {
      continue;
    }
    TweetListItem *item = [[TweetListItem alloc] init];
    item.userListItem = [[UserListItem alloc] init];
    //解析tweetList部分
    [item jsonToObject:subDic];
    //找到userList的uid
    NSString *uid = [SimuUtil changeIDtoStr:subDic[@"uid"]];
    item.userListItem = [userListW getUserById:uid];
    //通过共同的uidtmcList,userList共同加到messageListArray
    [self.messageListArray addObject:item];
  }
}

- (NSArray *)getArray {
  return self.messageListArray;
}

+ (void)requestCommentDataWithCallback:(HttpRequestCallBack *)callback
                         requestUserID:(NSString *)userID
                         requestFromID:(NSString *)fromID
                         requestReqNum:(NSString *)reqNum {
  NSString *url = [istock_address
      stringByAppendingFormat:
          @"istock/newTalkStock/usercommenttweet?userid=%@&fromId=%@&reqNum=%@",
          userID, fromID, reqNum];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[UserCommentList class]
             withHttpRequestCallBack:callback];
}

@end
