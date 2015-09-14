

//
//  ViewController.m
//  SimuStock
//
//  Created by Mac on 13-8-7.
//  Copyright (c) 2013年 Mac. All rights reserved.
//
#import "ViewController.h"
#import "SimuAction.h"
#import "MyGoldClientVC.h"
#import "SettingsBaseViewController.h"
#import "NetShoppingMallBaseViewController.h"
#import "event_view_log.h"
#import "BindSuperManTrace.h"
#import "StockPositionViewController.h"
#import "HomepageViewController.h"
#import "HomePopupsViewController.h"
#import "MyAttentionViewController.h"
#import "MyFansViewController.h"
#import "StockPersonTransactionViewController.h"
#import "SimuProgressView.h"
#import "SimuStockRegisterView.h"
#import "MyInfoViewController.h"
#import "MyChestsViewController.h"
#import "MyIncomingViewController.h"
#import "CacheUtil.h"
#import "YouguuSchema.h"
#import "MyChatStockViewController.h"
#import "StockAlarmRuleList.h"
#import "PortfolioStockModel.h"
#import "AttentionEventObserver.h"
#import "TrancingViewController.h"
#import "AccountPageViewController.h"
#import "StoreBuySuccessResponse.h"
#import "SimuConfigConst.h"
/// YL 网络队栈单例
#import "UploadRequestController.h"

static CGFloat const kHeadViewHeight = 75;
static CGFloat const kCellHeight = 38;

@implementation ViewController

- (id)init {
  if (self = [super init]) {
    //添加收藏通知监控
    [[NSNotificationCenter defaultCenter]
        addObserverForName:CollectWeiboSuccessNotification
                    object:nil
                     queue:[NSOperationQueue mainQueue]
                usingBlock:^(NSNotification *notif) {
                  NSDictionary *userInfo = [notif userInfo];
                  NSNumber *operation = userInfo[@"operation"];

                  //修改本地数据
                  SliderUserCounterWapper *myCounters = [CacheUtil loadMySliderCounter];
                  int count = [myCounters.mycollect.totalNum intValue] + [operation intValue];
                  myCounters.mycollect.totalNum = [NSString stringWithFormat:@"%d", count];
                  [self bindSliderUserCounterWapper:myCounters saveToCache:YES];

                  //延时发送请求，更新数据
                  [SimuUtil performBlockOnMainThread:^{
                    [self getUserCounter];
                  } withDelaySeconds:1];
                }];

    //点击通知消息，导致的登录成功
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifactionLoginSucees:)
                                                 name:NotifactionLoginSuccess
                                               object:nil];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.backgroundColor = [Globle colorFromHexRGB:@"#222329"]; //侧边栏黑色

  NSLog(@"ViewController.height:%f", self.view.frame.size.height);

  _processViewArray = [[NSMutableArray alloc] init];
  _processLabelArray = [[NSMutableArray alloc] init];

  NSMutableArray *menuNameArrayM = [@[
    @"签到送金币",
    @"我的追踪",
    @"我的关注",
    @"我的粉丝",
    @"我的交易",
    @"我的聊股",
    @"我的宝箱",
    @"我的收入"
  ] mutableCopy];
  if ([SimuConfigConst isShowExpertPlan]) {
    [menuNameArrayM addObject:@"我的账户"];
  }
  _menuNameArray = [menuNameArrayM copy];

  //创建承载视图
  [self createBaseView];
  //渐变背景色
  [self drawBackgroundColor];
  //创建item
  [self createAllBaseControllerView];
  //创建表格
  [self createTableView];
  [self createControl];
  [self createSettingAndMallButton];
  //创建主页面
  [self createMainViewController];
  [self registerMessageSeverse];
  [self resetUserInfo];
  [self resetTotalProfit:@""];
  //创建购买数据消息中心
  [self createNotification];
  //设置行情刷新频率
  [self refreshTime];

  //设定主页面移动需要的函数
  [self resetViewMoniteMove];
  //创建观察者
  [self addKVOObservers];
  //消息中心注册
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(homePopupsMethods:)
                                               name:SHOW_SIMUSTOCK_VIEW
                                             object:nil];
}

#pragma mark
#pragma mark 创建各个主要显示页面
//创建登录前和登录后的页面
- (void)createBaseView {
  //  //登录页面
  _loginView =
      [[SimuStockRegisterView alloc] initWithFrame:CGRectMake(-30, (self.view.height - 370) / 2, MAX_SIDESLIP_WIDTH, 270)];
  _loginView.isOtherLogin = 1;
  _loginView.hidden = NO;
  [self.view addSubview:_loginView];

  //登录后的页面头部
  _loginSuccessView = [[UIView alloc] initWithFrame:CGRectOffset(self.view.bounds, -30, 0)];
  _loginSuccessView.backgroundColor = [Globle colorFromHexRGB:Color_White alpha:0.15];
  _loginSuccessView.hidden = YES;
  [self.view addSubview:_loginSuccessView];
}

