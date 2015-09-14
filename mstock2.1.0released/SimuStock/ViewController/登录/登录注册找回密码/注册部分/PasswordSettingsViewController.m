//
//  PasswordSettingsViewController.m
//  SimuStock
//
//  Created by jhss on 13-9-26.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "PasswordSettingsViewController.h"
#import "SimuUtil.h"
#import "SimuAction.h"
#import "CommonFunc.h"
#import "UserInformationItem.h"
#import "event_view_log.h"
#import "NetLoadingWaitView.h"
#import "JsonFormatRequester.h"

@implementation PasswordSettingsViewController

- (id)initWithCode:(NSString *)action_code
    withPhoneNumber:(NSString *)phoneNumber {
  self = [super init];
  if (self) {
    _verifyCode = action_code;
    _phoneNumber = phoneNumber;
  }
  return self;
}
- (void)viewDidLoad {
  [super viewDidLoad];
  [self createMainView];
}
#pragma mark
#pragma mark------界面-----
- (void)createMainView {
  CGRect frame = self.view.frame;
  self.view.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  _indicatorView.hidden = YES;
  [_topToolBar resetContentAndFlage:@"手机快速注册" Mode:TTBM_Mode_Leveltwo];
  UILabel *detailLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(side_edge_width, 17,
                               frame.size.width - side_edge_width * 2, 15)];
  detailLabel.font = [UIFont systemFontOfSize:15];
  detailLabel.textAlignment = NSTextAlignmentCenter;
  detailLabel.text = @"验证成功，请设置您的登录密码";
  detailLabel.backgroundColor = [UIColor clearColor];
  detailLabel.textColor = [Globle colorFromHexRGB:@"454545"];
  [self.clientView addSubview:detailLabel];
  //分割线
  UILabel *firstCuttingLineLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(side_edge_width, 83,
                               self.view.frame.size.width - side_edge_width * 2,
                               0.5f)];
  firstCuttingLineLabel.backgroundColor = [Globle colorFromHexRGB:@"086dae"];
  [self.clientView addSubview:firstCuttingLineLabel];

  UILabel *secondCuttingLineLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(side_edge_width, 83 + 45,
                               self.view.frame.size.width - side_edge_width * 2,
                               0.5f)];
  secondCuttingLineLabel.backgroundColor = [Globle colorFromHexRGB:@"086dae"];
  [self.clientView addSubview:secondCuttingLineLabel];

  //  UILabel *thirdCuttingLineLabel = [[UILabel alloc]
  //      initWithFrame:CGRectMake(side_edge_width, 83 + 45 * 2,
  //                               self.view.frame.size.width - side_edge_width
  //                               * 2,
  //                               0.5f)];
  //  thirdCuttingLineLabel.backgroundColor = [Globle
  //  colorFromHexRGB:@"086dae"];
  //  [self.clientView addSubview:thirdCuttingLineLabel];
  //左侧label
  //密码
  UILabel *passwordLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(side_edge_width,
                               firstCuttingLineLabel.frame.origin.y - 28, 45,
                               28)];
  passwordLabel.text = @"密码：";
  passwordLabel.textAlignment = NSTextAlignmentLeft;
  passwordLabel.textColor = [Globle colorFromHexRGB:@"086dae"];
  passwordLabel.font = [UIFont systemFontOfSize:15];
  passwordLabel.backgroundColor = [UIColor clearColor];
  [self.clientView addSubview:passwordLabel];
  //确认密码
  UILabel *confirmPasswordLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(side_edge_width,
                               secondCuttingLineLabel.frame.origin.y - 28, 75,
                               28)];
  confirmPasswordLabel.textColor = [Globle colorFromHexRGB:@"086dae"];
  confirmPasswordLabel.textAlignment = NSTextAlignmentLeft;
  confirmPasswordLabel.text = @"确认密码：";
  confirmPasswordLabel.backgroundColor = [UIColor clearColor];
  confirmPasswordLabel.font = [UIFont systemFontOfSize:15];
  [self.clientView addSubview:confirmPasswordLabel];
  //  //邀请码
  //  UILabel *invitedCodeLabel = [[UILabel alloc]
  //      initWithFrame:CGRectMake(side_edge_width,
  //                               thirdCuttingLineLabel.frame.origin.y - 28,
  //                               60,
  //                               28)];
  //  invitedCodeLabel.textColor = [Globle colorFromHexRGB:@"086dae"];
  //  invitedCodeLabel.textAlignment = NSTextAlignmentLeft;
  //  invitedCodeLabel.text = @"邀请码：";
  //  invitedCodeLabel.backgroundColor = [UIColor clearColor];
  //  invitedCodeLabel.font = [UIFont systemFontOfSize:15];
  //  [self.clientView addSubview:invitedCodeLabel];
  // textview
  passwordTextField = [[UITextField alloc]
      initWithFrame:CGRectMake(passwordLabel.frame.origin.x +
                                   passwordLabel.frame.size.width,
                               firstCuttingLineLabel.frame.origin.y - 24,
                               frame.size.width - 95, 20)];
  passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
  passwordTextField.placeholder = @"6-16位字母或数字";
  passwordTextField.delegate = self;
  [passwordTextField setSecureTextEntry:YES];
  passwordTextField.textColor = [Globle colorFromHexRGB:@"454545"];
  passwordTextField.font = [UIFont systemFontOfSize:15];
  passwordTextField.backgroundColor = [UIColor clearColor];
  [self.clientView addSubview:passwordTextField];

  oncePassWordTextField = [[UITextField alloc]
      initWithFrame:CGRectMake(confirmPasswordLabel.frame.origin.x +
                                   confirmPasswordLabel.frame.size.width,
                               secondCuttingLineLabel.frame.origin.y - 24,
                               frame.size.width - 125, 20)];
  oncePassWordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
  oncePassWordTextField.placeholder = @"请再次输入密码";
  oncePassWordTextField.textColor = [Globle colorFromHexRGB:@"454545"];
  oncePassWordTextField.delegate = self;
  [oncePassWordTextField setSecureTextEntry:YES];
  oncePassWordTextField.backgroundColor = [UIColor clearColor];
  oncePassWordTextField.font = [UIFont systemFontOfSize:14];
  [self.clientView addSubview:oncePassWordTextField];

  //  inviteCodeTextField = [[UITextField alloc]
  //      initWithFrame:CGRectMake(invitedCodeLabel.frame.origin.x +
  //                                   invitedCodeLabel.frame.size.width,
  //                               thirdCuttingLineLabel.frame.origin.y - 24,
  //                               frame.size.width - 110, 20)];
  //  inviteCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
  //  inviteCodeTextField.placeholder = @"选填";
  //  inviteCodeTextField.textColor = [Globle colorFromHexRGB:@"454545"];
  //  inviteCodeTextField.delegate = self;
  //  //[inviteCodeTextField setSecureTextEntry:YES];
  //  inviteCodeTextField.backgroundColor = [UIColor clearColor];
  //  inviteCodeTextField.font = [UIFont systemFontOfSize:14];
  //  [self.clientView addSubview:inviteCodeTextField];
  //  //邀请码文案
  //  UILabel *inviteCodeTipLabel = [[UILabel alloc]
  //      initWithFrame:CGRectMake(side_edge_width,
  //                               thirdCuttingLineLabel.frame.origin.y + 10,
  //                               self.view.frame.size.width - side_edge_width
  //                               * 2,
  //                               20)];
  //  inviteCodeTipLabel.backgroundColor = [UIColor clearColor];
  //  inviteCodeTipLabel.font = [UIFont systemFontOfSize:Font_Height_12_0];
  //  inviteCodeTipLabel.textAlignment = NSTextAlignmentLeft;
  //  inviteCodeTipLabel.textColor = [Globle colorFromHexRGB:@"f79100"];
  //  inviteCodeTipLabel.text = @"输" @"入" @"邀" @"请"
  //                                                 @"码注册成功，立即获赠20金币";
  //  [self.clientView addSubview:inviteCodeTipLabel];
  //确定
  UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
  finishButton.frame =
      CGRectMake(side_edge_width, secondCuttingLineLabel.frame.origin.y + 40,
                 frame.size.width - side_edge_width * 2, 35);
  [finishButton setBackgroundColor:[Globle colorFromHexRGB:@"086dae"]];
  [finishButton setTitle:@"确定" forState:UIControlStateNormal];
  [finishButton setBackgroundImage:[UIImage imageNamed:@"return_touch_down.png"]
                          forState:UIControlStateHighlighted];
  [finishButton addTarget:self
                   action:@selector(finish:)
         forControlEvents:UIControlEventTouchUpInside];
  [self.clientView addSubview:finishButton];
}

