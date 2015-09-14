//
//  AppDelegate.m
//  SimuStock
//  svn
//  Created by Mac on 13-8-7.
//  Copyright (c) 2013年 Mac. All rights reserved.
// s

#import "AppDelegate.h"
#import "JSONKit.h"

#import "SimuUtil.h"
#import "WeiboApi.h"
#import "Reachability.h"
#import "event_view_log.h"
#import "MobClick.h"

#import "BindSuperManTrace.h"
#import <TencentOpenAPI/QQApiInterface.h>

#import "NewShowLabel.h"
#import "AppUpdateInfo.h"
#import "WeiBoExtendButtons.h"
#import "UploadRequestController.h"
#import "CoreDataController.h"
#import "StockDBManager.h"
#import <TencentOpenAPI/TencentOAuth.h>

//震动效果
#import <AudioToolbox/AudioToolbox.h>
///推送个类型总数的获取
#import "BpushModelDeal.h"

///协议数据解析
#import "YouguuSchema.h"
#import "TopNewShowPushLabel.h"

#import "SimuScreenAdapter.h"

#define ios_systemVersion ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? 1 : 0)
@interface AppDelegate () {
  UINavigationController *_navigationDelegate;
}

@end

@implementation AppDelegate

@synthesize urlCache = _urlCache;
@synthesize tempViewController = _tempViewController;
@synthesize jhssViewDelegate = _jhssViewDelegate;
@synthesize authOptionsDelegate = _authOptionsDelegate;
@synthesize viewController = _viewController;
@synthesize is_needUpData = _is_needUpData;

- (id)init {
  if (self = [super init]) {
    _scene = WXSceneSession;
    _jhssViewDelegate = [[JHSSViewDelegate alloc] init];
    _authOptionsDelegate = [[AuthOptionsDelegate alloc] init];
  }
  return self;
}
- (void)dealloc {
  self.window.rootViewController = nil;
}

//创建缓存机制1
- (void)creatCaches {
  //创建url缓存
  self.urlCache = [NSURLCache sharedURLCache];
  [self.urlCache setMemoryCapacity:1 * 1024 * 1024];
}

- (void)createHomePage {
  fullLogonVC = [[FullScreenLogonViewController alloc] init];
  //登录页，有成员变为局部
  [AppDelegate pushViewControllerFromRight:fullLogonVC];
}

