//
//  SimuUser.m
//  SimuStock
//
//  Created by Mac on 14-9-15.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SimuUser.h"

#import "SimuUtil.h"
#import "MyAttentionInfo.h"
#import "BaiDuPush.h"

#define sessionId_saved_time @"previousSessionIdSavedTime"
#define firmLogonSuccessTime @"firmLogonSuccessTime"
/** 五分钟（实盘免重登期限）*/
#define FiveMinutes 300

@implementation SimuUser

/** 当退出登录时 */
+ (void)onLoginOut {
  //退出时，解除
  [SimuUser sendDelBindBpush];

  //清空baiduUserId
  [SimuUtil setBaiduUserId:@""];

  //清空关注信息数据
  NSMutableArray *attentionArray =
      [[MyAttentionInfo sharedInstance] getAttentionArray];
  [attentionArray removeAllObjects];

  //清空密码，sessionid，userid缓存，防止自动登录
  [SimuUtil setUserPassword:@""];
  [SimuUtil setSesionID:@"-1"];
  [SimuUtil setUserID:@"-1"];
  [SimuUtil setHsUserID:@"-1"];
  [SimuUtil setUserPhone:@""];
  [SimuUtil setUserCertName:@""];
  [SimuUtil setUserCertNo:@""];

  //重置保存sid时间
  [SimuUser setSessionSavedTime:0];
  //实盘登录时间清零
  [SimuUser setUserFirmLogonSuccessTime:0];

  //清除头像
  [SimuUtil setUserImageURL:@""];

  // 1. 刷新主界面
  [[NSNotificationCenter defaultCenter] postNotificationName:LogoutSuccess
                                                      object:nil];
}
/////退出时推送解绑
+ (void)sendDelBindBpush {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onSuccess = ^(NSObject *obj) {

  };
  [BaiDuPush pushDelBindUserWithCallback:callback];
}

/** 设置session被获取时的时间*/
+ (void)setSessionSavedTime:(int64_t)time {
  NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
  [userinfo setObject:@(time) forKey:sessionId_saved_time];
  [userinfo synchronize];
};

/** 返回session被获取时的时间 */
+ (int64_t)getSessionSavedTime {
  NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
  NSNumber *time = [userinfo objectForKey:sessionId_saved_time];
  return time == nil ? 0 : [time longLongValue];
};
/** 用户实盘登录时刻 */
+ (void)setUserFirmLogonSuccessTime:(int64_t)time {
  NSUserDefaults *firmInfo = [NSUserDefaults standardUserDefaults];
  [firmInfo setObject:@(time) forKey:firmLogonSuccessTime];
  [firmInfo synchronize];
}
/** 实盘是否直接登录 */
+ (BOOL)getUserFirmLogonSuccessStatus {
  NSUserDefaults *firmInfo = [NSUserDefaults standardUserDefaults];
  NSNumber *time = [firmInfo objectForKey:firmLogonSuccessTime];
  int64_t recordPreviousTime = (time == nil ? 0 : [time longLongValue]);
  int64_t currentTime = [NSDate timeIntervalSinceReferenceDate];
  if (!recordPreviousTime || recordPreviousTime < 1) {
    //首次运行
    return NO;
  } else if (currentTime - recordPreviousTime < FiveMinutes) {
    return YES;
  } else {
    return NO;
  }
  // return (time == nil ? 0: [time longLongValue]);
}
//保存历史登录信息
+ (void)saveUsernameHistoryInfo:(NSString *)loginUserName {
  if (loginUserName == nil || [loginUserName length] == 0) {
    return;
  }

  //历史记录调用
  NSMutableArray *historyUserNames = [self userNameHistoryInfo];
  [historyUserNames removeObject:@""];

  //先去重
  if ([historyUserNames containsObject:loginUserName]) {
    [historyUserNames removeObject:loginUserName];
  }
  //清除末项
  if ([historyUserNames count] == 5) {
    [historyUserNames removeLastObject];
  }

  [historyUserNames insertObject:loginUserName atIndex:0];

  //保存历史记录
  NSUserDefaults *myUser = [NSUserDefaults standardUserDefaults];
  [myUser setObject:historyUserNames forKey:@"USER_NAME_ARRAY"];
  [myUser synchronize];
}

+ (NSMutableArray *)userNameHistoryInfo {
  NSUserDefaults *myUser = [NSUserDefaults standardUserDefaults];
  NSArray *array = [myUser objectForKey:@"USER_NAME_ARRAY"];
  return array ? [[NSMutableArray alloc] initWithArray:array]
               : [[NSMutableArray alloc] init];
}
@end
