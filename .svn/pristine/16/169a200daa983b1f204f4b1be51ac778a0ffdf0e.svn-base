//
//  PhoneRegisterViewController.m
//  SimuStock
//
//  Created by Jhss on 15/6/16.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "PhoneRegisterViewController.h"
#import "SimuUtil.h"
#import "NSString+validate.h"
#import "NewShowLabel.h"
#import "PhoneRegister.h"
#import "NetLoadingWaitView.h"
#import "UserInformationItem.h"
#import "SimuAction.h"
#import "event_view_log.h"
#import "GetUserBandPhoneNumber.h"
#import "SendVerifyCodeData.h"
#import "SettingsBaseViewController.h"


@implementation PhoneRegisterViewController


-(void)awakeFromNib{
  [super awakeFromNib];
  self.view.frame = CGRectMake(0, 0, WIDTH_OF_SCREEN, HEIGHT_OF_SCREEN);
}
- (id)initWithFrame:(CGRect)frame
                    withTitleLabel:(NSString *)titleStr
                      withHintLabel:(NSString *)hintStr {
  if (self = [super initWithFrame:frame]) {
    _titleStr = titleStr;
    _hintString = hintStr;
  }
  return self;
}



- (void)viewDidLoad {
  [super viewDidLoad];
  //加载视图控件
  [self settingUpViewControls];

  /**创建获取用户验证码*/
  [self createVerCode];

  self.isBindPhoneGetVerifyCode = YES;

  //判断手机号输入框是否显示手机号
  [self getBindingPhoneNumber];

  // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

/** 设置视图控件的基本属性 */
- (void)settingUpViewControls {

  //显示“绑定手机号”，并且隐藏刷新按钮
  [self.topToolBar resetContentAndFlage:self.titleStr Mode:TTBM_Mode_Leveltwo];
  self.indicatorView.hidden = YES;
  //去掉最上层的clientView,
  self.clientView.alpha = 0;

  //”获取验证码“文字的高亮颜色Jhss
  self.getAuthCodeButton.userInteractionEnabled = NO;
  [self.getAuthCodeButton setTitleColor:[Globle colorFromHexRGB:@"4dfdff"]
                               forState:UIControlStateHighlighted];
  
  requesting = NO;
  
  __weak PhoneRegisterViewController *weakSelf = self;
  [_getAuthCodeButton setOnButtonPressedHandler:^{
    [weakSelf sendSmsGetAuthCodePress];
  }];
  
  [_confirmButton setOnButtonPressedHandler:^{
    [weakSelf clickConfirmPress];
  }];


  //设置确定按钮的高亮状态
  [self.confirmButton buttonWithNormal:Color_Blue_but
                  andHightlightedColor:Color_Blue_butDown];
  [self.confirmButton buttonWithTitle:@"确认"
                   andNormaltextcolor:Color_White
             andHightlightedTextColor:Color_White];
  //设置温馨提示
  self.hintContentLabel.text = self.hintString;

  [self.passwordField setSecureTextEntry:YES];
  [self.secondInputPasswordField setSecureTextEntry:YES];
}

/**创建获取用户验证码*/
- (void)createVerCode {
  getVerCode = [[GetVerificationCode alloc] init];
}
- (void)getAuthCodeButtonAction {
  self.getAuthCodeButton.userInteractionEnabled = YES;
}
/** 获取验证码的触发事件 */
- (void)sendSmsGetAuthCodePress{
  NSString *phone = self.phoneNumberField.text;
  if (self.phoneNumberField.userInteractionEnabled == NO) {
    phone = self.phoneNumber;
  }
  if ([phone length] == 0) {
    [NewShowLabel setMessageContent:@"请输入手机号"];
    return;
  } else if (![NSString validataPhoneNumber:phone]) {
    [NewShowLabel setMessageContent:@"请输入正确的手机号"];
    return;
  }
  [self.getAuthCodeButton setTitleColor:[Globle colorFromHexRGB:@"086dae"]
                               forState:UIControlStateNormal];
  
  if (requesting) {
    return;
  }
  
  //获得验证码
  
  [self sendSmsAuthCodeWith:phone num:0];
  
  
}

- (void)sendSmsAuthCodeWith:(NSString *)phone num:(NSInteger)num {
  if (num>=3) {
    return;
  }
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  requesting = YES;
  
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  //解析
  __weak PhoneRegisterViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    PhoneRegisterViewController *strongSelf = weakSelf;
    if (strongSelf) {
      requesting = NO;
      return NO;
    } else
      return YES;
  };
  callback.onSuccess = ^(NSObject *obj) {
    PhoneRegisterViewController *strongSelf = weakSelf;
    if (strongSelf) {
    }
  };
  callback.onError = ^(BaseRequestObject *error, NSException *ex) {
    if ([error.status isEqualToString:@"1001"]) {
      [self authReset];
    }
    [BaseRequester defaultErrorHandler](error, ex);
  };
  callback.onFailed = ^() {
    [self sendSmsAuthCodeWith:phone num:num+1];
  };
  /**
   * 由于该页面在三个地方被调用，所以在获取验证码的时候，调用的接口有所不同，分为两种第一种为首次注册，第二种为绑定手机号或者是修改手机号
   */
  if ([self.titleStr isEqualToString:@"手机快速注册"]) {
    [PhoneRegister phoneRegisterMakeRegisterPinWithPhoneNumber:phone
                                                      withType:phoneRegister
                                                  withCallback:callback];
  } else {
    if (self.isUserLoginLossPwdInto == YES) {
      //登陆页面进入修改密码
      [SendVerifyCodeData
          requestPhoneVerifyCodeWithPhoneNumber:phone
                                           type:CodeTypeUserLoginLossPassword
                                       callback:callback];
    } else {
      if (self.isBindPhoneGetVerifyCode == YES) {
        //绑定手机号
        [SendVerifyCodeData
            requestPhoneVerifyCodeWithPhoneNumber:phone
                                             type:CodeTypeBindingPhoneNumber
                                         callback:callback];
      } else {
        //修改密码
        [SendVerifyCodeData
            requestPhoneVerifyCodeWithPhoneNumber:phone
                                             type:CodeTypeChanagePassWord
                                         callback:callback];
      }
    }
  }
  //点击就重置了button
  [self authReset];
  [getVerCode changeButton];
  getVerCode.getAuthBtn = self.getAuthCodeButton;
  getVerCode.TPphoneNumber = self.phoneNumberField.text;
}
#pragma mark 重置按钮
- (void)authReset {
  if ([self.phoneNumberField.text length] > 0) {
    self.getAuthCodeButton.userInteractionEnabled = YES;
  } else {
    self.getAuthCodeButton.userInteractionEnabled = NO;
  }
  [self.getAuthCodeButton setTitleColor:[Globle colorFromHexRGB:@"086dae"]
                               forState:UIControlStateNormal];
  [self.getAuthCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
  [getVerCode stopTime];
}
/** 当输入手机框清空的时候获取验证码不可点击 */
- (BOOL)textFieldShouldClear:(UITextField *)textField {
  if (textField == self.phoneNumberField) {
    self.getAuthCodeButton.userInteractionEnabled = NO;
    self.getAuthCodeButton.alpha = 0.8;
  }
  return YES;
}
#pragma textField协议函数
//比较完整的校验
- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string {
  if ([string isEqualToString:@"\n"]) {
    return YES;
  }
  //此处容易出问题
  NSString *toBeString =
      [textField.text stringByReplacingCharactersInRange:range
                                              withString:string];
  ///手机号输入框
  if (textField == self.phoneNumberField) {
    if (![NSString validataNumberInput:toBeString]) {
      return NO;
    }
    if ([toBeString length] > 10) {
      //更改显示效果，设置为输入就可以验证
      if ([toBeString length] > 10) {
        textField.text = [toBeString substringToIndex:11];
        self.getAuthCodeButton.userInteractionEnabled = YES;
        self.getAuthCodeButton.alpha = 1.0;
        return NO;
      } else {
        return YES;
      }
    } else {
      self.getAuthCodeButton.userInteractionEnabled = NO;
      self.getAuthCodeButton.alpha = 0.8f;
    }
  }
  ///验证码输入框
  if (textField == self.authCodeTextField) {
    if (![NSString validataNumberInput:toBeString]) {
      return NO;
    }
    if ([toBeString length] > 6) {
      textField.text = [toBeString substringToIndex:6];
      return NO;
    }
  }
  ///密码输入框
  if (textField == self.passwordField) {
    /// 输入限制
    if (![NSString validataPasswordOnInput:toBeString]) {
      return NO;
    }
  }
  ///再次确认密码输入框
  if (textField == self.secondInputPasswordField) {
    /// 输入限制
    if (![NSString validataPasswordOnInput:toBeString]) {
      return NO;
    }
  }
  return YES;
}

/// 点击确认按钮触发的方法
- (void)clickConfirmPress{
  NSString *phone = self.phoneNumberField.text;
  if (self.phoneNumberField.userInteractionEnabled == NO) {
    phone = self.phoneNumber;
  }
  //输入限定条件
  if ([phone length] == 0) {
    [NewShowLabel setMessageContent:@"请输入手机号"];
    return;
  } else if (![NSString validataPhoneNumber:phone]) {
    [NewShowLabel setMessageContent:@"请输入正确的手机号"];
    return;
  }
  
  if ([self.authCodeTextField.text length] == 0) {
    [NewShowLabel setMessageContent:@"请输入验证码"];
    return;
  } else if ([self.authCodeTextField.text length] != 6) {
    [NewShowLabel setMessageContent:@"验证码输入错误"];
    return;
  }
  
  if ([self.passwordField.text length] == 0) {
    [NewShowLabel setMessageContent:@"请输入密码"];
    return;
  } else if ([self.passwordField.text length] < 6) {
    [NewShowLabel setMessageContent:@"请设置6~16位密码"];
    return;
  }
  
  if ([self.secondInputPasswordField.text length] == 0) {
    [NewShowLabel setMessageContent:@"请输入确认密码"];
    return;
  } else if (![self.passwordField.text
               isEqualToString:self.secondInputPasswordField.text]) {
    [NewShowLabel setMessageContent:@"两次输入密码不一致"];
    return;
  }
  
  //请求接口判定
  if ([self.titleStr isEqualToString:@"手机快速注册"]) {
    [self finishRegister];
  } else if ([self.titleStr isEqualToString:@"绑定手机"]) {
    [self sendDataToTheBackground];
  } else {
    [self modifyPasswordByPhoneSendDataToTheBackgroundWithPhone:phone];
  }
}

#pragma mark-------------------忘记密码，重设密码-----------------------
/** 如果是重设密码页面，并且有手机绑定 */
- (void)getBindingPhoneNumber {
  if ([self.titleStr isEqualToString:@"重设密码"]) {
    if (![SimuUtil isExistNetwork]) {
      [NewShowLabel showNoNetworkTip];
      return;
    }
    HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
    //解析
    __weak PhoneRegisterViewController *weakSelf = self;
    callback.onSuccess = ^(NSObject *obj) {
      PhoneRegisterViewController *strongSelf = weakSelf;
      if (strongSelf) {
        GetUserBandPhoneNumber *userBindPhone = (GetUserBandPhoneNumber *)obj;
        if (userBindPhone.phoneNumber && userBindPhone.phoneNumber.length > 0) {
          NSString *phoneNumber = userBindPhone.phoneNumber;
          strongSelf.phoneNumber = phoneNumber;
          self.phoneNumberField.text =
              [phoneNumber stringByReplacingCharactersInRange:NSMakeRange(3, 4)
                                                   withString:@"****"];
          self.phoneNumberField.userInteractionEnabled = NO;
          self.getAuthCodeButton.userInteractionEnabled = YES;
          [self.view reloadInputViews];
          strongSelf.isBindPhoneGetVerifyCode = NO;
        } else {
          ///如果用户还没绑定手机号，
          self.phoneNumberField.userInteractionEnabled = YES;
          strongSelf.isBindPhoneGetVerifyCode = YES;
        }
      }
    };
    [GetUserBandPhoneNumber checkUserBindPhonerWithCallback:callback];
  }
}

- (void)modifyPasswordByPhoneSendDataToTheBackgroundWithPhone:
        (NSString *)phone {

  if (!self.confirmButton.enabled) {
    return;
  }
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  //解析
  __weak PhoneRegisterViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    PhoneRegisterViewController *strongSelf = weakSelf;
    if (strongSelf) {
       self.confirmButton.enabled = YES;
      [strongSelf authReset];
      return NO;
    } else {
      return YES;
    }
  };
  callback.onSuccess = ^(NSObject *obj) {
    PhoneRegisterViewController *strongSelf = weakSelf;
    if (strongSelf) {
      //返回绑定状态
      [strongSelf onSuccessBack];
    }
  };
  callback.onError = ^(BaseRequestObject *obj, NSException *exc) {
    [BaseRequester defaultErrorHandler](obj, exc);
  };
  callback.onFailed = ^() {
    [BaseRequester defaultFailedHandler]();
  };

  if (self.isUserLoginLossPwdInto == YES) {
    [PhoneRegister
        userLoginIntoModifyPasswordWithPhoneNUmber:phone
                                    withVerifyCode:self.authCodeTextField.text
                                       WithUserPwd:self.passwordField.text
                                 WithVerifyUserPwd:self.secondInputPasswordField
                                                       .text
                                          withFlag:@"-1"
                                      WithCallback:callback];
  } else {
    if (self.isBindPhoneGetVerifyCode == YES) {
      //重设密码   绑定手机号
      [PhoneRegister
          mobilePhoneBindPhoneWithPhoneNumber:phone
                               withVerifyCode:self.authCodeTextField.text
                                  WithUserPwd:self.passwordField.text
                            WithVerifyUserPwd:self.secondInputPasswordField.text
                                     withFlag:@"-1"
                                 WithCallback:callback];
    } else {
      //重设密码   修改密码
      [PhoneRegister
          mobilePhoneModifyPasswordWithPhoneNUmber:phone
                                    withVerifyCode:self.authCodeTextField.text
                                       WithUserPwd:self.passwordField.text
                                 WithVerifyUserPwd:self.secondInputPasswordField
                                                       .text
                                          withFlag:@"-1"
                                      WithCallback:callback];
    }
  }
}