#pragma mark
#pragma mark------------------登录-------------------
//说明：当程序被推送到后台的时候调用。所以要设置后台继续运行，则在这个函数里面设置即可
- (void)applicationDidEnterBackground:(UIApplication *)application {
  //退出log
  [[event_view_log sharedManager] addOnLineEventToLog];
  //记录退出时间
  [[NSUserDefaults standardUserDefaults] setInteger:[NSDate timeIntervalSinceReferenceDate]
                                             forKey:@"startTimerData"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

//说明：当程序从后台将要重新回到前台时候调用，这个刚好跟上面的那个方法相反。
- (void)applicationWillEnterForeground:(UIApplication *)application {
  //股票代码需要检查更新
  [StockUpdateItemListWrapper incrementUpdateStockInfo];

  ///刷新，设置中，推送总的开关
  [[NSNotificationCenter defaultCenter] postNotificationName:@"BPushMasterSwitch" object:nil];

  //发出刷新表格通知
  [[NSNotificationCenter defaultCenter] postNotificationName:MessageCenterNotification object:nil];

  ///重新统计推送数量
  [UserBpushInformationNum requestUnReadStaticData];

  [[event_view_log sharedManager] addAppStartEventToLog:NO];
  //记录进入前台时间
  [[NSUserDefaults standardUserDefaults] setInteger:[NSDate timeIntervalSinceReferenceDate]
                                             forKey:@"endTimerData"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

//说明：当程序将要退出是被调用，通常是用来保存数据和一些退出前的清理工作。这个需要要设置UIApplicationExitsOnSuspend的键值。
- (void)applicationWillTerminate:(UIApplication *)application {
  //退出log
  [[event_view_log sharedManager] addOnLineEventToLog];
  [self saveContext];
}

static BOOL internetActive = YES;
static NSString *networkDescription = @"";

+ (NSString *)getNetworkDescription {
  return networkDescription;
}

- (BOOL)isExistNetwork {
  return internetActive;
}

//当网络发生变化的时候，都会触发这个事件
- (void)reachabilityChanged:(NSNotification *)note {
  Reachability *reach = [note object];
  if ([reach isReachable]) {
    internetActive = YES;

    ///重启，网络队栈线程
    [[UploadRequestController sharedManager] RestartNetworkQueue];
  } else {
    internetActive = NO;
  }
  NSLog(@"network is %@", internetActive ? @"OK" : @"not OK");
}

- (void)addNetworkStatusMonitor {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(reachabilityChanged:)
                                               name:kReachabilityChangedNotification
                                             object:nil];

  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    Reachability *reach = [Reachability reachabilityWithHostname:TEST_NET_STATUS_HOST];
    internetActive = reach.isReachable;
    reach.reachableBlock = ^(Reachability *reachability) {
      dispatch_async(dispatch_get_main_queue(), ^{
        internetActive = YES;
      });
    };
    reach.unreachableBlock = ^(Reachability *reachability) {
      dispatch_async(dispatch_get_main_queue(), ^{
        internetActive = NO;
      });
    };
    [reach startNotifier];
  });
}

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  CoreDataController *coreDataMgr = [CoreDataController sharedInstance];
  if ([coreDataMgr prepare]) {
    // do nothing
  } else {
    if (coreDataMgr.isMigrationNeeded) {
      [coreDataMgr migrate:nil];
    }
    [StockUpdateItemListWrapper incrementUpdateStockInfo];
  }

  [self addNetworkStatusMonitor];
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  //去掉菊花(系统)
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

  _is_needUpData = NO;
  _viewController = [[ViewController alloc] init];
  UINavigationController *navigationController =
      [[UINavigationController alloc] initWithRootViewController:_viewController];
  navigationController.delegate = self;
  navigationController.navigationBarHidden = YES;
  self.window.rootViewController = navigationController;

  [self matchNewIOSSystem];
  [self matchIPhoneScreen];
  //启动页（转动）
  entrance = [[EntranceFunctionsClass alloc] initWithRoot:self.viewController.view];
  // Umeng信息
  [self umengInfo];
  //设置要在其它开发者账号之前
  [ShareSDK registerApp:@"b126775514e"];
  //[ShareSDK convertUrlEnabled:YES];

  //如果需要支持 iOS8,请加上这些代码并在 iOS6 中编译
  if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
    [[UIApplication sharedApplication]
        registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound
                                                                           categories:nil]];
  } else {
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
  }
  //百度推送
  //①
  //渠道,必须
  [BPush setupChannel:launchOptions];
  //必须。参数对象必须实现(void)onMethod:(NSString*)method
  // response:(NSDictionary*)data 方法,本示例中为 self
  [BPush setDelegate:self];

  //启动日志
  [event_view_log sharedManager];
  //三方授权
  [self performSelector:@selector(userAuth) withObject:nil];
  //创建缓存机制
  [self creatCaches];
  if (!AD_SYSTEM_VERSION_GREATER_THAN_7) {
    [UIApplication sharedApplication].statusBarHidden = YES;
    self.transitionController.navigationBarHidden = YES;
    self.transitionController.toolbarHidden = YES;
    [UIApplication sharedApplication].statusBarHidden = NO;
  }
  ///重新统计推送数量
  [UserBpushInformationNum requestUnReadStaticData];

  self.window.backgroundColor = [UIColor blackColor];
  [self.window makeKeyAndVisible];
  [self messageAlertView];
  [self createWeiboExtendButtons];

  NSDictionary *dic = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
  if (dic) {
    //必须等待NavigationVC创建完毕，才可以跳转消息对应的页面，例如：牛人主页
    [self sendNotification:dic];
  }
  return YES;
}

