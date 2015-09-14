//
//  ReinstallViewController.m
//  SimuStock
//
//  Created by jhss on 13-9-26.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "ReinstallViewController.h"
#import "SimuAction.h"
#import "AppDelegate.h"
#import "SimuUtil.h"
#import "UserInformationItem.h"
#import "event_view_log.h"

#import "NetLoadingWaitView.h"

@implementation ReinstallViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self createMainView];
}
#pragma mark
#pragma mark---------界面--------
- (void)createMainView {
  //自适应
  CGRect frame = self.view.frame;
  _indicatorView.hidden = YES;
  [_topToolBar resetContentAndFlage:@"忘记密码" Mode:TTBM_Mode_Leveltwo];
  // self.view设计
  //分割线
  UILabel *firstCuttingLineLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(side_edge_width, 47,
                               self.view.frame.size.width - side_edge_width * 2,
                               0.5f)];
  firstCuttingLineLabel.backgroundColor = [Globle colorFromHexRGB:@"086dae"];
  [self.clientView addSubview:firstCuttingLineLabel];

  UILabel *secondCuttingLineLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(side_edge_width, 47 + 45,
                               self.view.frame.size.width - side_edge_width * 2,
                               0.5f)];
  secondCuttingLineLabel.backgroundColor = [Globle colorFromHexRGB:@"086dae"];
  [self.clientView addSubview:secondCuttingLineLabel];
  //左侧label（名称）
  UILabel *passwordLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(side_edge_width,
                               firstCuttingLineLabel.frame.origin.y - 28, 60,
                               28)];
  passwordLabel.text = @"新密码：";
  passwordLabel.backgroundColor = [UIColor clearColor];
  passwordLabel.textAlignment = NSTextAlignmentLeft;
  passwordLabel.textColor = [Globle colorFromHexRGB:@"086ade"];
  passwordLabel.font = [UIFont systemFontOfSize:14];
  [self.clientView addSubview:passwordLabel];
  UILabel *confirmPasswordLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(side_edge_width,
                               secondCuttingLineLabel.frame.origin.y - 28, 70,
                               28)];
  confirmPasswordLabel.textColor = [Globle colorFromHexRGB:@"086ade"];
  confirmPasswordLabel.textAlignment = NSTextAlignmentLeft;
  confirmPasswordLabel.text = @"确认密码：";
  confirmPasswordLabel.backgroundColor = [UIColor clearColor];
  confirmPasswordLabel.font = [UIFont systemFontOfSize:14];
  [self.clientView addSubview:confirmPasswordLabel];
  // textfield（输入框）
  //新密码
  passwordTextField = [[UITextField alloc]
      initWithFrame:CGRectMake(passwordLabel.frame.origin.x +
                                   passwordLabel.frame.size.width,
                               firstCuttingLineLabel.frame.origin.y - 24,
                               frame.size.width - 100, 20)];
  passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
  passwordTextField.placeholder = @"6-16位字母或数字";
  passwordTextField.delegate = self;
  [passwordTextField setSecureTextEntry:YES];
  passwordTextField.textColor = [Globle colorFromHexRGB:@"454545"];
  passwordTextField.font = [UIFont systemFontOfSize:14];
  passwordTextField.backgroundColor = [UIColor clearColor];
  [self.clientView addSubview:passwordTextField];
  //确认密码
  oncePassWordTextField = [[UITextField alloc]
      initWithFrame:CGRectMake(confirmPasswordLabel.frame.origin.x +
                                   confirmPasswordLabel.frame.size.width,
                               secondCuttingLineLabel.frame.origin.y - 24,
                               frame.size.width - 110, 20)];
  oncePassWordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
  oncePassWordTextField.placeholder = @"请再次输入密码";
  oncePassWordTextField.textColor = [Globle colorFromHexRGB:@"454545"];
  oncePassWordTextField.delegate = self;
  [oncePassWordTextField setSecureTextEntry:YES];
  oncePassWordTextField.backgroundColor = [UIColor clearColor];
  oncePassWordTextField.font = [UIFont systemFontOfSize:14];
  [self.clientView addSubview:oncePassWordTextField];
  //完成
  UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
  confirmButton.frame =
      CGRectMake(side_edge_width, secondCuttingLineLabel.frame.origin.y + 40,
                 frame.size.width - side_edge_width * 2, 35);
  UIImage *confirmImage = [UIImage imageNamed:@"return_touch_down.png"];
  confirmImage =
      [confirmImage resizableImageWithCapInsets:UIEdgeInsetsMake(14, 5, 14, 5)];
  [confirmButton setBackgroundImage:confirmImage
                           forState:UIControlStateHighlighted];
  [confirmButton setTitle:@"确认" forState:UIControlStateNormal];
  [confirmButton setBackgroundColor:[Globle colorFromHexRGB:@"086dae"]];
  __weak ReinstallViewController *selfBlock = self;
  [confirmButton setOnButtonPressedHandler:^{ [selfBlock confirm]; }];
  [self.clientView addSubview:confirmButton];
}

