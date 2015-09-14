//
//  WFBindMobilePhoneViewController.m
//  SimuStock
//
//  Created by Jhss on 15/4/26.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "WFBindMobilePhoneViewController.h"
#import "PhoneRegister.h"
#import "WFFinancingParse.h"
#import "UIButton+Hightlighted.h"
#import "NSString+validate.h"

@interface WFBindMobilePhoneViewController () <UITextFieldDelegate>

@end

@implementation WFBindMobilePhoneViewController

- (id)initWithBindMobilePhoneBlock:(BindMobilePhoneBlock)block {
  self = [super init];
  if (self) {
    self.bindMobilePhoneBlock = block;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  //加载视图控件
  [self settingUpViewControls];

  /**创建获取用户验证码*/
  [self createVerCode];
  //设置输入框
  [self settingPhoneNumberAndauthCodeTextTFStyle];

  // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
/** 设置视图的控件 */
- (void)settingUpViewControls {

  //显示“绑定手机号”，并且隐藏刷新按钮
  [self.topToolBar resetContentAndFlage:@"绑定手机号" Mode:TTBM_Mode_Leveltwo];
  self.indicatorView.hidden = YES;
  //去掉最上层的clientView,
  self.clientView.alpha = 0;

  //”获取验证码“文字的高亮颜色Jhss
  self.getAuthCodeButton.userInteractionEnabled = NO;
  [self.getAuthCodeButton setTitleColor:[Globle colorFromHexRGB:@"4dfdff"]
                               forState:UIControlStateHighlighted];
  
  requesting = NO;
  
  __weak WFBindMobilePhoneViewController *weakSelf = self;
  [_getAuthCodeButton setOnButtonPressedHandler:^{
    [weakSelf sendSmsGetAuthCodePress];
  }];
  
  //设置确定按钮的高亮状态
  self.confirmButton.userInteractionEnabled = NO;
  self.confirmButton.alpha = 0.8;
  [self.confirmButton buttonWithNormal:Color_WFOrange_btn
                  andHightlightedColor:Color_WFOrange_btnDown];
  [self.confirmButton buttonWithTitle:@"确认"
                   andNormaltextcolor:Color_White
             andHightlightedTextColor:Color_White];

  __block WFBindMobilePhoneViewController *blockSelf = self;
  [self.confirmButton setOnButtonPressedHandler:^{
    [blockSelf confirmBindMobilePhonePress:nil];
  }];
}

/** 设置手机号输入框 */
- (void)settingPhoneNumberAndauthCodeTextTFStyle {
  //手机号输入框
  self.phoneNumber.placeholder = @"请输入手机号";
  self.phoneNumber.clearButtonMode = UITextFieldViewModeWhileEditing;
  self.phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
  self.phoneNumber.textColor = [Globle colorFromHexRGB:@"454545"];
  self.phoneNumber.font = [UIFont systemFontOfSize:14];
  self.phoneNumber.delegate = self;
  //验证码输入框
  self.authCodeTextFeild.placeholder = @"请输入验证码";
  self.authCodeTextFeild.textColor = [Globle colorFromHexRGB:@"454545"];
  self.authCodeTextFeild.delegate = self;
  self.authCodeTextFeild.clearButtonMode = UITextFieldViewModeWhileEditing;
  self.authCodeTextFeild.keyboardType = UIKeyboardTypeNumberPad;
  self.authCodeTextFeild.font = [UIFont systemFontOfSize:14];
}

/**创建获取用户验证码*/
- (void)createVerCode {
  getVerCode = [[GetVerificationCode alloc] init];
}
#pragma mark
- (void)getAuthCodeButtonAction {
  self.getAuthCodeButton.userInteractionEnabled = YES;
}
///"获取验证码"的点击事件
- (void)sendSmsGetAuthCodePress{
  //收回键盘
  [self resignKeyBoardFirstResponder];
  if ([self.phoneNumber.text length] == 0) {
    [self showMessage:@"请输入手机号"];
    return;
  } else if (![NSString validataPhoneNumber:self.phoneNumber.text]) {
    [self showMessage:@"请输入正确的手机号"];
    return;
  }
  //按钮状态
  [self.getAuthCodeButton setTitleColor:[Globle colorFromHexRGB:@"086dae"]
                               forState:UIControlStateNormal];
  
  if (requesting) {
    return;
  }
  //获得验证码
  [self sendSmsAuthCodeNum:0];
}

///调用接口，发送验证码
- (void)sendSmsAuthCodeNum:(NSInteger)num {
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
  __weak WFBindMobilePhoneViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    WFBindMobilePhoneViewController *strongSelf = weakSelf;
    if (strongSelf) {
      requesting = NO;
      return NO;
    } else
      return YES;
  };
  callback.onSuccess = ^(NSObject *obj) {
    WFBindMobilePhoneViewController *strongSelf = weakSelf;
    if (strongSelf) {
    }
  };
  callback.onError = ^(BaseRequestObject *error, NSException *ex) {
    if ([error.status isEqualToString:@"1001"]) {
      [self authReset];
    }
    [BaseRequester defaultErrorHandler](error, ex);
  };
  callback.onFailed=^(){
    [self sendSmsAuthCodeNum:num+1];
  };
  
  [PhoneRegister
      phoneRegisterMakeRegisterPinWithPhoneNumber:self.phoneNumber.text
                                         withType:WFbindPhone
                                     withCallback:callback];
  //点击就重置了button
  [self authReset];
  [getVerCode changeButton];
  getVerCode.getAuthBtn = self.getAuthCodeButton;
  getVerCode.TPphoneNumber = self.phoneNumber.text;
}

#pragma mark
#pragma mark 重置按钮
- (void)authReset {
  if ([self.phoneNumber.text length] > 0) {
    self.getAuthCodeButton.userInteractionEnabled = YES;
  } else {
    self.getAuthCodeButton.userInteractionEnabled = NO;
  }
  [self.getAuthCodeButton setTitleColor:[Globle colorFromHexRGB:@"086dae"]
                               forState:UIControlStateNormal];
  [self.getAuthCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
  [getVerCode stopTime];
}
- (BOOL)textFieldShouldClear:(UITextField *)textField {
  if (textField == self.phoneNumber) {
    self.getAuthCodeButton.userInteractionEnabled = NO;
    self.getAuthCodeButton.alpha = 0.8;
  }
  self.confirmButton.userInteractionEnabled = NO;
  self.confirmButton.alpha = 0.8;
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
  if (textField == self.phoneNumber) {
    if ([toBeString length] > 10) {
      //更改显示效果，设置为输入就可以验证
      if ([toBeString length] > 10) {
        textField.text = [toBeString substringToIndex:11];
        self.getAuthCodeButton.userInteractionEnabled = YES;
        self.getAuthCodeButton.alpha = 1.0;
        if ([self.authCodeTextFeild.text length] > 5) {
          self.confirmButton.userInteractionEnabled = YES;
          self.confirmButton.alpha = 1.0;
        }
        return NO;
      } else {
        return YES;
      }
    } else {
      self.confirmButton.userInteractionEnabled = NO;
      self.confirmButton.alpha = 0.8f;
      self.getAuthCodeButton.userInteractionEnabled = NO;
      self.getAuthCodeButton.alpha = 0.8f;
    }
  }
  if (textField == self.authCodeTextFeild) {
    if ([toBeString length] > 5) {
      textField.text = [toBeString substringToIndex:6];
      if ([self.phoneNumber.text length] == 11) {
        self.confirmButton.userInteractionEnabled = YES;
        self.confirmButton.alpha = 1.0f;
      } else {
        self.confirmButton.userInteractionEnabled = NO;
        self.confirmButton.alpha = 0.8f;
      }
      return NO;
    } else {
      self.confirmButton.userInteractionEnabled = NO;
      self.confirmButton.alpha = 0.8f;
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
  [self.phoneNumber resignFirstResponder];
  [self.authCodeTextFeild resignFirstResponder];
}
#pragma mark
#pragma mark-----辅助函数----
//提示框
- (void)showMessage:(NSString *)content {
  [NewShowLabel setMessageContent:content];
}
///"确定"按钮的点击事件
- (IBAction)confirmBindMobilePhonePress:(UIButton *)sender {

  [self resignKeyBoardFirstResponder];
  //输入限定条件
  if ([self.phoneNumber.text length] == 0) {
    [self showMessage:@"请输入手机号"];
    return;
  } else if (![NSString validataPhoneNumber:self.phoneNumber.text]) {
    [self showMessage:@"请输入正确的手机号"];
    return;
  } else if ([self.authCodeTextFeild.text length] == 0) {
    [self showMessage:@"请输入验证码"];
    return;
  }
  if (!sender.enabled) {
    return;
  }
  sender.enabled = NO;
  /** 1.3手机号的绑定 发送信息进行手机号的绑定 */
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  //解析
  __weak WFBindMobilePhoneViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    WFBindMobilePhoneViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf authReset];
      return NO;
    } else
      return YES;
  };
  callback.onSuccess = ^(NSObject *obj) {
    WFBindMobilePhoneViewController *strongSelf = weakSelf;
    if (strongSelf) {
      //保存手机号
      [strongSelf onBindPhoneNumSuccess];
    }
  };
  callback.onError = ^(BaseRequestObject *obj, NSException *exc) {
    [BaseRequester defaultErrorHandler](obj, exc);
    sender.enabled = YES;
  };
  callback.onFailed = ^() {
    [BaseRequester defaultFailedHandler]();
    sender.enabled = YES;
  };

  [WFFinancingParse bindMobileCodeWithPhone:self.phoneNumber.text
                             withVerifycode:self.authCodeTextFeild.text
                               withCallback:callback];
}

- (void)onBindPhoneNumSuccess {
  [SimuUtil setUserPhone:self.phoneNumber.text];
  [self.navigationController popViewControllerAnimated:NO];
  [SimuUtil performBlockOnMainThread:^{
    if (self.bindMobilePhoneBlock) {
      self.bindMobilePhoneBlock(YES);
    }
  } withDelaySeconds:0.2];
}

@end
