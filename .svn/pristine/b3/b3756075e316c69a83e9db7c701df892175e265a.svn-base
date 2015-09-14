//
//  BindingViewController.m
//  SimuStock
//
//  Created by jhss on 13-10-29.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "BindingViewController.h"
#import "SimuUtil.h"
#import "SimuAction.h"
#import "event_view_log.h"
#import "MobClick.h"
#import "NetLoadingWaitView.h"
#import "UIImage+ColorTransformToImage.h"
#import "NewShowLabel.h"
#import "ThirdBindingResult.h"
#import "BaseRequester.h"

@implementation BindingViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self createMainView];
}
#pragma mark
#pragma mark------界面------
- (void)createMainView {
  CGRect frame = self.view.frame;

  if ([self.logonType integerValue] == 3) {
    //纪录日志
    [[event_view_log sharedManager]
        addPVAndButtonEventToLog:Log_Type_PV
                         andCode:@"登录页-新浪微博登录"];
    [MobClick beginLogPageView:@"登录页-新浪微博登录"];
  } else {
    //记录日志
    [[event_view_log sharedManager]
        addPVAndButtonEventToLog:Log_Type_PV
                         andCode:@"登录页-QQ登录"];
    [MobClick beginLogPageView:@"登录页-QQ登录"];
  }
  self.view.backgroundColor = [UIColor whiteColor];
  _indicatorView.hidden = YES;
  [_topToolBar resetContentAndFlage:_titleName Mode:TTBM_Mode_Leveltwo];
  //用户头像
  UIImageView *headImageViewBackImageView = [[UIImageView alloc]
      initWithFrame:CGRectMake(frame.size.width / 2 - 36, 8, 72, 72)];
  headImageViewBackImageView.image = [UIImage imageNamed:@"圆形背景"];
  [self.clientView addSubview:headImageViewBackImageView];
  CALayer *headImageVBLayer = headImageViewBackImageView.layer;
  [headImageVBLayer setMasksToBounds:YES];
  [headImageVBLayer setCornerRadius:36];
  headImageViewBackImageView.layer.borderColor =
      [Globle colorFromHexRGB:@"e0e0e0"].CGColor;
  headImageViewBackImageView.layer.borderWidth = 1;
  UIImageView *headImageView =
      [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 68, 68)];

  [JhssImageCache setImageView:headImageView
                       withUrl:_headImage
          withDefaultImageName:@"用户默认头像"];
  CALayer *headLayer = headImageView.layer;
  [headLayer setMasksToBounds:YES];
  [headLayer setCornerRadius:34];
  [self.clientView addSubview:headImageViewBackImageView];
  [headImageViewBackImageView addSubview:headImageView];

  //分割线
  UILabel *cuttingLineLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(side_edge_width, 131,
                               self.view.frame.size.width - side_edge_width * 2,
                               0.5f)];
  cuttingLineLabel.backgroundColor = [Globle colorFromHexRGB:@"086dae"];
  [self.clientView addSubview:cuttingLineLabel];
  //昵称：
  UILabel *nickNameLab = [[UILabel alloc]
      initWithFrame:CGRectMake(cuttingLineLabel.origin.x + 10,
                               cuttingLineLabel.origin.y - 22, 50.0, 20.0)];
  nickNameLab.backgroundColor = [UIColor clearColor];
  nickNameLab.textColor = [UIColor colorWithRed:39.0 / 255.0
                                          green:107.0 / 255.0
                                           blue:173.0 / 255.0
                                          alpha:1.0];
  nickNameLab.textAlignment = NSTextAlignmentLeft;
  nickNameLab.font = [UIFont systemFontOfSize:Font_Height_16_0];
  nickNameLab.text = @"昵称：";
  [self.clientView addSubview:nickNameLab];

  //字体大小可能给人视觉误差，所以要靠下摆放
  nickNameTextField = [[UITextField alloc]
      initWithFrame:CGRectMake(cuttingLineLabel.origin.x + 40 + 30,
                               cuttingLineLabel.origin.y - 22,
                               frame.size.width - side_edge_width * 2 - 40 * 2,
                               20)];
  nickNameTextField.delegate = self;
  nickNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
  nickNameTextField.text = _nickName;
  thirdPartNickName = _nickName;
  nickNameTextField.placeholder = @"请输入用户名";
  nickNameTextField.font = [UIFont systemFontOfSize:Font_Height_16_0];
  nickNameTextField.backgroundColor = [UIColor clearColor];
  [self.clientView addSubview:nickNameTextField];
  //完成按钮
  UIButton *successButton = [UIButton buttonWithType:UIButtonTypeCustom];
  successButton.frame =
      CGRectMake(side_edge_width, cuttingLineLabel.origin.y + 43 + 40,
                 frame.size.width - side_edge_width * 2, 35);

  UIImage *successNormalImage =
      [UIImage imageFromView:successButton
          withBackgroundColor:[Globle colorFromHexRGB:@"086dae"]];
  [successButton setBackgroundImage:successNormalImage
                           forState:UIControlStateNormal];
  [successButton setBackgroundImage:[UIImage imageNamed:@"return_touch_down"]
                           forState:UIControlStateHighlighted];
  [successButton setTitleColor:[UIColor whiteColor]
                      forState:UIControlStateNormal];
  [successButton addTarget:self
                    action:@selector(registerComplete)
          forControlEvents:UIControlEventTouchUpInside];
  [successButton setTitle:@"完成" forState:UIControlStateNormal];
  [self.clientView addSubview:successButton];
  //第三方icon
  UIImageView *iconImageView =
      [[UIImageView alloc] initWithImage:[UIImage imageNamed:_thirdPartIcon]];
  iconImageView.bounds = CGRectMake(0, 0, 33, 30);
  iconImageView.center =
      CGPointMake(frame.size.width / 2, cuttingLineLabel.origin.y + 200);
  [self.clientView addSubview:iconImageView];
}

