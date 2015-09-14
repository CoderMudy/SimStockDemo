//
//  MyChestsListWrapper.m
//  SimuStock
//
//  Created by moulin wang on 14-11-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

/**类说明（我的宝箱网络解析和网络请求）*/
#import "MyChestsListWrapper.h"
#import "JsonFormatRequester.h"

@implementation MyPropsListItem
@end

#pragma mark----------(3)（取得用户宝箱内所有用钻石）myChest----------
@implementation MyChestsMyChestlistListWrapper
- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.MyChestdataArray = [[NSMutableArray alloc] init];
  NSArray *array = dic[@"pboxlist"];
  self.result = [SimuUtil changeIDtoStr:dic[@"diamond"]];
  self.coins = [SimuUtil changeIDtoStr:dic[@"coins"]];
  for (NSDictionary *subDic in array) {
    MyPropsListItem *item = [[MyPropsListItem alloc] init];
    item.mCoinsCount = dic[@"coinscount"];
    item.mMaxVipDays = dic[@"maxVipDays"];
    item.mMessage = dic[@"message"];
    item.mMidVipDays = dic[@"midVipDays"];
    item.mPboxID = subDic[@"pboxId"];
    item.mPboxName = subDic[@"pboxName"];
    item.mPboxPic = subDic[@"pboxPic"];
    item.mPboxType = subDic[@"pboxType"];
    item.mPboxTotal = subDic[@"pboxtotal"];
    item.mUID = subDic[@"uid"];
    [self.MyChestdataArray addObject:item];
  }
}

- (NSArray *)getArray {
  return _MyChestdataArray;
}

+ (void)requestPositionDataWithCallback:(HttpRequestCallBack *)callback {
  NSString *url = [mall_address stringByAppendingString:@"pay/props/myChest"];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[MyChestsMyChestlistListWrapper class]
             withHttpRequestCallBack:callback];
}
@end
#pragma mark----------(5)使用商品（钻石商城新接口）useProps----------
@implementation MyChestsUsePropslistListWrapper
- (void)jsonToObject:(NSDictionary *)dic {
  //使用道具
  [super jsonToObject:dic];
  self.UsePropsdataArray = [[NSMutableArray alloc] init];
  MyChestsUsePropslistListWrapper *item =
      [[MyChestsUsePropslistListWrapper alloc] init];
  item.result = dic[@"message"];
  [self.UsePropsdataArray addObject:item.result];
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
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[MyChestsUsePropslistListWrapper class]
             withHttpRequestCallBack:callback];
}
@end
