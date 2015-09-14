//
//  SameStockHero.m
//  SimuStock
//
//  Created by Mac on 15/4/29.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SameStockHero.h"
#import "BaseRequester.h"
#import "JsonFormatRequester.h"
#import "StockUtil.h"

@implementation SameStockHero

- (void)jsonToObject:(NSDictionary *)dic {
  self.rank = [dic[@"rank"] integerValue];
  self.positionProfitRate = [dic[@"positionProfitRate"] floatValue];
  self.costPrice = [dic[@"costPrice"] floatValue];
  self.positionDays = [dic[@"positionDays"] integerValue];
  self.user = [[UserListItem alloc] init];
  [self.user jsonToObject:dic];
  self.user.rating = dic[@"ratingGrade"];
  self.user.nickName = dic[@"userNick"];
  self.user.stockFirmFlag = [SimuUtil changeIDtoStr:dic[@"stockFirmFlag"]];
  self.user.vipType = (UserVipType)[dic[@"vipType"] integerValue];
}

@end

@implementation SameStockHeroList

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  NSDictionary *dicResult = dic[@"result"];
  self.count = [dicResult[@"count"] integerValue];

  self.rate = [dicResult[@"rate"] floatValue];
  self.avgCostPrice = [dicResult[@"avgCostPrice"] floatValue];

  self.avgProfitRate = [dicResult[@"avgProfitRate"] floatValue];
  self.rankList = [[NSMutableArray alloc] init];

  NSArray *array = dicResult[@"rankList"];
  [array enumerateObjectsUsingBlock:^(NSDictionary *subDic, NSUInteger idx, BOOL *stop) {
    SameStockHero *user = [[SameStockHero alloc] init];
    [user jsonToObject:subDic];
    [self.rankList addObject:user];
  }];
}

- (NSArray *)getArray {
  return self.rankList;
}

+ (void)requestHeroListWithStockCode:(NSString *)stockCode
                        withCallback:(HttpRequestCallBack *)callback {
  JsonFormatRequester *requester = [[JsonFormatRequester alloc] init];
  NSString *url = [data_address stringByAppendingString:@"youguu/position/superlist?code={code}"];

  stockCode = stockCode ? [StockUtil sixStockCode:stockCode] : @"";
  NSDictionary *dic = @{ @"code" : stockCode };

  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:@"GET"
                 withRequestParameters:dic
                withRequestObjectClass:[SameStockHeroList class]
               withHttpRequestCallBack:callback];
}

@end
