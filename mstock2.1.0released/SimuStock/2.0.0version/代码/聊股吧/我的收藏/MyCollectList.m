//
//  MyCollectList.m
//  SimuStock
//
//  Created by jhss_wyz on 15/6/3.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MyCollectList.h"
#import "JsonFormatRequester.h"
#import "TweetListItem.h"
#import "WBCoreDataUtil.h"

@implementation MyCollectList

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
    //    NSInteger type = [subDic[@"type"] integerValue];
    //    if (type != 7) {
    //      continue;
    //    }
    TweetListItem *item = [[TweetListItem alloc] init];
    item.userListItem = [[UserListItem alloc] init];
    //解析tweetList部分
    [item jsonToObject:subDic];
    //找到userList的uid
    NSString *uid = [SimuUtil changeIDtoStr:subDic[@"uid"]];
    item.userListItem = [userListW getUserById:uid];
    //通过共同的uidtmcList,userList共同加到messageListArray
    [self.messageListArray addObject:item];
    [WBCoreDataUtil insertCollectTid:item.tstockid];
  }
}

- (NSArray *)getArray {
  return self.messageListArray;
}

+ (void)requestCollectDataWithCallback:(HttpRequestCallBack *)callback
                         requestFromID:(NSString *)fromID
                         requestReqNum:(NSString *)reqNum {
  NSString *url =
      [istock_address stringByAppendingString:@"istock/newTalkStock/"
                      @"collectList?fromId={fromId}&reqNum={reqNum}"];
  NSDictionary *dic = @{
    @"fromId" : fromID,
    @"reqNum" : reqNum,
  };
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[MyCollectList class]
             withHttpRequestCallBack:callback];
}

@end
