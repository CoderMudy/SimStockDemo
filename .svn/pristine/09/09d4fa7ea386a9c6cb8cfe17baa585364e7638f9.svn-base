//
//  SessionIDVerificationProcess.m
//  SimuStock
//
//  Created by jhss on 14-7-22.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SessionIDVerificationProcess.h"
#import "UserDataModel.h"

static SessionIDVerificationProcess *sidVer = nil;

@implementation SessionIDVerificationProcess

- (id)init {
  self = [super init];
  if (self) {
    autoLogin = [[LoginProcess alloc] init];
    // viewcontroller控件创建完毕
//    [self performSelector:@selector(isOutOfDateOfSid)
//               withObject:nil
//               afterDelay:2.5];
    [self isOutOfDateOfSid];
  }

  return self;
}
//创建单例访问对象
+ (SessionIDVerificationProcess *)shareSidVerification {
  if (sidVer == nil) {
    sidVer = [[self alloc] init];
  }
  return sidVer;
}

//验证sid是否过期
- (NSInteger)isOutOfDateOfSid {
  NSLog(@"验证sessionid 是否 过期");
  //之前保存sid时间
  previousSaveSidTime = [SimuUser getSessionSavedTime];
  NSString *sid = [SimuUtil getSesionID];
  //当前时间
  currentTime = [NSDate timeIntervalSinceReferenceDate];
  if (!previousSaveSidTime || previousSaveSidTime < 1) {
    //首次运行
    return -1;
  }
  if (currentTime - previousSaveSidTime < sid_one_day_time) {
    if (![sid isEqualToString:@"-1"]) {
      //刷新总资金
      [[NSNotificationCenter defaultCenter] postNotificationName:LogonSuccess
                                                          object:nil];
    }
    return 1;
  } else if (currentTime - previousSaveSidTime < sid_seven_days_time) {
    if (![sid isEqualToString:@"-1"]) {
      //刷新总资金,sid使用超过一天，需验证
      [self sessionIdVerification];
    }
    return 2;
  } else {
    [autoLogin loginPort];
    return 0;
  }
}
#pragma mark
#pragma mark-------1-7天的验证过程------
//验证sid
- (void)sessionIdVerification {
    [self sendSidVerificationRequest];
}
- (void)sendSidVerificationRequest {
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak SessionIDVerificationProcess *weakSelf = self;

  callback.onSuccess = ^(NSObject *obj) {
      SessionIDVerificationProcess *strongSelf = weakSelf;
      if (strongSelf) {
        //刷新总资金
        [[NSNotificationCenter defaultCenter] postNotificationName:LogonSuccess
                                                            object:nil];
        //记录sid保存时间
        [SimuUser setSessionSavedTime:[NSDate timeIntervalSinceReferenceDate]];
      }
  };

  callback.onError = ^(BaseRequestObject *obj, NSException *ex) {
      if (obj && [obj.status isEqualToString:@"1001"]) {
        //重新登录
        [autoLogin loginPort];
      } else {
        [BaseRequester defaultErrorHandler](obj, ex);
      }
  };
  [UserDataModel authSessionWithCallback:callback];
}

@end
