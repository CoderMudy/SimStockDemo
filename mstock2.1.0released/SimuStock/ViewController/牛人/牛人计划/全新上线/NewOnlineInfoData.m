//
//  NewOnlineInfoData.m
//  SimuStock
//
//  Created by Jhss on 15/6/30.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "NewOnlineInfoData.h"

@implementation NewOnlineInfoItem
- (void)jsonToObject:(NSDictionary *)dic {
  if (dic[@"result"] == nil) {
    return;
  }
  NSDictionary *resultDic = dic[@"result"];
  NSArray *palnlist = resultDic[@"plans"];
  NSArray *userlist = resultDic[@"userList"];
  self.dataArray = [[NSMutableArray alloc] init];
  NSMutableDictionary *userListDic = [[NSMutableDictionary alloc] init];

  [userlist enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx,
                                         BOOL *stop) {
    NSString *userId = [@([obj[@"userId"] intValue]) stringValue];
    [userListDic setValue:obj forKey:userId];
  }];

  [palnlist enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx,
                                         BOOL *stop) {
    NSString *uid = [@([obj[@"uid"] intValue]) stringValue];
    if (uid) {
      /** 将userlist和ranklist中相同UserId的字典拼接成一个字典 */
      NSMutableDictionary *jointDic = [[NSMutableDictionary alloc] init];
      NSDictionary *mdic = [userListDic objectForKey:uid];
      if (mdic.count > 0) {
        //将字典mdic添加到jointDic中（jointDic为空）
        [jointDic setDictionary:mdic];
      }
      //将obj拼接到jointDic中(jointDic有数据)
      [jointDic addEntriesFromDictionary:obj];
      NewOnlineInfoData *item = [[NewOnlineInfoData alloc] init];
      [item jsonToObject:jointDic];
      [self.dataArray addObject:item];
    }
  }];
}
- (NSArray *)getArray {
  return _dataArray;
}
- (NSDictionary *)mappingDictionary {
  return @{ @"dataArray" : NSStringFromClass([NewOnlineInfoData class]) };
}

+ (void)newOnlinePlanListRequest:(NSDictionary *)dic
                    withCallback:(HttpRequestCallBack *)callback {

  NSString *url = [istock_address
      stringByAppendingFormat:
          @"youguu/super_trade/new_plan?fromId={fromId}&reqNum={reqNum}"];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[NewOnlineInfoItem class]
             withHttpRequestCallBack:callback];
}
+ (void)newOnlinePlanOpenTraceWithAccountId:(NSString *)accountId
                              withTargetUid:(NSString *)targetUid
                               withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [istock_address
      stringByAppendingFormat:@"youguu/super_trade/"
      @"open_trace?accountId={accountId}&targetUid={" @"targetUid}"];
  NSDictionary *dic = @{ @"accountId" : accountId, @"targetUid" : targetUid };
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[NewOnlineInfoItem class]
             withHttpRequestCallBack:callback];
}

@end

@implementation NewOnlineInfoData

- (void)jsonToObject:(NSDictionary *)dic {
  self.name = dic[@"name"];
  self.goalProfit = [dic[@"goalProfit"] stringValue];
  self.stopLossLine = [dic[@"stopLossLine"] stringValue];
  self.price = [dic[@"price"] stringValue];
  self.accountId = dic[@"accountId"];
  self.buystatus = [dic[@"buyStatus"] stringValue];
  self.buyStopTime = [dic[@"buyStopTime"] stringValue];
  self.buyerCount = [dic[@"buyerCount"] stringValue];
  self.buyerLimit = [dic[@"buyerLimit"] stringValue];
  self.slogan = dic[@"slogan"];
  self.goalMonths = [dic[@"goalMonths"] stringValue];
  self.profit = [dic[@"profit"] stringValue];
  self.runDay = [dic[@"runDay"] stringValue];
  self.uid = [dic[@"uid"] stringValue];

  //获取用户头像
  self.head_pic = dic[@"headPic"];

  self.userListItem = [[UserListItem alloc] init];
  [self.userListItem jsonToObject:dic];
  self.userListItem.userId = @([dic[@"userId"] integerValue]);
}

@end