/** 修改成功后返回 */
- (void)onSuccessBack {
  [NewShowLabel setMessageContent:@"重设密码成功"];
  if (self.isUserLoginLossPwdInto == YES) {
    [self resetPasswordSuccess];
  } else {
    for (UIViewController *controller in self.navigationController
             .viewControllers) {
      if ([controller isKindOfClass:[SettingsBaseViewController class]]) {
        [self.navigationController popToViewController:controller animated:YES];
      }
    }
  }
}
- (void)resetPasswordSuccess {
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak PhoneRegisterViewController *weakSelf = self;

  callback.onSuccess = ^(NSObject *obj) {
    PhoneRegisterViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf lossPwdLoginLogonSuccess];
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

  [UserInformationItem requestLoginWithUserName:self.phoneNumberField.text
                                   withPassword:self.passwordField.text
                                   withCallback:callback];
}
- (void)lossPwdLoginLogonSuccess {
  //返回登录数据
  //登录日志
  [[event_view_log sharedManager] addLoginEventToLog];
  [SimuUser saveUsernameHistoryInfo:self.phoneNumberField.text];
  //切换界面
  [self lossPwdLoginChangePage];

  if ([NetLoadingWaitView isAnimating]) {
    [NetLoadingWaitView stopAnimating];
  }
}
- (void)lossPwdLoginChangePage {
  //个人中心的手机更换、绑定区分接口
  NSString *PhoneNumber = self.phoneNumberField.text;
  if (PhoneNumber) {
    [SimuUtil setUserName:PhoneNumber];
  } else {
    [SimuUtil setUserName:PhoneNumber];
  }
  [SimuUtil setUserName:PhoneNumber];
  [SimuUtil setUserPassword:self.passwordField.text];
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

#pragma mark-------------------三方登陆，绑定手机号----------------
/** 点击确认进行网络请求，向后台发送数据 */
- (void)sendDataToTheBackground {

  if (!self.confirmButton.enabled) {
    return;
  }

  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  //解析
  __weak PhoneRegisterViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    PhoneRegisterViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf authReset];
      return NO;
    } else {
      return YES;
    }
  };
  callback.onSuccess = ^(NSObject *obj) {
    PhoneRegisterViewController *strongSelf = weakSelf;
    if (strongSelf) {
      //返回绑定状态
      [strongSelf cofirmButtonOperation];
    }
  };
  callback.onError = ^(BaseRequestObject *obj, NSException *exc) {
    [BaseRequester defaultErrorHandler](obj, exc);
    self.confirmButton.enabled = YES;
  };
  callback.onFailed = ^() {
    [BaseRequester defaultFailedHandler]();
    self.confirmButton.enabled = YES;
  };
  [PhoneRegister
      mobilePhoneBindPhoneWithPhoneNumber:self.phoneNumberField.text
                           withVerifyCode:self.authCodeTextField.text
                              WithUserPwd:self.passwordField.text
                        WithVerifyUserPwd:self.secondInputPasswordField.text
                                 withFlag:@"-1"
                             WithCallback:callback];
}
- (void)cofirmButtonOperation {
  //使用绑定接口，绑定手机
  if (self.isSettingInfoPageInto) {
    //数据回传
    [_delegagte returnThirdBindPhoneNumber:self.phoneNumberField.text
                                 withTitle:@"解绑"];
    self.phoneNumberField.text = @"";
    self.authCodeTextField.text = @"";
    [super leftButtonPress];
  }else{
    [self.navigationController popViewControllerAnimated:YES];
  }
}

