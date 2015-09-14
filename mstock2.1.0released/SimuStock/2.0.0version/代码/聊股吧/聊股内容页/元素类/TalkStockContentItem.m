//
//  TalkStockContentItem.m
//  SimuStock
//
//  Created by jhss on 14-11-21.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "TalkStockContentItem.h"


@implementation TalkStockContentItem
- (void)jsonToObject:(NSDictionary *)dict {
  [super jsonToObject:dict];
  self.dataArray = [[NSMutableArray alloc] init];

  NSDictionary *resultDict = dict[@"result"];

  /**userList节点解析*/
  UserListWrapper *userListWrapper = [[UserListWrapper alloc] init];
  NSArray *userLists = resultDict[@"userList"];
  [userListWrapper jsonToMap:userLists];
  
  //再绑定所有股聊消息
  TalkStockContentItem *talkListItem = [[TalkStockContentItem alloc] init];
  talkListItem.barId = resultDict[@"barId"];
  talkListItem.tstockid = resultDict[@"tstockid"];
  talkListItem.barName = resultDict[@"barName"];
  talkListItem.ctime = resultDict[@"ctime"];
  if (resultDict[@"elite"]) {
    talkListItem.elite = [resultDict[@"elite"]stringValue];
  }else
  {
    talkListItem.elite = @"0";
  }
  talkListItem.content = resultDict[@"content"];
  talkListItem.type = [resultDict[@"type"] integerValue];
  talkListItem.praise = [resultDict[@"praise"]integerValue];
  talkListItem.collect = [resultDict[@"collect"]integerValue];
  talkListItem.comment = [resultDict[@"comment"]integerValue];
  talkListItem.imgs = resultDict[@"imgs"];
  talkListItem.repost = [resultDict[@"repost"] integerValue];
  talkListItem.share = [resultDict[@"share"] integerValue];
  talkListItem.stype = [resultDict[@"stype"] integerValue];
  talkListItem.title = resultDict[@"title"];
  //判空
  if (resultDict[@"source"]) {
     [talkListItem setValuesForKeysWithDictionary:resultDict[@"source"]];
  }
  
  NSString *uid = [SimuUtil changeIDtoStr:resultDict[@"uid"]];

  talkListItem.writer = [userListWrapper getUserById:uid];
  

  [self.dataArray addObject:talkListItem];
}

+ (void)getTalkStockInitialContentWithTalkWeetId:(NSString *)talkID
                                    withCallback:(HttpRequestCallBack *)callback
{
  NSString *url = [NSString stringWithFormat:@"%@istock/newTalkStock/getTStock?tweetId=%@", istock_address, talkID];
  JsonFormatRequester *request = [[JsonFormatRequester alloc]init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[TalkStockContentItem class]
             withHttpRequestCallBack:callback];
}

@end
