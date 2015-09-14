//
//  UpdateCustomerInfomationAssets.m
//  SimuStock
//
//  Created by moulin wang on 15/3/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "UpdateCustomerInfomationAssets.h"
#import "RealTradeRequester.h"

@implementation UpdateCustomerInfomationAssets

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
}

+ (void)updateCustomerInfomationAsser:(PositionData *)position
                          andCallBack:(HttpRequestCallBack *)callback {
  NSString *url = [stat_address
      stringByAppendingString:@"stat/mncg/"
      @"updateRealUserInfo?khh={khh}&brokerId={brokerId}&zhzzc={zhzzc}&"
      @"gpsz={gpsz}&zjye={zjye}"];
  id urlFactory = [RealTradeUrls getRealTradeUrlFactory];
  //客户号
  NSString *brokerID = [urlFactory getFactoryBrokerID];
  NSString *khh = [urlFactory getBrokerUserCust];
  NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] init];
  if (mutableDic) {
    [mutableDic removeAllObjects];
  }
  mutableDic[@"khh"] = khh;
  mutableDic[@"zhzzc"] = position.zzc;
  mutableDic[@"gpsz"] = position.zxsz;
  mutableDic[@"zjye"] = position.kyzj;
  mutableDic[@"brokerId"] = brokerID;
  RealTradeRequester *requester = [[RealTradeRequester alloc] init];
  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:@"GET"
                 withRequestParameters:mutableDic
                withRequestObjectClass:[UpdateCustomerInfomationAssets class]
               withHttpRequestCallBack:callback];
}

@end
