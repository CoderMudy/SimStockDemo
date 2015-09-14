//
//  MyInfoViewController.m
//  SimuStock
//
//  Created by jhss on 14-7-31.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "MyInfoViewController.h"
#import "SimuUtil.h"
#import "event_view_log.h"

#import "ChangeUserInfoRequest.h"

#import "CacheUtil.h"
#import "NetLoadingWaitView.h"
#import "MyInformationCenterData.h"
#import "InviteCodeView.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "MyInfoTableViewCell.h"

@implementation MyInfoViewController
- (id)initWithTaskId:(NSString *)taskId {
  if (self = [super init]) {
    _taskId = taskId;
  }
  return self;
}

- (void)viewDidLoad {
  userInfoBinded = NO;
  [super viewDidLoad];
  [self createMainView];
  [self createTableview];
  [self createShowMyInfoUrl];

  _userInfoNotificationUtil = [[UserInfoNotificationUtil alloc] init];
  __weak MyInfoViewController *weakSelf = self;
  OnUserInfoChanging action = ^{
    [weakSelf updateUserInfo];

  };
  _userInfoNotificationUtil.onNicknameChangeAction = action;
  _userInfoNotificationUtil.onHeadPicChangeAction = action;
  _userInfoNotificationUtil.onSignatureChangeAction = action;
}

- (void)updateUserInfo {
  item.mNickName = [SimuUtil getUserNickName];
  item.mSignature = [SimuUtil getUserSignature];
  item.mHeadPic = [SimuUtil getUserImageURL];
  [myInformationTableView reloadData];
}

#pragma mark
#pragma mark------界面设计-------
//导航栏
- (void)createMainView {
  //回拉效果
  [_topToolBar resetContentAndFlage:@"个人信息" Mode:TTBM_Mode_Leveltwo];
  self.view.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];

  //配置多种账号绑定配置
  rowToBindTypeDic = [@{} mutableCopy];
  NSInteger row = 0;
  if ([WXApi isWXAppSupportApi]) {
    rowToBindTypeDic[@(row)] = @(UserLoginTypeWeixin);
    row++;
  }
  rowToBindTypeDic[@(row)] = @(UserLoginTypePhone);
  row++;
  if ([TencentOAuth iphoneQQInstalled]) {
    rowToBindTypeDic[@(row)] = @(UserLoginTypeQQ);
    row++;
  }
  rowToBindTypeDic[@(row)] = @(UserLoginTypeSinaWeibo);

  _indicatorView.delegate = self;
  [_indicatorView setButonIsVisible:NO];
}
- (void)createTableview {
  //表格
  CGRect frame = self.view.frame;
  myInformationTableView =
      [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - _topToolBar.frame.size.height)];
  myInformationTableView.delegate = self;
  myInformationTableView.dataSource = self;
  myInformationTableView.bounces = YES;
  myInformationTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  myInformationTableView.backgroundColor = [UIColor clearColor];

  //修改滚动条据右边的距离
  myInformationTableView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
  myInformationTableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -2);
  [self.clientView addSubview:myInformationTableView];
}

#pragma mark
#pragma mark------链接请求-------
- (void)createShowMyInfoUrl {
  if (!userInfoBinded) {
    MyInfomationItem *myinfo = [CacheUtil myInfomation];
    if (myinfo) {
      [self bindMyInfomationItem:myinfo];
    }
  }
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak MyInfoViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    MyInfoViewController *strongSelf = weakSelf;
    if ([_indicatorView isAnimating]) {
      [_indicatorView stopAnimating];
    }
    if (strongSelf) {
      [strongSelf.indicatorView stopAnimating];
      return NO;
    } else {
      return YES;
    }
  };
  callback.onSuccess = ^(NSObject *obj) {
    MyInfoViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindMyInfomationItem:(MyInfomationItem *)obj];
    }
  };
  if (![_indicatorView isAnimating]) {
    [_indicatorView startAnimating];
  }
  [MyInfomationItem requestMyInfomationWithCallBack:callback];
}