- (void)showSimuMessageContent:(NSString *)content {
  [NewShowLabel setMessageContent:content];
}
/**
 *键盘回收
 */
- (void)resignKeyBoardFirstResponder {
  [passwordTextField resignFirstResponder];
  [oncePassWordTextField resignFirstResponder];
  //  [inviteCodeTextField resignFirstResponder];
}
/**输入约束条件*/
- (BOOL)restrictiveConditionOfFinishBtn {
  //键盘收回
  [self resignKeyBoardFirstResponder];
  //输入框限定条件
  if ([passwordTextField.text length] == 0) {
    [NewShowLabel setMessageContent:@"请输入密码"];
    return NO;
  } else if (![self isNumbersOrLetters:passwordTextField.text]) {
    [NewShowLabel
        setMessageContent:@"密码由6-" @"16位字母或数字组成，请重新输入"];
    return NO;
  } else if ([passwordTextField.text length] < 6) {
    [NewShowLabel setMessageContent:@"密码至少是6位的数字或字母"];
    return NO;
  } else if ([oncePassWordTextField.text length] == 0) {
    [NewShowLabel setMessageContent:@"请输入确认密码"];
    return NO;
  } else if (![passwordTextField.text
                 isEqualToString:oncePassWordTextField.text]) {
    [NewShowLabel setMessageContent:@"两次输入密码不一致"];
    return NO;
    //  } else if (![[ConditionsWithKeyBoardUsing shareInstance]
    //                 isNumbersOrLetters:inviteCodeTextField.text]) {
    //    [NewShowLabel setMessageContent:@"邀请码只能为字母或数字"];
    //    return NO;
  } else
    return YES;
}

