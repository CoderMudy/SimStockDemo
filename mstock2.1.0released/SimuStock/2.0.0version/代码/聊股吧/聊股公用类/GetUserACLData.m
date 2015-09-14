//
//  GetUserACLData.m
//  SimuStock
//
//  Created by Yuemeng on 14/12/29.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "GetUserACLData.h"
#import "NewShowLabel.h"
#import "SimuUtil.h"
#import "BaseRequester.h"

@implementation GetUserACLData

#pragma mark - 网络请求方法
#pragma mark 无网提示
- (void)setNoNetwork {
  [NewShowLabel setMessageContent:@"网" @"络" @"不" @"给"
                @"力，用户权限获取失" @"败"];
}

#pragma mark 用户权限检测
- (void)requestUserACLData {
  if (![SimuUtil isExistNetwork]) {
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak GetUserACLData *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    GetUserACLData *strongSelf = weakSelf;
    if (strongSelf) {
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    GetUserACLData *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindUserACLData:(UserACLData *)obj];
    }
  };
  callback.onFailed = ^{
    [weakSelf setNoNetwork];
  };

  [UserACLData requestUserACLDataWithCallback:callback];
}

- (void)bindUserACLData:(UserACLData *)userACLData {
  _userACLData = userACLData;
  if (_getUserACLBlock) {
    _getUserACLBlock(_userACLData);
  }
}

#pragma mark - 单例方法
- (instancetype)init {
  self = [super init];
  if (self) {
    [self requestUserACLData];
    __weak GetUserACLData *weakSelf = self;
    _loginLogoutNotification = [[LoginLogoutNotification alloc] init];
    _loginLogoutNotification.onLoginLogout = ^{
      [weakSelf onLogonLogout];
    };
  }
  return self;
}

- (void)onLogonLogout {
  if ([SimuUtil isLogined]) {
    NSLog(@"登录成功，重新获取用户权限列表");
    [self requestUserACLData];
  } else {
    NSLog(@"登出，清空权限列表");
    _userACLData = nil;
  }
}

+ (instancetype)sharedUserACLData {
  static GetUserACLData *getUserACLData;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    getUserACLData = [[GetUserACLData alloc] init];
  });
  return getUserACLData;
}

+ (void)checkLoginStatusWithCallBack:(getUserACLBlock)getUserACLBlock {
  GetUserACLData *getUserACLData = [GetUserACLData sharedUserACLData];
  getUserACLData.getUserACLBlock = getUserACLBlock;
  [getUserACLData requestUserACLData];
}

@end
