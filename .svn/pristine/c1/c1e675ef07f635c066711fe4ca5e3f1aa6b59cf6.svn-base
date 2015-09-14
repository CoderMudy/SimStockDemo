//
//  UserRealTradingInfo.m
//  SimuStock
//
//  Created by jhss on 14-10-22.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "UserRealTradingInfo.h"
#import "SimuUtil.h"
static UserRealTradingInfo *userInfo = nil;
@implementation UserRealTradingInfo
+ (UserRealTradingInfo *)sharedInstance {
  @synchronized(self) {
    if (userInfo == nil) {
      userInfo = [[UserRealTradingInfo alloc] init];
    }
  }
  return userInfo;
}
+ (id)allocWithZone:(NSZone *)zone {
  @synchronized(self) {
    if (userInfo == nil) {
      userInfo = [super allocWithZone:zone];
      return userInfo;
    }
  }
  return nil;
}
/**保存信息*/
- (void)saveUserInfo:(SaveType)saveType
     withSaveContent:(NSString *)saveContent {
  NSString *userId = [SimuUtil getUserID];
  NSUserDefaults *myUser = [NSUserDefaults standardUserDefaults];
  NSString *saveCon = [NSString stringWithFormat:@"%@#%d", userId, saveType];
  [myUser setObject:saveContent forKey:saveCon];
  [myUser synchronize];
}
/**删除某项信息*/
- (void)deleteUserInfo:(SaveType)saveType {
  NSString *userId = [SimuUtil getUserID];
  NSUserDefaults *myUser = [NSUserDefaults standardUserDefaults];
  NSString *saveCon = [NSString stringWithFormat:@"%@#%d", userId, saveType];
  switch (saveType) {
  case SaveTypeAccountSaveStatus:
  case SaveTypeUserTradingIDCustomerNumber:
  case SaveTypeUserTradingIDFundNumber:
  case SaveTypeAccountTypeCustomerNumber:
  case SaveTypeAccountTypeFundNumber:
  case SaveTypeSelectedType:
  case SaveTypeUserTradingCompany:
  default: {
    [myUser removeObjectForKey:saveCon];
    [myUser synchronize];
  } break;
  }
}
/**获取某项信息*/
- (NSString *)getUserInfo:(SaveType)saveType {
  NSString *userId = [SimuUtil getUserID];
  NSUserDefaults *myUser = [NSUserDefaults standardUserDefaults];
  NSString *saveCon = [NSString stringWithFormat:@"%@#%d", userId, saveType];
  NSString *saveContent = [myUser objectForKey:saveCon];
    if (saveContent && [saveContent length] > 0) {
      return saveContent;
    } else {
      return @"";
    }
}
/**实盘交易，不同账号的失败次数*/
- (void)saveUserRealTradeLogonWithAccountId:(NSString *)accountId
                               withFailTime:(NSInteger)failTime {
  NSString *logonTimeKey =
      [NSString stringWithFormat:@"realTradeTime_%@", accountId];
  NSUserDefaults *myUser = [NSUserDefaults standardUserDefaults];
  [myUser setInteger:failTime forKey:logonTimeKey];
  [myUser synchronize];
}
/**实盘交易,不同账号的失败时间*/
- (void)saveUserRealTradeFailDateWithAccountId:(NSString *)accountId {
  NSString *logonDateKey =
      [NSString stringWithFormat:@"realTradeDate_%@", accountId];
  NSUserDefaults *myUser = [NSUserDefaults standardUserDefaults];
  [myUser setObject:[NSDate date] forKey:logonDateKey];
  [myUser synchronize];
}
- (NSInteger)getUserRealTradeLogonWithAccountId:(NSString *)accountId {
  NSString *logonTimeKey =
      [NSString stringWithFormat:@"realTradeTime_%@", accountId];
  NSUserDefaults *myUser = [NSUserDefaults standardUserDefaults];
  NSInteger saveTime = [myUser integerForKey:logonTimeKey];
  return saveTime;
}
/**实盘交易，不同账号的失败时间*/
- (NSDate *)getUserFailLogonTimeWithAccountId:(NSString *)accountId {
  NSString *logonDateKey =
      [NSString stringWithFormat:@"realTradeDate_%@", accountId];
  NSUserDefaults *myUser = [NSUserDefaults standardUserDefaults];
  NSDate *saveDate = [myUser objectForKey:logonDateKey];
  return saveDate;
}
- (void)logonSuccessResetUserInfo:(NSString *)accountId {
  NSString *logonDateKey =
      [NSString stringWithFormat:@"realTradeDate_%@", accountId];
  NSString *logonTimeKey =
      [NSString stringWithFormat:@"realTradeTime_%@", accountId];
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:logonDateKey];
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:logonTimeKey];
  [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
