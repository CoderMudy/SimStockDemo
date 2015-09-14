//
//  UserLogonViewController.m
//  SimuStock
//
//  Created by jhss on 14-7-8.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "UserLogonViewController.h"
#import "PhoneRegisterViewController.h"
#import "SimuUtil.h"
#import "UserInformationItem.h"
#import "SimuAction.h"
#import "event_view_log.h"
#import "GetUserBandPhoneNumber.h"
#import "NetLoadingWaitView.h"

@implementation UserLogonViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self createLogonPageView];
  __weak UserLogonViewController *weakSelf = self;
  [logonButton setOnButtonPressedHandler:^{
    [weakSelf logonEntrance];
  }];

  if (historyUserNameArray && historyUserNameArray.count > 0) {
    userNameTextField.text = historyUserNameArray[0];
  } else {
    //自动注册账号不显示用户名
    NSString *selfUserName = [SimuUtil getUserName];
    if (![selfUserName hasPrefix:@"优顾"]) {
      userNameTextField.text = selfUserName;
    }
  }
}

#pragma mark
#pragma mark--------界面设计--------
- (void)createLogonPageView {
  _indicatorView.hidden = YES;
  arrowType = arrow_down;
  [_topToolBar resetContentAndFlage:@"登录" Mode:TTBM_Mode_Leveltwo];
  //右上角登录按钮
  logonButton = [UIButton buttonWithType:UIButtonTypeCustom];
  logonButton.frame =
      CGRectMake(_topToolBar.frame.size.width - 60, _topToolBar.frame.size.height - 44, 60, 44);
  [logonButton setBackgroundImage:[UIImage imageNamed:@"return_touch_down.png"]
                         forState:UIControlStateHighlighted];
  [_topToolBar addSubview:logonButton];
  //右上角登录label
  UILabel *logonLabel =
      [[UILabel alloc] initWithFrame:CGRectMake(_topToolBar.frame.size.width - 60, _topToolBar.frame.size.height - 44, 60, 44)];
  logonLabel.textAlignment = NSTextAlignmentCenter;
  logonLabel.text = @"登录";
  logonLabel.backgroundColor = [UIColor clearColor];
  logonLabel.textColor = [Globle colorFromHexRGB:@"4dfdff"];
  logonLabel.font = [UIFont systemFontOfSize:Font_Height_16_0];
  [_topToolBar addSubview:logonLabel];
  //分割线
  firstCuttingLineLabel =
      [[UILabel alloc] initWithFrame:CGRectMake(side_edge_width, 67, self.view.frame.size.width - side_edge_width * 2, 0.5f)];
  firstCuttingLineLabel.backgroundColor = [Globle colorFromHexRGB:@"086dae"];
  [self.clientView addSubview:firstCuttingLineLabel];

  UILabel *secondCuttingLineLabel =
      [[UILabel alloc] initWithFrame:CGRectMake(side_edge_width, 67 + 45, self.view.frame.size.width - side_edge_width * 2, 0.5f)];
  secondCuttingLineLabel.backgroundColor = [Globle colorFromHexRGB:@"086dae"];
  [self.clientView addSubview:secondCuttingLineLabel];
  //添加扩展按钮
  //用户名
  UIButton *userNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
  userNameButton.frame = CGRectMake(side_edge_width, firstCuttingLineLabel.frame.origin.y - 40,
                                    firstCuttingLineLabel.frame.size.width - side_edge_width * 2, 40);
  userNameButton.backgroundColor = [UIColor clearColor];
  [userNameButton addTarget:self
                     action:@selector(click_userNameTextField)
           forControlEvents:UIControlEventTouchUpInside];
  [self.clientView addSubview:userNameButton];
  //用户密码
  UIButton *userPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
  userPasswordButton.frame = CGRectMake(side_edge_width, secondCuttingLineLabel.frame.origin.y - 40,
                                        secondCuttingLineLabel.frame.size.width - side_edge_width * 2, 40);
  userPasswordButton.backgroundColor = [UIColor clearColor];
  [userPasswordButton addTarget:self
                         action:@selector(click_userPasswordTextField)
               forControlEvents:UIControlEventTouchUpInside];
  [self.clientView addSubview:userPasswordButton];
  // userNameTextField
  userNameTextField =
      [[UITextField alloc] initWithFrame:CGRectMake(28, firstCuttingLineLabel.frame.origin.y - 24,
                                                    self.view.bounds.size.width - 76, 20)];
  userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
  passwordTextField =
      [[UITextField alloc] initWithFrame:CGRectMake(28, secondCuttingLineLabel.frame.origin.y - 24,
                                                    self.view.bounds.size.width - 51, 20)];
  passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
  userNameTextField.delegate = self;
  passwordTextField.delegate = self;
  //不自动改正
  userNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
  userNameTextField.returnKeyType = UIReturnKeyDone;
  userNameTextField.textColor = [Globle colorFromHexRGB:@"454545"];
  passwordTextField.textColor = [Globle colorFromHexRGB:@"454545"];
  userNameTextField.backgroundColor = [UIColor clearColor];
  passwordTextField.backgroundColor = [UIColor clearColor];
  userNameTextField.font = [UIFont systemFontOfSize:14];
  passwordTextField.font = [UIFont systemFontOfSize:14];
  passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
  passwordTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
  userNameTextField.placeholder = @"用户名/手机号";

  //避免出现首次输入消失情况
  passwordTextField.placeholder = @"请输入密码";
  [passwordTextField setSecureTextEntry:YES];
  [self.clientView addSubview:userNameTextField];
  [self.clientView addSubview:passwordTextField];
  //注册新用户
  UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
  registerButton.frame = CGRectMake(side_edge_width, secondCuttingLineLabel.frame.origin.y + 21, 77, 17);
  registerButton.backgroundColor = [UIColor clearColor];
  //为了实现图片交替显示的效果，加入了3个事件
  [registerButton addTarget:self
                     action:@selector(registerNewUserTouchDown:)
           forControlEvents:UIControlEventTouchDown];
  [registerButton addTarget:self
                     action:@selector(registerNewUserTouchUpOutSide:)
           forControlEvents:UIControlEventTouchUpOutside];
  [registerButton addTarget:self
                     action:@selector(registerNewUserTouchUpInSide:)
           forControlEvents:UIControlEventTouchUpInside];
  [self.clientView addSubview:registerButton];
  //左侧icon
  newUserIconButton = [UIButton buttonWithType:UIButtonTypeCustom];
  newUserIconButton.frame = CGRectMake(20, secondCuttingLineLabel.frame.origin.y + 21, 17, 17);
  [newUserIconButton setBackgroundImage:[UIImage imageNamed:@"register_new_user_up.png"]
                               forState:UIControlStateNormal];
  newUserIconButton.userInteractionEnabled = NO;
  [self.clientView addSubview:newUserIconButton];
  //右侧label
  newUserLabel =
      [[UILabel alloc] initWithFrame:CGRectMake(side_edge_width + 21, secondCuttingLineLabel.frame.origin.y + 23.5f, 60, 12)];
  newUserLabel.backgroundColor = [UIColor clearColor];
  newUserLabel.text = @"注册新用户";
  newUserLabel.font = [UIFont systemFontOfSize:Font_Height_12_0];
  newUserLabel.textColor = [Globle colorFromHexRGB:@"086dae"];
  newUserLabel.textAlignment = NSTextAlignmentLeft;
  [self.clientView addSubview:newUserLabel];
  //忘记密码
  //为了实现图片交替显示的效果，加入了两个事件
  UIButton *lossPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
  lossPasswordButton.frame = CGRectMake(self.view.bounds.size.width - side_edge_width - 70,
                                        secondCuttingLineLabel.frame.origin.y + 21, 70, 17);
  lossPasswordButton.backgroundColor = [UIColor clearColor];
  //为了实现图片交替显示的效果，加入了3个事件
  [lossPasswordButton addTarget:self
                         action:@selector(lossPasswordTouchDown:)
               forControlEvents:UIControlEventTouchDown];
  [lossPasswordButton addTarget:self
                         action:@selector(lossPasswordTouchUpOutSide:)
               forControlEvents:UIControlEventTouchUpOutside];
  [lossPasswordButton addTarget:self
                         action:@selector(lossPasswordTouchUpInSide:)
               forControlEvents:UIControlEventTouchUpInside];
  [self.clientView addSubview:lossPasswordButton];
  //左侧icon
  lossPasswordIconButton = [UIButton buttonWithType:UIButtonTypeCustom];
  lossPasswordIconButton.frame = CGRectMake(self.view.bounds.size.width - side_edge_width - 70,
                                            secondCuttingLineLabel.frame.origin.y + 21, 17, 17);
  [lossPasswordIconButton setBackgroundImage:[UIImage imageNamed:@"forget_password_up.png"]
                                    forState:UIControlStateNormal];
  lossPasswordIconButton.userInteractionEnabled = NO;
  [self.clientView addSubview:lossPasswordIconButton];
  //忘记密码
  lossPasswordLabel =
      [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - side_edge_width - 70 + 22,
                                                secondCuttingLineLabel.frame.origin.y + 23.5f, 50, 12)];
  lossPasswordLabel.backgroundColor = [UIColor clearColor];
  lossPasswordLabel.text = @"忘记密码";
  lossPasswordLabel.font = [UIFont systemFontOfSize:Font_Height_12_0];
  lossPasswordLabel.textColor = [Globle colorFromHexRGB:@"086dae"];
  lossPasswordLabel.textAlignment = NSTextAlignmentLeft;
  [self.clientView addSubview:lossPasswordLabel];
  //下拉菜单
  arrowImageView =
      [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - side_edge_width - 11 - 15,
                                                    firstCuttingLineLabel.frame.origin.y - 8 - 10, 15, 10)];
  arrowImageView.image = [UIImage imageNamed:@"logon_pull_down.png"];
  arrowType = arrow_down;
  [self.clientView addSubview:arrowImageView];
  //下拉按钮(扩大化)
  UIButton *arrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
  arrowButton.frame = CGRectMake(self.view.frame.size.width - 30 - side_edge_width,
                                 firstCuttingLineLabel.frame.origin.y - 30, 30, 30);
  arrowButton.backgroundColor = [UIColor clearColor];
  // arrowButton.alpha = 0.5;
  [arrowButton addTarget:self
                  action:@selector(pullDown:)
        forControlEvents:UIControlEventTouchUpInside];
  [self.clientView addSubview:arrowButton];
  //用户名历史记录隐藏
  //记录数据

  historyUserNameArray = [SimuUser userNameHistoryInfo];
  if ([historyUserNameArray count] != 0) {
    arrowButton.hidden = NO;
    arrowImageView.hidden = NO;
    tableViewBackgroundView =
        [[UIView alloc] initWithFrame:CGRectMake(side_edge_width, firstCuttingLineLabel.frame.origin.y,
                                                 self.view.frame.size.width - side_edge_width * 2, 0)];
    tableViewBackgroundView.backgroundColor = [UIColor whiteColor];
    tableViewBackgroundView.userInteractionEnabled = YES;
    tableViewBackgroundView.clipsToBounds = NO;
    historyTableView =
        [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - side_edge_width * 2, 0.1)];
    historyTableView.backgroundColor = [UIColor clearColor];
    historyTableView.bounces = NO;
    historyTableView.delegate = self;
    historyTableView.dataSource = self;
    historyTableView.scrollEnabled = NO;
    historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableViewBackgroundView addSubview:historyTableView];
    [self.clientView addSubview:tableViewBackgroundView];
  } else {
    arrowButton.hidden = YES;
    arrowImageView.hidden = YES;
  }
}
- (void)userNameTextField {
  [userNameTextField becomeFirstResponder];
}
// button来扩展textfield
- (void)click_userNameTextField {
  [userNameTextField becomeFirstResponder];
}
- (void)click_userPasswordTextField {
  [passwordTextField becomeFirstResponder];
}