//消息提醒
- (void)messageAlertView {
  NewShowLabel *NewLab = [NewShowLabel newShowLabel];
  [self.window addSubview:NewLab];

  //推送
  TopNewShowPushLabel *topnewshowPush = [TopNewShowPushLabel topNewShowPushLabel];
  [self.window addSubview:topnewshowPush];
}

//微博长按拓展按钮
- (void)createWeiboExtendButtons {
  WeiBoExtendButtons *extendButtons = [WeiBoExtendButtons sharedExtendButtons];
  [self.window addSubview:extendButtons];
}
//发送通知登陆（由通知进入APP，则显示通知相应程序）
- (void)sendNotification:(NSDictionary *)dic {

  [[NSNotificationCenter defaultCenter] postNotificationName:NotifactionLoginSuccess
                                                      object:nil
                                                    userInfo:dic];
}
//处理属性改变事件
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
  UIWindow *one_window = object;
  NSLog(@"window.frame.orign.x = %f, window.frame.orign.y = %f, "
        @"window.frame.size.width = %f,widow.frame.size.height = %f",
        one_window.frame.origin.x, one_window.frame.origin.y, one_window.frame.size.width,
        one_window.frame.size.height);
  NSLog(@"window change = %@", change);
}
- (void)matchNewIOSSystem {
  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setBarTintColor:[Globle colorFromHexRGB:@"086dae"]];
  }
}
/** iPhone屏幕尺寸适配 */
- (void)matchIPhoneScreen {
  CGFloat chatStockMutiple = 1;
  CGFloat weiboDetailMutiple = 1;
  if (WIDTH_OF_SCREEN == 414) {
    /// 如果是宽为414尺寸的屏幕，设置文字放大倍数为CHAT_STOCK_TEXT_MUTIPLE
    chatStockMutiple = CHAT_STOCK_TEXT_MUTIPLE;
    weiboDetailMutiple = WB_DETAILS_TEXT_MUTIPLE;
  }
  /// 设置聊股内容的文字大小
  CHAT_STOCK_TITTLE_FONT = CHAT_STOCK_TITTLE_DEFAULT_FONT * chatStockMutiple;
  CHAT_STOCK_CONTENT_FONT = CHAT_STOCK_CONTENT_DEFAULT_FONT * chatStockMutiple;
  CHAT_STOCK_REPLY_CONTENT_FONT = CHAT_STOCK_REPLY_CONTENT_DEFAULT_FONT * chatStockMutiple;
  /// 设置聊股正文页的文字大小
  WB_DETAILS_TITTLE_FONT = WB_DETAILS_TITTLE_DEFAULT_FONT * weiboDetailMutiple;
  WB_DETAILS_CONTENT_FONT = WB_DETAILS_CONTENT_DEFAULT_FONT * weiboDetailMutiple;
  WB_DETAILS_REPLY_CONTENT_FONT = WB_DETAILS_REPLY_CONTENT_DEFAULT_FONT * weiboDetailMutiple;
}

//如果需要支持 iOS8,请加上这些代码
#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application
    didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
  // register to receive notifications
  [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application
    handleActionWithIdentifier:(NSString *)identifier
         forRemoteNotification:(NSDictionary *)userInfo
             completionHandler:(void (^)())completionHandler {
  // handle the actions
  if ([identifier isEqualToString:@"declineAction"]) {
  } else if ([identifier isEqualToString:@"answerAction"]) {
  }
}
#endif

//③
//注册device token
//获取终端设备标示，这个标识需要通过接口发送到服务器端，服务器端推送消息到APNS时需要知道终端的标识，APNS通过注册的终端标识找到终端设备。
- (void)application:(UIApplication *)application
    didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
  if (token && token.length >= 72) {
    token = [[[NSString stringWithFormat:@"%@", deviceToken] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]
        stringByReplacingOccurrencesOfString:@" "
                                  withString:@""];
    ///保存推送Token
    if (token && token.length > 0) {
      [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"AppleToken"];
      [[NSUserDefaults standardUserDefaults] synchronize];
    }
  }
  //必须
  NSUserDefaults *myUser = [NSUserDefaults standardUserDefaults];
  NSString *baiduUid = [myUser objectForKey:@"BAIDU_UID"];
  NSString *baiduChannel = [myUser objectForKey:@"BAIDU_CHANNEL"];
  if (baiduUid == nil || baiduChannel == nil || [baiduChannel isEqualToString:@""] ||
      [baiduUid isEqualToString:@""]) {
    [BPush registerDeviceToken:deviceToken];
    // 必须。可以在其它时机调用,只有在该方法返回(通过
    // onMethod:response:回调)绑定成功时,app 才能接收到 Push 消息。一个 app
    // 绑定成功至少一次即可(如 果 access token 变更请重新绑定)。
    //绑定测试下
    [BPush bindChannel];
  }
  //设定通知是否处于接受状态
  [[NSUserDefaults standardUserDefaults] setObject:@"No" forKey:@"Notification_Set"];
}

