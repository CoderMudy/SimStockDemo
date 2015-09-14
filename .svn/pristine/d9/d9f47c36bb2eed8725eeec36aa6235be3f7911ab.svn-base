//
//  UserListItem.m
//  SimuStock
//
//  Created by jhss on 14-11-21.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "UserListItem.h"
#import "Globle.h"
#import "JsonFormatRequester.h"

@implementation UserListItem

- (void)jsonToObject:(NSDictionary *)dic {
  self.userId = dic[@"userId"];
  self.nickName = [dic[@"nickName"] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
  self.headPic = dic[@"headPic"];
  self.signature = dic[@"signature"];
  self.userName = dic[@"userName"];
  self.rating = dic[@"rating"];
  self.vipType = (UserVipType)[dic[@"vipType"] intValue];
  self.stockFirmFlag = [SimuUtil changeIDtoStr:dic[@"stockFirmFlag"]];
}

- (BOOL)hasRealTradeAccount {
  return self.stockFirmFlag && [@"1" isEqualToString:self.stockFirmFlag];
}

//根据vip类型返回颜色
+ (UIColor *)colorWithVIPType:(UserVipType)vipType {
  if (vipType == VipUser || vipType == SVipUser) {
    return [Globle colorFromHexRGB:Color_Red];
  } else {
    return [Globle colorFromHexRGB:Color_Blue_but];
  }
}

+ (UIColor *)colorWithVIPType:(UserVipType)vipType defaultColor:(UIColor *)color {
  if (vipType == VipUser || vipType == SVipUser) {
    return [Globle colorFromHexRGB:Color_Red];
  } else {
    return color;
  }
}

@end

@implementation UserListItemMatch

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];

  self.dataArray = [[NSMutableArray alloc] init];

  //比赛 盈利榜列表
  NSArray *array = dic[@"result"];
  
  for (NSDictionary *itemDic in array) {
    UserListItemMatch *userItem = [[UserListItemMatch alloc] init];
    userItem.userID = [NSString stringWithFormat:@"%@", itemDic[@"uid"]];
    userItem.userId = @([userItem.userID longLongValue]);
    NSString *sad_UserName = itemDic[@"name"] ? itemDic[@"name"] : itemDic[@"realName"];
    userItem.headPic = itemDic[@"headPic"];
    userItem.userName = [SimuUtil changeIDtoStr:sad_UserName];
    userItem.nickName = userItem.userName;
    NSString *sad_UserProfitability = itemDic[@"profitRate"] ? itemDic[@"profitRate"] : itemDic[@"profit"];
    userItem.userProfitability = [SimuUtil changeIDtoStr:sad_UserProfitability];
    userItem.userRank = [NSString stringWithFormat:@"%@", itemDic[@"rank"]];
    userItem.rating = itemDic[@"rating"];
    userItem.teamId = itemDic[@"teamId"];
    userItem.teamName = itemDic[@"teamName"];
    userItem.vipType = (UserVipType)[itemDic[@"vipType"] intValue];
    userItem.stockFirmFlag = [SimuUtil changeIDtoStr:itemDic[@"stockFirmFlag"]];
    [self.dataArray addObject:userItem];
  }
}

- (NSArray *)getArray {
  return _dataArray;
}

+ (void)requestUserListItemMatchWithParameter:(NSDictionary *)dic
                                    withmType:(NSString *)mtype
                                     withType:(NSString *)type
                                 withCallback:(HttpRequestCallBack *)callback {

  NSString *url = data_address;
  switch ([mtype intValue]) {
  case 978: {
    int i = 2; //总排行
    if ([type isEqualToString:@"week"]) {
      i = 0;
    } else if ([type isEqualToString:@"month"]) {
      i = 1;
    }
    url = [url stringByAppendingFormat:@"youguu/match/rank/personal/?"];
    NSString *dataStr =
        [NSString stringWithFormat:@"startid={startId}&reqnum={reqnum}&mid={matchId}&type=%d", i];
    url = [url stringByAppendingString:dataStr];

    JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
    [request asynExecuteWithRequestUrl:url
                     WithRequestMethod:@"GET"
                 withRequestParameters:dic
                withRequestObjectClass:[UserListItemMatch class]
               withHttpRequestCallBack:callback];
  }
      return;
  case 974:
  case 976:
  case 977:
  case 971:
  case 972:
  case 973: {
    url = [url stringByAppendingFormat:@"youguu/match/rank/%@?", type];
    url = [url stringByAppendingString:@"startid={startId}&reqnum={reqnum}&mid={matchId}"];

    JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
    [request asynExecuteWithRequestUrl:url
                     WithRequestMethod:@"GET"
                 withRequestParameters:dic
                withRequestObjectClass:[UserListItemMatch class]
               withHttpRequestCallBack:callback];
   
  }
       return;
  default:
    break;
  }
}

@end

@implementation UserListWrapper

- (void)jsonToMap:(NSArray *)array {

  self.mappings = [[NSMutableDictionary alloc] init];

  for (NSDictionary *dic in array) {
    UserListItem *item = [[UserListItem alloc] init];
    [item jsonToObject:dic];
    self.mappings[[item.userId stringValue]] = item;
  }
}

- (UserListItem *)getUserById:(NSString *)uid {
  return self.mappings[uid];
}
@end
