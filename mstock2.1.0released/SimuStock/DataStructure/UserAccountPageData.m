//
//  UserAccountPageData.m
//  SimuStock
//
//  Created by Mac on 14-11-3.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "UserAccountPageData.h"
#import "JsonFormatRequester.h"
#import "SimuRankPositionPageData.h"
#import "UserListItem.h"
#import "NSString+MD5Addition.h"



@implementation MatchUserAccountData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];

  //总资产
  self.totalAssets = dic[@"zzc"];
  //可用金额
  self.fundBalance = dic[@"zjye"];
  //股票市值
  self.positionValue = dic[@"cgsz"];
  //浮动盈亏
  self.floatProfit = dic[@"fdyk"];

  self.totalProfit = dic[@"totalProfit"];
}

@end

@implementation UserAccountPageData
- (id)init {
  self = [super init];
  if (self) {
    self.profitrate = @"0.00%";
    self.totalAssets = @"0.00";
    self.fundBalance = @"0.00";
    self.positionValue = @"0.00";
    self.floatProfit = @"0.00";
    self.positionRate = @"0.00";
    self.totalProfit = @"0.00";
  }
  return self;
}

- (NSDictionary *)mappingDictionary {
  return @{ @"postionArray" : NSStringFromClass([PositionInfo class]) };
}

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  NSDictionary *resultDic = dic[@"result"];
  //总盈利率
  self.profitrate = resultDic[@"profitRate"];
  //总资产
  self.totalAssets = resultDic[@"totalAssets"];
  //可用金额
  self.fundBalance = resultDic[@"fundBalance"];
  //股票市值
  self.positionValue = resultDic[@"positionValue"];
  //浮动盈亏
  self.floatProfit = resultDic[@"floatProfit"];
  //总仓位
  self.positionRate = resultDic[@"positionRate"];

  self.totalProfit = resultDic[@"totalProfit"];

  self.postionArray = [[NSMutableArray alloc] init];
  NSArray *array = resultDic[@"itemList"];
  for (NSDictionary *subDic in array) {
    PositionInfo *item = [[PositionInfo alloc] init];
    [item jsonToObject:subDic];
    [self.postionArray addObject:item];
  }

  //仅用于聊股发表、评论、回复时的假数据显示用户评级信息
  self.userListItem = [[UserListItem alloc] init];
  self.userListItem.rating = resultDic[@"rating"];
  self.userListItem.stockFirmFlag =
      [SimuUtil changeIDtoStr:resultDic[@"stockFirmFlag"]];
  self.userListItem.vipType = [resultDic[@"vipType"] intValue];
}

+ (void)requestAccountDataWithMatchId:(NSString *)matchId
                         withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [data_address stringByAppendingString:@"youguu/simtrade/"
                                @"getAccountDetail?matchid={matchid}&version=1&"
                                @"identity={identity}"];
  NSString *identity = [[SimuUtil getUserID] stringFromMD5];
  NSDictionary *dic = @{ @"matchid" : matchId, @"identity" : identity };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[UserAccountPageData class]
             withHttpRequestCallBack:callback];
}

+ (void)requestAccountDataWithUserId:(NSString *)uid
                         withMatchId:(NSString *)matchId
                        withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [data_address
      stringByAppendingString:
          @"youguu/simtrade/showmymoney/{ak}/{sid}/{userid}/{matchid}"];

  NSDictionary *dic = @{ @"userid" : uid, @"matchid" : matchId };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[MatchUserAccountData class]
             withHttpRequestCallBack:callback];
}


@end