- (void)application:(UIApplication *)application
    didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  [[NSUserDefaults standardUserDefaults] setObject:@"Yes" forKey:@"Notification_Set"];
}

- (void)saveContext {
  NSError *error = nil;
  NSManagedObjectContext *managedObjectContext = [CoreDataController sharedInstance].managedObjectContext;
  if (managedObjectContext) {
    if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
      // Replace this implementation with code to handle the error
      // appropriately.
      // abort() causes the application to generate a crash log and terminate.
      // You should not use this function in a shipping application, although it
      // may be useful during development.
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    }
  }
}
//④
//必须,如果正确调用了 setDelegate,在 bindChannel 之后,结果在这个回调中返回。
//若绑定失败,请进行重新绑定,确保至少绑定成功一次
- (void)onMethod:(NSString *)method response:(NSDictionary *)data {
  NSLog(@"On method:%@", method);
  NSLog(@"data:%@", [data description]);

  if ([BPushRequestMethod_Bind isEqualToString:method]) {
    NSDictionary *res = [[NSDictionary alloc] initWithDictionary:data];
    NSLog(@"res = %@", res);
    //保存用户推送id信息
    BindSuperManTrace *bindUserId = [[BindSuperManTrace alloc] init];
    NSString *baiduUid = res[@"user_id"];
    NSString *baiduChannel = res[@"channel_id"];
    if (baiduUid == nil || [baiduUid length] == 0) {
      baiduUid = @"";
    }
    if (baiduChannel == nil || [baiduChannel length] == 0) {
      baiduChannel = @"";
    }
    //保存
    [bindUserId getUserIDInfo:baiduUid withString:baiduChannel];
  }
}
//清空看过的推送通知
- (void)application:(UIApplication *)application
    didReceiveLocalNotification:(UILocalNotification *)notification {
  //  系统震动，效果
  AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
  //[[UIApplication sharedApplication]cancelAllLocalNotifications];
  [[UIApplication sharedApplication] cancelLocalNotification:notification];
}