- (void)bindMyInfomationItem:(MyInfomationItem *)data {
  //个人信息数据
  item = data;
  userInfoBinded = YES;
  [CacheUtil saveUserInfomation:data];

  //刷新表格
  [myInformationTableView reloadData];
}

#pragma mark
#pragma mark-------表格显示--------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0) {
    return 4;
  } else {
    return rowToBindTypeDic.count;
  }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 50.0f;
}
- (void)tableView:(UITableView *)tableView
      willDisplayCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath {
  cell.backgroundColor = [UIColor clearColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  if (indexPath.section == 0) {
    //纪录日志
    [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button andCode:@"349"];
    switch (indexPath.row) {
    case 0: {
      changeHeadImageController =
          [[ChangeHeadImageController alloc] initWithNavigator:self.navigationController];
      [changeHeadImageController showActionSheet];
    } break;
    case 1: {
      //纪录日志_修改昵称
      [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button andCode:@"350"];
      [AppDelegate pushViewControllerFromRight:[[ChangeNickNameViewController alloc] initWithNickname:item.mNickName]];
    } break;
    case 2: {
      //用户名 do nothing
    } break;
    case 3: {
      //个人签名
      [AppDelegate pushViewControllerFromRight:[[PersonalSignatureViewController alloc] initWithSignature:item.mSignature]];
    } break;
    default:
      break;
    }
  } else if (indexPath.section == 1) {
    NSInteger bindType = [rowToBindTypeDic[@(indexPath.row)] integerValue];
    selectedRow = bindType;

    switch (bindType) {
    case UserLoginTypeWeixin: {
      BOOL bindable;
      if (item.bindDictionary[@(UserBindTypeWeixinRegister)]) {
        //不可解绑，直接返回
        return;
      }
      if (item.bindDictionary[@(UserBindTypeBindWeixin2Exist)]) {
        bindable = NO; //可解绑
      } else {
        bindable = YES; //可以解绑
      }
      [self selectThirdPratWay:UserLoginTypeWeixin withBind:bindable];
      break;
    }
    case UserLoginTypeQQ: { // qq栏选中
      BOOL bindable;
      if (item.bindDictionary[@(UserBindTypeQQ)]) {
        //不可解绑，直接返回
        return;
      }
      if (item.bindDictionary[@(UserBindTypeBindQQ2Exist)]) {
        bindable = NO; //可解绑
      } else {
        bindable = YES; //可以解绑
      }
      [self selectThirdPratWay:UserLoginTypeQQ withBind:bindable];
    } break;
    case UserLoginTypePhone: { //手机一栏选中
      [self row_PhoneNumber];
    } break;
    case UserLoginTypeSinaWeibo: { // sina栏选中
      BOOL bindable;
      if (item.bindDictionary[@(UserBindTypeSinaWeibo)]) {
        //不可解绑，直接返回
        return;
      }
      if (item.bindDictionary[@(UserBindTypeBindSinaWeibo2Exist)]) {
        bindable = NO; //可解绑
      } else {
        bindable = YES; //可以解绑
      }
      [self selectThirdPratWay:UserLoginTypeSinaWeibo withBind:bindable];
    } break;
    }
  }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
  if (section == 0) {
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, 116.0);
    InviteCodeView *inviteCodeView = [[InviteCodeView alloc] initWithFrame:frame];
    [inviteCodeView bindInviteCode:item];
    return inviteCodeView;
  } else {
    return nil;
  }
}

