//
//  BindingPhoneViewController.m
//  SimuStock
//
//  Created by Jhss on 15/6/29.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BindingPhoneViewController.h"
#import "SimuUtil.h"
#import "event_view_log.h"
#import "BaseRequester.h"
#import "MyInformationCenterData.h"
#import "NSString+validate.h"
#import "UIButton+Hightlighted.h"


@interface BindingPhoneViewController ()

@end

@implementation BindingPhoneViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  //加载视图控件
  [self addSubViews];

  /**创建获取用户验证码*/
  [self createVerCode];

  // Do any additional setup after loading the view from its nib.
}

- (void)addSubViews {
  //显示“绑定手机号”，并且隐藏刷新按钮
  [self.topToolBar resetContentAndFlage:self.titleStr Mode:TTBM_Mode_Leveltwo];
  self.indicatorView.hidden = YES;
  self.clientView.alpha = 0;
  
  self.phoneNumberField.delegate = self;
  self.authCodeTextField.delegate = self;
  
  //”获取验证码“文字的高亮颜色Jhss
  self.getAuthCodeButton.userInteractionEnabled = NO;
  [self.getAuthCodeButton setTitleColor:[Globle colorFromHexRGB:@"4dfdff"]
                               forState:UIControlStateHighlighted];
  //获取验证码的点击事件
  requesting = NO;
  __weak BindingPhoneViewController *weakSelf = self;
  [_getAuthCodeButton setOnButtonPressedHandler:^{
    [weakSelf sendSmsGetAuthCodePress];
  }];
  
  
  //设置确定按钮的高亮状态
  [self.confirmButton buttonWithNormal:Color_Blue_but
                  andHightlightedColor:Color_Blue_butDown];
  [self.confirmButton buttonWithTitle:@"确定"
                   andNormaltextcolor:Color_White
             andHightlightedTextColor:Color_White];
  [_confirmButton setOnButtonPressedHandler:^{
    [weakSelf clickConfirmPress];
  }];
  
  //设置温馨提示
  self.hintContentLabel.text = self.hintString;
  //纪录日志
  [[event_view_log sharedManager]
   addPVAndButtonEventToLog:Log_Type_PV
   andCode:@"个人中心-个人信息-手机"];
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
  if ([self.phoneNumberField.text length] == 0) {
    [NewShowLabel setMessageContent:@"请输入手机号"];
    return;
  } else if (![NSString validataPhoneNumber:self.phoneNumberField.text]) {
    [NewShowLabel setMessageContent:@"请输入正确的手机号"];
    return;
  }
  
  [self.getAuthCodeButton setTitleColor:[Globle colorFromHexRGB:@"086dae"]
                               forState:UIControlStateNormal];
  //获得验证码
  if (requesting) {
    return;
  }
  [self sendSmsAuthCodeWithSendCount:0];

}

- (void)sendSmsAuthCodeWithSendCount:(NSInteger)num {
  if (num >= 3) {
    return;
  }
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  requesting = YES;
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  //解析
  __weak BindingPhoneViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    BindingPhoneViewController *strongSelf = weakSelf;
    if (strongSelf) {
      requesting = NO;
      return NO;
    } else
      return YES;
  };
  callback.onSuccess = ^(NSObject *obj) {
    BindingPhoneViewController *strongSelf = weakSelf;
    if (strongSelf) {
    }
  };
  callback.onFailed = ^() {
    [self authReset];
    [self sendSmsAuthCodeWithSendCount:num+1];
  };
  callback.onError = ^(BaseRequestObject *error, NSException *ex) {
    [BaseRequester defaultErrorHandler](error, ex);
    if ([error.status isEqualToString:@"1001"]) {
      [self authReset];
    }
  };
  [PhoneNumberRegister
      phoneNumberRegisterWithPhoneNumber:self.phoneNumberField.text
                                withType:@"3"
                            withCallback:callback];
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
  return YES;
}

- (void)cofirmButtonOperation {
  //使用绑定接口，绑定手机
  [_delegagte returnVerifyPhoneNumber:self.phoneNumberField.text withTitle:@"更换"];
  self.phoneNumberField.text = @"";
  self.authCodeTextField.text = @"";
  [super leftButtonPress];
}

/** 点击确认按钮触发的方法 */
- (void)clickConfirmPress{
  //输入限定条件
  if ([self.phoneNumberField.text length] == 0) {
    [NewShowLabel setMessageContent:@"请输入手机号"];
    return;
  } else if (![NSString validataPhoneNumber:self.phoneNumberField.text]) {
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
  
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  //解析
  __weak BindingPhoneViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    BindingPhoneViewController *strongSelf = weakSelf;
    if (strongSelf) {
      return NO;
    } else
      return YES;
  };
  callback.onSuccess = ^(NSObject *obj) {
    BindingPhoneViewController *strongSelf = weakSelf;
    if (strongSelf) {
      //键盘回收
      [strongSelf authReset];
      [strongSelf cofirmButtonOperation];
    }
  };
  callback.onFailed = ^() {
    [self authReset];
    [NewShowLabel showNoNetworkTip];
  };
  callback.onError = ^(BaseRequestObject *error, NSException *ex) {
    [BaseRequester defaultErrorHandler](error, ex);
  };
  [PhoneNumberRegister
   phoneNumberRegisterWithAuthCodeVerifyWithPhoneNumber:
   self.phoneNumberField.text withAuthCode:self.authCodeTextField.text
   withType:@"3"
   withCallback:callback];
}

//左边按钮按下
- (void)leftButtonPress {
  //重置
  [self authReset];
  [super leftButtonPress];
}

//回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self.view endEditing:YES];
}
@end