#pragma mark
#pragma mark---------数据解析-----
/**
 *释放键盘
 */
- (void)resignKeyboardFirstResponder {
  [nickNameTextField resignFirstResponder];
  //  [inviteField resignFirstResponder];
}
#pragma mark
#pragma mark-------完成按钮-----
- (void)registerComplete {
  //过滤两侧空格
  NSString *tempNickNameStr = [nickNameTextField.text
      stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  if ([tempNickNameStr length] == 0) {
    [NewShowLabel setMessageContent:@"请输入昵称"];
    return;
  } else if ([tempNickNameStr length] < 3) {
    [NewShowLabel setMessageContent:@"昵称长度为3-12位"];
    return;
  }
  //  else if (![[ConditionsWithKeyBoardUsing shareInstance]
  //                 isNumbersOrLetters:inviteField.text]) {
  //    [NewShowLabel setMessageContent:@"邀请码只能为字母或数字"];
  //    return;
  //  }
  NSString *inviteCode = @"";
  if ([inviteField.text length] <= 10 && [inviteField.text length] > 0) {
    inviteCode = inviteField.text;
  }
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel setMessageContent:REQUEST_FAILED_MESSAGE];
    return;
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  //解析
  __weak BindingViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    BindingViewController *strongSelf = weakSelf;
    if (strongSelf) {
      if ([NetLoadingWaitView isAnimating]) {
        [NetLoadingWaitView stopAnimating];
      }
      return NO;
    } else
      return YES;
  };
  callback.onSuccess = ^(NSObject *obj) {
    BindingViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf resignKeyboardFirstResponder];
      [strongSelf switchPage];
    }
  };
  //请求开始
  if (![NetLoadingWaitView isAnimating]) {
    [NetLoadingWaitView startAnimating];
  }
  [ThirdBindingResult registerOfThirdPartWithOpenId:_uid
                                      withLogonType:_logonType
                                    withNewNickName:tempNickNameStr
                                    withOldNickName:thirdPartNickName
                                      withHeadImage:_headImage
                                     withInviteCode:inviteCode
                                       withCallBack:callback];
}
- (void)switchPage {
  //登录日志
  [[event_view_log sharedManager] addLoginEventToLog];
  //保存图片

  if (!_headImage) {
    _headImage = @"";
  }
  [SimuUtil setUserImageURL:_headImage];

  //更新用户头像和昵称,uid
  UITextField *nickNameTextfield = (UITextField *)[self.view viewWithTag:101];
  [SimuUtil setUserNiceName:nickNameTextfield.text];

  //切换界面
  //登录成功提示，更新主界面数据
  [self saveSessionIdSavedTime];
  [[NSNotificationCenter defaultCenter] postNotificationName:LogonSuccess
                                                      object:nil];
  [self sendMessageUpdataUserInfo];
  [self performSelector:@selector(updateMainViewController)
             withObject:nil
             afterDelay:0.5];
  //先删除当前界面
  [super leftButtonPress];
}
#pragma mark
#pragma mark-------记录登录时间---------
//保存sid
- (void)saveSessionIdSavedTime {
  [SimuUser setSessionSavedTime:[NSDate timeIntervalSinceReferenceDate]];
}
#pragma mark
#pragma mark---------------------切换效果及辅助函数----------------------------------
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
#pragma mark -textfield协议函数
- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string {
  //改变过程中保存用户昵称
  self.nickName = textField.text;
  if ([string isEqualToString:@"\n"]) {
    return YES;
  }
  NSString *toBeString =
      [textField.text stringByReplacingCharactersInRange:range
                                              withString:string];
  if ([toBeString length] > 11) {
    textField.text = [toBeString substringToIndex:12];
    return NO;
  }
  return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self resignKeyboardFirstResponder];
}
//回调左上侧按钮的协议事件
//左边按钮按下
- (void)leftButtonPress {
  [self resignKeyboardFirstResponder];
  UIAlertView *alertView =
      [[UIAlertView alloc] initWithTitle:@"取消授权"
                                 message:@"您确定取消授权？"
                                delegate:self
                       cancelButtonTitle:@"取消"
                       otherButtonTitles:@"确定", nil];
  if ([_titleName isEqualToString:@"新浪微博"]) {
    alertView.tag = ShareTypeSinaWeibo;
  } else if ([_titleName isEqualToString:@"微信"]) {
    alertView.tag = ShareTypeWeixiSession;
  } else {
    alertView.tag = ShareTypeQQSpace;
  }
  [alertView show];
}
- (void)alertView:(UIAlertView *)alertView
    clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 1) {
    //如果返回则取消授权操作
    [ShareSDK cancelAuthWithType:(ShareType)alertView.tag];
    [super leftButtonPress];
  }
}
- (void)dealloc {
  if ([self.logonType integerValue] == 3) {
    [MobClick endLogPageView:@"登录页-新浪微博登录"];
  } else {
    [MobClick endLogPageView:@"登录页-QQ登录"];
  }
}
@end
