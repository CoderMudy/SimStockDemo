//
//  PasswordViewController.m
//  SimuStock
//
//  Created by jhss on 13-9-26.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "PasswordViewController.h"
#import "ReinstallViewController.h"
#import "SimuUtil.h"
#import "NetLoadingWaitView.h"
#import "NewShowLabel.h"
#import "LossPassword.h"
#import "NSString+validate.h"

@implementation PasswordViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self createMainView];
  [self createVerCode];
}
#pragma mark
#pragma mark-------界面------

- (void)createMainView {
  CGRect frame = self.view.frame;

  _indicatorView.hidden = YES;
  [_topToolBar resetContentAndFlage:@"忘记密码" Mode:TTBM_Mode_Leveltwo];
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
  // self.view设计
  //输入框
  phoneNumber = [[UITextField alloc]
      initWithFrame:CGRectMake(side_edge_width + 10,
                               firstCuttingLineLabel.frame.origin.y - 24,
                               frame.size.width - side_edge_width * 2 - 120,
                               20)];
  phoneNumber.placeholder = @"请输入手机号";
  phoneNumber.clearButtonMode = UITextFieldViewModeWhileEditing;
  phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
  phoneNumber.textColor = [Globle colorFromHexRGB:@"454545"];
  phoneNumber.font = [UIFont systemFontOfSize:14];
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
  getAuthCodeButton.frame =
      CGRectMake(frame.size.width - 120,
                 firstCuttingLineLabel.frame.origin.y - 30, 100, 30);
  getAuthCodeButton.userInteractionEnabled = NO;
  getAuthCodeButton.alpha = 0.8;
  getAuthCodeButton.titleLabel.font = [UIFont systemFontOfSize:15];
  [getAuthCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
  [getAuthCodeButton setTitleColor:[Globle colorFromHexRGB:@"086dae"]
                          forState:UIControlStateNormal];
  [getAuthCodeButton setTitleColor:[Globle colorFromHexRGB:@"4dfdff"]
                          forState:UIControlStateHighlighted];
  __weak PasswordViewController *weakSelf = self;
  [getAuthCodeButton setOnButtonPressedHandler:^{
    [weakSelf codeVerification];
  }];
  
  
  [self.clientView addSubview:getAuthCodeButton];
  //验证码textView
  authCodeTextField = [[UITextField alloc]
      initWithFrame:CGRectMake(side_edge_width + 10,
                               secondCuttingLineLabel.frame.origin.y - 24,
                               frame.size.width - side_edge_width * 2 - 10,
                               20)];
  authCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
  authCodeTextField.placeholder = @"请输入验证码";
  authCodeTextField.textColor = [Globle colorFromHexRGB:@"454545"];
  authCodeTextField.delegate = self;
  authCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
  authCodeTextField.font = [UIFont systemFontOfSize:14];
  authCodeTextField.backgroundColor = [UIColor clearColor];
  [self.clientView addSubview:authCodeTextField];
  //下一步
  nextStepButton = [UIButton buttonWithType:UIButtonTypeCustom];
  nextStepButton.frame =
      CGRectMake(side_edge_width, secondCuttingLineLabel.frame.origin.y + 40,
                 frame.size.width - side_edge_width * 2, 34);
  nextStepButton.userInteractionEnabled = NO;
  nextStepButton.alpha = 0.8;
  [nextStepButton setBackgroundColor:[Globle colorFromHexRGB:@"086dae"]];
  [nextStepButton setTitle:@"下一步" forState:UIControlStateNormal];
  nextStepButton.tag = 103;
  [nextStepButton
      setBackgroundImage:[UIImage imageNamed:@"return_touch_down.png"]
                forState:UIControlStateHighlighted];
  __weak PasswordViewController *blockSelf = self;
  [nextStepButton setOnButtonPressedHandler:^{
    [blockSelf nextStep];
  }];
  [self.clientView addSubview:nextStepButton];
  //标题
  UILabel *titleLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(side_edge_width,
                               nextStepButton.frame.origin.y + 34,
                               frame.size.width - side_edge_width * 2, 40)];
  titleLabel.font = [UIFont systemFontOfSize:Font_Height_12_0];
  titleLabel.textAlignment = NSTextAlignmentLeft;
  titleLabel.numberOfLines = 0;
  titleLabel.text = @"温" @"馨" @"提"
      @"示：只有手机注册或已绑定手机的用户可通过手机号"
      @"找回密" @"码，其他情况请联系客服。";
  titleLabel.backgroundColor = [UIColor clearColor];
  titleLabel.textColor = [Globle colorFromHexRGB:@"454545"];
  titleLabel.userInteractionEnabled = YES;
  [self.clientView addSubview:titleLabel];

  UILabel *phoneNameLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(side_edge_width, titleLabel.frame.origin.y + 40,
                               60, 12)];
  phoneNameLabel.textColor = [Globle colorFromHexRGB:@"454545"];
  phoneNameLabel.textAlignment = NSTextAlignmentLeft;
  phoneNameLabel.font = [UIFont systemFontOfSize:Font_Height_12_0];
  phoneNameLabel.backgroundColor = [UIColor clearColor];
  phoneNameLabel.text = @"客服电话：";
  [self.clientView addSubview:phoneNameLabel];
  //号码与下划线同时减2 -12
  UILabel *phoneNumberLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(phoneNameLabel.frame.size.width +
                                   side_edge_width,
                               titleLabel.frame.origin.y + 40, 40 - 2, 12)];
  phoneNumberLabel.textColor = [Globle colorFromHexRGB:@"ca332a"];
  phoneNumberLabel.text = @"010-53599702";
  phoneNumberLabel.backgroundColor = [UIColor clearColor];
  phoneNumberLabel.textAlignment = NSTextAlignmentLeft;
  phoneNumberLabel.font = [UIFont systemFontOfSize:Font_Height_10_0];
  CGSize phoneSize = [phoneNumberLabel.text
           sizeWithFont:[UIFont systemFontOfSize:Font_Height_10_0]
      constrainedToSize:CGSizeMake(frame.size.width - 15 - 140, 12)
          lineBreakMode:NSLineBreakByCharWrapping];
  phoneNumberLabel.frame =
      CGRectMake(phoneNameLabel.frame.size.width + side_edge_width,
                 titleLabel.frame.origin.y + 40, phoneSize.width, 10);
  phoneNumberLabel.userInteractionEnabled = YES;
  [self.clientView addSubview:phoneNumberLabel];

  UILabel *lineLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(phoneNameLabel.frame.size.width +
                                   side_edge_width,
                               phoneNameLabel.frame.origin.y + 11,
                               phoneSize.width, 1)];
  lineLabel.userInteractionEnabled = YES;
  lineLabel.backgroundColor = [Globle colorFromHexRGB:@"ca332a"];
  [self.clientView addSubview:lineLabel];
  //拨打电话(扩大)
  UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
  phoneButton.frame = CGRectMake(phoneNumberLabel.frame.origin.x - 5,
                                 phoneNumberLabel.frame.origin.y - 5,
                                 phoneNumberLabel.frame.size.width + 10,
                                 phoneNumberLabel.frame.size.height + 10);
  [phoneButton setBackgroundColor:[UIColor clearColor]];
  [phoneButton addTarget:self
                  action:@selector(dialing)
        forControlEvents:UIControlEventTouchUpInside];
  [self.clientView addSubview:phoneButton];
}
/**创建获取用户验证码*/
- (void)createVerCode {
  getVerCode = [[GetVerificationCode alloc] init];
}
- (void)codeVerification {
  //收回键盘
  [self resignKeyBoardFirstResponder];
  if ([phoneNumber.text length] == 0) {
    [self showMessage:@"请输入手机号"];
    return;
  } else if (![NSString validataPhoneNumber:phoneNumber.text]) {
    [self showMessage:@"请输入正确的手机号"];
    return;
  }
  //按钮状态
  [getAuthCodeButton setTitleColor:[Globle colorFromHexRGB:@"939393"]
                          forState:UIControlStateNormal];

  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  //解析
  __weak PasswordViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    PasswordViewController *strongSelf = weakSelf;
    if (strongSelf) {
      return NO;
    } else
      return YES;
  };
  callback.onSuccess = ^(NSObject *obj) {
    PasswordViewController *strongSelf = weakSelf;
    if (strongSelf) {
    }
  };
  callback.onError = ^(BaseRequestObject *error, NSException *ex) {
    if ([error.status isEqualToString:@"1001"]) {
      [self authReset];
    }
    [BaseRequester defaultErrorHandler](error, ex);
  };
  [LossPassword lossPasswordMakeForgotPwdPinWithPhoneNumber:phoneNumber.text
                                               withCallback:callback];
  //点击就重置了button
  [self authReset];
  [getVerCode changeButton];
  getVerCode.getAuthBtn = getAuthCodeButton;
  getVerCode.TPphoneNumber = phoneNumber.text;
}
#pragma mark
#pragma mark-------辅助函数-------
//提示框
- (void)showMessage:(NSString *)content {
  [NewShowLabel setMessageContent:content];
}
- (void)authReset {
  if ([phoneNumber.text length] > 0) {
    getAuthCodeButton.userInteractionEnabled = YES;
  } else {
    getAuthCodeButton.userInteractionEnabled = NO;
  }
  [getAuthCodeButton setTitleColor:[Globle colorFromHexRGB:@"086dae"]
                          forState:UIControlStateNormal];
  [getAuthCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
  [getVerCode stopTime];
}
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
        if ([authCodeTextField.text length] > 5) {
          nextStepButton.userInteractionEnabled = YES;
          nextStepButton.alpha = 1.0;
        }
        return NO;
      } else {
        return YES;
      }
    } else {
      nextStepButton.userInteractionEnabled = NO;
      nextStepButton.alpha = 0.8;
      getAuthCodeButton.userInteractionEnabled = NO;
      getAuthCodeButton.alpha = 0.8;
    }
  }
  if (textField == authCodeTextField) {
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
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self resignKeyBoardFirstResponder];
}
/**
 *释放键盘
 */