- (void)confirm {
  //键盘收回
  [self resignKeyBoardFirstResponder];
  //输入框限定条件
  if ([passwordTextField.text length] == 0) {
    [NewShowLabel setMessageContent:@"请输入密码"];
    return;
  } else if (![self isNumbersOrLetters:passwordTextField.text]) {
    [NewShowLabel
        setMessageContent:@"密码由6-" @"16位字母或数字组成，请重新输入"];
    return;
  } else if ([passwordTextField.text length] < 6) {
    [NewShowLabel setMessageContent:@"密码至少是6位的数字或字母"];
    return;
  } else if ([oncePassWordTextField.text length] == 0) {
    [NewShowLabel setMessageContent:@"请输入确认密码"];
    return;
  } else if (![passwordTextField.text
                 isEqualToString:oncePassWordTextField.text]) {
    [NewShowLabel setMessageContent:@"两次输入密码不一致"];
    return;
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak ReinstallViewController *weakSelf = self;
  callback.onSuccess = ^(NSObject *obj) {
      ReinstallViewController *strongSelf = weakSelf;
      if (strongSelf) {
        [strongSelf resetPasswordSuccess];
      }
  };

  callback.onFailed = ^{
      if ([NetLoadingWaitView isAnimating]) {
        [NetLoadingWaitView stopAnimating];
      }
  };
  callback.onError = ^(BaseRequestObject *obj, NSException *error) {
      if ([NetLoadingWaitView isAnimating]) {
        [NetLoadingWaitView stopAnimating];
      }
      [BaseRequester defaultErrorHandler](obj, error);
  };
  if (![NetLoadingWaitView isAnimating]) {
    [NetLoadingWaitView startAnimating];
  }
  [UserDataModel resetPasswordWithPhoneNum:self.phoneNumber
                              withPassword:passwordTextField.text
                              withCallback:callback];
}

- (void)resetPasswordSuccess {

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak ReinstallViewController *weakSelf = self;

  callback.onSuccess = ^(NSObject *obj) {
      ReinstallViewController *strongSelf = weakSelf;
      if (strongSelf) {
        [strongSelf logonSuccess];
      }
  };
  callback.onFailed = ^{
      if ([NetLoadingWaitView isAnimating]) {
        [NetLoadingWaitView stopAnimating];
      }
  };
  callback.onError = ^(BaseRequestObject *obj, NSException *error) {
      if ([NetLoadingWaitView isAnimating]) {
        [NetLoadingWaitView stopAnimating];
      }
      [BaseRequester defaultErrorHandler](obj, error);
  };

  [UserInformationItem requestLoginWithUserName:self.phoneNumber
                                   withPassword:passwordTextField.text
                                   withCallback:callback];
}
- (void)logonSuccess {
  //返回登录数据
  //登录日志
  [[event_view_log sharedManager] addLoginEventToLog];

  [SimuUser saveUsernameHistoryInfo:self.phoneNumber];

  //切换界面
  [self changePage];

  if ([NetLoadingWaitView isAnimating]) {
    [NetLoadingWaitView stopAnimating];
  }
}
- (void)changePage {
  //个人中心的手机更换、绑定区分接口

  if (_phoneNumber) {
    [SimuUtil setUserName:_phoneNumber];
  } else {
    [SimuUtil setUserName:_phoneNumber];
  }
  [SimuUtil setUserName:_phoneNumber];
  [SimuUtil setUserPassword:passwordTextField.text];
  [SimuUser setSessionSavedTime:[NSDate timeIntervalSinceReferenceDate]];
  //登录成功后返回位置
  NSInteger isOtherLogin =
      [[NSUserDefaults standardUserDefaults] integerForKey:@"isOtherLogin"];
  switch (isOtherLogin) {
  case 1: {
    [AppDelegate popToRootViewController:NO];
  } break;
  case 2: {
    [AppDelegate popViewController:NO];
  } break;
  default:
    break;
  }
  //登录成功提示，更新主界面数据
  [[NSNotificationCenter defaultCenter] postNotificationName:LogonSuccess
                                                      object:nil];
  [self sendMessageUpdataUserInfo];

  [[NSNotificationCenter defaultCenter]
      postNotificationName:UpDataFromNet_WithMainController
                    object:@"upformNet_For_Userinfo"];
}

#pragma mark
#pragma mark textField----------协议函数--------
- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string {
  if ([string isEqualToString:@"\n"]) {
    return YES;
  }
  NSString *toBeString =
      [textField.text stringByReplacingCharactersInRange:range
                                              withString:string];
  if ([toBeString length] > 15) {
    [NewShowLabel setMessageContent:@"您的密码长度不能超过16位"];
    textField.text = [toBeString substringToIndex:16];
    return NO;
  }
  return YES;
}
#pragma mark
#pragma mark--------辅助--------
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self resignKeyBoardFirstResponder];
}
/**
 *释放键盘
 */
- (void)resignKeyBoardFirstResponder {
  [passwordTextField resignFirstResponder];
  [oncePassWordTextField resignFirstResponder];
}
//判断是否是数字或字母
//密码是否只为字母或数字
- (BOOL)isNumbersOrLetters:(NSString *)str {
  if (str == nil || str == NULL)
    return NO;
  NSUInteger uILength = [str length];
  int i;
  for (i = 0; i < uILength; ++i) {
    unichar everyChar = [str characterAtIndex:i];
    if ((everyChar >= '0' && everyChar <= '9') ||
        (everyChar >= 'a' && everyChar <= 'z') ||
        (everyChar >= 'A' && everyChar <= 'Z'))
      continue;
    else
      return NO;
  }
  return YES;
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
#pragma mark----回拉效果-----
- (void)leftButtonPress {
  [self resignKeyBoardFirstResponder];
  [super leftButtonPress];
}

@end
