//
//  StockTradeList.m
//  SimuStock
//
//  Created by Mac on 14-11-5.
//  Copyright (c) 2014年 Mac. All rights reserved.

//

#import "StockTradeList.h"

#import "JsonFormatRequester.h"
#import "CustomPageData.h"
#import "SimuProfitLinePageData.h"
#import "WBImageView.h"

/** 侧栏我的交易 */
@implementation MyTradeList

- (NSArray *)getArray {
  return _dataArray;
}

- (void)jsonToObject:(NSDictionary *)dic {

  [super jsonToObject:dic];
  self.dataArray = [[NSMutableArray alloc] init];
  NSArray *array = dic[@"result"];
  if ([array count] > 0) {
    self.lastObjectId = [[array lastObject][@"tstockid"] stringValue];
  }

  //当前聊股仅支持3中类型：
  NSArray *supportTypes = @[ @"9", @"10", @"13" ];
  for (NSDictionary *itemDic in array) {
    if ([supportTypes containsObject:[itemDic[@"type"] stringValue]]) {
      TweetListItem *item = [[TweetListItem alloc] init];
      [item jsonToObject:itemDic];
      [self.dataArray addObject:item];
    }
  }
}

@end

@implementation StockTradeList

- (void)jsonToObject:(NSDictionary *)dic {
  //  NSLog(@"nima!!!!%@",dic);
  [super jsonToObject:dic];
  self.dataArray = [[NSMutableArray alloc] init];
  NSArray *tweetListArray = dic[@"result"][@"tweetList"];
  if ([tweetListArray count] > 0) {
    self.lastObjectId = [[tweetListArray lastObject][@"tstockid"] stringValue];
  }

  /**userList节点解析*/
  UserListWrapper *userListWrapper = [[UserListWrapper alloc] init];
  NSArray *userLists = dic[@"result"][@"userList"];
  [userListWrapper jsonToMap:userLists];

  //当前聊股仅支持3中类型：
  NSArray *supportTypes = @[ @"1", @"2", @"9", @"10", @"13" ];
  for (NSDictionary *itemDic in tweetListArray) {
    if ([supportTypes containsObject:[itemDic[@"type"] stringValue]]) {
      TweetListItem *item = [[TweetListItem alloc] init];
      [item jsonToObject:itemDic];

      //找到userList的uid
      NSString *uid = [SimuUtil changeIDtoStr:itemDic[@"uid"]];
      item.userListItem = [userListWrapper getUserById:uid];

      [self.dataArray addObject:item];
    }
  }
}

- (NSArray *)getArray {
  return self.dataArray;
}

/**统计分享次数*/
+ (void)shareTimesOfStatisticsWithTalkStockID:(NSString *)talkStockID
                                 withCallback:(HttpRequestCallBack *)callback {
  NSString *url =
      [istock_address stringByAppendingString:@"istock/talkstock/share/"
                      @"{ak}/{sid}/{uid}/{tStockId}"];
  NSString *ak = [SimuUtil getAK];
  NSString *sid = [SimuUtil getSesionID];
  NSString *uid = [SimuUtil getUserID];
  NSDictionary *dict = @{
    @"ak" : ak,
    @"sid" : sid,
    @"uid" : uid,
    @"tStockId" : talkStockID
  };
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dict
              withRequestObjectClass:[StockTradeList class]
             withHttpRequestCallBack:callback];
}
/**   交易明细*/
+ (void)requestTradeDetailWithDic:(NSDictionary *)dic
                     withCallback:(HttpRequestCallBack *)callback {
  // http://mncg.youguu.com/youguu/trade/conclude/query?matchid={matchid}&fromtid={fromtid}&reqnum={reqnum}&uid={uid}&version=1
  NSString *url = [data_address
      stringByAppendingString:@"youguu/trade/conclude/"
                              @"query?matchid={matchid}&fromtid={fromtid}&"
                              @"reqnum={reqnum}&uid={uid}&version=1"];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[MyTradeList class]
             withHttpRequestCallBack:callback];
}

