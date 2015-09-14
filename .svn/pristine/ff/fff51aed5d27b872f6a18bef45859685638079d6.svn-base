//
//  SettingsBaseViewController.m
//  SimuStock
//
//  Created by jhss on 13-9-9.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "SettingsBaseViewController.h"
#import "ApplicationRecomendViewController.h"
#import "AboutUsViewController.h"
#import "FeedBackViewController.h"
//设置箭头按钮

#import "NetLoadingWaitView.h"
#import "event_view_log.h"
#import "MobClick.h"

#import "SettingCell.h"
#import "MyInfoViewController.h"
#import "ChangePasswordViewController.h"
#import "UIImage+ColorTransformToImage.h"
#import "SchollWebViewController.h"

#import "RefrashTimeTableViewCell.h"

@implementation SettingsBaseViewController

- (id)init {

  if (self = [super init]) {
    //选择控制器内容
    pickerData = @[ @"手动刷新", @"5秒", @"10秒", @"20秒", @"30秒" ];

    //数据
    settingList = @[
      @"个人信息",
      @"修改密码",
      @"推送消息",
      @"行情刷新频率",
      @"给我好评",
      @"意见反馈",
      @"帮助中心",
      @"关于我们"
    ];
  }
  return self;
}
- (void)BPushMasterSwitchClick {
  if (settingsTableView) {
    [settingsTableView reloadData];
  }
}
- (void)viewDidLoad {
  [super viewDidLoad];
  [self createMainView];

  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(BPushMasterSwitchClick)
             name:@"BPushMasterSwitch"
           object:nil];
  //记录日志
  [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_PV
                                                   andCode:@"设置"];
  [MobClick beginLogPageView:@"设置"];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self refreshCurrentPage];
}

