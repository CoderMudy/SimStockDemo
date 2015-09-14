//
//  LoginProcess.m
//  SimuStock
//
//  Created by jhss on 14-7-22.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "LoginProcess.h"

#import "NetLoadingWaitView.h"

@implementation LoginProcess
@synthesize userName = _userName;
@synthesize userPassword = _userPassword;

- (id)initWithUserName:(NSString *)tempUserName
      withUserPassword:(NSString *)tempUserPassword {
  self = [super init];
  if (self) {
    _userName = tempUserName;
    _userPassword = tempUserPassword;

  }
  return self;
}
#pragma mark
#pragma mark--------登录过程-------

- (void)loginPort {
    [self sendLoginRequest];
}
- (void)sendLoginRequest {
  //登录解析
  NSString *localUserName = [SimuUtil getUserName];
  if (_userName && [_userName length] > 0) {
    localUserName = [NSString stringWithString:_userName];
  }
  
  NSString *localUserPassword = [SimuUtil getUserPassword];
  if (_userPassword && [_userPassword length] > 0) {
    localUserPassword = self.userPassword;
  }
  if (![NetLoadingWaitView isAnimating]) {
    [NetLoadingWaitView startAnimating];
  }
  if ([localUserName length] < 1||[localUserPassword length] < 1) {
    if ([NetLoadingWaitView isAnimating]) {
      [NetLoadingWaitView stopAnimating];
    }
    [NewShowLabel setMessageContent:@"用户名或密码不能为空!"];
    return;
  }
  
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak LoginProcess *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    LoginProcess *strongSelf = weakSelf;
    if ([NetLoadingWaitView isAnimating]) {
      [NetLoadingWaitView stopAnimating];
    }
    if (strongSelf) {
      return NO;
    } else {
      return YES;
    }
  };
  
  callback.onSuccess = ^(NSObject *obj) {
    LoginProcess *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf setLoginSuccess];
    }
  };
  [UserInformationItem requestLoginWithUserName:localUserName
                                   withPassword:localUserPassword
                                   withCallback:callback];
}

-(void) setLoginSuccess{
  //保存登录信息
  if (_userName == nil) {
    _userName = @"";
  }
  if (_userPassword == nil) {
    _userPassword = @"";
  }
  //跳转位置
  NSInteger isOtherLogin = [[NSUserDefaults standardUserDefaults]integerForKey: @"isOtherLogin"];
  switch (isOtherLogin) {
    case 1:
    {
     [AppDelegate popToRootViewController:YES];
    }
      break;
    case 2:
    {
      [AppDelegate popViewController:NO];
    }
      break;
    default:
      break;
  }
  [self saveUsernameHistoryInfo:_userName withUserPassword:_userPassword];
  //登录成功，记录sid刷新时间
  [SimuUser setSessionSavedTime:[NSDate timeIntervalSinceReferenceDate]];
  //刷新总资金
  [[NSNotificationCenter defaultCenter] postNotificationName:LogonSuccess
                                                      object:nil];
}

#pragma mark
#pragma mark--------保留登录用户名——-----
//保存历史登录信息
- (void)saveUsernameHistoryInfo:(NSString *)localUserName
               withUserPassword:(NSString *)userPassword {
  //去掉自动注册的情况
  if ([localUserName hasPrefix:@"优顾"]) {
    return;
  }
  [SimuUser saveUsernameHistoryInfo:localUserName];
}

@end