//接收push到的消息
- (void)application:(UIApplication *)application
    didReceiveRemoteNotification:(NSDictionary *)userInfo {
  //推送收到的消息  type=12(系统消息)
  NSLog(@"userInfo = %@", userInfo);
  if (!userInfo) {
    return;
  }
  if (!_app_userinfo) {
    self.app_userinfo = [[NSMutableDictionary alloc] init];
  }
  [self.app_userinfo removeAllObjects];
  [self.app_userinfo addEntriesFromDictionary:userInfo];

  NSNumber *number = userInfo[@"type"];
  NSNumber *msgtype = userInfo[@"msgtype"];
  if (number == nil)
    return;
  BPushTypeMNCG type = (BPushTypeMNCG)[number integerValue];

  if (type == BPushExpertTraceMessage || type == BPushAllExpert || type == BPushTheSystemMessage ||
      type == BPushTongAccountProfitability || type == BPushSoonerOrLaterTheNewspaper ||
      type == BPushStockPricesEarlyWarning || type == BPushVipTransactionMessageNotification ||
      type == BPushMasterPlanMessageTrace || type == BPushSuperVipNotification || type == BPushMarketTransaction) {

    NSDictionary *userinfoDic = @{ @"UIApplicationLaunchOptionsRemoteNotificationKey" : userInfo };
    [[NSUserDefaults standardUserDefaults] setObject:userinfoDic forKey:@"userInfo"];
    if (application.applicationState == UIApplicationStateActive) {
      [BpushModelDeal BPushTextAnimationWithMessgate:userInfo];
    } else if (application.applicationState == UIApplicationStateInactive) {
      if (type == BPushStockPricesEarlyWarning || type == BPushMarketTransaction) {
        [YouguuSchema forwardPageFromNoticfication:userInfo];
        [BpushModelDeal saveStockWarningData:userInfo];
      } else {
        NSString *loginSuccess = [SimuUtil getSesionID];
        if ([loginSuccess length] > 0) {
          [self sendNotification:userInfo];
        }
      }
    }
  } else if (type == BPushTalkingStockNewsCenter) { // BPushTalkingStockNewsCenter =
                                                    // 3,// 聊股消息中心提醒
    // msgtype： @我 = 2，回复 = 1，关注 = 3，赞 = 4
    //    MessageType messageType = [msgtype intValue];
    if (application.applicationState == UIApplicationStateActive) {
      YLBpushType bpushType = [msgtype intValue];
      ///在应用里面收到应用推送
      [UserBpushInformationNum increaseUnReadCountWithMessageType:bpushType];
    }
  }
  //显示收到的信息
  [BPush handleNotification:userInfo];
  //
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
  return NO;
}
#pragma mark
#pragma mark---------umemng---------
- (void)umengInfo {
  // 如果不需要捕捉异常，注释掉此行
  [MobClick setCrashReportEnabled:YES];
  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
  [MobClick setLogEnabled:NO];
  //参数为NSString
  //*类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
  [MobClick setAppVersion:XcodeAppVersion];
  //
  [MobClick startWithAppkey:UMENG_APPKEY
               reportPolicy:(ReportPolicy)REALTIME
                  channelId:Ument_channelId];

  [MobClick checkUpdate]; //自动更新检查,
  //如果需要自定义更新请使用下面的方法,需要接收一个(NSDictionary
  //*)appInfo的参数

  [MobClick setLogSendInterval:60];
  [MobClick updateOnlineConfig]; //在线参数配置

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(onlineConfigCallBack:)
                                               name:UMOnlineConfigDidFinishedNotification
                                             object:nil];
}
- (void)umengEvent:(NSString *)eventId
        attributes:(NSDictionary *)attributes
            number:(NSNumber *)number {
  NSString *numberKey = @"__ct__";
  NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:attributes];
  mutableDictionary[numberKey] = [number stringValue];
  [MobClick event:eventId attributes:mutableDictionary];
}
- (void)onlineConfigCallBack:(NSNotification *)note {
  //[MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(REALTIME)
  // channelId:nil];
  // [self umengEvent:@"0001" attributes:@{@"模拟炒股":@"0001",
  // @"模拟炒股":@"模拟炒股"} number:nil];
  // NSLog(@"online config has fininshed and note = %@", note.userInfo);
  //  [self deviceInfo];
}

#pragma mark
#pragma mark------版本更新相关------
/*
 *功能：苹果商店升级函数（从苹果商店上，取得升级消息）
 */
- (void)onCheckVersion {
  NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
  NSString *currentVersion = infoDic[@"CFBundleVersion"];

  NSString *URL = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", [SimuUtil appid]];
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
  [request setURL:[NSURL URLWithString:URL]];
  [request setHTTPMethod:@"POST"];
  NSHTTPURLResponse *urlResponse = nil;
  NSError *error = nil;
  NSData *recervedData =
      [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];

  NSString *results = [[NSString alloc] initWithBytes:[recervedData bytes]
                                               length:[recervedData length]
                                             encoding:NSUTF8StringEncoding];
  if (results == nil || [results length] == 0)
    return;
  NSDictionary *dic = [results objectFromJSONString];
  // NSLog(@"%@",dic);
  NSArray *infoArray = dic[@"results"];
  if ([infoArray count]) {
    NSDictionary *releaseInfo = infoArray[0];
    NSString *lastVersion = releaseInfo[@"version"];
    if (![lastVersion isEqualToString:currentVersion]) {
      // trackViewURL = [releaseInfo objectForKey:@"trackVireUrl"];
      UIAlertView *alert =
          [[UIAlertView alloc] initWithTitle:@"升级提示"
                                     message:@" \"优顾炒股\" "
                                     @"已推出了新版，便于您使用体验，请升级。"
                                    delegate:self
                           cancelButtonTitle:@"取消"
                           otherButtonTitles:@"升级", nil];
      alert.tag = 10000;
      [alert show];
    }
  }
}
/*
 *功能：版本服务器升级函数（从公司的版本服务器上，取得升级消息）
 */