- (void)resignKeyBoardFirstResponder {
  [phoneNumber resignFirstResponder];
  [authCodeTextField resignFirstResponder];
}
#pragma mark
#pragma mark 客服电话

- (void)dialing {
  NSString *number = @"01053599702"; // 此处读入电话号码
  NSURL *backURL = [NSURL
      URLWithString:[NSString stringWithFormat:@"telprompt://%@", number]];
  [[UIApplication sharedApplication] openURL:backURL];
}
#pragma mark
#pragma mark------下一步-------
- (void)nextStep {
  //输入限定条件
  if ([phoneNumber.text length] == 0) {
    [self showMessage:@"请输入手机号"];
    return;
  } else if (![NSString validataPhoneNumber:phoneNumber.text]) {
    [self showMessage:@"请输入正确的手机号"];
    return;
  } else if ([authCodeTextField.text length] == 0) {
    [self showMessage:@"请输入验证码"];
    return;
  }
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel setMessageContent:REQUEST_FAILED_MESSAGE];
    return;
  }
  if (![NetLoadingWaitView isAnimating]) {
    [NetLoadingWaitView startAnimating];
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  //解析
  __weak PasswordViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    PasswordViewController *strongSelf = weakSelf;
    if ([NetLoadingWaitView isAnimating]) {
      [NetLoadingWaitView stopAnimating];
    }
    if (strongSelf) {
      return NO;
    } else
      return YES;
  };
  callback.onSuccess = ^(NSObject *obj) {
    PasswordViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [self authReset];
      [self comfirmButtonOperation];
    }
  };
  callback.onFailed = ^() {
    [BaseRequester defaultFailedHandler]();
    [self authReset];
  };
  callback.onError = ^(BaseRequestObject *error, NSException *ex) {
    [BaseRequester defaultErrorHandler](error, ex);
  };
  [LossPassword lossPasswordAuthSmsCodeWithPhoneNumber:phoneNumber.text
                                          withAuthCode:authCodeTextField.text
                                          withCallback:callback];
  //键盘回收
  [self resignKeyBoardFirstResponder];
}
- (void)comfirmButtonOperation {
  [self resignKeyBoardFirstResponder];
  ReinstallViewController *reinstallVC = [[ReinstallViewController alloc] init];
  reinstallVC.phoneNumber = phoneNumber.text;
  reinstallVC.verifyCode = authCodeTextField.text;
  [AppDelegate pushViewControllerFromRight:reinstallVC];
}
//回调左上侧按钮的协议事件
//左边按钮按下
- (void)leftButtonPress {
  [self resignKeyBoardFirstResponder];
  //按钮重置
  [self authReset];
  [super leftButtonPress];
}
@end