/**  交易明细2*/
+ (void)requestTradeDetailWithUid:(NSString *)uid
                          fromtid:(NSString *)fromId
                           reqnum:(NSString *)reqnum
                      withMatchId:(NSString *)matchId
                     withCallback:(HttpRequestCallBack *)callback {
  // http://mncg.youguu.com/youguu/trade/conclude/query?matchid={matchid}&fromtid={fromtid}&reqnum={reqnum}&uid={uid}&version=1
  NSString *url = [data_address
      stringByAppendingString:@"youguu/trade/conclude/"
                              @"query?matchid={matchid}&fromtid={fromtid}&"
                              @"reqnum={reqnum}&uid={uid}&version=1"];

  NSString *ak = [SimuUtil getAK];
  NSString *sid = [SimuUtil getSesionID];
  NSDictionary *dic = @{
    @"ak" : ak,
    @"sid" : sid,
    @"uid" : uid,
    @"matchid" : matchId,
    @"fromtid" : fromId,
    @"reqnum" : reqnum
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[MyTradeList class]
             withHttpRequestCallBack:callback];
}
//聊股主页
+ (void)requestNewTalksOfUserId:(NSString *)userId
                         fromId:(NSString *)fromId
                         reqNum:(NSString *)reqNum
                   withCallback:(HttpRequestCallBack *)callback {

  NSString *url = [istock_address
      stringByAppendingString:@"istock/newTalkStock/"
      @"homeList?appointuid={appointuid}&fromId={" @"fromId}&reqNum={reqNum}"];

  NSDictionary *dic = @{
    @"appointuid" : userId,
    @"fromId" : fromId,
    @"reqNum" : reqNum,
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[StockTradeList class]
             withHttpRequestCallBack:callback];
}

/** 请求分享 */
+ (void)requestShareStockTradeWithTid:(NSNumber *)tid
                         withCallback:(HttpRequestCallBack *)callback {
  NSString *url =
      [istock_address stringByAppendingString:
                          @"istock/talkstock/share/{ak}/{sid}/{userid}/{tid}"];
  NSDictionary *dic = @{ @"tid" : [tid stringValue] };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];

  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[StockTradeList class]
             withHttpRequestCallBack:callback];
}
@end

@implementation HomeTradeInfoInfo

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.dataArray = [[NSMutableArray alloc] init];
  NSMutableDictionary *data_dictionary = dic[@"result"];
  //当前聊股仅支持3中类型：
  TradeStatisticsData *statisticsData = [[TradeStatisticsData alloc] init];
  //总交易数
  statisticsData.closeNum = [NSString
      stringWithFormat:@"%ld",
                       (long)[data_dictionary[@"closeNum"] integerValue]];
  //交易成功数
  statisticsData.sucNum =
      [NSString stringWithFormat:@"%d", [data_dictionary[@"sucNum"] intValue]];
  //交易成功率
  statisticsData.sucRate = [NSString
      stringWithFormat:@"%f", [data_dictionary[@"sucRate"] floatValue]];
  //交易成功率
  statisticsData.sucRate = [NSString
      stringWithFormat:@"%f", [data_dictionary[@"sucRate"] floatValue]];
  //平均持仓天数
  NSString *avgDays = [NSString
      stringWithFormat:@"%f", [data_dictionary[@"avgDays"] floatValue]];
  statisticsData.avgDays = [SimuUtil changeIDtoStr:avgDays];
  //最后一次交易日期
  NSString *lastCloseAt = data_dictionary[@"lastCloseAt"];
  statisticsData.lastCloseAt = [SimuUtil changeIDtoStr:lastCloseAt];
  [self.dataArray addObject:statisticsData];
}

+ (void)getForCompleteTradeStatisticsAuserId:(NSString *)userId
                                     matchID:(NSString *)matchID
                                withCallback:(HttpRequestCallBack *)callback {
  NSString *ak = [SimuUtil getAK];
  NSString *sid = [SimuUtil getSesionID];
  NSString *uid = [SimuUtil getUserID];
  NSDictionary *dict = @{ @"ak" : ak, @"sid" : sid, @"uid" : uid };

  NSString *url = data_address;
  NSString *real_url =
      [url stringByAppendingFormat:
               @"youguu/position/closed/stat?userid=%@&matchid=1", userId];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:real_url
                   WithRequestMethod:@"GET"
               withRequestParameters:dict
              withRequestObjectClass:[HomeTradeInfoInfo class]
             withHttpRequestCallBack:callback];
}
@end

@implementation TracePCInfo
- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  NSDictionary *dataDic = dic[@"result"];
  if (dataDic[@"traceFlag"]) {
    NSInteger traceFlag = [dataDic[@"traceFlag"] integerValue];
    self.totolCount = traceFlag;
  }
}

+ (void)queryTheUserToTrackTheRelationshipAuserId:(NSString *)userId
                                          matchID:(NSString *)matchID
                                     withCallback:
                                         (HttpRequestCallBack *)callback {
  NSString *ak = [SimuUtil getAK];
  NSString *sid = [SimuUtil getSesionID];
  NSString *uid = [SimuUtil getUserID];
  NSDictionary *dict = @{ @"ak" : ak, @"sid" : sid, @"uid" : uid };

  NSString *url = data_address;
  NSString *realurl = [url
      stringByAppendingFormat:@"youguu/trace/relation?target_uid=%@&matchid=%d",
                              userId, 1];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:realurl
                   WithRequestMethod:@"GET"
               withRequestParameters:dict
              withRequestObjectClass:[TracePCInfo class]
             withHttpRequestCallBack:callback];
}