#pragma mark
#pragma mark--------按钮事件-------
//登录按钮
- (void)logonEntrance {
  //纪录日志
  [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button andCode:@"10"];
  NSString *userName =
      [userNameTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
  NSString *userPassword = passwordTextField.text;
  //前端判断输入格式
  if ([userName length] == 0) {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请输入用户名"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
    return;
  }
  if ([userPassword length] == 0) {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请输入密码"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
    return;
  }
  [self resignKeyboardFirstResponder];

  //未响应时，自动关闭
  [self performSelector:@selector(netLoadingViewRelease) withObject:nil afterDelay:30];
  [NetLoadingWaitView startAnimating];
  __weak UserLogonViewController *weakSelf = self;
  HttpRequestCallBack *callback = [HttpRequestCallBack initWithOwner:self
                                                       cleanCallback:^{
                                                         [NetLoadingWaitView stopAnimating];
                                                       }];

  callback.onSuccess = ^(NSObject *obj) {
    UserLogonViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf setLoginSuccess:userName];
    }
  };
  [UserInformationItem requestLoginWithUserName:userName
                                   withPassword:userPassword
                                   withCallback:callback];
}
//下拉按钮
- (void)pullDown:(UIButton *)button {
  // iOS6上可能错误的传入数组类
  if (![button.class isSubclassOfClass:[UIButton class]]) {
    return;
  }
  //收回键盘
  [self resignKeyboardFirstResponder];
  CGRect frame = self.view.frame;
  //表格放在动画外侧
  if (arrowType == arrow_down) {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1 * [historyUserNameArray count]];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    historyTableView.frame =
        CGRectMake(0, 0, frame.size.width - side_edge_width * 2, [historyUserNameArray count] * 37);
    arrowImageView.image = [UIImage imageNamed:@"logon_pull_up.png"];
    arrowType = arrow_up;
    tableViewBackgroundView.frame =
        CGRectMake(side_edge_width, firstCuttingLineLabel.frame.origin.y,
                   frame.size.width - side_edge_width * 2, [historyUserNameArray count] * 37);
    //[historyTableView reloadData];
    [UIView commitAnimations];
  } else {
    [self retractTableView];
  }
}
//全部收回
- (void)retractTableView {
  CGRect frame = self.view.frame;
  arrowImageView.image = [UIImage imageNamed:@"logon_pull_down.png"];
  arrowType = arrow_down;
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.1 * [historyUserNameArray count]];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
  [UIView setAnimationDidStopSelector:@selector(tableviewRetract)];
  [UIView setAnimationDelegate:self];
  historyTableView.frame = CGRectMake(0, 0, frame.size.width - side_edge_width * 2, 0.1);
  tableViewBackgroundView.frame = CGRectMake(side_edge_width, firstCuttingLineLabel.frame.origin.y,
                                             frame.size.width - side_edge_width * 2, 0.2f);
  [UIView commitAnimations];
}
//表格收回
- (void)tableviewRetract {
  //[historyTableView reloadData];
}
//构建注册按钮效果
- (void)registerNewUserTouchDown:(UIButton *)button {
  newUserLabel.textColor = [Globle colorFromHexRGB:@"4dfdff"];
  [newUserIconButton setBackgroundImage:[UIImage imageNamed:@"register_new_user_down.png"]
                               forState:UIControlStateNormal];
}
- (void)registerNewUserTouchUpOutSide:(UIButton *)button {
  newUserLabel.textColor = [Globle colorFromHexRGB:@"086dae"];
  [newUserIconButton setBackgroundImage:[UIImage imageNamed:@"register_new_user_up.png"]
                               forState:UIControlStateNormal];
}
- (void)registerNewUserTouchUpInSide:(UIButton *)button {
  newUserLabel.textColor = [Globle colorFromHexRGB:@"086dae"];
  [newUserIconButton setBackgroundImage:[UIImage imageNamed:@"register_new_user_up.png"]
                               forState:UIControlStateNormal];
  //纪录日志
  [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button andCode:@"12"];
  [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_PV andCode:@"注册页"];
  //-----button显示
  [newUserHeadImageButton setBackgroundImage:[UIImage imageNamed:@"registerNewInfo_up"]
                                    forState:UIControlStateNormal];
  //----手机注册界面显示
  [self resignKeyboardFirstResponder];

  PhoneRegisterViewController *registerVC = [[PhoneRegisterViewController alloc] init];
  registerVC.titleStr = @"手机快速注册";
  registerVC.hintString = @"手机注册后，可通过手机号与密码进行登录。";
  [AppDelegate pushViewControllerFromRight:registerVC];
}
//构建忘记密码按钮效果
- (void)lossPasswordTouchDown:(UIButton *)button {
  lossPasswordLabel.textColor = [Globle colorFromHexRGB:@"4dfdff"];
  [lossPasswordIconButton setBackgroundImage:[UIImage imageNamed:@"forget_password_down.png"]
                                    forState:UIControlStateNormal];
}
- (void)lossPasswordTouchUpOutSide:(UIButton *)button {
  lossPasswordLabel.textColor = [Globle colorFromHexRGB:@"086dae"];
  [lossPasswordIconButton setBackgroundImage:[UIImage imageNamed:@"forget_password_up.png"]
                                    forState:UIControlStateNormal];
}