#pragma mark
#pragma mark-----刷新当前界面----
//主要由-退出登录按钮
- (void)refreshCurrentPage {
  if (![SimuUtil isLogined]) {
    footerButton.hidden = YES;
  } else {
    footerButton.hidden = NO;
  }
}
#pragma mark
#pragma mark------界面设计------
//主视图
- (void)createMainView {
  NSInteger app_number =
      [[UIApplication sharedApplication] applicationIconBadgeNumber];
  if (app_number == 1) {
    stmv_isNewVersion = YES;
  } else {
    stmv_isNewVersion = NO;
  }
  CGRect frame = self.clientView.bounds;
  self.view.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  //抽屉阴影
  _indicatorView.hidden = YES;
  [_topToolBar resetContentAndFlage:@"设置" Mode:TTBM_Mode_Leveltwo];
  //表格
  settingsTableView = [[UITableView alloc]
      initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
  settingsTableView.dataSource = self;
  settingsTableView.delegate = self;
  settingsTableView.showsVerticalScrollIndicator = NO;
  settingsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  [self.clientView addSubview:settingsTableView];
  //顶部白色区域，高度为7
  headView =
      [[UIView alloc] initWithFrame:CGRectMake(0, 45, frame.size.width, 0)];
  headView.backgroundColor = [UIColor clearColor];
  settingsTableView.tableHeaderView = headView;
  //底部白色底图
  footView =
      [[UIView alloc] initWithFrame:CGRectMake(0, 10, frame.size.width, 58)];
  footView.backgroundColor = [UIColor clearColor];
  //退出登录按钮
  footerButton = [UIButton buttonWithType:UIButtonTypeCustom];
  footerButton.frame =
      CGRectMake(10, 10, self.view.frame.size.width - 10 * 2, 38);

  if ([[SimuUtil getUserID] length] < 3 &&
      [[SimuUtil getSesionID] length] < 3) {
    footerButton.hidden = YES;
  } else {
    footerButton.hidden = NO;
  }
  UIImage *loginImage =
      [UIImage imageFromView:footerButton
          withBackgroundColor:[Globle colorFromHexRGB:@"a61a1d"]];
  UIImage *loginDownImage =
      [UIImage imageFromView:footerButton withIndex:logout_button_index];
  [footerButton setBackgroundImage:loginDownImage
                          forState:UIControlStateNormal];
  [footerButton setBackgroundImage:loginImage
                          forState:UIControlStateHighlighted];
  [footerButton setTitle:@"退出登录" forState:UIControlStateNormal];
  footerButton.titleLabel.font = [UIFont systemFontOfSize:Font_Height_16_0];
  [footerButton setTitleColor:[UIColor whiteColor]
                     forState:UIControlStateNormal];
  [footerButton addTarget:self
                   action:@selector(logoutSimuStock:)
         forControlEvents:UIControlEventTouchUpInside];
  [footView addSubview:footerButton];
  settingsTableView.tableFooterView = footView;
}
- (void)logoutSimuStock:(UIButton *)button {
  [self clearCache];
  //确定用户是否登出
  //纪录日志
  if (logonOutAlertView == nil) {
    [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button
                                                     andCode:@"155"];
    logonOutAlertView =
        [[UIAlertView alloc] initWithTitle:@"退出登录"
                                   message:@"确定要退出吗？"
                                  delegate:self
                         cancelButtonTitle:@"取消"
                         otherButtonTitles:@"确定", nil];
    logonOutAlertView.tag = 2220;
  }
  [logonOutAlertView show];
}
- (void)alertView:(UIAlertView *)alertView
    clickedButtonAtIndex:(NSInteger)buttonIndex {

  if (alertView.tag == 2053) {
    //    if (buttonIndex == 0) {
    //      return;
    //    } else if (buttonIndex == 1) {
    //      UIImageView *pigeonImageView = (UIImageView *)[self.view
    //      viewWithTag:199];
    //      pigeonImageView.hidden = YES;
    //      [[NSUserDefaults standardUserDefaults] setObject:@""
    //                                                forKey:@"pigeonStatus"];
    //      [[NSUserDefaults standardUserDefaults] synchronize];
    //      pigeonImageView.image = [UIImage imageNamed:@""];
    //      [self cancelPush];
    //      //刷新下表格
    //      [settingsTableView reloadData];
    //    }
  } else if (alertView.tag == 2220) {
    //退出登录
    if (buttonIndex == 0) {
      NSLog(@"取消");
    } else {
      [SimuUser onLoginOut];

      [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_PV
                                                       andCode:@"登录页"];

      //切换到登录页面
      [self leftButtonPress];
    }

  } else {
    if (scoreAlertView) {
      if (buttonIndex == 1) {

        NSString *url =
            [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/"
                                       @"WebObjects/MZStore.woa/wa/"
                                       @"viewContentsUserReviews?type=Purple+"
                                       @"Software&id=%@",
                                       [SimuUtil appid]];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
          url = [NSString
              stringWithFormat:@"itms-apps://itunes.apple.com/us/app/id%@?mt=8",
                               [SimuUtil appid]];
        }
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
      }
      return;
    }
    if (alertView.tag == 10000) {
      if (buttonIndex == 1) {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        NSString *urlStr = [NSString
            stringWithFormat:@"itms-apps://itunes.apple.com/us/app/id%@?mt=8",
                             [SimuUtil appid]];
        NSURL *url = [NSURL URLWithString:urlStr];
        [[UIApplication sharedApplication] openURL:url];
      }
    } else {
    }
  }
}

//重置sid
- (void)saveSessionIdSavedTime {
  [SimuUser setSessionSavedTime:0];
}
#pragma mark
#pragma mark------清理排行的缓存-----
//一天期限
- (void)clearCache {
  //如果更换其他的参数的话，即可清理对应存储策略的缓存数据
  //  AppDelegate *appDelegate =
  //      (AppDelegate *)[[UIApplication sharedApplication] delegate];
  //  [appDelegate.Rankcache clearCachedResponsesForStoragePolicy:
  //                             ASICachePermanentlyCacheStoragePolicy];
}