//增加追踪
+ (void)addTrace:(NSString *)userId
         matchID:(NSString *)matchID
    withCallback:(HttpRequestCallBack *)callback {
  NSString *ak = [SimuUtil getAK];
  NSString *sid = [SimuUtil getSesionID];
  NSString *uid = [SimuUtil getUserID];
  NSDictionary *dict = @{ @"ak" : ak, @"sid" : sid, @"uid" : uid };
  NSString *url = data_address;
  NSString *baseurl =
      [NSString stringWithFormat:
                    @"/youguu/trace/following/add?follow_uid=%@&follow_mid=%@",
                    userId, matchID];
  url = [url stringByAppendingString:baseurl];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dict
              withRequestObjectClass:[TracePCInfo class]
             withHttpRequestCallBack:callback];
}

//取消追踪
+ (void)delTrace:(NSString *)userId
         matchID:(NSString *)matchID
    withCallback:(HttpRequestCallBack *)callback {
  NSString *ak = [SimuUtil getAK];
  NSString *sid = [SimuUtil getSesionID];
  NSString *uid = [SimuUtil getUserID];
  NSDictionary *dict = @{ @"ak" : ak, @"sid" : sid, @"uid" : uid };
  NSString *url = data_address;
  NSString *baseurl =
      [NSString stringWithFormat:
                    @"/youguu/trace/following/del?follow_uid=%@&follow_mid=%@",
                    userId, matchID];
  url = [url stringByAppendingString:baseurl];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dict
              withRequestObjectClass:[TracePCInfo class]
             withHttpRequestCallBack:callback];
}
@end

@implementation PCProfitLine
- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.dataArray = [[NSMutableArray alloc] init];
  SimuProfitLinePageData *pagedata = [[SimuProfitLinePageData alloc] init];

  //盈利利率曲线数据
  NSArray *array = dic[@"result"];
  for (NSDictionary *obj in array) {
    SimuPointData *DataElment = [[SimuPointData alloc] init];
    if (DataElment) {
      NSString *date = obj[@"date"];
      DataElment.Date = date;
      NSNumber *myprofite = obj[@"myProfit"];
      if (![myprofite isKindOfClass:[NSNull class]]) {
        DataElment.MyProfit = [myprofite floatValue];
      }

      NSNumber *avgprofite = obj[@"avgProfit"];
      if (![avgprofite isKindOfClass:[NSNull class]]) {
        DataElment.AvgProfit = [avgprofite floatValue];
      }
      [pagedata.DataArray addObject:DataElment];
    }
  }
  [self.dataArray addObject:pagedata];
}

//盈利曲线
+ (void)showmyhistoryprofitAuserId:(NSString *)userId
                           matchID:(NSString *)matchID
                      withCallback:(HttpRequestCallBack *)callback {
  NSString *ak = [SimuUtil getAK];
  NSString *sid = [SimuUtil getSesionID];
  NSString *uid = [SimuUtil getUserID];
  NSDictionary *dict = @{ @"ak" : ak, @"sid" : sid, @"uid" : uid };

  NSString *url = data_address;
  NSString *real_url =
      [url stringByAppendingString:@"youguu/simtrade/showmyhistoryprofit/"];
  NSString *m_ak = [SimuUtil getAK];
  NSString *m_sid = nil;
  if ([[SimuUtil getUserID] isEqualToString:@"-1"]) {
    m_sid = @"-1";
  } else {
    m_sid = [SimuUtil getSesionID];
  }
  if (!userId && userId.length == 0) {
    return;
  }
  NSString *parame_rul =
      [NSString stringWithFormat:@"%@/%@/%@/1/~6/80", m_ak, m_sid, userId];
  real_url = [real_url stringByAppendingString:parame_rul];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:real_url
                   WithRequestMethod:@"GET"
               withRequestParameters:dict
              withRequestObjectClass:[PCProfitLine class]
             withHttpRequestCallBack:callback];
}
@end

@implementation ShareInfo

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
}
+ (void)refreshShareNumber:(NSString *)url
              withCallback:(HttpRequestCallBack *)callback {
  NSString *ak = [SimuUtil getAK];
  NSString *sid = [SimuUtil getSesionID];
  NSString *uid = [SimuUtil getUserID];
  NSDictionary *dict = @{ @"ak" : ak, @"sid" : sid, @"uid" : uid };
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dict
              withRequestObjectClass:[ShareInfo class]
             withHttpRequestCallBack:callback];
}
@end