///注册登录
- (void)finish:(UIButton *)button {
  if (![self restrictiveConditionOfFinishBtn]) {
    return;
  }
  //获取分辨率
  //屏幕尺寸
  CGRect rect = [[UIScreen mainScreen] bounds];
  CGSize size = rect.size;
  CGFloat width = size.width;
  CGFloat height = size.height;
  //分辨率
  CGFloat scale_screen = [UIScreen mainScreen].scale;
  NSString *scaleScreenStr =
      [NSString stringWithFormat:@"%1.0f*%1.0f", width * scale_screen,
                                 height * scale_screen];
  NSString *url = [user_address
      stringByAppendingString:@"jhss/member/doregister/{ak}/{uuid}/{model}/"
      @"{scaleScreen}/{systemName}/{networkType}/"
      @"{checkCarrier}/{password}/{phoneNumber}/" @"{verifyCode}"];
  //有无邀请码
  //  if ([inviteCodeTextField.text length] > 1) {
  //    url = [url
  //        stringByAppendingFormat:@"?inviteCode=%@",
  //        inviteCodeTextField.text];
  //  }
  NSDictionary *dict = @{
    @"ak" : [SimuUtil getAK],
    @"uuid" : [SimuUtil getUUID],
    @"model" :
        [CommonFunc base64StringFromText:[[UIDevice currentDevice] model]],
    @"scaleScreen" : scaleScreenStr,
    @"systemName" :
        [CommonFunc base64StringFromText:[[UIDevice currentDevice] systemName]],
    @"networkType" : [SimuUtil getNetWorkType],
    @"checkCarrier" : [CommonFunc base64StringFromText:[SimuUtil checkCarrier]],
    @"password" : [CommonFunc
        base64StringFromText:[passwordTextField.text
                                 stringByAddingPercentEscapesUsingEncoding:
                                     NSUTF8StringEncoding]],
    @"phoneNumber" : _phoneNumber,
    @"verifyCode" : _verifyCode
  };
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  if (![NetLoadingWaitView isAnimating]) {
    [NetLoadingWaitView startAnimating];
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak PasswordSettingsViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    PasswordSettingsViewController *strongSelf = weakSelf;
    if (strongSelf) {
      if ([NetLoadingWaitView isAnimating]) {
        [NetLoadingWaitView stopAnimating];
      }
      return NO;
    } else {
      return YES;
    }
  };
  callback.onSuccess = ^(NSObject *obj) {
    PasswordSettingsViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf registerSuccess];
    }
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dict
              withRequestObjectClass:[UserInformationItem class]
             withHttpRequestCallBack:callback];
}