- (void)drawBackgroundColor {
  // 01：#1d2728  02：#30323c   03：33353a   04：#26313a    05：#202a2c
  _backImageView =
      [[UIImageView alloc] initWithFrame:CGRectMake(0, kHeadViewHeight + HEIGHT_0F_STATUSBAR, SIDE_SLIP_WIDTH,
                                                    self.view.frame.size.height - kHeadViewHeight - HEIGHT_0F_STATUSBAR)];
  _backImageView.userInteractionEnabled = YES;
  UIGraphicsBeginImageContext(_backImageView.frame.size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
  CGFloat colors[] = {
      29.0 / 255.0, 39.0 / 255.0, 40.0 / 255.0, 1, 48.0 / 255.0, 50.0 / 255.0, 60.0 / 255.0, 1,
      51.0 / 255.0, 53.0 / 255.0, 58.0 / 255.0, 1, 38.0 / 255.0, 49.0 / 255.0, 58.0 / 255.0, 1,
      32.0 / 255.0, 42.0 / 255.0, 44.0 / 255.0, 1,
  };
  CGGradientRef gradient =
      CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors) / (sizeof(colors[0]) * 4));
  CGColorSpaceRelease(rgb);
  CGContextDrawLinearGradient(context, gradient, CGPointMake(0, kHeadViewHeight),
                              CGPointMake(SIDE_SLIP_WIDTH, self.view.frame.size.height - kHeadViewHeight),
                              kCGGradientDrawsBeforeStartLocation);
  _backImageView.image = UIGraphicsGetImageFromCurrentImageContext();
  [_loginSuccessView addSubview:_backImageView];
  CGGradientRelease(gradient);
}

- (void)createAllBaseControllerView {
  //创建用户背景头像图片
  //创建用户头像图片
  _userHeadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 9 + HEIGHT_0F_STATUSBAR, 56, 56)];
  [_userHeadImageView setBackgroundColor:[Globle colorFromHexRGB:@"87c8f1"]];
  _userHeadImageView.layer.masksToBounds = YES;
  _userHeadImageView.layer.cornerRadius = 28.0;
  [_userHeadImageView.layer setBorderWidth:2.0f];
  [_userHeadImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
  [_loginSuccessView addSubview:_userHeadImageView];

  //总盈利名称标签
  UILabel *totalRateLabel =
      [[UILabel alloc] initWithFrame:CGRectMake(80, 14 + HEIGHT_0F_STATUSBAR, 120, 12)];
  totalRateLabel.text = @"总盈利:";
  totalRateLabel.textColor = [Globle colorFromHexRGB:Color_White alpha:.7f];
  totalRateLabel.font = [UIFont boldSystemFontOfSize:Font_Height_12_0];
  totalRateLabel.textAlignment = NSTextAlignmentLeft;
  [_loginSuccessView addSubview:totalRateLabel];
  totalRateLabel.backgroundColor = [UIColor clearColor];

  //总盈利数值
  _userFundLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 35 + HEIGHT_0F_STATUSBAR, 140, 21)];
  _userFundLabel.text = @"0.00元";
  _userFundLabel.textColor = [Globle colorFromHexRGB:Color_White];
  _userFundLabel.font = [UIFont systemFontOfSize:Font_Height_16_0];
  [_loginSuccessView addSubview:_userFundLabel];
  _userFundLabel.backgroundColor = [UIColor clearColor];

  //我的主页标签
  UILabel *myHomeLabel =
      [[UILabel alloc] initWithFrame:CGRectMake(SIDE_SLIP_WIDTH - 44 - 4, 10 + HEIGHT_0F_STATUSBAR, 44, 48)];
  myHomeLabel.numberOfLines = 2;
  myHomeLabel.text = @"我的\n主页";
  myHomeLabel.font = [UIFont systemFontOfSize:Font_Height_12_0];
  myHomeLabel.textColor = [Globle colorFromHexRGB:Color_White alpha:.7f];
  [_loginSuccessView addSubview:myHomeLabel];
  myHomeLabel.backgroundColor = [UIColor clearColor];

  //箭头
  UIImageView *ArrowImageView =
      [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SST_Main_arrow.png"]];
  ArrowImageView.frame = CGRectMake(SIDE_SLIP_WIDTH - 10 - 10, 26 + HEIGHT_0F_STATUSBAR, 10, 18);
  [_loginSuccessView addSubview:ArrowImageView];

  //红、蓝、绿、黄
  NSArray *arraycolor = @[ @"F58FA7", @"6D99E2", @"8EC44A", @"E89B11" ];
  CGFloat linewidth = SIDE_SLIP_WIDTH / 4;
  for (int i = 0; i < 4; ++i) {
    UIView *lineView =
        [[UIView alloc] initWithFrame:CGRectMake(i * linewidth, kHeadViewHeight - 3 + HEIGHT_0F_STATUSBAR, linewidth, 3)];
    lineView.backgroundColor = [Globle colorFromHexRGB:arraycolor[i]];
    [_loginSuccessView addSubview:lineView];
  }

  //透明按钮
  _homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
  _homeButton.layer.masksToBounds = YES;
  _homeButton.frame = CGRectMake(0, HEIGHT_0F_STATUSBAR, self.view.frame.size.width, kHeadViewHeight);
  _homeButton.backgroundColor = [UIColor clearColor];
  [_homeButton setOnButtonPressedHandler:^{
    //个人主页
    [HomepageViewController showWithUserId:[SimuUtil getUserID]
                                 titleName:[SimuUtil getUserNickName]
                                   matchId:@"1"];
    //纪录日志
    [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button andCode:@"0018"];

  }];
  //点击高亮
  [_homeButton setBackgroundImage:[SimuUtil imageFromColor:@"#CA5C59" alpha:.5f]
                         forState:UIControlStateHighlighted];
  [_loginSuccessView addSubview:_homeButton];

  //头像按钮
  UIButton *userHeadButton = [UIButton buttonWithType:UIButtonTypeCustom];
  userHeadButton.frame = _userHeadImageView.frame;
  userHeadButton.userInteractionEnabled = YES;
  userHeadButton.layer.masksToBounds = YES;
  userHeadButton.layer.cornerRadius = 28;
  userHeadButton.backgroundColor = [UIColor clearColor];
  UIImage *backImage = [UIImage imageNamed:@"比赛按钮高亮状态"];
  userHeadButton.alpha = 0.75;
  [userHeadButton setBackgroundImage:backImage forState:UIControlStateHighlighted];
  [userHeadButton setOnButtonPressedHandler:^{
    //纪录日志
    [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button andCode:@"146"];
    [AppDelegate pushViewControllerFromRight:[[MyInfoViewController alloc] init]];

  }];
  [_loginSuccessView addSubview:userHeadButton];
}