- (void)lossPasswordTouchUpInSide:(UIButton *)button {
  lossPasswordLabel.textColor = [Globle colorFromHexRGB:@"086dae"];
  [lossPasswordIconButton setBackgroundImage:[UIImage imageNamed:@"forget_password_up.png"]
                                    forState:UIControlStateNormal];
  //纪录日志
  [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button andCode:@"13"];
  //-----密码
  [self resignKeyboardFirstResponder];
  
  NSString *titleStr = @"重设密码";
  NSString *hintString = @"请您牢记您的登录密码";
  CGRect frame = CGRectMake(0, 0, WIDTH_OF_SCREEN, HEIGHT_OF_SCREEN);
  PhoneRegisterViewController *modifyVC = [[PhoneRegisterViewController alloc]initWithFrame:frame withTitleLabel:titleStr withHintLabel:hintString];
  modifyVC.isUserLoginLossPwdInto = YES;
  [AppDelegate pushViewControllerFromRight:modifyVC];
}
#pragma mark
#pragma mark----------------表格协议函数--------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [historyUserNameArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 37;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  //  NSLog(@"登录%ld,%ld",(long)historyUserNameArray.count,(long)indexPath.row);
  if (historyUserNameArray.count > indexPath.row) {
    userNameTextField.text = historyUserNameArray[indexPath.row];
    [self retractTableView];
  }
  [historyTableView reloadData];
}
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
  cell.backgroundColor = [UIColor clearColor];
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *ID = @"cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
  }
  cell.selectionStyle = UITableViewCellSelectionStyleGray;
  UILabel *lineLabel =
      [[UILabel alloc] initWithFrame:CGRectMake(2, 0, self.view.frame.size.width - side_edge_width * 2 - 4, 0.5)];
  lineLabel.backgroundColor = [Globle colorFromHexRGB:@"086dae"];
  [cell addSubview:lineLabel];
  cell.textLabel.text = historyUserNameArray[indexPath.row];
  cell.textLabel.font = [UIFont systemFontOfSize:Font_Height_12_0];
  cell.textLabel.textColor = [Globle colorFromHexRGB:@"454545"];
  return cell;
}
#pragma mark
#pragma mark--------网络请求-----------