- (void)changePage {
  //登录主界面

  [SimuUtil setUserPassword:oncePassWordTextField.text];
  //先返回给主界面显示内容
  //登录成功提示
  [[NSNotificationCenter defaultCenter] postNotificationName:LogonSuccess
                                                      object:nil];
  //更新主界面内容
  [self sendMessageUpdataUserInfo];
  [SimuUser setSessionSavedTime:[NSDate timeIntervalSinceReferenceDate]];
  [[NSNotificationCenter defaultCenter]
      postNotificationName:UpDataFromNet_WithMainController
                    object:@"upformNet_For_Userinfo"];
}
#pragma mark
#pragma mark-------记录登录时间---------
/**注册成功*/
- (void)registerSuccess {
  //手机号注册成功，再走登录步骤
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak PasswordSettingsViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    PasswordSettingsViewController *strongSelf = weakSelf;
    if (strongSelf) {
      if ([NetLoadingWaitView isAnimating]) {
        [NetLoadingWaitView stopAnimating];
      }
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    PasswordSettingsViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindUserInformationItem:(UserInformationItem *)obj];
    }
  };

  [UserInformationItem requestLoginWithUserName:_phoneNumber
                                   withPassword:oncePassWordTextField.text
                                   withCallback:callback];
  if ([NetLoadingWaitView isAnimating]) {
    [NetLoadingWaitView stopAnimating];
  }
}

- (void)bindUserInformationItem:(UserInformationItem *)userInfo {
  //登录成功后返回位置
  NSInteger isOtherLogin =
      [[NSUserDefaults standardUserDefaults] integerForKey:@"isOtherLogin"];
  switch (isOtherLogin) {
  case 1: {
    [AppDelegate popToRootViewController:YES];
  } break;
  case 2: {
    [AppDelegate popViewController:NO];
  } break;
  default:
    break;
  }
  if (userInfo) {
    [self saveUsernameHistoryInfo:userInfo];
  }
  [self logonSuccess];
  [self changePage];
}
- (void)logonSuccess {
  //登录日志
  [[event_view_log sharedManager] addLoginEventToLog];

  //键盘收回
  [self resignKeyBoardFirstResponder];
}
#pragma mark
#pragma mark------辅助函数------
- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string {
  if ([string isEqualToString:@"\n"]) {
    return YES;
  }
  NSString *toBeString =
      [textField.text stringByReplacingCharactersInRange:range
                                              withString:string];
  //  if (textField == inviteCodeTextField) {
  //    if ([toBeString length] > 15) {
  //      textField.text = [toBeString substringToIndex:16];
  //      return NO;
  //    }
  //  } else {
  if ([toBeString length] > 15) {
    [self showSimuMessageContent:@"您的密码长度不能超过16位"];
    textField.text = [toBeString substringToIndex:16];
    return NO;
  }
  //  }
  return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self resignKeyBoardFirstResponder];
}
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
//保存历史登录信息
- (void)saveUsernameHistoryInfo:(UserInformationItem *)item {
  [SimuUser saveUsernameHistoryInfo:item.mUserName];
  //记录登录用户名
  UITextField *userPasswordTextField =
      (UITextField *)[self.view viewWithTag:202];
  //保存到本地数据库
  [SimuUtil setUserName:self.phoneNumber];
  [SimuUtil setUserPassword:userPasswordTextField.text];
}
- (void)resignKeyboardFirstResponder {
  [passwordTextField resignFirstResponder];
  [oncePassWordTextField resignFirstResponder];
  //  [inviteCodeTextField resignFirstResponder];
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
#pragma mark----------view动画--------
- (void)leftButtonPress {
  [self resignKeyBoardFirstResponder];
  [super leftButtonPress];
}

@end