#pragma mark
#pragma mark--------刷新频率确定与取消-----------
- (void)isOK {

  popBackView.hidden = YES;

  pickIndex = colorView.tag;
  if (pickIndex <= [pickerData count] - 1) {
    //保存下刷新数据
    tempPicker = pickerData[pickIndex];
    //行情定时刷新变化
    [SimuUtil setCorRefreshTime:tempPicker];
    [SimuUtil setMarketRefreshTime:[NSString stringWithFormat:@"%ld",
                                                              (long)pickIndex]];
    [[NSNotificationCenter defaultCenter] postNotificationName:Timer_Refresh
                                                        object:nil];
    [settingsTableView reloadData];
  }
}
#pragma mark
#pragma mark----------创建选择函数-----------
- (void)createPickerView {
  if (popBackView == nil) {
    CGRect frame = self.clientView.frame;
    //灰色底图
    popBackView = [[UIView alloc]
        initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    popBackView.tag = 1001;
    popBackView.userInteractionEnabled = YES;
    popBackView.backgroundColor =
        [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [self.clientView addSubview:popBackView];

    pickerBackImageView = [[UIImageView alloc]
        initWithFrame:CGRectMake(WIDTH_OF_SCREEN / 2 - 255 / 2,
                                 (popBackView.height - 20 - 250) / 2, 255,
                                 250)];
    pickerBackImageView.userInteractionEnabled = YES;
    pickerBackImageView.layer.cornerRadius = 5;
    pickerBackImageView.clipsToBounds = YES;
    pickerBackImageView.backgroundColor = [UIColor whiteColor];
    [popBackView addSubview:pickerBackImageView];

    colorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    colorView.layer.cornerRadius = 12;
    colorView.tag = [[SimuUtil getMarketRefreshTime] intValue];
    colorView.backgroundColor = [Globle colorFromHexRGB:Color_Blue_butDown];
    //刷新栏
    CGRect pickerRect = CGRectMake(0, 0, 255, 250);

    UITableView *refrash_tableView =
        [[UITableView alloc] initWithFrame:pickerRect];
    refrash_tableView.tag = 2000;
    refrash_tableView.delegate = self;
    refrash_tableView.dataSource = self;
    refrash_tableView.bounces = NO;
    refrash_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [pickerBackImageView addSubview:refrash_tableView];

  } else {
    popBackView.hidden = NO;
  }
}

#pragma mark
#pragma mark------版本更新相关------

- (void)onCheckVersion {
  NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
  // CFShow((__bridge CFTypeRef)(infoDic));
  NSString *currentVersion = infoDic[@"CFBundleVersion"];

  NSString *URL =
      [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",
                                 [SimuUtil appid]];
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
  [request setURL:[NSURL URLWithString:URL]];
  [request setHTTPMethod:@"POST"];
  NSHTTPURLResponse *urlResponse = nil;
  NSError *error = nil;
  NSData *recervedData = [NSURLConnection sendSynchronousRequest:request
                                               returningResponse:&urlResponse
                                                           error:&error];

  [NetLoadingWaitView stopAnimating];

  NSString *results = [[NSString alloc] initWithBytes:[recervedData bytes]
                                               length:[recervedData length]
                                             encoding:NSUTF8StringEncoding];
  NSLog(@"results:%@", results);
  NSDictionary *dic = [results objectFromJSONString];
  NSLog(@"dic:%@", dic);
  NSArray *infoArray = dic[@"results"];
  if ([infoArray count]) {
    NSDictionary *releaseInfo = infoArray[0];
    NSString *lastVersion = releaseInfo[@"version"];

    if (![lastVersion isEqualToString:currentVersion]) {
      // trackViewURL = [releaseInfo objectForKey:@"trackVireUrl"];
      UIAlertView *alert = [[UIAlertView alloc]
              initWithTitle:@"升级提示"
                    message:@" \"优顾炒股\" "
                    @"已推出了新版，便于您使用体验，请升级。"
                   delegate:self
          cancelButtonTitle:@"取消"
          otherButtonTitles:@"升级", nil];
      alert.tag = 10000;
      [alert show];
    } else {
      UIAlertView *alert =
          [[UIAlertView alloc] initWithTitle:@"升级提示"
                                     message:@"此版本为最新版本"
                                    delegate:self
                           cancelButtonTitle:@"确定"
                           otherButtonTitles:nil, nil];
      alert.tag = 10001;
      [alert show];
    }
  }
}

- (void)onCheckVersionForSevers {
  if ([NetLoadingWaitView isAnimating])
    [NetLoadingWaitView startAnimating];

  [self performBlock:^{
    if ([NetLoadingWaitView isAnimating])
      [NetLoadingWaitView stopAnimating];
  } withDelaySeconds:8];

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak SettingsBaseViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    if ([NetLoadingWaitView isAnimating])
      [NetLoadingWaitView stopAnimating];
    return NO;
  };
  callback.onSuccess = ^(NSObject *obj) {
    AppUpdateInfo *appUpdateInfo = (AppUpdateInfo *)obj;
    [weakSelf bindAppUpdateInfo:appUpdateInfo];
  };
  [AppUpdateInfo checkLatestAppVersion:callback];
}

- (void)bindAppUpdateInfo:(AppUpdateInfo *)appUpdateInfo {
  if ([appUpdateInfo.status isEqualToString:ALREADY_LATEST_APP]) {

    //最新版本
    UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"升级提示"
                                   message:@"此版本为最新版本"
                                  delegate:self
                         cancelButtonTitle:@"确定"
                         otherButtonTitles:nil, nil];
    alert.tag = 10001;
    [alert show];
  } else {
    //普通升级
    NSString *titel =
        [NSString stringWithFormat:@"发现新版本%@", appUpdateInfo.version];
    NSString *content =
        [NSString stringWithFormat:@"%@", appUpdateInfo.message];
    UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:titel
                                   message:content
                                  delegate:self
                         cancelButtonTitle:@"下次再说"
                         otherButtonTitles:@"立即更新", nil];
    alert.tag = 10000;
    [alert show];
  }
}
#pragma mark
#pragma mark-------tableView协议函数--------
- (void)tableView:(UITableView *)tableView
      willDisplayCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath {
  cell.backgroundColor = [UIColor clearColor];
}
- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {

  if (tableView.tag == 2000) {
    return [pickerData count];
  }

  return [settingList count];
}
- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  //刷新时间选择
  if (tableView.tag == 2000) {
    return 50.0f;
  }

  if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4) {
    return 55.0f;
  } else {
    return 48.0f;
  }
}
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (tableView.tag == 2000) {
    RefrashTimeTableViewCell *cell =
        (RefrashTimeTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    colorView.tag = indexPath.row;
    [cell.selectedbtn addSubview:colorView];
    [self isOK];
  }
}
//软件升级
- (void)updateApp:(NSNotification *)notification {
}