- (void)netLoadingViewRelease {
  [NetLoadingWaitView stopAnimating];
}
- (void)setLoginSuccess:(NSString *)localUserName {
  self.view.hidden = YES;
  logonButton.enabled = NO;
  //登录日志
  [[event_view_log sharedManager] addLoginEventToLog];

  [SimuUser saveUsernameHistoryInfo:localUserName];
  //保存到本地数据库
  [SimuUtil setUserName:localUserName];
  [SimuUtil setUserPassword:passwordTextField.text];
  [SimuUser setSessionSavedTime:[NSDate timeIntervalSinceReferenceDate]];
  //更新数据
  [self sendMessageUpdataUserInfo];
  //
  [self userWhetherBindingPhone];
  
  NSLog(@" pop login page ");
  [SimuUtil performBlockOnMainThread:^{
    [[NSNotificationCenter defaultCenter] postNotificationName:LogonSuccess object:nil];
  } withDelaySeconds:0.1];

  [[NSNotificationCenter defaultCenter] postNotificationName:UpDataFromNet_WithMainController
                                                      object:@"upformNet_For_Userinfo"];
  [self resignKeyboardFirstResponder];
  [self netLoadingViewRelease];
  //登录成功提示
  [AppDelegate popViewController:NO];
}

/** 手机号是否绑定 */
-(void)userWhetherBindingPhone
{
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onSuccess = ^(NSObject *obj){
  };
  callback.onFailed = ^(){
    
  };
  callback.onError = ^(BaseRequestObject *obj, NSException *exc){
    
  };
  [GetUserBandPhoneNumber checkUserBindPhonerWithCallback:callback];
}


