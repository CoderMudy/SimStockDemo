//
//  FullScreenLogonViewController.m
//  SimuStock
//
//  Created by jhss on 14-7-13.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "FullScreenLogonViewController.h"
#import "SimuStockRegisterView.h"
#import "AppDelegate.h"
#import "SimuUtil.h"

@implementation FullScreenLogonViewController {
  LoginLogoutNotification *loginLogoutNotification;
}

- (id)init {
  self = [super init];
  if (self) {
    __weak FullScreenLogonViewController *weakSelf = self;
    loginLogoutNotification = [[LoginLogoutNotification alloc] init];
    loginLogoutNotification.onLoginLogout = ^{
      FullScreenLogonViewController *strongSelf = weakSelf;
      if (strongSelf) {
        UINavigationController *navigationController =
            strongSelf.navigationController;
        [navigationController popToViewController:strongSelf animated:NO];
        [navigationController popViewControllerAnimated:NO];
        if (strongSelf.onLoginCallBack) {
          [SimuUtil performBlockOnMainThread:^{
            strongSelf.onLoginCallBack(NO);
          } withDelaySeconds:0.2];
        }
      }
    };
  }
  return self;
}

- (id)initWithOnLoginCallBack:(OnLoginCallBack)onLoginCallBack {
  return [self initWithOnLoginCallBack:onLoginCallBack notLogin:NULL];
}

- (id)initWithOnLoginCallBack:(OnLoginCallBack)onLoginCallBack
                     notLogin:(notLoginCallBack)notLoginCallBack {
  self = [self init];
  if (self) {
    self.onLoginCallBack = onLoginCallBack;
    self.notLoginCallBack = notLoginCallBack;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  CGRect frame = self.clientView.bounds;
  //导航条
  _indicatorView.hidden = YES;
  [_topToolBar resetContentAndFlage:@"登录" Mode:TTBM_Mode_Leveltwo];
  //三种登录方式
  SimuStockRegisterView *simuStockRegisterView =
      [[SimuStockRegisterView alloc] initWithFrame:CGRectMake(0, 64, 230, 270)];
  simuStockRegisterView.center = CGPointMake(frame.size.width / 2, 64 + 135);
  simuStockRegisterView.isOtherLogin = 2;
  [simuStockRegisterView.titleLabel
      setTextColor:[Globle colorFromHexRGB:@"5a5a5a"]];
  [self.clientView addSubview:simuStockRegisterView];
}

- (void)releaseFullLoginPage:(NSNotification *)notification {
  if (self.backHandlerInContainer) {
    self.backHandlerInContainer();
    return;
  }
  [AppDelegate popViewController:NO];
}

+ (void)checkLoginStatusWithCallBack:(OnLoginCallBack)onLoginCallBack {
  BOOL notLogined = [@"-1" isEqualToString:[SimuUtil getUserID]];
  if (notLogined) {
    [AppDelegate pushViewControllerFromRight:
                     [[FullScreenLogonViewController alloc]
                         initWithOnLoginCallBack:onLoginCallBack]];
  } else {
    onLoginCallBack(YES);
  }
};

+ (void)checkLoginStatusWithCallBack:(OnLoginCallBack)onLoginCallBack
                            notLogin:(notLoginCallBack)notLoginCallBack {
  BOOL notLogined = [@"-1" isEqualToString:[SimuUtil getUserID]];
  if (notLogined) {
    [AppDelegate pushViewControllerFromRight:
                     [[FullScreenLogonViewController alloc]
                         initWithOnLoginCallBack:onLoginCallBack
                                        notLogin:notLoginCallBack]];
  } else {
    onLoginCallBack(YES);
  }
};

- (void)leftButtonPress {
  NSLog(@"用户未登录");
  if (_notLoginCallBack) {
    _notLoginCallBack();
  }
  [super leftButtonPress];
}

@end