- (void)createTableView {
  _tableView =
      [[UITableView alloc] initWithFrame:CGRectMake(0, kHeadViewHeight + HEIGHT_0F_STATUSBAR,
                                                    self.view.frame.size.width, kCellHeight * _menuNameArray.count)];
  [_loginSuccessView addSubview:_tableView];
  _tableView.delegate = self;
  _tableView.dataSource = self;
  _tableView.backgroundColor = [UIColor clearColor];
  _tableView.scrollEnabled = NO;
  _tableView.scrollsToTop = NO;
  _tableView.delaysContentTouches = NO;
  [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  [_tableView reloadData];
}

#pragma mark
#pragma mark 创建控件
- (void)createControl {
  //创建交易相关控件
  _productPurchase = [[EBPurchase alloc] init];
  _productPurchase.delegate = self;
  //追踪卡提示：购买成功，追踪权限已经开通
  _showAlertView = [[UIAlertView alloc] initWithTitle:@"订单提交成功"
                                              message:nil
                                             delegate:self
                                    cancelButtonTitle:nil
                                    otherButtonTitles:nil, nil];
  _actIndicatorView =
      [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
}

//创建底部的设置按钮和商城按钮
- (void)createSettingAndMallButton {
  //设置按钮
  _settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  _settingBtn.alpha = 0.8;
  _settingBtn.frame = CGRectMake(15, self.view.bottom - 36, 65, 36);
  _settingBtn.backgroundColor = [UIColor clearColor];
  [_settingBtn setImage:[UIImage imageNamed:@"设置"] forState:UIControlStateNormal];
  [_settingBtn setTitle:@"设置" forState:UIControlStateNormal];
  _settingBtn.titleLabel.font = [UIFont boldSystemFontOfSize:Font_Height_12_0];
  _settingBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, -6);
  [_settingBtn setBackgroundImage:[SimuUtil imageFromColor:@"1f2829"]
                         forState:UIControlStateHighlighted];

  [_settingBtn setOnButtonPressedHandler:^{
    //设置页面切换
    [AppDelegate pushViewControllerFromRight:[[SettingsBaseViewController alloc] init]];
    //纪录日志
    [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button andCode:@"23"];
  }];
  [self.view addSubview:_settingBtn];

  //创建商城按钮
  _mallBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  _mallBtn.alpha = 0.8;
  _mallBtn.frame = CGRectMake(SIDE_SLIP_WIDTH - 10 - 65, self.view.bottom - 36, 65, 36);
  _mallBtn.backgroundColor = [UIColor clearColor];
  [_mallBtn setImage:[UIImage imageNamed:@"商店"] forState:UIControlStateNormal];
  [_mallBtn setTitle:@"商城" forState:UIControlStateNormal];
  _mallBtn.titleLabel.font = [UIFont boldSystemFontOfSize:Font_Height_12_0];
  _mallBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, -6);
  [_mallBtn setBackgroundImage:[SimuUtil imageFromColor:@"1f2829"]
                      forState:UIControlStateHighlighted];

  [_mallBtn setOnButtonPressedHandler:^{
    //商城
    NetShoppingMallBaseViewController *mallVC =
        [[NetShoppingMallBaseViewController alloc] initWithPageType:Mall_Buy_Diamond_Mode];
    [AppDelegate pushViewControllerFromRight:mallVC];
    //纪录日志
    [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button andCode:@"0018"];
  }];
  [self.view addSubview:_mallBtn];

  ///判断是否隐藏商城
  _mallBtn.hidden = ![SimuUtil isLogined];
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  _mallBtn.frame = CGRectMake(SIDE_SLIP_WIDTH - 10 - 65, self.view.bottom - 36, 65, 36);
  _settingBtn.frame = CGRectMake(15, self.view.bottom - 36, 65, 36);
}