#pragma mark----------结束---------
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (tableView.tag == 2000) {
    static NSString *RefrashTimeID = @"RefrashTimecell";
    RefrashTimeTableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:RefrashTimeID];
    if (cell == nil) {
      cell = [[RefrashTimeTableViewCell alloc]
            initWithStyle:UITableViewCellStyleDefault
          reuseIdentifier:RefrashTimeID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.TitleLable.text = pickerData[indexPath.row];
    if (indexPath.row == colorView.tag) {
      [cell.selectedbtn addSubview:colorView];
    }
    return cell;
  }

  if (indexPath.row > [settingList count]) {
    return nil;
  }
  static NSString *ID = @"cell";
  SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
  if (cell == nil) {
    CGRect frame = self.view.frame;
    if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4) {
      frame = CGRectMake(0, 0, frame.size.width, 55.0f);
    } else {
      frame = CGRectMake(0, 0, frame.size.width, 48.0f);
    }
    cell = [[SettingCell alloc] initWithFrame:frame];
  }
  if (indexPath.row == 5 || indexPath.row == 6) {
    cell.height = 48.0f;
    //中间行
    UIImage *rowBackImage = [UIImage imageNamed:@"列表02"];
    rowBackImage = [rowBackImage
        resizableImageWithCapInsets:UIEdgeInsetsMake(14, 4, 14, 4)];
    [cell.settingBackImageView setImage:rowBackImage];
    //选中图片添加
    UIImage *rowButtonBackImage = [UIImage imageNamed:@"select_middle"];
    rowButtonBackImage = [rowButtonBackImage
        resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    [cell.settingButton setBackgroundImage:rowButtonBackImage
                                  forState:UIControlStateHighlighted];
    [cell.settingButton addTarget:self
                           action:@selector(clickRow:)
                 forControlEvents:UIControlEventTouchUpInside];
    cell.settingButton.tag = indexPath.row + 200;
    //显示分界线
    cell.upView.hidden = NO;
    cell.downView.hidden = NO;
  } else if (indexPath.row == 1 || indexPath.row == 3 || indexPath.row == 7) {
    cell.height = 48.0f;
    //末行
    UIImage *rowBackImage = [UIImage imageNamed:@"列表_03"];
    rowBackImage = [rowBackImage
        resizableImageWithCapInsets:UIEdgeInsetsMake(2, 15, 12, 15)];
    [cell.settingBackImageView setImage:rowBackImage];
    //选中图片添加
    UIImage *rowButtonBackImage = [UIImage imageNamed:@"select_down"];
    rowButtonBackImage = [rowButtonBackImage
        resizableImageWithCapInsets:UIEdgeInsetsMake(2, 8, 10, 8)];
    [cell.settingButton setBackgroundImage:rowButtonBackImage
                                  forState:UIControlStateHighlighted];
    [cell.settingButton addTarget:self
                           action:@selector(clickRow:)
                 forControlEvents:UIControlEventTouchUpInside];
    cell.settingButton.tag = indexPath.row + 200;
    //显示分界线
    cell.upView.hidden = NO;
    cell.downView.hidden = NO;
  } else if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4) {
    cell.height = 55.0f;
    UIImage *rowBackImage = [UIImage imageNamed:@"列表01"];
    rowBackImage = [rowBackImage
        resizableImageWithCapInsets:UIEdgeInsetsMake(10, 11, 10, 11)];
    [cell.settingBackImageView setImage:rowBackImage];
    //选中图片添加
    UIImage *rowButtonBackImage = [UIImage imageNamed:@"select_up"];
    rowButtonBackImage = [rowButtonBackImage
        resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    [cell.settingButton setBackgroundImage:rowButtonBackImage
                                  forState:UIControlStateHighlighted];
    [cell.settingButton addTarget:self
                           action:@selector(clickRow:)
                 forControlEvents:UIControlEventTouchUpInside];
    cell.settingButton.tag = indexPath.row + 200;
    //隐藏分界线
    cell.upView.hidden = YES;
    cell.downView.hidden = YES;
  }

  cell.refreshLabel.top = 16.0f;
  //刷新频率
  if (indexPath.row == 3) {
    cell.arrowImageView.hidden = YES;
    cell.arrowImageView.image = [UIImage imageNamed:@""];
    cell.refreshLabel.hidden = NO;

    if ([SimuUtil getCorRefreshTime] == 0) {
      cell.refreshLabel.text = @"手动刷新";
    } else {
      cell.refreshLabel.text = [NSString
          stringWithFormat:@"%ld秒", (long)[SimuUtil getCorRefreshTime]];
    }
  } else if (indexPath.row == 2) {
    cell.arrowImageView.hidden = YES;
    cell.arrowImageView.image = [UIImage imageNamed:@""];
    cell.refreshLabel.hidden = NO;
    cell.refreshLabel.top = 22.0f;
    //是否开启推送
    if ([SimuUtil hasNotificationsEnabled]) {
      cell.refreshLabel.text = @"已开启";
    } else {
      cell.refreshLabel.text = @"已关闭";
    }
  }
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  //表格标题
  cell.settingNameLabel.textColor = [Globle colorFromHexRGB:@"454545"];
  cell.settingNameLabel.text = settingList[indexPath.row];
  cell.iconImageView.image = [UIImage imageNamed:settingList[indexPath.row]];
  return cell;
}

