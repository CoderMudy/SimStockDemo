//
//  MyAttentionInfoItem.m
//  SimuStock
//
//  Created by jhss on 13-12-17.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "MyAttentionInfoItem.h"

#import "JsonFormatRequester.h"

@implementation MyAttentionInfoItem

- (void)jsonToObject:(NSDictionary *)dic {
  self.mProfit = dic[@"profit"];
  self.mIsAttention = @"1";

  self.userListItem = [[UserListItem alloc] init];
  self.userListItem.userId =
      @([[SimuUtil changeIDtoStr:dic[@"userId"]] longLongValue]);
  self.userListItem.nickName = dic[@"nickName"];
  self.userListItem.headPic = dic[@"headPic"];
  self.userListItem.rating = dic[@"rating"];
  self.userListItem.vipType = (UserVipType)[dic[@"vipType"] intValue];
  self.userListItem.stockFirmFlag =
      [SimuUtil changeIDtoStr:dic[@"stockFirmFlag"]];
}

- (void)searchStockHeroJsonToObject:(NSDictionary *)dic {

  self.mIsAttention = dic[@"isAttention"];
  self.mProfit = dic[@"zyl"];

  self.userListItem = [[UserListItem alloc] init];
  self.userListItem.nickName = dic[@"nickname"];
  self.userListItem.userId =
      @([[SimuUtil changeIDtoStr:dic[@"id"]] longLongValue]);
  self.userListItem.headPic = dic[@"pic"];
  self.userListItem.rating = dic[@"rating"];
  self.userListItem.vipType = (UserVipType)[dic[@"vipType"] intValue];
  self.userListItem.stockFirmFlag =
      [SimuUtil changeIDtoStr:dic[@"stockFirmFlag"]];
}

- (void)fanJsonToObject:(NSDictionary *)dic {
  self.mProfit = dic[@"profit"];
  self.mIsAttention = dic[@"at"];

  self.userListItem = [[UserListItem alloc] init];
  self.userListItem.nickName = dic[@"nickName"];
  self.userListItem.userId =
      @([[SimuUtil changeIDtoStr:dic[@"userId"]] longLongValue]);
  self.userListItem.headPic = dic[@"headPic"];
  self.userListItem.rating = dic[@"rating"];
  self.userListItem.vipType = (UserVipType)[dic[@"vipType"] intValue];
  self.userListItem.stockFirmFlag =
      [SimuUtil changeIDtoStr:dic[@"stockFirmFlag"]];
}

@end

@implementation MyAttentionList

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];

  self.dataArray = [[NSMutableArray alloc] init];
  NSArray *array = dic[@"result"];
  for (NSDictionary *dic in array) {
    MyAttentionInfoItem *item = [[MyAttentionInfoItem alloc] init];
    [item jsonToObject:dic];
    [self.dataArray addObject:item];
  }
}
- (NSArray *)getArray {
  return _dataArray;
}

- (NSDictionary *)mappingDictionary {
  return @{ @"dataArray" : NSStringFromClass([MyAttentionInfoItem class]) };
}
+ (void)requestPositionDataWithParams:(NSDictionary *)dic
                         withCallback:(HttpRequestCallBack *)callback {

  NSString *url = [user_address
      stringByAppendingString:
          @"jhss/member/queryFollows/{ak}/{sid}/{uid}/{startnum}/{endnum}"];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[MyAttentionList class]
             withHttpRequestCallBack:callback];
}
@end

@implementation MyFansList

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.dataArray = [[NSMutableArray alloc] init];
  NSArray *array = dic[@"result"];
  for (NSDictionary *dic in array) {
    MyAttentionInfoItem *item = [[MyAttentionInfoItem alloc] init];
    [item fanJsonToObject:dic];
    [self.dataArray addObject:item];
  }
}
- (NSArray *)getArray {
  return _dataArray;
}
+ (void)requestFansWithParams:(NSDictionary *)dic
                 withCallback:(HttpRequestCallBack *)callback {

  NSString *url = [user_address
      stringByAppendingString:
          @"jhss/member/queryFans/{ak}/{sid}/{uid}/{startnum}/{endnum}"];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[MyFansList class]
             withHttpRequestCallBack:callback];
}
@end

@implementation StockFriendsListWrapper

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.dataArray = [[NSMutableArray alloc] init];
  NSArray *array = dic[@"result"];
  for (NSDictionary *subDict in array) {
    MyAttentionInfoItem *item = [[MyAttentionInfoItem alloc] init];
    [item searchStockHeroJsonToObject:subDict];
    [self.dataArray addObject:item];
  }
}

- (NSArray *)getArray {
  return _dataArray;
}
+ (void)requestStockFriendsWithParams:(NSDictionary *)dic
                          wthCallback:(HttpRequestCallBack *)callback {
  NSString *url = [NSString
      stringWithFormat:@"%@jhss/member/searchbynickname?nickname={nickname}"
                       @"&pageindex={pageindex}&pagesize={pagesize}",
                       user_address];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[StockFriendsListWrapper class]
             withHttpRequestCallBack:callback];
}

@end
