//
//  phoneRegisterViewController.m
//  SimuStock
//
//  Created by jhss on 13-9-26.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "phoneRegisterViewController.h"
#import "PasswordSettingsViewController.h"

@implementation phoneRegisterViewController
- (void)viewDidLoad {
  [super viewDidLoad];
  [MobClick beginLogPageView:@"注册页"];
  [self createMainView];
}
#pragma mark
#pragma mark-----界面-----
- (void)createMainView {
  //回拉效果
  CGRect frame = self.view.frame;

  _indicatorView.hidden = YES;
  [_topToolBar resetContentAndFlage:@"手机快速注册" Mode:TTBM_Mode_Leveltwo];
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
  //输入手机号
  phoneNumber = [[UITextField alloc]
      initWithFrame:CGRectMake(
                        side_edge_width + 10,
                        firstCuttingLineLabel.frame.origin.y - 24,
                        frame.size.width - side_edge_width * 2 - 20 - 100, 20)];
  phoneNumber.placeholder = @"请输入手机号";
  phoneNumber.clearButtonMode = UITextFieldViewModeWhileEditing;
  phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
  phoneNumber.textColor = [Globle colorFromHexRGB:@"454545"];
  phoneNumber.font = [UIFont systemFontOfSize:14];
  phoneNumber.contentHorizontalAlignment =
      UIControlContentHorizontalAlignmentCenter;
  phoneNumber.contentVerticalAlignment =
      UIControlContentVerticalAlignmentCenter;
  phoneNumber.delegate = self;
  phoneNumber.backgroundColor = [UIColor clearColor];
  [self.clientView addSubview:phoneNumber];
  //竖线
  UILabel *verticalLineLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(self.view.bounds.size.width - 115,
                               firstCuttingLineLabel.frame.origin.y - 23, 0.5,
                               19)];
  verticalLineLabel.backgroundColor = [Globle colorFromHexRGB:@"086dea"];
  [self.clientView addSubview:verticalLineLabel];
  //验证码button
  getAuthCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
  getAuthCodeButton.userInteractionEnabled = NO;
  getAuthCodeButton.frame =
      CGRectMake(frame.size.width - 120,
                 firstCuttingLineLabel.frame.origin.y - 30, 100, 30);
  getAuthCodeButton.alpha = 0.8;
  getAuthCodeButton.titleLabel.font = [UIFont systemFontOfSize:15];
  [getAuthCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
  getAuthCodeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
  [getAuthCodeButton setTitleColor:[Globle colorFromHexRGB:@"086dae"]
                          forState:UIControlStateNormal];
  [getAuthCodeButton setTitleColor:[Globle colorFromHexRGB:@"4dfdff"]
                          forState:UIControlStateHighlighted];
  [getAuthCodeButton addTarget:self
                        action:@selector(getAuthCode:)
              forControlEvents:UIControlEventTouchUpInside];
  getAuthCodeButton.contentHorizontalAlignment =
      UIControlContentHorizontalAlignmentCenter;
  getAuthCodeButton.contentVerticalAlignment =
      UIControlContentVerticalAlignmentCenter;
  [self.clientView addSubview:getAuthCodeButton];
  //验证码textView
  authCodeTextFeild = [[UITextField alloc]
      initWithFrame:CGRectMake(side_edge_width + 10,
                               secondCuttingLineLabel.frame.origin.y - 24,
                               frame.size.width - side_edge_width * 2 - 10,
                               20)];
  authCodeTextFeild.placeholder = @"请输入验证码";
  authCodeTextFeild.textColor = [Globle colorFromHexRGB:@"454545"];
  authCodeTextFeild.delegate = self;
  authCodeTextFeild.clearButtonMode = UITextFieldViewModeWhileEditing;
  authCodeTextFeild.contentHorizontalAlignment =
      UIControlContentHorizontalAlignmentCenter;
  authCodeTextFeild.contentVerticalAlignment =
      UIControlContentVerticalAlignmentCenter;
  authCodeTextFeild.keyboardType = UIKeyboardTypeNumberPad;
  authCodeTextFeild.font = [UIFont systemFontOfSize:14];
  authCodeTextFeild.backgroundColor = [UIColor clearColor];
  [self.clientView addSubview:authCodeTextFeild];
  //下一步
  nextStepButton = [UIButton buttonWithType:UIButtonTypeCustom];
  nextStepButton.frame =
      CGRectMake(side_edge_width, secondCuttingLineLabel.frame.origin.y + 40,
                 frame.size.width - side_edge_width * 2, 34);
  nextStepButton.alpha = 0.8;
  nextStepButton.backgroundColor = [Globle colorFromHexRGB:@"086dae"];
  nextStepButton.userInteractionEnabled = NO;
  [nextStepButton setTitle:@"下一步" forState:UIControlStateNormal];
  [nextStepButton
      setBackgroundImage:[UIImage imageNamed:@"return_touch_down.png"]
                forState:UIControlStateHighlighted];
  __weak phoneRegisterViewController *blockSelf = self;
  [nextStepButton setOnButtonPressedHandler:^{
    [blockSelf nextStep];
  }];
  [self.clientView addSubview:nextStepButton];
  //标题
  UILabel *titleLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(side_edge_width,
                               nextStepButton.frame.origin.y + 43,
                               frame.size.width - side_edge_width * 2, 12)];
  titleLabel.font = [UIFont systemFontOfSize:Font_Height_12_0];
  titleLabel.textAlignment = NSTextAlignmentLeft;
  titleLabel.text = @"温馨提示：手机号仅用于登录或找回密码";
  titleLabel.backgroundColor = [UIColor clearColor];
  titleLabel.textColor = [Globle colorFromHexRGB:@"5a5a5a"];
  [self.clientView addSubview:titleLabel];
}
/**
 *键盘回收
 */
