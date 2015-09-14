//
//  simuUserConterListWrapper.m
//  SimuStock
//
//  Created by moulin wang on 14-11-19.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "simuUserConterListWrapper.h"
#import "JsonFormatRequester.h"

#pragma mark----------（1）取得用户宝箱内所有用钻石兑换的商品----------
@implementation simuUserConterPropsMyChestListWrapper
- (void)jsonToObject:(NSDictionary *)dic {
  //我的宝箱（钻石兑换商品宝箱，钻石商城新接口）
  [super jsonToObject:dic];
  self.PropsMyChestdataArray = [[NSMutableArray alloc] init];
  self.CoinsdataArray = [[NSMutableArray alloc] init];
  simuUserConterPropsMyChestListWrapper *item =
      [[simuUserConterPropsMyChestListWrapper alloc] init];
  //钻石余额
  item.result = [SimuUtil changeIDtoStr:dic[@"diamond"]];
  //金币余额
  item.coins = [SimuUtil changeIDtoStr:dic[@"coins"]];
  [self.CoinsdataArray addObject:item.result];
  [self.CoinsdataArray addObject:item.coins];
  //商品数组
  NSArray *array = dic[@"pboxlist"];
  for (NSDictionary *subDict in array) {
    item.mCoinsCount = dic[@"coinscount"];
    item.mMaxVipDays = dic[@"maxVipDays"];
    item.mMessage = dic[@"message"];
    item.mMidVipDays = dic[@"midVipDays"];
    item.mPboxID = subDict[@"pboxId"];
    item.mPboxName = subDict[@"pboxName"];
    item.mPboxPic = subDict[@"pboxPic"];
    item.mPboxType = subDict[@"pboxType"];
    item.mPboxTotal = subDict[@"pboxtotal"];
    item.mUID = subDict[@"uid"];
    [self.PropsMyChestdataArray addObject:item];
  }
  NSLog(@"-----dic-----%@", dic);
  NSLog(@"-----CoinsdataArray-----%@", self.CoinsdataArray);
  NSLog(@"-----PropsMyChestdataArray-----%@", self.PropsMyChestdataArray);
}
+ (void)requestPositionDataWithCallback:(HttpRequestCallBack *)callback {
  NSString *url = [mall_address stringByAppendingString:@"pay/props/myChest"];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request
      asynExecuteWithRequestUrl:url
              WithRequestMethod:@"GET"
          withRequestParameters:nil
         withRequestObjectClass:[simuUserConterPropsMyChestListWrapper class]
        withHttpRequestCallBack:callback];
}
@end
#pragma mark----------（2）使用商品----------
@implementation simuUserConteruseUsePropsListWrapper
- (void)jsonToObject:(NSDictionary *)dic {
  NSLog(@"----------simuUserConteruseUsePropsListWrapper dic%@----------", dic);
  //使用道具
  [super jsonToObject:dic];
  self.PropsdataArray = [[NSMutableArray alloc] init];
  simuUserConteruseUsePropsListWrapper *item =
      [[simuUserConteruseUsePropsListWrapper alloc] init];
  item.result = dic[@"message"];
  [self.PropsdataArray addObject:item.result];
}

+ (void)requestPositionDataWithGetAK:(NSString *)GetAK
                       withGetUserID:(NSString *)UserID
                     withGetUserName:(NSString *)UserName
                  withClickedPropsID:(NSString *)PropsID
                        withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [NSString
      stringWithFormat:@"%@pay/props/"
                       @"useProps?ak=%@&userId=%@&userName=%@&propsId=%@&"
                       @"matchId=-1",
                       mall_address, GetAK, UserID, UserName, PropsID];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request
      asynExecuteWithRequestUrl:url
              WithRequestMethod:@"GET"
          withRequestParameters:nil
         withRequestObjectClass:[simuUserConterPropsMyChestListWrapper class]
        withHttpRequestCallBack:callback];
}
@end
