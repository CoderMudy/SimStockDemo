//
//  RankingListItem.m
//  SimuStock
//
//  Created by jhss on 13-9-3.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "RankingListItem.h"

#import "JsonFormatRequester.h"
#import "UserListItem.h"

@implementation RankingListItem

- (void)jsonToObject:(NSDictionary *)subDict {
  self.mExponent = subDict[@"exponent"];
  self.mAttention = subDict[@"attention"];

  self.mFansCount = subDict[@"fansCount"];
  self.mNickName = subDict[@"nickName"];
  self.mPositionCount = subDict[@"positionCount"];
  self.mProfit = subDict[@"profit"];
  self.mHeadPic = subDict[@"headPic"];
  self.mProfitRate = subDict[@"profitRate"];
  self.mProfit = subDict[@"profit"];
  self.mRank = subDict[@"rank"];
  if ([self.mRank isKindOfClass:[NSNumber class]]) {
    self.mRank = [subDict[@"rank"] stringValue];
  }
  self.mSuccessRate = subDict[@"successRate"];
  self.mTradeCount = subDict[@"tradeCount"];
  self.mIStockCount = subDict[@"istockCount"];
  self.mUserID = [subDict[@"userId"] stringValue];
  self.mVipType = subDict[@"vipType"];
  if ([self.mVipType isKindOfClass:[NSNumber class]]) {
    self.mVipType = [subDict[@"vipType"] stringValue];
  }
  self.exponent = subDict[@"exponent"];

  self.userListItem = [[UserListItem alloc] init];
  [self.userListItem jsonToObject:subDict];
  self.userListItem.userId = @([subDict[@"userId"] integerValue]);
}

@end

@implementation MasterRankList

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];

  self.dataArray = [[NSMutableArray alloc] init];
  NSMutableDictionary *userdic = [[NSMutableDictionary alloc] init];
  NSDictionary *resultDic = dic[@"result"];
  NSArray *ranklist = resultDic[@"rankList"];
  NSArray *userlist = resultDic[@"userList"];

  [userlist enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx,
                                         BOOL *stop) {
    NSString *uid = [@([obj[@"userId"] intValue]) stringValue];
    [userdic setValue:obj forKey:uid];
  }];

  [ranklist enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx,
                                         BOOL *stop) {
    NSString *userId = [@([obj[@"uid"] intValue]) stringValue];
    if (userId) {
      /** 将userlist和ranklist中相同UserId的字典拼接成一个字典 */
      NSMutableDictionary *jointDic = [[NSMutableDictionary alloc] init];
      NSDictionary *mdic = [userdic objectForKey:userId];
      if (mdic.count > 0) {
        [jointDic setDictionary:mdic];
      }
      [jointDic addEntriesFromDictionary:obj];
      RankingListItem *item = [[RankingListItem alloc] init];
      [item jsonToObject:jointDic];
      [self.dataArray addObject:item];
    }
  }];

  /**
   * 判断是否需要显示自己的信息，如果需要则会走下面代码，不显示的则不会走下面代码
   */
  NSDictionary *personDic = resultDic[@"personal"];
  NSString *myUid = [personDic[@"uid"] stringValue];
  [userlist enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx,
                                         BOOL *stop) {
    NSString *uid = [@([obj[@"userId"] intValue]) stringValue];
    if ([uid intValue] == [myUid intValue]) {
      [userdic setObject:obj forKey:uid];
    }
  }];
  NSMutableDictionary *jointDicPer = [[NSMutableDictionary alloc] init];
  NSDictionary *personalDictionary = [userdic objectForKey:myUid];
  if (personalDictionary.count > 0) {
    [jointDicPer setDictionary:personalDictionary];
  }
  [jointDicPer addEntriesFromDictionary:personDic];
  RankingListItem *item = [[RankingListItem alloc] init];
  [item jsonToObject:jointDicPer];
  self.myRankInfo = item;
}
+ (void)requestMasterRankListWithType:(int)type
                           withFromId:(NSString *)fromid
                           withReqnum:(NSString *)reqnum
                         withCallback:(HttpRequestCallBack *)callback {
  NSString *userNumber = @"";

  switch (type) {
  case 1:
    userNumber = @"recommend";
    break;
  case 2:
    userNumber = @"popularity";
    break;
  case 3:
    userNumber = @"total";
    break;
  case 4:
    userNumber = @"suc";
    break;
  case 5:
    userNumber = @"month";
    break;
  case 6:
    userNumber = @"steady";
    break;
  case 7:
    userNumber = @"shortLine";
    break;
  case 8:
    userNumber = @"week";
    break;
  }

  NSString *url = [data_address
      stringByAppendingString:
          @"youguu/newRank/{sortList}?fromId={fromId}&reqNum={reqNum}"];
  NSDictionary *dic = @{
    @"sortList" : userNumber,
    @"fromId" : fromid,
    @"reqNum" : reqnum
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[MasterRankList class]
             withHttpRequestCallBack:callback];
}
@end
