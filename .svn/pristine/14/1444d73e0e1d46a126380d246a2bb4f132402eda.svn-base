//
//  RealTradeUrls.m
//  SimuStock
//
//  Created by Mac on 14-9-19.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "RealTradeUrls.h"
#import "SimuUtil.h"

@implementation RealTradeApexSoftUrlFactory

- (void)sendValueCustomer:(NSString *)customer {
  self.userCust = customer;
}

- (void)setUrlPrefix:(NSString *)urlHead {
  self.urlHead = urlHead;
}

- (void)sendValueForLongon:(NSString *)method {
  self.method = method;
}

- (void)sendvalueforBrokerID:(NSString *)brokerId {
  self.brokerId = brokerId;
}
- (NSString *)appendUrlHeadAndTailer:(NSString *)tailer {
  if (self.urlHead == nil) {
    return @"";
  }
  return [self.urlHead stringByAppendingString:tailer];
}

/** 获取柜台类型 1 = 顶点 2 = 恒生 */
- (void)senDValueBrokerFactoryType:(NSInteger)type {
  self.type = type;
}

/**
 * 得到柜台类型 type  1 = 顶点 2 = 恒生
 */
- (NSInteger)getBrokerFactoryType {
  return self.type;
}

/**
 * 得到 brokerID
 */
- (NSString *)getFactoryBrokerID {
  if (self.brokerId && self.brokerId.length > 0) {
    return self.brokerId;
  }
  return nil;
}

/** 得到 userCust 客户号 */
- (NSString *)getBrokerUserCust {
  if (self.userCust && self.userCust.length > 0) {
    return self.userCust;
  }
  return nil;
}

/** 获取柜台的请求方式 GET 或者 POST */
- (NSString *)getBrokerRequstMethod {
  if (self.method && self.method.length > 0) {
    return self.method;
  }
  return nil;
}

/**
 * 登录接口
 */
- (NSString *)getLoginPath {
  if (self.method && [self.method isEqualToString:@"POST"]) {
    return [self appendUrlHeadAndTailer:@"logon/auth"];
  } else if (self.method && [self.method isEqualToString:@"GET"]) {
    return [self appendUrlHeadAndTailer:
                     @"logon/auth?yzm={yzm}&zhlx={zhlx}&zh={zh}&jymm={jymm}"];
  } else {
    return nil;
  }
}

/**
 * 实时行情
 */
- (NSString *)getPlancountPath {
  if (self.method && [self.method isEqualToString:@"POST"]) {
    return [self appendUrlHeadAndTailer:@"trade/plancount"];
  } else if (self.method && [self.method isEqualToString:@"GET"]) {
    return [self appendUrlHeadAndTailer:
                     @"trade/plancount?zqdm={zqdm}&wtlb={wtlb}&wtjg={wtjg}"];
  } else {
    return nil;
  }
}

/**
 * 买卖委托
 */
- (NSString *)getEntrustorderPath {
  if (self.method && [self.method isEqualToString:@"POST"]) {
    return [self appendUrlHeadAndTailer:@"trade/" @"entrustorder"];
  } else if (self.method && [self.method isEqualToString:@"GET"]) {
    return [self appendUrlHeadAndTailer:@"trade/"
                 @"entrustorder?zqdm={zqdm}&wtlb={wtlb}&"
                 @"wtjg={wtjg}&wtsl={wtsl}"];
  } else {
    return nil;
  }
}

/**
 *  查询客户信息
 */
- (NSString *)getUserInfo {
  if (self.method && [self.method isEqualToString:@"POST"]) {
    return [self appendUrlHeadAndTailer:@"trade/getCustomerInfo"];
  } else if (self.method && [self.method isEqualToString:@"GET"]) {
    return [self appendUrlHeadAndTailer:@"trade/getCustomerInfo?khh={khh}"];
  } else {
    return nil;
  }
}

/**
 * 持仓查询
 */
- (NSString *)getQueryuserstockPath {
  return [self appendUrlHeadAndTailer:@"trade/queryNewAccount"];
}

