//
//  PraiseList.m
//  SimuStock
//
//  Created by jhss on 14-12-24.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "PraiseList.h"

@implementation PraiseList

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  NSMutableArray *array = [[NSMutableArray alloc] init];
  NSDictionary *resultDict = dic[@"result"];
  /** userlist 节点解析 */
  UserListWrapper *userListWrapper = [[UserListWrapper alloc] init];
  NSArray *userLists = resultDict[@"userList"];
  [userListWrapper jsonToMap:userLists];
  NSArray *praiseLists = resultDict[@"tmcList"];
  //保存所有赞消息
  for (NSDictionary *praiseDict in praiseLists) {
    PraiseList *item = [[PraiseList alloc] init];
    [item.writer setValuesForKeysWithDictionary:praiseDict];
    NSString *uid = [SimuUtil changeIDtoStr:praiseDict[@"uid"]];
    item.writer = [userListWrapper getUserById:uid];
    [item setValuesForKeysWithDictionary:praiseDict];
    [array addObject:item];
  }
  self.dataArray = [NSMutableArray arrayWithArray:array];
}
- (NSArray *)getArray {
  return _dataArray;
}
/** 请求赞列表信息 */
// http://ip:port/istock/newTalkStock/praiselist?tweetId={tweetId}&fromId={fromId}&reqNum={reqNum}
+ (void)getPraiseListsWithTweetDic:(NSDictionary *)dic
                      withCallback:(HttpRequestCallBack *)callback{
  NSString *url =
      [NSString stringWithFormat:@"%@istock/newTalkStock/"
                                 @"praiselist?tweetId={tweetId}&fromId={"
                                 @"fromId}&reqNum={reqNum}",
                                 istock_address];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[PraiseList class]
             withHttpRequestCallBack:callback];
}

@end