//创建并激活永远存在的真实主页面
- (void)createMainViewController {
  _mainVC = [[SimuMainViewController alloc] init];
  _mainVC.view.frame = self.view.bounds;
  [self.view addSubview:_mainVC.view];
  [self addChildViewController:_mainVC];
}

#pragma mark
#pragma mark 和其他页面互动函数
//注册事件消息监听
- (void)registerMessageSeverse {
  //注册页面互动事件监听
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(doActionForLeftButton:)
                                               name:SYS_VAR_NAME_DOACTION_MSG
                                             object:nil];

  __weak ViewController *weakSelf = self;
  _loginLogoutNotification = [[LoginLogoutNotification alloc] init];
  _loginLogoutNotification.onLoginLogout = ^{
    [weakSelf onLoginLogoutEvent];
  };

  //通知主页面进行网络更新
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(upDateForNotifier:)
                                               name:UpDataFromNet_WithMainController
                                             object:nil];

  //左侧栏显示总盈利的通知
  [[NSNotificationCenter defaultCenter] addObserverForName:AccountTotalProfitNotification
                                                    object:nil
                                                     queue:[NSOperationQueue mainQueue]
                                                usingBlock:^(NSNotification *notif) {
                                                  NSDictionary *userInfo = [notif userInfo];
                                                  [self resetTotalProfit:userInfo[@"totalProfit"]];
                                                }];
}

//事件处理
- (void)doActionForLeftButton:(NSNotification *)notification {
  SimuAction *action = [notification object];
  if ([action.actionCode isEqualToString:AC_UpDate_UserInfo]) {
    //更新用户图片，等信息
    [self resetUserInfo];
  }
}

#pragma mark
#pragma mark 重新设置头像等信息
- (void)resetUserInfo {
  //重新设置头像
  if ([SimuUtil isLogined]) {
    [JhssImageCache setImageView:_userHeadImageView
                         withUrl:[SimuUtil getUserImageURL]
            withDefaultImageName:@"用户默认头像"];
  } else {
    _userHeadImageView.image = [UIImage imageNamed:@"用户默认头像"];
  }

  //设定盈利
  UserAccountPageData *userInfo = [CacheUtil loadUserAccountPositions];
  NSString *str = userInfo ? userInfo.totalProfit : @"";
  [self resetTotalProfit:str];
}

#pragma mark 重新设置总盈利
- (void)resetTotalProfit:(NSString *)totalProfit {
  NSString *strFund;
  if (totalProfit == nil || [totalProfit length] == 0) {
    strFund = @"";
  } else if (totalProfit.length > 12) {
    CGFloat fundFloat = [totalProfit doubleValue] / 10000;
    strFund = [NSString stringWithFormat:@"%0.2f万元", fundFloat];
  } else {
    strFund = [NSString stringWithFormat:@"%@元", totalProfit];
  }
  _userFundLabel.text = strFund;
}

//接收购买的那种卡型
#pragma mark
#pragma mark--------------区分购买卡型----------
- (void)createNotification {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(getTrackCard)
                                               name:@"cardSort"
                                             object:@"trackCard"];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(getOtherCard)
                                               name:@"cardSort"
                                             object:@"otherCard"];
}

- (void)getTrackCard {
  _cardSort = @"trackCard";
}
- (void)getOtherCard {
  _cardSort = @"otherCard";
}

- (void)refreshTime {
  switch ([SimuUtil getCorRefreshTime]) {
  case 0:
    [SimuUtil setMarketRefreshTime:@"0"];
    break;
  case 5:
    [SimuUtil setMarketRefreshTime:@"1"];
    break;
  case 10:
    [SimuUtil setMarketRefreshTime:@"2"];
    break;
  case 20:
    [SimuUtil setMarketRefreshTime:@"3"];
    break;
  case 30:
    [SimuUtil setMarketRefreshTime:@"4"];
    break;

  default:
    break;
  }
}