#pragma mark
#pragma mark---------手机号一栏--------
//绑定手机号
- (void)row_PhoneNumber {
  // false是普通用户注册
  BindStatus *bindStatus = item.bindDictionary[@(UserBindTypePhoneRegister)];
  BindStatus *bindPhoneStatus = item.bindDictionary[@(UserBindTypeBindPhone2Exist)];
  if (bindStatus || bindPhoneStatus) {
    //更换手机号
    BindingPhoneViewController *bindingVC =
        [[BindingPhoneViewController alloc] initWithFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN, HEIGHT_OF_SCREEN)];
    bindingVC.titleStr = @"绑定手机";
    bindingVC.hintString =
        @"绑" @"定" @"手机后，可以通过手机号登录和找回密码，提高" @"账户"
        @"安" @"全性。设置密码后可以通过手机号与" @"密码进行登录。";
    bindingVC.delegagte = self;
    self.hintString = @"更换";
    [AppDelegate pushViewControllerFromRight:bindingVC];
  } else {
    //绑定
    NSString *titleStr = @"绑定手机";
    NSString *hintStr =
        @"绑" @"定手机后，可以通过手机号登录和找回密码，提高账"
        @"户安全性。设置密码后可以通过手机号与密码进行登" @"录。";
    CGRect frame = CGRectMake(0, 0, WIDTH_OF_SCREEN, HEIGHT_OF_SCREEN);
    PhoneRegisterViewController *bindPhoneVC = [[PhoneRegisterViewController alloc] initWithFrame:frame
                                                                                   withTitleLabel:titleStr
                                                                                    withHintLabel:hintStr];
    bindPhoneVC.delegagte = self;
    //勿删
    bindPhoneVC.isSettingInfoPageInto = YES;
    self.hintString = @"绑定";
    [AppDelegate pushViewControllerFromRight:bindPhoneVC];
  }
}
- (void)returnVerifyPhoneNumber:(NSString *)phoneNumber withTitle:(NSString *)title {
  self.bindPhoneNumber = phoneNumber;
  [self createShowMyInfoUrl];
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  BindStatus *unBindableStatus = item.bindDictionary[@(UserBindTypePhoneRegister)];
  BindStatus *bindableStatus = item.bindDictionary[@(UserBindTypeBindPhone2Exist)];
  NSString *oldPhoneNumber;
  if (!unBindableStatus && !bindableStatus) {
    return;
  }

  pendingBindStatus = [[BindStatus alloc] init];
  pendingBindStatus.openId = phoneNumber;
  pendingBindStatus.type = unBindableStatus ? UserBindTypePhoneRegister : UserBindTypeBindPhone2Exist;
  pendingBindStatus.thirdNickname = phoneNumber;

  oldPhoneNumber = unBindableStatus ? unBindableStatus.thirdNickname : bindableStatus.thirdNickname;

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  //解析
  __weak MyInfoViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    MyInfoViewController *strongSelf = weakSelf;
    if (strongSelf) {
      return NO;
    } else
      return YES;
  };
  callback.onSuccess = ^(NSObject *obj) {
    MyInfoViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindSuccess];
    }
  };

  [ChangePhoneNumber changeBindingPhoneWithNewPhoneNumber:phoneNumber
                                       withOldPhoneNumber:oldPhoneNumber
                                             withCallBack:callback];
}
- (void)returnThirdBindPhoneNumber:(NSString *)phoneNumber withTitle:(NSString *)title {
  if (phoneNumber && phoneNumber.length > 0) {
    self.bindPhoneNumber = phoneNumber;
    pendingBindStatus = [[BindStatus alloc] init];
    pendingBindStatus.openId = phoneNumber;
    pendingBindStatus.type = UserBindTypeBindPhone2Exist;
    pendingBindStatus.thirdNickname = phoneNumber;
    [self bindSuccess];
  }
}