- (void)onCheckVersionForSevers {
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak AppDelegate *weakSelf = self;
  callback.onSuccess = ^(NSObject *obj) {

    AppDelegate *strongSelf = weakSelf;
    if (strongSelf) {
      AppUpdateInfo *appUpdateInfo = (AppUpdateInfo *)obj;
      [strongSelf bindAppUpdateInfo:appUpdateInfo];
    }
  };
  [AppUpdateInfo checkLatestAppVersion:callback];
}

- (void)bindAppUpdateInfo:(AppUpdateInfo *)appUpdateInfo {
  if ([appUpdateInfo.status isEqualToString:ALREADY_LATEST_APP]) {
    //最新版本
    _is_needUpData = NO;
  } else {
    //普通升级
    _is_needUpData = YES;
    NSString *titel = [NSString stringWithFormat:@"发现新版本%@", appUpdateInfo.version];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titel
                                                    message:appUpdateInfo.message
                                                   delegate:self
                                          cancelButtonTitle:@"下次再说"
                                          otherButtonTitles:@"立即更新", nil];
    alert.tag = 10000;
    [alert show];
  }
}

#pragma mark
#pragma mark alertViewdelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (alertView.tag == 10000) {
    if (buttonIndex == 1) {
      //[[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
      NSString *urlStr =
          [NSString stringWithFormat:@"itms-apps://itunes.apple.com/us/app/id%@?mt=8", [SimuUtil appid]];
      NSURL *url = [NSURL URLWithString:urlStr];
      [[UIApplication sharedApplication] openURL:url];
    }
  } else if (alertView.tag == 1000) {
    if (buttonIndex == 1) {
      NSString *loginSuccess = [SimuUtil getSesionID];
      if ([loginSuccess length] > 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotifactionLoginSuccess
                                                            object:nil
                                                          userInfo:self.app_userinfo];
      }
    }
  }
}
- (void)didPresentAlertView:(UIAlertView *)alertView {
}

#pragma mark