#pragma mark
#pragma mark 普通函数
- (void)resetViewMoniteMove {
  if (_mainVC) {
    [_mainVC setLoginView:_loginSuccessView NotLoginView:_loginView];
  }
}

#pragma mark
#pragma mark EBPurchaseDelegate
//产品回调
- (void)requestedProduct:(EBPurchase *)ebp
              identifier:(NSString *)productId
                    name:(NSString *)productName
                   price:(NSString *)productPrice
             description:(NSString *)productDescription {
}

- (void)productsRequest:(SKProductsRequest *)request
     didReceiveResponse:(SKProductsResponse *)response {
}

- (void)successfulPurchase:(EBPurchase *)ebp
                identifier:(NSString *)productId
                   receipt:(NSData *)transactionReceipt {

  //验证苹果票据倒计时
  static NSInteger ValidatingCountDown = 10;
  [NetLoadingWaitView stopAnimating];

  if (ebp == _productPurchase) {
    // 1. show validating dialog, count down from 10seconds
    // 2. send validaing request, with callback
    // 3. if success before count down, dismiss dialog, goto my chest
    // 4. if success after count down, dismiss dialog

    [_showAlertView show];
    [SimuUtil performBlockOnMainThread:^{
      _cardSort = @"";
      [_showAlertView dismissWithClickedButtonIndex:0 animated:YES];
    } withDelaySeconds:ValidatingCountDown];

    _sendBuySuccessUtil = [[StoreBuySuccessResponse alloc] initWithEBPurchase:_productPurchase
                                                                      receipt:transactionReceipt];
    [_sendBuySuccessUtil sendBuySuccessNotify];
  }
}

- (void)failedPurchase:(EBPurchase *)ebp
                 error:(NSInteger)errorCode
               message:(NSString *)errorMessage {
  if ([NetLoadingWaitView isAnimating])
    [NetLoadingWaitView stopAnimating];

  UIAlertView *failedAlert = [[UIAlertView alloc] initWithTitle:@"交易停止"
                                                        message:@"交易失败，请重试！ "
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
  [failedAlert show];
}

- (void)incompleteRestore:(EBPurchase *)ebp {
  if ([NetLoadingWaitView isAnimating])
    [NetLoadingWaitView stopAnimating];

  UIAlertView *restoreAlert =
      [[UIAlertView alloc] initWithTitle:@"Restore Issue"
                                 message:@"A prior purchase transaction could not be found. To " @"restore the purchased product, tap the Buy button. " @"Paid customers will NOT be charged again, but the "
                                 @"purchase will be restored."
                                delegate:nil
                       cancelButtonTitle:@"确定"
                       otherButtonTitles:nil];
  [restoreAlert show];
}

- (void)failedRestore:(EBPurchase *)ebp
                error:(NSInteger)errorCode
              message:(NSString *)errorMessage {
  if ([NetLoadingWaitView isAnimating])
    [NetLoadingWaitView stopAnimating];

  UIAlertView *failedAlert = [[UIAlertView alloc] initWithTitle:@"交易中止"
                                                        message:@"交易失败，请重试！"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
  [failedAlert show];
}

#pragma mark
#pragma mark UIAlertViewDelegate

// before animation and showing view
- (void)willPresentAlertView:(UIAlertView *)alertView {
  if (_showAlertView == alertView) {
    _actIndicatorView.center =
        CGPointMake(_showAlertView.bounds.size.width / 2.0f, _showAlertView.bounds.size.height - 40.0f);
    [_actIndicatorView startAnimating];
    [_showAlertView addSubview:_actIndicatorView];
  }
}

#pragma mark

//通知相应函数－从服务器上更新信息
- (void)upDateForNotifier:(NSNotification *)notification {
  NSString *message = [notification object];
  if ([message isEqualToString:@"upformNet_For_Userinfo"]) {
    //更新用户的总资产和盈利率信息（修改）=======
    [SimuPositionPageData updatePostion];
  }
}

/** 登陆成功 */
- (void)onLoginLogoutEvent {
  _mallBtn.hidden = ![SimuUtil isLogined];

  ///重启，网络队栈线程
  [[UploadRequestController sharedManager] RestartNetworkQueue];

  if ([SimuUtil isLogined]) {
    _loginSuccessView.hidden = NO;
    _loginView.hidden = YES;
    NSUserDefaults *myUser = [NSUserDefaults standardUserDefaults];
    [myUser setObject:@"1" forKey:@"SHOW_HOMEPAGE"];
    [myUser synchronize];
    //实盘登录时间置零
    [SimuUser setUserFirmLogonSuccessTime:0];

    [self performSelector:@selector(GetIniteData) withObject:nil afterDelay:0];
    //绑定百度推送用户ID
    if (_bindSuperManTrace == nil) {
      _bindSuperManTrace = [[BindSuperManTrace alloc] init];
    }
    NSString *UserID = [SimuUtil getBaiduUserId];
    if (UserID == nil || [UserID isEqualToString:@""]) {
      [_bindSuperManTrace userBindSever];
    }
    [_bindSuperManTrace sendApplePushToken];
    [self refreshTime];
    [self getMyAttentionsInfo];
    [self resetUserInfo];
    [ViewController updateMyInfo];
  } else {
    _loginSuccessView.hidden = YES;
    _loginView.hidden = NO;
  }
}

+ (void)updateMyInfo {
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onSuccess = ^(NSObject *obj) {
    [CacheUtil saveUserInfomation:(MyInfomationItem *)obj];
  };
  callback.onFailed = ^{
  };
  [MyInfomationItem requestMyInfomationWithCallBack:callback];
}

/**
 *如果登陆获得关注数据
 */
- (void)getMyAttentionsInfo {
  [[MyAttentionInfo sharedInstance] startGetAttentionInfo];
}

- (void)GetIniteData {
  [self getStockInfoAndSelfStockInfo];
}

#pragma mark
#pragma mark 牛人追踪相关函数
//消息通知登录成功，展示牛人主页，并展示追踪牛人个人主页
- (void)notifactionLoginSucees:(NSNotification *)obj {
  //绑定百度推送用户 ID
  NSString *UserID = [SimuUtil getBaiduUserId];
  if (UserID == nil || [UserID isEqualToString:@""]) {
    [_bindSuperManTrace userBindSever];
  }
  [_bindSuperManTrace sendApplePushToken];
  NSLog(@"userfn");
  [YouguuSchema forwardPageFromNoticfication:obj.userInfo];
}

//弹出登陆框
- (void)popLoginView {
  [AppDelegate pushViewControllerFromRight:[[FullScreenLogonViewController alloc] init]];
}

#pragma mark
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 0) {
    [self illegeLogin];
  } else {
    //取消
  }
}
/**
 *提示退出登录
 */