- (void)createResetPop:(NSString *)cardFunction withPrompt:(NSString *)prompt {
  CGRect frame = self.view.bounds;
  //灰色底图
  UIView *popBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
  popBackView.tag = 1001;
  popBackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
  [self.view addSubview:popBackView];
  //白色交互界面
  UIImage *backImage = [UIImage imageNamed:@"tipBackground"];
  backImage = [backImage resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
  UIImageView *popImageView = [[UIImageView alloc] initWithFrame:CGRectMake(35, 150, 250, 170)];
  popImageView.centerX = WIDTH_OF_SCREEN / 2;
  popImageView.centerY = HEIGHT_OF_SCREEN / 2;
  popImageView.userInteractionEnabled = YES;
  popImageView.image = backImage;
  [popBackView addSubview:popImageView];
  //顶部label
  UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 12, 80, 19)];
  headLabel.text = cardFunction;
  headLabel.backgroundColor = [UIColor clearColor];
  headLabel.textAlignment = NSTextAlignmentCenter;
  headLabel.textColor = [Globle colorFromHexRGB:@"2f2e2e"];
  headLabel.font = [UIFont systemFontOfSize:19];
  [popImageView addSubview:headLabel];
  //提示信息
  UILabel *promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 210, 75)];
  promptLabel.text = prompt;
  promptLabel.numberOfLines = 0;
  promptLabel.lineBreakMode = NSLineBreakByCharWrapping;
  promptLabel.backgroundColor = [UIColor clearColor];
  promptLabel.textAlignment = NSTextAlignmentLeft;
  promptLabel.textColor = [Globle colorFromHexRGB:@"545454"];
  promptLabel.font = [UIFont systemFontOfSize:Font_Height_16_0];
  [popImageView addSubview:promptLabel];
  //  确定，取消按钮
  UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
  okButton.frame = CGRectMake(20 + 20 + 95, 125, 95, 34);
  okButton.titleLabel.font = [UIFont systemFontOfSize:Font_Height_16_0];
  [okButton setTitle:@"确定" forState:UIControlStateNormal];
  UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
  cancelButton.frame = CGRectMake(20, 125, 95, 34);
  cancelButton.titleLabel.font = [UIFont systemFontOfSize:Font_Height_16_0];
  [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
  UIImage *buttonBackImage = [UIImage imageNamed:@"redButton_up"];
  UIImage *buttonDownImage = [UIImage imageNamed:@"redButton_down"];
  UIImage *cancelImage = [UIImage imageNamed:@"grayButton_UP"];
  UIImage *cancelHighlightImage = [UIImage imageNamed:@"grayButton_down"];
  cancelImage = [cancelImage resizableImageWithCapInsets:UIEdgeInsetsMake(13, 5, 16, 5)];
  cancelHighlightImage = [cancelHighlightImage resizableImageWithCapInsets:UIEdgeInsetsMake(13, 5, 16, 5)];
  buttonBackImage = [buttonBackImage resizableImageWithCapInsets:UIEdgeInsetsMake(13, 5, 16, 5)];
  buttonDownImage = [buttonDownImage resizableImageWithCapInsets:UIEdgeInsetsMake(13, 5, 16, 5)];
  [cancelButton setTitleColor:[Globle colorFromHexRGB:@"939393"] forState:UIControlStateNormal];
  [okButton setBackgroundImage:buttonBackImage forState:UIControlStateNormal];
  [okButton setBackgroundImage:buttonDownImage forState:UIControlStateHighlighted];
  [cancelButton setBackgroundImage:cancelImage forState:UIControlStateNormal];
  [cancelButton setBackgroundImage:cancelHighlightImage forState:UIControlStateHighlighted];
  [okButton addTarget:self
                action:@selector(confirmSelected:)
      forControlEvents:UIControlEventTouchUpInside];
  [cancelButton addTarget:self
                   action:@selector(cancelSelected:)
         forControlEvents:UIControlEventTouchUpInside];
  [popImageView addSubview:okButton];
  [popImageView addSubview:cancelButton];
}

