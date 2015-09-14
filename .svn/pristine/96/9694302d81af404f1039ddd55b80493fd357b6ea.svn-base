//
//  LogonDataParsingClass.m
//  SimuStock
//
//  Created by jhss on 14-7-7.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "LogonDataParsingClass.h"
#import "SimuUtil.h"
#import "NetLoadingWaitView.h"
#import "event_view_log.h"
#import "SimuAction.h"
#import "BaseRequester.h"

@implementation LogonDataParsingClass

#pragma mark
#pragma mark-------三方登录请求入口---------
- (void)thirdPartAutoLogon:(NSString *)uid
             withLogonType:(NSString *)logonType
                 withToken:(NSString *)token {
  //暂存三方登录方式
  tempThirdLogonType = [logonType integerValue];
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  //解析
  __weak LogonDataParsingClass *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    LogonDataParsingClass *strongSelf = weakSelf;
    if ([NetLoadingWaitView isAnimating])
      [NetLoadingWaitView stopAnimating];
    if (strongSelf) {
      return NO;
    } else
      return YES;
  };
  callback.onSuccess = ^(NSObject *obj) {
    LogonDataParsingClass *strongSelf = weakSelf;
    if (strongSelf) {
      if (tempThirdLogonType == 2) {
        //记录日志
        [[event_view_log sharedManager]
            addPVAndButtonEventToLog:Log_Type_PV
                             andCode:@"登录页-QQ登录"];
      } else if (tempThirdLogonType == 3) {
        //纪录日志
        [[event_view_log sharedManager]
            addPVAndButtonEventToLog:Log_Type_PV
                             andCode:@"登录页-新浪微博登录"];
      } else {
        //纪录日志
        [[event_view_log sharedManager]
            addPVAndButtonEventToLog:Log_Type_PV
                             andCode:@"登录页-微信登录"];
      }
      //切换界面
      //登录成功提示，更新主界面数据
      [[NSNotificationCenter defaultCenter] postNotificationName:LogonSuccess
                                                          object:nil];

      [self sendMessageUpdataUserInfo];
      [SimuUser setSessionSavedTime:[NSDate timeIntervalSinceReferenceDate]];
      [self performSelector:@selector(updateMainViewController) withObject:nil];
    }
  };
  callback.onError = ^(BaseRequestObject *error, NSException *ex) {
    if ([error.status integerValue] == 1010) {
      [self bindingPage];
      return;
    }
    [BaseRequester defaultErrorHandler](error, ex);
  };
  if (![NetLoadingWaitView isAnimating])
    [NetLoadingWaitView startAnimating];
  [ThirdPartLogon logonDoThirdPartAuthWithUid:uid
                                withLogonType:logonType
                                    withToken:token
                                 withCallback:callback];
}

#pragma mark
#pragma mark-------记录登录时间---------
- (void)updateMainViewController {
  [[NSNotificationCenter defaultCenter]
      postNotificationName:UpDataFromNet_WithMainController
                    object:@"upformNet_For_Userinfo"];
}
- (void)sendMessageUpdataUserInfo {
  SimuAction *action = nil;
  action = [[SimuAction alloc] initWithCode:AC_UpDate_UserInfo ActionURL:nil];
  if (nil != action) {
    //关闭事件不用联网
    [[NSNotificationCenter defaultCenter]
        postNotificationName:SYS_VAR_NAME_DOACTION_MSG
                      object:action];
  }
}
#pragma mark
#pragma mark--------请求成功(数据处理函数)------
//获取的三方授权信息及用户信息
//三方向绑定页传递的数据
- (void)logonDataMessagePassingWithUid:(NSString *)uid
                          withNickName:(NSString *)nickName
                   withThirdLogonImage:(NSString *)logonImage
                         withTitleName:(NSString *)titleName
                 withThirdWayIconImage:(NSString *)thirdWayIconImage
                         withShareType:(NSInteger)shareType {
  self.tempUid = uid;
  self.tempNickName = nickName;
  self.tempHeadImage = logonImage;
  self.tempThirdPartImage = thirdWayIconImage;
  tempShareType = shareType;
  self.tempTitleName = titleName;
}
/** 三方绑定界面 */
- (void)bindingPage {
  //绑定页面
  BindingViewController *bindingVC = [[BindingViewController alloc] init];
  bindingVC.uid = self.tempUid;
  bindingVC.nickName = self.tempNickName;
  bindingVC.headImage = self.tempHeadImage;
  bindingVC.thirdPartIcon = self.tempThirdPartImage;
  bindingVC.titleName = self.tempTitleName;
  if (tempShareType == ShareTypeSinaWeibo) {
    bindingVC.logonType = @"3";
  } else if (tempShareType == ShareTypeQQSpace) {
    bindingVC.logonType = @"2";
  } else {
    //微信登录
    bindingVC.logonType = @"7";
  }
  [AppDelegate pushViewControllerFromRight:bindingVC];
}

@end
