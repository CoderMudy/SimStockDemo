//
//  LoginLogoutNotification.m
//  SimuStock
//
//  Created by Mac on 15/5/6.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "LoginLogoutNotification.h"

@implementation LoginLogoutNotification

- (id)init {
  if (self = [super init]) {
    [self addObservers];
  }
  return self;
}

- (void)addObservers {
  __weak LoginLogoutNotification *weakSelf = self;
  [self addObserverName:LogonSuccess
           withObserver:^(NSNotification *notif) {
             weakSelf.onLoginLogout();
           }];

  [self addObserverName:LogoutSuccess
           withObserver:^(NSNotification *notif) {
             weakSelf.onLoginLogout();
           }];
}

@end