#pragma mark
#pragma mark--------cell.button----------
- (void)clickRow:(UIButton *)button {
  NSInteger buttonIndexRow = button.tag % 10;
  switch (buttonIndexRow) {
  case 0: {
    [FullScreenLogonViewController
        checkLoginStatusWithCallBack:^(BOOL isLogined) {
          //已登录
          //个人信息
          //纪录日志
          [[event_view_log sharedManager]
              addPVAndButtonEventToLog:Log_Type_Button
                               andCode:@"146"];
          [AppDelegate
              pushViewControllerFromRight:[[MyInfoViewController alloc] init]];
        }];
  } break;
  case 1: {
    [FullScreenLogonViewController
        checkLoginStatusWithCallBack:^(BOOL isLogined) {
          //已登录
          //修改密码
          [[event_view_log sharedManager]
              addPVAndButtonEventToLog:Log_Type_Button
                               andCode:@"148"];
          [AppDelegate pushViewControllerFromRight:
                           [[ChangePasswordViewController alloc]
                               initWithFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN,
                                                        HEIGHT_OF_SCREEN)]];
        }];
  } break;
  case 2: {
    //推送信息
    [self clickPushButton];
  } break;
  case 3: {
    //行情刷新频率
    [self createPickerView];
    [settingsTableView reloadData];
  } break;
  case 4: {
    //给我评分
    NSString *appName = [[NSBundle mainBundle]
        objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    if (scoreAlertView == nil) {
      scoreAlertView = [[UIAlertView alloc]
              initWithTitle:
                  [NSString stringWithFormat:@"去给'%@'打分吧！", appName]
                    message:@"您的评价对我们很重要"
                   delegate:self
          cancelButtonTitle:nil
          otherButtonTitles:@"稍后评价", @"去评价", nil];
    }
    [scoreAlertView show];
    return;
    //应用推荐
    //纪录日志
    [AppDelegate pushViewControllerFromRight:
                     [[ApplicationRecomendViewController alloc] init]];
    //记录日志
    [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button
                                                     andCode:@"149"];
    [[event_view_log sharedManager]
        addPVAndButtonEventToLog:Log_Type_PV
                         andCode:@"设置-应用推荐"];
  } break;
  case 5: {
    //意见反馈
    [FullScreenLogonViewController
        checkLoginStatusWithCallBack:^(BOOL isLogined) {
          [self switchToFeedBackPage];
        }];
  } break;
  case 6: {
    //帮助中心
    //纪录日志
    [self creatHelpCenterListContrler];

  } break;
  default: {
    //关于我们
    //纪录日志
    [AppDelegate
        pushViewControllerFromRight:[[AboutUsViewController alloc] init]];

    //记录日志
    [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button
                                                     andCode:@"153"];
    [[event_view_log sharedManager]
        addPVAndButtonEventToLog:Log_Type_PV
                         andCode:@"设置-关于我们"];
  } break;
  }
}
#pragma mark-------登录成功-----
//切换到意见反馈
- (void)switchToFeedBackPage {
  //隐藏退出按钮
  footerButton.hidden = NO;

  [AppDelegate
      pushViewControllerFromRight:[[FeedBackViewController alloc] init]];

  //记录日志
  [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button
                                                   andCode:@"150"];
  [[event_view_log sharedManager]
      addPVAndButtonEventToLog:Log_Type_PV
                       andCode:@"设置-意见反馈"];
}
#pragma mark
#pragma mark-------------创建帮助中心页面-----------------------
- (void)creatHelpCenterListContrler {
  NSString *textUrl =
      [NSString stringWithFormat:@"%@/wap/helpCenter.shtml", wap_address];
  [SchollWebViewController startWithTitle:@"帮助中心" withUrl:textUrl];
}

#pragma mark
#pragma mark-------打开和取消云推送-----
- (void)clickPushButton {

  UIAlertView *alertV = [[UIAlertView alloc]
          initWithTitle:@"温馨提示"
                message:@"如"
                @"果你要关闭或开启优顾炒股的新消息通"
                @"知,请在iPhone的\"设置\"-"
                @"\"通知\"功能中，找到应用程序\"优顾" @"炒股\"更改"
               delegate:self
      cancelButtonTitle:@"确认"
      otherButtonTitles:nil, nil];
  alertV.tag = 2053;
  [alertV show];
}
#pragma mark
#pragma mark-------网路请求错误提示-------
- (void)showMessage:(NSString *)message {
  [NewShowLabel setMessageContent:message];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