/**
 * 今日委托
 */
- (NSString *)getTodayentrustPath {
  if (self.method && [self.method isEqualToString:@"POST"]) {
    return [self appendUrlHeadAndTailer:@"trade/todayentrust"];
  } else if (self.method && [self.method isEqualToString:@"GET"]) {
    return [self appendUrlHeadAndTailer:@"trade/todayentrust?flag={flag}"];
  } else {
    return nil;
  }
}

/**
 * 今日成交
 */
- (NSString *)getTodaytransactionPath {
  return [self appendUrlHeadAndTailer:@"trade/todaytransaction"];
}

/**
 * 历史成交
 */
- (NSString *)getHistransactionPath {
  if (self.method && [self.method isEqualToString:@"POST"]) {
    return [self appendUrlHeadAndTailer:@"trade/" @"histransaction"];
  } else if ([self.method isEqualToString:@"GET"]) {
    return [self appendUrlHeadAndTailer:@"trade/"
                 @"histransaction?startdate={startdate}&"
                 @"enddate={enddate}&pagesize={pagesize}&" @"seq={seq}"];
  } else {
    return nil;
  }
}

/**
 * 撤单
 */
- (NSString *)getRevokePath {
  if (self.method && [self.method isEqualToString:@"POST"]) {
    return [self appendUrlHeadAndTailer:@"trade/batchentrustwithdraw"];
  } else if (self.method && [self.method isEqualToString:@"GET"]) {
    return
        [self appendUrlHeadAndTailer:@"trade/batchentrustwithdraw?wths={wths}"];
  } else {
    return nil;
  }
}

/**
 * 银证转账信息
 */
- (NSString *)getBankSecuInfo {
  return [self appendUrlHeadAndTailer:@"trade/banksecuinfo"];
}

/**
 * 银行转证券
 */
- (NSString *)getBankToSecu {
  if (self.method && [self.method isEqualToString:@"POST"]) {
    return [self appendUrlHeadAndTailer:@"trade/" @"banktosecu"];

  } else if (self.method && [self.method isEqualToString:@"GET"]) {
    return [self appendUrlHeadAndTailer:@"trade/"
                 @"banktosecu?zjzh={zjzh}&bz={bz}&yhzh={"
                 @"yhzh}&yhdm={yhdm}&yhmm={yhmm}&zzje={" @"zzje}"];
  } else {
    return nil;
  }
}

/**
 * 证券转银行
 */
- (NSString *)getSecuToBank {
  if (self.method && [self.method isEqualToString:@"POST"]) {
    return [self appendUrlHeadAndTailer:@"trade/" @"secutobank"];
  } else if (self.method && [self.method isEqualToString:@"GET"]) {
    return [self appendUrlHeadAndTailer:@"trade/"
                 @"secutobank?zjzh={zjzh}&zjmm={zjmm}&bz={"
                 @"bz}&yhzh={yhzh}&yhdm={yhdm}&zzje={zzje}"];
  } else {
    return nil;
  }
}

/**
 * 转账查询
 */
- (NSString *)getTransaccountDetail {
  return [self appendUrlHeadAndTailer:@"trade/transaccountdetail"];
}

/**
 * 指定交易（页面显示）
 */
- (NSString *)getSpecifiedTransaction {
  return [self appendUrlHeadAndTailer:@"trade/specifiedTransactionForView"];
}

/**
 * 指定交易（提交委托）
 */
- (NSString *)getDoSpecifiedTransaction {
  return [self appendUrlHeadAndTailer:@"trade/doSpecifiedTransaction"];
}
@end

@implementation RealTradeUrls

+ (RealTradeUrls *)singleInstance {
  static RealTradeUrls *sharedInstance = nil;

  static dispatch_once_t predicate;
  dispatch_once(&predicate, ^{
    sharedInstance = [[self alloc] init];
    sharedInstance.apexSoftUrlFactory =
        [[RealTradeApexSoftUrlFactory alloc] init];
  });

  return sharedInstance;
}