#pragma mark
#pragma mark------分享，绑定---------
- (void)userAuth {
  //添加新浪微博应用
  [ShareSDK connectSinaWeiboWithAppKey:@"3378757548"
                             appSecret:@"873068b6523566c09b72df1c28cab791"
                           redirectUri:@"http://www.youguu.com"];
  //腾讯微博
  [ShareSDK connectTencentWeiboWithAppKey:@"801299558"
                                appSecret:@"b53e57bd1e329d3c6b566d655f64ffab"
                              redirectUri:@"http://www.youguu.com"
                                 wbApiCls:[WeiboApi class]];
  //微信
  [ShareSDK connectWeChatWithAppId:@"wx60dea140d03d3194"
                         appSecret:@"d3d8e8e7b1092e5951f500d98c880ca0"
                         wechatCls:[WXApi class]];
  //连接短信分享
  [ShareSDK connectSMS];
  [ShareSDK connectQQWithQZoneAppKey:@"100530934"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
  [ShareSDK connectQZoneWithAppKey:@"100530934"
                         appSecret:@"a0d7f7d9fc80ebd1d7747690f9f15dfe"
                 qqApiInterfaceCls:nil
                   tencentOAuthCls:nil];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
  NSLog(@"url recieved: %@", url);
  NSLog(@"query string: %@", [url query]);
  NSLog(@"host: %@", [url host]);
  NSLog(@"url path: %@", [url path]);
  if ([[url scheme] isEqualToString:@"youguu"]) {
    [YouguuSchema handleYouguuUrl:url];
    return YES;
  }
  return [ShareSDK handleOpenURL:url wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
  if ([[url scheme] isEqualToString:@"youguu"]) {
    [YouguuSchema handleYouguuUrl:url];
    return YES;
  }
  return [ShareSDK handleOpenURL:url
               sourceApplication:sourceApplication
                      annotation:annotation
                      wxDelegate:self];
}

+ (void)pushViewControllerFromRight:(UIViewController *)viewController {
  [AppDelegate pushViewController:viewController];
};

+ (void)pushViewControllerFromBottom:(UIViewController *)viewController {
  AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;

  UINavigationController *navigationController = app.viewController.navigationController;

  CATransition *transition = [CATransition animation];
  transition.duration = 0.35f;
  transition.type = kCATransitionMoveIn;
  transition.subtype = kCATransitionFromTop;
  [navigationController.view.layer addAnimation:transition forKey:kCATransition];
  [navigationController pushViewController:viewController animated:NO];
}

+ (void)pushViewController:(UIViewController *)toViewController {
  AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;

  if (app.isPushing) {
    NSLog(@"🔞" @"亲" @"，" @"请"
          @"别同时点击两个按钮哦！本次萌哥就给你屏蔽了，" @"下不"
          @"为例哦" @"~" @"！🔞");
    return;
  }
  app.isPushing = YES;
  UINavigationController *navigationController = app.viewController.navigationController;

  [navigationController pushViewController:toViewController animated:YES];
}

//弹出完成后
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
  self.isPushing = NO;
}

+ (void)popViewController:(BOOL)animated {
  AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
  [app.viewController.navigationController popViewControllerAnimated:animated];
  NSLog(@"popViewController, current view controller hierarchy: \n %@",
        [app.viewController.navigationController recursiveDescription]);
}

///向下弹走页面
+ (void)popViewControllerToBottom {
  AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
  UINavigationController *navigationController = app.viewController.navigationController;
  CATransition *transition = [CATransition animation];
  transition.duration = 0.35f;
  transition.type = kCATransitionReveal;
  transition.subtype = kCATransitionFromBottom;
  [navigationController.view.layer addAnimation:transition forKey:kCATransition];
  [navigationController popViewControllerAnimated:NO];
  NSLog(@"popViewController, current view controller hierarchy: \n %@",
        [app.viewController.navigationController recursiveDescription]);
}

+ (void)popToViewController:(UIViewController *)viewController aminited:(BOOL)animated {
  AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
  [app.viewController.navigationController popToViewController:viewController animated:animated];
  NSLog(@"popToViewController, current view controller hierarchy: \n %@",
        [app.viewController.navigationController recursiveDescription]);
}

+ (UIViewController *)topMostController {
  UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;

  while (topController.presentedViewController) {
    topController = topController.presentedViewController;
  }

  return topController;
}

+ (void)popToRootViewController:(BOOL)animated {
  AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
  [app.viewController.navigationController popToRootViewControllerAnimated:YES];
}

+ (NSManagedObjectContext *)getManagedObjectContext {
  return [CoreDataController sharedInstance].managedObjectContext;
}

///重置导航条取消按钮颜色
+ (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController {
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
  [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
  //设置NavigationBar背景颜色
  if (SYSTEM_VERSION >= 7.0) {
    [[UINavigationBar appearance] setBarTintColor:[Globle colorFromHexRGB:@"236cb1"]];
  }

  [[UINavigationBar appearance]
      setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

  UIColor *tintColor;
  if (SYSTEM_VERSION >= 7.0) {
    tintColor = [Globle colorFromHexRGB:@"4dfdff"];
  } else {
    tintColor = [Globle colorFromHexRGB:Color_Blue_but];
  }

  viewController.navigationItem.leftBarButtonItem.tintColor = tintColor;
  viewController.navigationItem.backBarButtonItem.tintColor = tintColor;
  viewController.navigationItem.rightBarButtonItem.tintColor = tintColor;
  navigationController.navigationBar.tintColor = tintColor;
}

@end