- (void)confirmSelected:(UIButton *)button {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  //解析
  __weak MyInfoViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    MyInfoViewController *strongSelf = weakSelf;
    if (strongSelf) {
      return NO;
    } else
      return YES;
  };
  callback.onSuccess = ^(NSObject *obj) {
    MyInfoViewController *strongSelf = weakSelf;
    if (strongSelf) {
      //解绑手机号、解绑三方账号
      [self unbinding];
    }
  };
  //解绑
  BindStatus *bindStatus;
  switch (selectedRow) {
  case UserLoginTypePhone: {
    bindStatus = item.bindDictionary[@(UserBindTypeBindPhone2Exist)];
  } break;
  case UserLoginTypeQQ: {
    bindStatus = item.bindDictionary[@(UserBindTypeBindQQ2Exist)];
  } break;
  case UserLoginTypeSinaWeibo: {
    bindStatus = item.bindDictionary[@(UserBindTypeBindSinaWeibo2Exist)];
  } break;
  case UserLoginTypeWeixin: {
    bindStatus = item.bindDictionary[@(UserBindTypeBindWeixin2Exist)];
  } break;
  default:
    break;
  }

  [UnbindingPhoneOrThirdPart unbindingPhoneOrThirdPartWithPhoneNumberOrOpenID:bindStatus.openId
                                                                 withCallback:callback];

  UIImageView *backImageView = (UIImageView *)[self.view viewWithTag:1001];
  [backImageView removeFromSuperview];
}
- (void)cancelSelected:(UIButton *)button {
  UIImageView *backImageView = (UIImageView *)[self.view viewWithTag:1001];
  [backImageView removeFromSuperview];
}

- (void)unbinding {
  //解绑UI变化
  switch (selectedRow) {
  case UserLoginTypePhone: {
    [NewShowLabel setMessageContent:@"手机号更换成功"];
  } break;
  case UserLoginTypeQQ: {
    [item.bindDictionary removeObjectForKey:@(UserBindTypeBindQQ2Exist)];
    [NewShowLabel setMessageContent:@"QQ解绑成功"];
  } break;
  case UserLoginTypeSinaWeibo: {
    [item.bindDictionary removeObjectForKey:@(UserBindTypeBindSinaWeibo2Exist)];
    [NewShowLabel setMessageContent:@"新浪微博解绑成功"];
  } break;
  case UserLoginTypeWeixin: {
    [item.bindDictionary removeObjectForKey:@(UserBindTypeBindWeixin2Exist)];
    [NewShowLabel setMessageContent:@"微信解绑成功"];
  } break;
  default:
    break;
  }
  [myInformationTableView reloadData];
}

#pragma mark------三方解绑------
- (void)thirdPartUnbind {
}
#pragma mark------三方绑定------
- (void)selectThirdPratWay:(NSInteger)logonType withBind:(BOOL)bind {

  if (bind) { //绑定
    ThirdWayLogon *thirdWayLogon = [[ThirdWayLogon alloc] init];
    thirdWayLogon.delegate = self;
    switch (logonType) {
    case UserLoginTypeQQ:
      [thirdWayLogon getAuthWithShareType:ShareTypeQQSpace];
      break;
    case UserLoginTypeSinaWeibo:
      [thirdWayLogon getAuthWithShareType:ShareTypeSinaWeibo];
      break;
    case UserLoginTypeWeixin:
      [thirdWayLogon getAuthWithShareType:ShareTypeWeixiSession];
      break;

    default:
      break;
    }
  } else { //解绑
    NSString *template = @"解绑后将无法使用“%@" @"”" @"登" @"录，确定要" @"解" @"绑吗" @"?";
    NSString *prompt;
    switch (logonType) {
    case UserLoginTypeQQ:
      prompt = [NSString stringWithFormat:template, @"QQ账号"];
      break;
    case UserLoginTypeSinaWeibo:
      prompt = [NSString stringWithFormat:template, @"新浪微博账号"];
      break;
    case UserLoginTypeWeixin:
      prompt = [NSString stringWithFormat:template, @"微信账号"];
      break;

    default:
      break;
    }
    if (prompt) {
      [self createResetPop:@"解绑" withPrompt:prompt];
    }
  }
}
#pragma mark-------三方绑定获得数据后，回调-------
- (void)rowThirdPartWithToken:(NSString *)token
                   withOpenId:(NSString *)openId
                 withNickName:(NSString *)nickName
                     withType:(UserBindType)type {

  pendingBindStatus = [[BindStatus alloc] init];
  pendingBindStatus.thirdNickname = nickName;
  pendingBindStatus.type = type;
  pendingBindStatus.token = token;
  pendingBindStatus.openId = openId;

  if ([NetLoadingWaitView isAnimating]) {
    [NetLoadingWaitView stopAnimating];
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  //解析
  __weak MyInfoViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    MyInfoViewController *strongSelf = weakSelf;
    if (strongSelf) {
      return NO;
    } else
      return YES;
  };
  callback.onSuccess = ^(NSObject *obj) {
    MyInfoViewController *strongSelf = weakSelf;
    if (strongSelf) {
      JsonRequestObject *result = (JsonRequestObject *)obj;
      if ([result isOK]) {
        //三方绑定
        [strongSelf bindSuccess];
      } else { //异常处理：0001: 您已经绑定相关账号
               //        [NewShowLabel setMessageContent:result.message];
        [strongSelf bindExceptionHandling];
      }
    }
  };
  [BindingMyAccount bindingMyAccountWithToken:token
                                   withOpenId:openId
                                 withNickName:nickName
                                     withType:[@(type) stringValue]
                                 withCallback:callback];
}