//回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self.view endEditing:YES];
}

#pragma mark-------------------首次登陆，注册账户-------------------

///注册登录
- (void)finishRegister {
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
        base64StringFromText:[self.passwordField.text
                                 stringByAddingPercentEscapesUsingEncoding:
                                     NSUTF8StringEncoding]],
    @"phoneNumber" : [CommonFunc
        base64StringFromText:[self.phoneNumberField.text
                                 stringByAddingPercentEscapesUsingEncoding:
                                     NSUTF8StringEncoding]],
    @"verifyCode" : [CommonFunc
        base64StringFromText:
            [self.authCodeTextField.text
                stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
  };
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    [NetLoadingWaitView stopAnimating];
    return;
  }
  //开始大菊花转动
  [NetLoadingWaitView startAnimating];

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak PhoneRegisterViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    PhoneRegisterViewController *strongSelf = weakSelf;
    if (strongSelf) {
      //停止大菊花转动
      [NetLoadingWaitView stopAnimating];
      return NO;
    } else {
      return YES;
    }
  };
  callback.onSuccess = ^(NSObject *obj) {
    PhoneRegisterViewController *strongSelf = weakSelf;
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
#pragma mark-------记录登录时间---------
/**注册成功*/
- (void)registerSuccess {
  //手机号注册成功，再走登录步骤
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak PhoneRegisterViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    PhoneRegisterViewController *strongSelf = weakSelf;
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
    PhoneRegisterViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindUserInformationItem:(UserInformationItem *)obj];
    }
  };

  [UserInformationItem
      requestLoginWithUserName:self.phoneNumberField.text
                  withPassword:self.secondInputPasswordField.text
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
}
//保存历史登录信息
- (void)saveUsernameHistoryInfo:(UserInformationItem *)item {
  [SimuUser saveUsernameHistoryInfo:item.mUserName];
  //记录登录用户名
  UITextField *userPasswordTextField =
      (UITextField *)[self.view viewWithTag:202];
  //保存到本地数据库
  [SimuUtil setUserName:self.phoneNumberField.text];
  [SimuUtil setUserPassword:userPasswordTextField.text];
}
- (void)changePage {
  //登录主界面

  [SimuUtil setUserPassword:self.secondInputPasswordField.text];
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

@end