#pragma mark
#pragma mark--------------textField协议函数-------------------------
- (void)textFieldDidBeginEditing:(UITextField *)textField {
  [self retractTableView];
}

- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string {
  if (textField == userNameTextField) {
    if ([string isEqualToString:@"\n"]) {
      return YES;
    }
    return YES;
  } else {
    if ([string isEqualToString:@"\n"]) {
      return YES;
    }
    return YES;
  }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [self resignKeyboardFirstResponder];
  return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  if (historyTableView.frame.size.height > 10) {
    [self retractTableView];
  }
  [self resignKeyboardFirstResponder];
}

#pragma mark
#pragma mark--------辅助函数---------
- (void)sendMessageUpdataUserInfo {
  SimuAction *action = nil;
  action = [[SimuAction alloc] initWithCode:AC_UpDate_UserInfo ActionURL:nil];
  if (nil != action) {
    //关闭事件不用联网
    [[NSNotificationCenter defaultCenter] postNotificationName:SYS_VAR_NAME_DOACTION_MSG
                                                        object:action];
  }
}
- (void)leftButtonPress {
  [self resignKeyboardFirstResponder];
  [super leftButtonPress];
}
- (void)destoryCurrentView {
  //登录成功
  if (self.backHandlerInContainer) {
    self.backHandlerInContainer();
    return;
  }

  AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [AppDelegate popToViewController:app.viewController aminited:YES];
}
//进入主界面
- (void)showMainPageViewController {
  [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_SIMUSTOCK_VIEW object:nil];
}
//释放键盘
- (void)resignKeyboardFirstResponder {
  [userNameTextField resignFirstResponder];
  [passwordTextField resignFirstResponder];
}

@end