#pragma mark------解绑，绑定UI-----
- (void)bindSuccess {
  if (pendingBindStatus) {
    switch (selectedRow) {
    case UserLoginTypePhone: {
      NSString *str = [NSString stringWithFormat:@"手机号%@成功", self.hintString];
      [NewShowLabel setMessageContent:str];
    } break;
    case UserLoginTypeQQ: {
      [NewShowLabel setMessageContent:@"QQ绑定成功"];
    } break;
    case UserLoginTypeSinaWeibo: {
      [NewShowLabel setMessageContent:@"新浪微博绑定成功"];
    } break;
    case UserLoginTypeWeixin: {
      [NewShowLabel setMessageContent:@"微信绑定成功"];
    } break;
    default:
      break;
    }
    item.bindDictionary[@(pendingBindStatus.type)] = pendingBindStatus;
    [myInformationTableView reloadData];
  }
}
///绑定异常处理
- (void)bindExceptionHandling {
  switch (selectedRow) {
  case UserLoginTypePhone: {
    [NewShowLabel setMessageContent:@"该手机号已绑定其他优顾账号"];
  } break;
  case UserLoginTypeQQ: {
    [NewShowLabel setMessageContent:@"该QQ账号已绑定其他优顾账号"];
  } break;
  case UserLoginTypeSinaWeibo: {
    [NewShowLabel setMessageContent:@"该微博账号已绑定其他优顾账号"];
  } break;
  case UserLoginTypeWeixin: {
    [NewShowLabel setMessageContent:@"该微信账号已绑定其他优顾账号"];
  } break;
  default:
    break;
  }
}
#pragma mark-------end-------
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  if (section == 0) {
    return 116.0;
  } else {
    return 0;
  }
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *ID = @"MyInfoTableViewCell";
  MyInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:self options:nil] lastObject];
    ;
  }

  [cell bindUserInfo:item withIndexPath:indexPath withRowToBindTypeDic:rowToBindTypeDic];
  [cell.topSplitView resetViewWidth:tableView.width];
  [cell.bottomSplitView resetViewWidth:tableView.width];
  return cell;
}

#pragma 表格点击事件

#pragma mark-----上一菜单------
//回调左上侧按钮的协议事件
//左边按钮按下
- (void)leftButtonPress {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [super leftButtonPress];
  myInformationTableView.delegate = nil;
  myInformationTableView.dataSource = nil;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [AppDelegate navigationController:self.navigationController willShowViewController:self];
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
  [AppDelegate navigationController:navigationController willShowViewController:viewController];
}

@end