- (void)resignKeyBoardResponder {
  [phoneNumber resignFirstResponder];
  [authCodeTextFeild resignFirstResponder];
}
#pragma mark
#pragma mark----- 解析-----
- (void)getAuthCodeButtonAction {
  getAuthCodeButton.userInteractionEnabled = YES;
}
- (void)getAuthCode:(UIButton *)button {
  [self resignKeyBoardResponder];
   button.userInteractionEnabled = NO;
  [self performSelector:@selector(getAuthCodeButtonAction)
             withObject:nil
             afterDelay:0.3];
  //手机号正确与否判断
  if (![NSString validataPhoneNumber:phoneNumber.text]) {
    [self showMessage:@"请输入正确的手机号"];
    return;
  }
  //按钮状态
  [getAuthCodeButton setTitleColor:[Globle colorFromHexRGB:@"939393"]
                          forState:UIControlStateNormal];

  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel setMessageContent:REQUEST_FAILED_MESSAGE];
    return;
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  //解析
  __weak phoneRegisterViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    phoneRegisterViewController *strongSelf = weakSelf;
    if (strongSelf) {
      return NO;
    } else
      return YES;
  };
  callback.onSuccess = ^(NSObject *obj) {
    phoneRegisterViewController *strongSelf = weakSelf;
    if (strongSelf) {
    }
  };
  callback.onFailed = ^() {
    [self authReset];
    [NewShowLabel showNoNetworkTip];
  };
  callback.onError = ^(BaseRequestObject *error, NSException *ex) {
    [BaseRequester defaultErrorHandler](error, ex);
    if ([error.status isEqualToString:@"1001"]) {
      [self authReset];
    }
  };

  [PhoneRegister phoneRegisterMakeRegisterPinWithPhoneNumber:phoneNumber.text withType:phoneRegister
                                                withCallback:callback];
  //点击就重置了button
  [self authReset];
  
  //开始计时
  [self changeButton];
}

//验证码输入只能输入数字
- (BOOL)isValidateMobile:(NSString *)mobile {
  NSString *phoneRegex = @"^[0-9]{0,6}$";
  NSPredicate *phoneTest =
      [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
  return [phoneTest evaluateWithObject:mobile];
}

- (void)nextStep {
  [self resignKeyBoardResponder];
  //输入限定条件
  if ([phoneNumber.text length] == 0) {
    [self showMessage:@"请输入手机号"];
    return;
  } else if (![NSString validataPhoneNumber:phoneNumber.text]) {
    [self showMessage:@"请输入正确的手机号"];
    return;
  } else if ([authCodeTextFeild.text length] == 0) {
    [self showMessage:@"请输入验证码"];
    return;
  } else if ([authCodeTextFeild.text length] > 0 &&
             !([self isValidateMobile:authCodeTextFeild.text])) {
    [self showMessage:@"请输入正确验证码"];
    return;
  }
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  if (![NetLoadingWaitView isAnimating]) {
    [NetLoadingWaitView startAnimating];
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  //解析
  __weak phoneRegisterViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    phoneRegisterViewController *strongSelf = weakSelf;
    if (strongSelf) {
      if ([NetLoadingWaitView isAnimating]) {
        [NetLoadingWaitView stopAnimating];
      }
      [strongSelf authReset];
      [strongSelf stopTime];
      return NO;
    } else {
      return YES;
    }
  };
  callback.onSuccess = ^(NSObject *obj) {
    phoneRegisterViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf changePage];
    }
  };
  [PhoneRegister phoneRegisterAuthSmsCodeWithPhoneNumber:phoneNumber.text
                                            withAuthCode:authCodeTextFeild.text
                                            withCallback:callback];
}