//得到协议的 指针
+ (id)getRealTradeUrlFactory {
  return (RealTradeApexSoftUrlFactory *)[RealTradeUrls singleInstance]
      .apexSoftUrlFactory;
}

/*
 *  保存项：
 *  证券类型 type 1 = 顶点 2 = 恒生
 *  证券网址 url
 *  证券操作的接口请求方式 method
 *  证券券商号 num
 */
- (void)saveRealTradeUrlFactory:(NSInteger)type {
  NSUserDefaults *myUser = [NSUserDefaults standardUserDefaults];
  NSString *uid = [SimuUtil getUserID];
  NSString *firmKeyType = [NSString stringWithFormat:@"%@_firmtype", uid];
  NSString *firmUrlKey = [NSString stringWithFormat:@"%@_firmurl", uid];
  NSString *firmMethodKey = [NSString stringWithFormat:@"%@_firmmethod", uid];
  NSString *firmNumKey = [NSString stringWithFormat:@"%@_firmnum", uid];
  RealTradeApexSoftUrlFactory *factory = nil;
  factory = (RealTradeApexSoftUrlFactory *)[RealTradeUrls singleInstance]
                .apexSoftUrlFactory;
  [myUser setObject:factory.urlHead forKey:firmUrlKey];
  [myUser setObject:factory.method forKey:firmMethodKey];
  [myUser setObject:factory.brokerId forKey:firmNumKey];
  [myUser setInteger:type forKey:firmKeyType];
  [myUser synchronize];
}
/** 自动配置实盘信息 */
- (BOOL)autoLoadRealTradeUrlFactory {
  NSUserDefaults *myUser = [NSUserDefaults standardUserDefaults];
  NSString *uid = [SimuUtil getUserID];
  NSString *firmKeyType = [NSString stringWithFormat:@"%@_firmtype", uid];
  NSString *firmUrlKey = [NSString stringWithFormat:@"%@_firmurl", uid];
  NSString *firmMethodKey = [NSString stringWithFormat:@"%@_firmmethod", uid];
  NSString *firmNumKey = [NSString stringWithFormat:@"%@_firmnum", uid];
  
  NSInteger firmType = [myUser integerForKey:firmKeyType];
  NSString *firmUrl = [myUser objectForKey:firmUrlKey];
  NSString *firmMethod = [myUser objectForKey:firmMethodKey];
  NSString *firmNum = [myUser objectForKey:firmNumKey];

  RealTradeApexSoftUrlFactory *factory =
      [RealTradeUrls getRealTradeUrlFactory];
  if (factory) {
    if (firmUrl && firmMethod && firmNum) {
      [factory setUrlPrefix:firmUrl];
      [factory sendValueForLongon:firmMethod];
      [factory sendvalueforBrokerID:firmNum];
      [factory senDValueBrokerFactoryType:firmType];
      return YES;
    }
  }
  return NO;
}
/** 取数据 */
- (NSString *)getBrokerStockInfor:(GetBrokerInfoData)getBrokerInfo {
  NSUserDefaults *myUser = [NSUserDefaults standardUserDefaults];
  NSString *uid = [SimuUtil getUserID];
  NSString *firmKeyType = [NSString stringWithFormat:@"%@_firmtype", uid];
  NSString *firmUrlKey = [NSString stringWithFormat:@"%@_firmurl", uid];
  NSString *firmMethodKey = [NSString stringWithFormat:@"%@_firmmethod", uid];
  NSString *firmNumKey = [NSString stringWithFormat:@"%@_firmnum", uid];

  switch (getBrokerInfo) {
  case GetBrokerUrl:
    return [myUser objectForKey:firmUrlKey];
  case GetBrokerMethod:
    return [myUser objectForKey:firmMethodKey];
  case GetBrokerNum:
    return [myUser objectForKey:firmNumKey];
  case GetBrokerType:
    return [NSString
        stringWithFormat:@"%ld", (long)[myUser integerForKey:firmKeyType]];
  }
  return nil;
}

@end
