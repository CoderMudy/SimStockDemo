//
//  ChangePasswordViewController.m
//  SimuStock
//
//  Created by Jhss on 15/6/17.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "SimuUtil.h"
#import "event_view_log.h"
#import "NetLoadingWaitView.h"
#import "NewShowLabel.h"
#import "BaseRequester.h"
#import "MyInformationCenterData.h"
#import "ConditionsWithKeyBoardUsing.h"
#import "UIButton+Hightlighted.h"
#import "PhoneRegisterViewController.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self createMainView];
  //判断是否切换到了一次下一页
  [[event_view_log sharedManager]
      addPVAndButtonEventToLog:Log_Type_PV
                       andCode:@"个人中心-修改密码"];
  // Do any additional setup after loading the view from its nib.
}
- (void)createMainView {
  self.view.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  [_topToolBar resetContentAndFlage:@"修改密码" Mode:TTBM_Mode_Leveltwo];
  self.clientView.alpha = 0;
  _indicatorView.hidden = YES;
  //确定
  self.confirmButton.alpha = 0.8;
  [self.confirmButton buttonWithNormal:Color_Blue_but
                  andHightlightedColor:Color_Blue_butDown];
  [self.confirmButton buttonWithTitle:@"修改密码"
                   andNormaltextcolor:Color_White
             andHightlightedTextColor:Color_White];
  [self.confirmButton addTarget:self
                         action:@selector(confirm:)
               forControlEvents:UIControlEventTouchUpInside];
  //忘记密码
  self.lossPasswordButton.backgroundColor = [UIColor clearColor];
  //为了实现图片交替显示的效果，加入了3个事件
  [self.lossPasswordButton addTarget:self
                              action:@selector(lossPasswordTouchDown:)
                    forControlEvents:UIControlEventTouchDown];
  [self.lossPasswordButton addTarget:self
                              action:@selector(lossPasswordTouchUpOutSide:)
                    forControlEvents:UIControlEventTouchUpOutside];
  [self.lossPasswordButton addTarget:self
                              action:@selector(lossPasswordTouchUpInSide:)
                    forControlEvents:UIControlEventTouchUpInside];

  //三个输入框
  self.oldPasswordTextField.delegate = self;
  self.passWordTextField.delegate = self;
  self.onceNewPasswordTextField.delegate = self;
  [self.oldPasswordTextField setSecureTextEntry:YES];
  [self.passWordTextField setSecureTextEntry:YES];
  [self.onceNewPasswordTextField setSecureTextEntry:YES];
}
//构建忘记密码按钮效果
- (void)lossPasswordTouchDown:(UIButton *)button {
  self.lossPasswordLabel.textColor = [Globle colorFromHexRGB:@"4dfdff"];
  [self.lossPasswordIconButton
      setImage:[UIImage imageNamed:@"forget_password_down.png"]];
}
- (void)lossPasswordTouchUpOutSide:(UIButton *)button {
  self.lossPasswordLabel.textColor = [Globle colorFromHexRGB:@"086dae"];
  [self.lossPasswordIconButton
      setImage:[UIImage imageNamed:@"forget_password_up.png"]];
}
- (void)lossPasswordTouchUpInSide:(UIButton *)button {
  self.lossPasswordLabel.textColor = [Globle colorFromHexRGB:@"086dae"];
  [self.lossPasswordIconButton
      setImage:[UIImage imageNamed:@"forget_password_up.png"]];
  //纪录日志
  [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button
                                                   andCode:@"13"];
  [self clickLossPasswordButton];
}
- (void)clickLossPasswordButton {
  NSString *titleStr = @"重设密码";
  NSString *hintString = @"请您牢记您的登录密码";
  CGRect frame = CGRectMake(0, 0, WIDTH_OF_SCREEN, HEIGHT_OF_SCREEN);
  PhoneRegisterViewController *modifyVC =
      [[PhoneRegisterViewController alloc] initWithFrame:frame withTitleLabel:titleStr withHintLabel:hintString];
  [AppDelegate pushViewControllerFromRight:modifyVC];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
- (void)confirm:(UIButton *)button {
  self.oldPassword = self.oldPasswordTextField.text;
  self.mPassword = self.passWordTextField.text;
  self.mOncePassword = self.onceNewPasswordTextField.text;
  //验证密码
  if ([self.oldPassword length] == 0) {
    UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:@"提示"
                                   message:@"请输入原始密码"
                                  delegate:self
                         cancelButtonTitle:@"确定"
                         otherButtonTitles:nil];
    [alertView show];
    return;
  } else if ([self.mPassword length] == 0) {
    UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:@"提示"
                                   message:@"请输入密码"
                                  delegate:self
                         cancelButtonTitle:@"确定"
                         otherButtonTitles:nil];
    [alertView show];
    return;
  } else if (![[ConditionsWithKeyBoardUsing shareInstance]
                 isNumbersOrLetters:self.mPassword]) {
    UIAlertView *alertView = [[UIAlertView alloc]
            initWithTitle:@"提示"
                  message:
                      @"密码由6-16位字母或数字组成，请重新输入"
                 delegate:self
        cancelButtonTitle:@"确定"
        otherButtonTitles:nil];
    [alertView show];
    return;
  } else if ([self.mPassword length] < 6) {
    UIAlertView *alertView = [[UIAlertView alloc]
            initWithTitle:@"提示"
                  message:@"密码至少是6位的数字或字母"
                 delegate:self
        cancelButtonTitle:@"确定"
        otherButtonTitles:nil];
    [alertView show];
    return;
  } else if ([self.mOncePassword length] == 0) {
    UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:@"提示"
                                   message:@"请输入确认密码"
                                  delegate:self
                         cancelButtonTitle:@"确定"
                         otherButtonTitles:nil];
    [alertView show];
    return;
  } else if (![self.mPassword isEqualToString:self.mOncePassword]) {
    UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:@"提示"
                                   message:@"两次密码输入不一致"
                                  delegate:self
                         cancelButtonTitle:@"确定"
                         otherButtonTitles:nil];
    [alertView show];
    return;
  } else if ([self.oldPassword isEqualToString:self.mPassword]) {
    UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:@"提示"
                                   message:@"新密码和旧密码不能相同"
                                  delegate:self
                         cancelButtonTitle:@"确定"
                         otherButtonTitles:nil];
    [alertView show];
    return;
  } else {
    NSString *passwordStr = [self.mPassword
        stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *oncePasswordStr = [self.mOncePassword
        stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *oldPasswordStr = [self.oldPassword
        stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (![SimuUtil isExistNetwork]) {
      [NewShowLabel setMessageContent:REQUEST_FAILED_MESSAGE];
      return;
    }
    HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
    //解析
    __weak ChangePasswordViewController *weakSelf = self;
    callback.onCheckQuitOrStopProgressBar = ^{
      ChangePasswordViewController *strongSelf = weakSelf;
      if ([NetLoadingWaitView isAnimating] == YES) {
        [NetLoadingWaitView stopAnimating];
      }
      if (strongSelf) {
        return NO;
      } else
        return YES;
    };
    callback.onSuccess = ^(NSObject *obj) {
      ChangePasswordViewController *strongSelf = weakSelf;
      if (strongSelf) {
        [SimuUtil setUserPassword:self.mPassword];
        //提示修改成功
        [self resignKeyBoardFirstResponder];
        [NewShowLabel setMessageContent:@"修改成功"];
        //返回上一页
        [strongSelf leftButtonPress];

      } else {
        self.oldPasswordTextField.text = @"";
      }
    };
    if ([NetLoadingWaitView isAnimating] == NO)
      [NetLoadingWaitView startAnimating];
    [ChangePassword changePasswordWithPassword:passwordStr
                              withOncePassword:oncePasswordStr
                               withOldPassword:oldPasswordStr
                                  withCallback:callback];
  }
}
#pragma mark
#pragma mark-----辅助函数-------
//键盘收回的三种情况
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self resignKeyBoardFirstResponder];
}
/**
 *释放键盘
 */
- (void)resignKeyBoardFirstResponder {
  [self.oldPasswordTextField resignFirstResponder];
  [self.passWordTextField resignFirstResponder];
  [self.onceNewPasswordTextField resignFirstResponder];
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
  if ([toBeString length] > 15) { // Gdd 修改
    textField.text = [toBeString substringToIndex:16];
    [NewShowLabel setMessageContent:@"您的密码长度不能超过16位"];
    return NO;
  }
  return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
  if (textField == self.oldPasswordTextField) {
    self.oldPassword = textField.text;
  } else if (textField == self.passWordTextField) {
    self.mPassword = textField.text;
  } else {
    self.mOncePassword = textField.text;
  }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return YES;
}

@end
