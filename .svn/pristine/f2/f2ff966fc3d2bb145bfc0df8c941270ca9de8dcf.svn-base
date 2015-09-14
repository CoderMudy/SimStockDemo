//
//  HotRecommendListData.m
//  SimuStock
//
//  Created by Yuemeng on 14-11-24.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "HotRecommendListData.h"
#import "JsonFormatRequester.h"

@implementation TweetListData

@end

@implementation HotRecommendListData

//- (void)jsonToObject:(NSDictionary *)dic {
//  [super jsonToObject:dic];
//  self.tweetList = [[NSMutableArray alloc] init];
//
//  NSDictionary *resultDict = dic[@"result"];
//
//  /**userList节点解析*/
//  UserListWrapper *userListWrapper = [[UserListWrapper alloc] init];
//  NSArray *userLists = resultDict[@"userList"];
//  [userListWrapper jsonToMap:userLists];
//
//  NSArray *tweetListData = resultDict[@"tweetList"];
//  for (NSDictionary *subDic in tweetListData) {
//    TweetListData *tweetListData = [[TweetListData alloc] init];
//    [tweetListData setValuesForKeysWithDictionary:subDic];
//
//    //找到userList的uid
//    NSString *uid = [SimuUtil changeIDtoStr:subDic[@"uid"]];
//    tweetListData.writer = [userListWrapper getUserById:uid];
//
//    [self.tweetList addObject:tweetListData];
//  }
//}

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.tweetList = [[NSMutableArray alloc] init];
  
  NSArray *resultArray = dic[@"result"];

  for (NSDictionary * Adic in resultArray)
  {
    TweetListData * tweetlistData =[[TweetListData alloc]init];
    tweetlistData.TitleName = Adic[@"name"];
    tweetlistData.PathUrl = Adic[@"url"];
    [self.tweetList addObject:tweetlistData];
  }
  
  
  
//  /**userList节点解析*/
//  UserListWrapper *userListWrapper = [[UserListWrapper alloc] init];
//  NSArray *userLists = resultDict[@"userList"];
//  [userListWrapper jsonToMap:userLists];
//  
//  NSArray *tweetListData = resultDict[@"tweetList"];
//  for (NSDictionary *subDic in tweetListData) {
//    TweetListData *tweetListData = [[TweetListData alloc] init];
//    [tweetListData setValuesForKeysWithDictionary:subDic];
//    
//    //找到userList的uid
//    NSString *uid = [SimuUtil changeIDtoStr:subDic[@"uid"]];
//    tweetListData.writer = [userListWrapper getUserById:uid];
//    
//    [self.tweetList addObject:tweetListData];
//  }
}

+ (void)requestHotRecommendListDataWithCallback:
            (HttpRequestCallBack *)callback {

//旧  NSString *url = [istock_address
//      stringByAppendingString:@"istock/newTalkStock/getHotRecommendList"];
  NSString *url = [istock_address
                   stringByAppendingString:@"istock/newTalkStock/queryMarquee"];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];

  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[HotRecommendListData class]
             withHttpRequestCallBack:callback];
}

@end
