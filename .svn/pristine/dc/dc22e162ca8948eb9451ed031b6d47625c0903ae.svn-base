//
//  ActualQuotationUserPinlessData.m
//  SimuStock
//
//  Created by moulin wang on 15/3/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ActualQuotationUserPinlessData.h"
#import "RealTradeRequester.h"

@implementation ActualQuotationUserInfoData
//解析
- (void)jsonToObject:(NSDictionary *)dic {
  self.arrayActualQuotationUserInfo =
      [[NSMutableArray alloc] initWithCapacity:1];
  [super jsonToObject:dic];
  [self setValuesForKeysWithDictionary:dic];
  [self.arrayActualQuotationUserInfo addObject:self];
}

//请求客户资料
+ (void)requestUserInfoWithCallback:(HttpRequestCallBack *)callback
                      andCustomerId:(NSString *)customer
                     withBrokerType:(NSInteger)brokerType {

  id urlFactory = [RealTradeUrls getRealTradeUrlFactory];
  NSString *url = [urlFactory getUserInfo];
  //客户号
  NSDictionary *dic = @{ @"khh" : customer };
  RealTradeRequester *requester = [[RealTradeRequester alloc] init];
  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:[urlFactory getBrokerRequstMethod]
                 withRequestParameters:dic
                withRequestObjectClass:[ActualQuotationUserInfoData class]
               withHttpRequestCallBack:callback];
}

@end

//实盘用户类
@implementation ActualQuotationUserPinlessData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
}

//实盘用户绑定 请求
+ (void)
requestYuuguUserAndActualQuotationUserWithUserInfo:
    (NSArray *)userInfoArray andWithCallback:(HttpRequestCallBack *)callback
                                       andBrokerId:(NSString *)brokerUserId
                                    withBrokerType:(NSInteger)brokerType {

  NSString *url =
      [user_address stringByAppendingString:@"jhss/member/bindRealUser"];
  id urlFactory = [RealTradeUrls getRealTradeUrlFactory];
  NSString *brokerId = [urlFactory getFactoryBrokerID];
  //用户userID userName
  NSString *userID = [SimuUtil getUserID];
  NSString *userName = [SimuUtil getUserName];
  ActualQuotationUserInfoData *actualQuotationUserInfo =
      [userInfoArray firstObject];
  NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] init];
  if (mutableDict) {
    [mutableDict removeAllObjects];
  }
  NSString *khxm = actualQuotationUserInfo.khxm;
  NSString *sfzh = actualQuotationUserInfo.sfzh;
  NSString *phone = actualQuotationUserInfo.phone;
  NSString *shgdh = actualQuotationUserInfo.shgdh;
  NSString *szgdh = actualQuotationUserInfo.szgdh;
  NSString *yyb = actualQuotationUserInfo.yyb;

  mutableDict[@"userId"] = userID;
  mutableDict[@"userName"] = userName;
  mutableDict[@"brokerId"] = brokerId;
  mutableDict[@"brokerUserId"] = brokerUserId;
  mutableDict[@"name"] = khxm;
  mutableDict[@"certNo"] = sfzh;
  mutableDict[@"phone"] = phone;
  if (shgdh == nil) {
    mutableDict[@"shShareholder"] = @"";
  } else {
    mutableDict[@"shShareholder"] = shgdh;
  }
  if (szgdh == nil) {
    mutableDict[@"szShareholder"] = @"";
  } else {
    mutableDict[@"szShareholder"] = szgdh;
  }
  mutableDict[@"departNo"] = yyb;
  RealTradeRequester *requester = [[RealTradeRequester alloc] init];
  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:@"POST"
                 withRequestParameters:mutableDict
                withRequestObjectClass:[ActualQuotationUserPinlessData class]
               withHttpRequestCallBack:callback];
}

@end