//切换到密码填写界面
- (void)changePage {
  [self resignKeyBoardResponder];
  PasswordSettingsViewController *passworSettingsVC = [
      [PasswordSettingsViewController alloc] initWithCode:authCodeTextFeild.text
                                          withPhoneNumber:phoneNumber.text];
  [AppDelegate pushViewControllerFromRight:passworSettingsVC];
}
#pragma mark
#pragma mark------辅助函数------
//提示框
- (void)showMessage:(NSString *)content {
  [NewShowLabel setMessageContent:content];
}
//计时
- (void)changeButton {
  time = 60;
  [self startTime];
}
- (void)updateBtn {
  NSInteger startBGTimer =
      [[NSUserDefaults standardUserDefaults] integerForKey:@"startTimerData"];
  NSInteger endBgTimer =
      [[NSUserDefaults standardUserDefaults] integerForKey:@"endTimerData"];
  if (endBgTimer - startBGTimer > time && endBgTimer - startBGTimer > 0) {
    [self stopTime];
    [self authReset];
    [self setTimeZero];
    return;
  } else {
    time = time - endBgTimer + startBGTimer;
    [self setTimeZero];
  }
  if (![SimuUtil isExistNetwork]) {
    [self stopTime];
    [self authReset];
    return;
  }
  if (time == 60) {
    //按钮状态
    [getAuthCodeButton setTitleColor:[Globle colorFromHexRGB:@"939393"]
                            forState:UIControlStateNormal];
  }
  //更改按钮名称，提示下载状态
  [getAuthCodeButton
      setTitle:[NSString stringWithFormat:@"重新获取(%ld)", (long)time]
      forState:UIControlStateNormal];
  time--;
  if (time < 0) {
    [self stopTime];
    [self authReset];
    [getAuthCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    getAuthCodeButton.userInteractionEnabled = YES;
    [getAuthCodeButton setTitleColor:[Globle colorFromHexRGB:@"086dae"]
                            forState:UIControlStateNormal];
  } else {
    getAuthCodeButton.userInteractionEnabled = NO;
  }
}
//定时器关闭与开启
- (void)stopTime {
  if (timer != nil) {
    if ([timer isValid]) {
      [timer invalidate];
      timer = nil;
    }
  }
}
//时间差清零
- (void)setTimeZero {
  //记录进入前台时间
  [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"startTimerData"];
  [[NSUserDefaults standardUserDefaults] setInteger:0.0 forKey:@"endTimerData"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)startTime {
  //重置
  [self setTimeZero];
  if (timer && [timer isValid]) {
    return;
  }
  timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                           target:self
                                         selector:@selector(updateBtn)
                                         userInfo:nil
                                          repeats:YES];
}
- (void)authReset {
  [self resignKeyBoardResponder];
  if ([phoneNumber.text length] > 0) {
    getAuthCodeButton.userInteractionEnabled = YES;
  } else {
    getAuthCodeButton.userInteractionEnabled = NO;
  }
  [getAuthCodeButton setTitleColor:[Globle colorFromHexRGB:@"086dae"]
                          forState:UIControlStateNormal];
  [getAuthCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
  [self stopTime];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self resignKeyBoardResponder];
}
#pragma mark
#pragma mark-------textField协议函数----------
- (BOOL)textFieldShouldClear:(UITextField *)textField {
  if (textField == phoneNumber) {
    getAuthCodeButton.userInteractionEnabled = NO;
    getAuthCodeButton.alpha = 0.8;
  }
  nextStepButton.userInteractionEnabled = NO;
  nextStepButton.alpha = 0.8;
  return YES;
}
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
  if (textField == phoneNumber) {
    if ([toBeString length] > 10) {
      //更改显示效果，设置为输入就可以验证
      if ([toBeString length] > 10) {
        textField.text = [toBeString substringToIndex:11];
        getAuthCodeButton.userInteractionEnabled = YES;
        getAuthCodeButton.alpha = 1.0;
        if ([authCodeTextFeild.text length] > 5) {
          nextStepButton.userInteractionEnabled = YES;
          nextStepButton.alpha = 1.0;
        }
        return NO;
      } else {
        return YES;
      }
    } else {
      nextStepButton.userInteractionEnabled = NO;
      getAuthCodeButton.userInteractionEnabled = NO;
      getAuthCodeButton.alpha = 0.8;
      nextStepButton.alpha = 0.8;
    }
  }
  if (textField == authCodeTextFeild) {
    if ([toBeString length] > 5) {
      textField.text = [toBeString substringToIndex:6];
      if ([phoneNumber.text length] == 11) {
        nextStepButton.userInteractionEnabled = YES;
        nextStepButton.alpha = 1.0f;
      } else {
        nextStepButton.userInteractionEnabled = NO;
        nextStepButton.alpha = 0.8;
      }
      return NO;
    } else {
      nextStepButton.userInteractionEnabled = NO;
      nextStepButton.alpha = 0.8;
      return YES;
    }
  }
  return YES;
}
- (void)leftButtonPress {
  [self stopTime];
  //按钮重置
  [self authReset];
  [super leftButtonPress];
}
- (void)dealloc {
  [MobClick endLogPageView:@"注册页"];
}
@end