- (void)illegeLogin {
  NSUserDefaults *myUser = [NSUserDefaults standardUserDefaults];
  //不在显示
  [myUser setObject:@"0" forKey:@"SHOW_HOMEPAGE"];
  [myUser synchronize];
  [(AppDelegate *)[[UIApplication sharedApplication] delegate] createHomePage];

  //登陆页日志
  [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_PV andCode:@"登录页"];
}

#pragma mark
#pragma mark UITableViewDelegate 表格相关函数
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return kCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_menuNameArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *ID = @"cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] init];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    UIView *backView = [[UIView alloc] initWithFrame:cell.frame];
    backView.backgroundColor = [Globle colorFromHexRGB:@"#CA5C59" alpha:.5f];
    cell.selectedBackgroundView = backView;
    [self setCell:cell andIndex:indexPath.row];
  }
  return cell;
}

- (void)setCell:(UITableViewCell *)cell andIndex:(NSInteger)index {
  //分割线
  UIView *viewline =
      [[UIView alloc] initWithFrame:CGRectMake(15, kCellHeight - 0.5, SIDE_SLIP_WIDTH - 30, 0.5)];
  viewline.backgroundColor = [[Globle colorFromHexRGB:Color_White] colorWithAlphaComponent:0.08];
  [cell addSubview:viewline];

  //签到送金币或其他标签
  UILabel *menuLabel =
      [[UILabel alloc] initWithFrame:CGRectMake((index == 0 ? 44 : 14), viewline.frame.origin.y - 26.5f, 140, 14)];
  menuLabel.backgroundColor = [UIColor clearColor];
  menuLabel.text = _menuNameArray[index];
  menuLabel.textColor = [[Globle colorFromHexRGB:Color_White] colorWithAlphaComponent:0.8];
  menuLabel.font = [UIFont boldSystemFontOfSize:14];
  [cell addSubview:menuLabel];

  //数量说明
  if (index == 0) {
    UIImage *iamge = [UIImage imageNamed:@"金币0"];
    UIImageView *imageView =
        [[UIImageView alloc] initWithFrame:CGRectMake(14, (viewline.frame.origin.y - 24) / 2, 23, 24)];
    imageView.image = iamge;
    [cell addSubview:imageView];
  } else if (index == 6) {
    //我的宝箱
    UIImage *image = [UIImage imageNamed:@"钻石"];
    UIImageView *imageView =
        [[UIImageView alloc] initWithFrame:CGRectMake(SIDE_SLIP_WIDTH - image.size.width - 15,
                                                      viewline.frame.origin.y - 25, 17, 13)];
    imageView.image = image;
    [cell addSubview:imageView];
  } else if (index == 7) {
    //我的收入
    UIImage *image = [UIImage imageNamed:@"我的收入"];
    UIImageView *imageView =
        [[UIImageView alloc] initWithFrame:CGRectMake(SIDE_SLIP_WIDTH - image.size.width - 15 + .75f,
                                                      viewline.frame.origin.y - 25, 18.5f, 18.5f)];
    imageView.image = image;
    [cell addSubview:imageView];
  } else if (index == 8 && [SimuConfigConst isShowExpertPlan]) {
    //我的账户
    UIImage *image = [UIImage imageNamed:@"我的账户小图标"];
    UIImageView *imageView =
        [[UIImageView alloc] initWithFrame:CGRectMake(SIDE_SLIP_WIDTH - image.size.width - 15 + 2,
                                                      viewline.frame.origin.y - 25, 21, 20)];
    imageView.image = image;
    [cell addSubview:imageView];
  } else {
    //进度条线
    SimuProgressView *progrem =
        [[SimuProgressView alloc] initWithFrame:CGRectMake(15, kCellHeight - 5.0, viewline.frame.size.width, 4.5)
                                       ColerStr:nil
                                    ProgressStr:@"1.0"];
    [_processViewArray addObject:progrem];
    [cell addSubview:progrem];
    if (index != 0) {
      //文字说明
      UILabel *numberLabel =
          [[UILabel alloc] initWithFrame:CGRectMake(SIDE_SLIP_WIDTH - 90, viewline.frame.origin.y - 24, 75, 16)];
      numberLabel.backgroundColor = [UIColor clearColor];
      numberLabel.font = [UIFont systemFontOfSize:15];
      numberLabel.textColor = [[Globle colorFromHexRGB:Color_White] colorWithAlphaComponent:0.8];
      numberLabel.textAlignment = NSTextAlignmentRight;
      [cell addSubview:numberLabel];
      [_processLabelArray addObject:numberLabel];
    }
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  [self tableView:tableView didDeselectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self pushSecondViewController:indexPath.row];
}

#pragma mark
#pragma mark------- 头像本地保存---------
- (UIImage *)getPhotoFromName:(NSString *)name {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *uniquePath = [paths[0] stringByAppendingPathComponent:name];
  BOOL blHave = [[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
  if (!blHave) {
    return nil;
  } else {
    NSData *data = [NSData dataWithContentsOfFile:uniquePath];
    UIImage *img = [[UIImage alloc] initWithData:data];
    return img;
  }
}

- (void)addKVOObservers {
  _userInfoNotificationUtil = [[UserInfoNotificationUtil alloc] init];
  __weak ViewController *weakSelf = self;
  _userInfoNotificationUtil.onHeadPicChangeAction = ^{
    [weakSelf resetUserInfo];
  };

  _attentionEventObserver = [[AttentionEventObserver alloc] init];
  _attentionEventObserver.onAttentionAction = ^{
    [weakSelf refreshAttentionData];
  };
}

#pragma mark 首页弹窗
- (void)homePopupsMethods:(NSNotification *)notification {
  [HomePopupsViewController requestAdDataWithViewController:self];
}

- (void)refreshAttentionData {
  //刷新侧栏关注栏
  if (_processLabelArray && [_processLabelArray count] > 0) {
    _tempAttentionStr = [@([[MyAttentionInfo sharedInstance] getAttentionArray].count) stringValue];
  }
  //更新侧边栏数据
  [self getUserCounter];
}

#pragma mark
#pragma mark 联网测试函数

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark
#pragma mark －－－－－－－version 2.1.0版本新函数－－－－－－－－

- (void)pushSecondViewController:(NSInteger)cellIndex {
  switch (cellIndex) {
  case 0: {
    //我的金币
    [AppDelegate pushViewControllerFromRight:[[MyGoldClientVC alloc] init]];
    //纪录日志
    [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button andCode:@"21"];
  } break;
  case 1: {
    //我的追踪
    TrancingViewController *myTrancingVC = [[TrancingViewController alloc] init];
    myTrancingVC.userID = [SimuUtil getUserID];
    [AppDelegate pushViewControllerFromRight:myTrancingVC];
    //纪录日志
    [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button andCode:@"15"];
  } break;
  case 2: {
    //我的关注
    MyAttentionViewController *myAttentionVC = [[MyAttentionViewController alloc] init];
    myAttentionVC.userID = [SimuUtil getUserID];
    [AppDelegate pushViewControllerFromRight:myAttentionVC];
    //纪录日志
    [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button andCode:@"16"];
  } break;
  case 3: {
    //我的粉丝
    MyFansViewController *myFansVC = [[MyFansViewController alloc] init];
    myFansVC.userID = [SimuUtil getUserID];
    [AppDelegate pushViewControllerFromRight:myFansVC];
    //纪录日志
    [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button andCode:@"19"];
  } break;
  case 4: {
    //我的交易
    StockPersonTransactionViewController *myDealVC =
        [[StockPersonTransactionViewController alloc] initWithUserID:[SimuUtil getUserID]
                                                        withUserName:[SimuUtil getUserNickName]
                                                         withMatchID:@"1"];
    [AppDelegate pushViewControllerFromRight:myDealVC];
    //纪录日志
    [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button andCode:@"18"];
  } break;
  case 5: {
    //我的聊股
    [AppDelegate pushViewControllerFromRight:[[MyChatStockViewController alloc] init]];
    break;
  }
  case 6: {
    //我的宝箱
    [AppDelegate pushViewControllerFromRight:[[MyChestsViewController alloc] init]];
    //纪录日志
    [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button andCode:@"22"];
  } break;
  case 7: {
    //我的收入
    [AppDelegate pushViewControllerFromRight:[[MyIncomingViewController alloc] init]];
    break;
  }
  case 8: {
    //我的账户
    if ([SimuConfigConst isShowExpertPlan]) {
      [AppDelegate pushViewControllerFromRight:[[AccountPageViewController alloc] initWithFrame:CGRectMake(0.f, 0.f, WIDTH_OF_SCREEN, HEIGHT_OF_SCREEN)]];
    }
    break;
  }
  default:
    break;
  }
}

#pragma mark
#pragma mark 网络请求接口
//获得侧边栏的接口计数
- (void)getUserCounter {
  if (!self.sliderDataBinded) {
    SliderUserCounterWapper *myCounters = [CacheUtil loadMySliderCounter];
    if (myCounters && [myCounters isOK]) {
      [self bindSliderUserCounterWapper:myCounters saveToCache:NO];
    }
  }

  if (![SimuUtil isExistNetwork]) {
    return;
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak ViewController *weakSelf = self;

  callback.onSuccess = ^(NSObject *obj) {
    ViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindSliderUserCounterWapper:(SliderUserCounterWapper *)obj saveToCache:YES];
    }
  };
  callback.onFailed = ^{
  };
  callback.onError = ^(BaseRequestObject *obj, NSException *error) {
  };
  [SliderUserCounterWapper requestUserCounterWithCallback:callback];
}

- (void)bindSliderUserCounterWapper:(SliderUserCounterWapper *)data saveToCache:(BOOL)saveToCache {
  if (saveToCache) {
    [CacheUtil saveMySliderCounter:data];
  }

  self.sliderDataBinded = YES;
  //我的追踪
  if (_processViewArray.count >= 1) {
    SimuProgressView *ItemView = _processViewArray[0];
    [ItemView resetItemContent:@"#c97cff" ProgressStr:data.mytrace.percentage];
    UILabel *lable = _processLabelArray[0];
    lable.text = data.mytrace.totalNum;
  }

  //我的关注
  if (_processViewArray.count >= 2) {
    SimuProgressView *ItemView = _processViewArray[1];
    [ItemView resetItemContent:@"#ff7c8a" ProgressStr:data.myfollow.percentage];
    UILabel *lable = _processLabelArray[1];
    lable.text = data.myfollow.totalNum;
    //更新关注信息（lq）
    if (_tempAttentionStr && [_tempAttentionStr integerValue] > 0) {
      lable.text = _tempAttentionStr;
      _tempAttentionStr = @"-1";
    }
  }

  //我的粉丝
  if (_processViewArray.count >= 3) {
    SimuProgressView *ItemView = _processViewArray[2];
    [ItemView resetItemContent:@"#fab217" ProgressStr:data.myfans.percentage];
    UILabel *lable = _processLabelArray[2];
    lable.text = data.myfans.totalNum;
  }

  //我的交易
  if (_processViewArray.count >= 4) {
    SimuProgressView *ItemView = _processViewArray[3];
    [ItemView resetItemContent:@"#619ef9" ProgressStr:data.mytrade.percentage];
    UILabel *lable = _processLabelArray[3];
    lable.text = data.mytrade.totalNum;
  }

  //我的聊股
  if (_processViewArray.count >= 5) {
    SimuProgressView *ItemView = _processViewArray[4];
    [ItemView resetItemContent:@"#75ba0b" ProgressStr:data.myistock.percentage];
    UILabel *lable = _processLabelArray[4];
    lable.text = data.myistock.totalNum;
  }
}

//更新股票数据库和自选股信息
- (void)getStockInfoAndSelfStockInfo {
  if (![SimuUtil isExistNetwork]) {
    return;
  }
  [PortfolioStockManager synchronizePortfolioStockWithIncrementFlag:NO];
  [SelfStockAlarmItems requestStockListOfSettingAlarm];
  [self getUserCounter];
  [SimuPositionPageData updatePostion];
}
@end
