//
//  SimuStockRegisterViewController.m
//  SimuStock
//
//  Created by Yuemeng on 15/8/3.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SimuStockRegisterViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "SimuUtil.h"
#import "UserLogonViewController.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "event_view_log.h"
#import "SettingsBaseViewController.h"

@implementation SimuStockRegisterViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self judgeButtonStatus];
}

//根据手机安装软件判断哪些button显示或隐藏
- (void)judgeButtonStatus {
  // QQ账号按钮
  _QQLogoButton.hidden = ![TencentOAuth iphoneQQInstalled];
  //微信账号按钮
  _WeiXinButton.hidden = ![WXApi isWXAppSupportApi];
}

- (IBAction)buttonCLick:(UIButton *)button {
  [self logonEntranceType];
  _thirdWayLogon = [[ThirdWayLogon alloc] init];
  if (button == _QQLogoButton) {
    [_thirdWayLogon getAuthWithShareType:ShareTypeQQSpace];
  } else if (button == _WeiXinButton) {
    [_thirdWayLogon getAuthWithShareType:ShareTypeWeixiSession];
  } else if (button == _WeiboButton) {
    [_thirdWayLogon getAuthWithShareType:ShareTypeSinaWeibo];
  } else if (button == _phoneOrUserNameButton) {
    [AppDelegate
        pushViewControllerFromRight:[[UserLogonViewController alloc] init]];
  }
}

- (IBAction)settingBtnClick:(UIButton *)sender {
  //设置页面切换
  [AppDelegate
      pushViewControllerFromRight:[[SettingsBaseViewController alloc] init]];
  //纪录日志
  [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button
                                                   andCode:@"23"];
}

/**区分登录来源*/
- (void)logonEntranceType {
  /**来自于主页 1 */
  /**来自于其他页面 2 */
  NSUserDefaults *myUser = [NSUserDefaults standardUserDefaults];
  [myUser setInteger:_isOtherLogin forKey:@"isOtherLogin"];
  [myUser synchronize];
}

@end
