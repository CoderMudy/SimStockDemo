
//
//  SimuUtil.m
//  SimuStock
//
//  Created by Mac on 13-8-12.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "SimuUtil.h"
#import "UIDevice+IdentifierAddition.h"
#import "Reachability.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "CacheUtil.h"
#import "FTCoreTextView.h"

#import "SimuTradeStatus.h"

@implementation DynamicAk

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.ak = dic[@"result"][@"ak"];
  self.replace = dic[@"result"][@"replace"];
}

@end

@implementation SimuUtil

#pragma mark
#pragma mark---------WebView_Agent(带信息)---------
+ (void)WebViewUserAgent:(UIWebView *)webview {
  NSString *secretAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"YL_userAgent"];
  if (!(secretAgent && [secretAgent length] > 0)) {
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    secretAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];

    if (secretAgent) {
      [[NSUserDefaults standardUserDefaults] setObject:secretAgent forKey:@"YL_userAgent"];
    }
  }
  NSString *version =
      [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];

  NSString *newUagent =
      [NSString stringWithFormat:@"%@ jhss/ios/mncg/%@/%@/%@/%@", secretAgent, version,
                                 [SimuUtil getAK], [SimuUtil getUserID], [SimuUtil getSesionID]];
  NSLog(@"打印userAgent：%@", newUagent);

  NSDictionary *dictionary = @{ @"UserAgent" : newUagent };
  [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
}

#pragma end

#pragma mark
#pragma mark---------推送开关是否开启---------
+ (BOOL)hasNotificationsEnabled {
  NSString *iOSversion = [[UIDevice currentDevice] systemVersion];
  NSString *prefix = [[iOSversion componentsSeparatedByString:@"."] firstObject];
  float versionVal = [prefix floatValue];

  if (versionVal >= 8) {
    NSLog(@"%@", [[UIApplication sharedApplication] currentUserNotificationSettings]);
    // The output of this log shows that the app is registered for PUSH so
    // should receive them
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types != UIUserNotificationTypeNone) {
      return YES;
    }
  } else {
    UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    if (types != UIRemoteNotificationTypeNone) {
      return YES;
    }
  }
  return NO;
}
#pragma end

+ (NSString *)appid {
  return @"735945050";
}

+ (NSString *)getUUID {
  NSUserDefaults *preference = [NSUserDefaults standardUserDefaults];
  NSString *uuid = [preference objectForKey:@"UUID_ID"];
  if (uuid == nil || [uuid length] == 0) {
    NSString *uuidString;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
      // create a new UUID
      CFUUIDRef uuidObj = CFUUIDCreate(nil);

      // get the string representation of the UUID
      uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));

      CFRelease(uuidObj);
    } else {
      uuidString = [SimuUtil getMacAdressAndMd5];
    }
    [preference setObject:uuidString forKey:@"UUID_ID"];
    [preference synchronize];
    return uuidString;
  } else {
    return uuid;
  }
}

+ (NSString *)getMacAdressAndMd5 {
  return [[UIDevice currentDevice] uniqueGlobalDeviceIdentifier];
}

+ (NSString *)getIphoneName {
  return [[UIDevice currentDevice] name];
}

+ (NSString *)getDevicesName {
  NSString *deviceName = [[UIDevice currentDevice] systemName];
  return deviceName;
}

+ (NSString *)getsystemVersions {
  NSString *phoneVersion = [[UIDevice currentDevice] systemVersion];
  return phoneVersion;
}

+ (NSString *)getDevicesModel {
  NSString *phoneModel = [[UIDevice currentDevice] model];
  return phoneModel;
}

+ (NSString *)getLocalDeviceModel {
  NSString *localPhoneModel = [[UIDevice currentDevice] localizedModel];
  return localPhoneModel;
}

+ (NSString *)getAppName {
  NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
  NSString *appCurName = infoDictionary[@"CFBundleDisplayName"];
  return appCurName;
}

+ (NSString *)getAppVersions {
  NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
  NSString *appCurVersion = infoDictionary[@"CFBundleShortVersionString"];
  return appCurVersion;
}

+ (int)getAppVersionsWithInt {
  NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
  NSString *appCurVersionNum = infoDictionary[@"CFBundleVersion"];
  return [appCurVersionNum intValue];
}

+ (NSString *)getScreenScol {
  CGRect rect_screen = [[UIScreen mainScreen] bounds];
  CGSize size_screen = rect_screen.size;

  CGFloat scale_screen = [UIScreen mainScreen].scale;

  CGSize size = CGSizeMake(size_screen.width * scale_screen, size_screen.height * scale_screen);
  NSInteger width = size.width;
  NSInteger height = size.height;
  NSString *rusult = [NSString stringWithFormat:@"%ld*%ld", (long)width, (long)height];
  return rusult;
}

+ (NSString *)getNetWorkType {
  if ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable) {
    return @"wifi";
  }
  if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable) {
    return @"3G";
  }

  return @"wifi";
}

+ (NSString *)checkCarrier {
  CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];

  CTCarrier *carrier = [netInfo subscriberCellularProvider];

  // lq
  NSString *carrierCode = [carrier carrierName];

  if ([carrierCode isEqualToString:@""] || carrierCode == nil) {
    return @"WiFi";
  }
  return carrierCode;
}

+ (BOOL)isExistNetwork {
  AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  return [appDelegate isExistNetwork];
}

// 是否wifi
+ (BOOL)IsEnableWIFI {
  return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}

// 是否3G
+ (BOOL)IsEnable3G {
  return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}

+ (BOOL)isAppFirstStart {
  if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
    return YES;
  else
    return NO;
}

+ (NSString *)getCorTime {
  NSDate *date = [NSDate date];
  NSTimeInterval a = [date timeIntervalSince1970] * 1000;
  // NSString *timeString = [NSString stringWithFormat:@"%f", a];
  int64_t dTime = [@(a) longLongValue];                           // 将double转为int64_t型
  NSString *curTime = [NSString stringWithFormat:@"%llu", dTime]; // 输出int64_t型
  return curTime;
}

//保存登录时间,登录时调用
+ (void)setLoginTime {
  NSString *time = [self getCorTime];
  [SimuUtil saveUserPreferenceObject:time forKey:@"Login_Time_Save"];
}

//得到登录时间
+ (NSString *)getLoginTime {
  return [SimuUtil getUserPreferenceObjectForKey:@"Login_Time_Save"];
}

///用户实名认证姓名
+ (NSString *)getUserCertName {
  NSString *usercertName = [[NSUserDefaults standardUserDefaults] objectForKey:Defaut_UserCertName];
  if (usercertName == nil || [usercertName length] == 0) {
    return @"";
  }
  return usercertName;
}
///用户实名认证身份证号
+ (NSString *)getUserCertNo {
  NSString *usercertNo = [[NSUserDefaults standardUserDefaults] objectForKey:Defaut_UserCertNO];
  if (usercertNo == nil || [usercertNo length] == 0) {
    return @"";
  }
  return usercertNo;
}
+ (NSString *)getMatchUniversionListVersion {
  NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:Defaut_Match_University_Version];
  if (version == nil || [version length] == 0) {
    return @"";
  }
  return version;
}

static NSString *cachedUserId;

+ (NSString *)getUserID {
  if (cachedUserId) {
    return cachedUserId;
  }
  NSString *youguuUserId = [[NSUserDefaults standardUserDefaults] objectForKey:Defaut_YouGu_UserID];
  if (youguuUserId == nil || [youguuUserId length] == 0) {
    NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:Defaut_UserID];
    if (userid == nil || [userid length] == 0) {
      cachedUserId = @"-1";
    } else {
      cachedUserId = userid;
    }
  } else {
    cachedUserId = youguuUserId;
  }
  return cachedUserId;
}
+ (void)setUserID:(NSString *)userId {
  if (userId == nil || [userId length] == 0)
    return;
  cachedUserId = userId;
  [[NSUserDefaults standardUserDefaults] setObject:userId forKey:Defaut_YouGu_UserID];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

///恒生ID
+ (NSString *)getHsUserID {
  NSString *hsUserId = [[NSUserDefaults standardUserDefaults] objectForKey:Defaut_HsUserId];
  if (hsUserId == nil || [hsUserId length] == 0) {
    return @"-1";
  }
  return hsUserId;
}

+ (void)setUserCertName:(NSString *)user_certname {
  if (user_certname == nil || [user_certname length] == 0)
    user_certname = @"";
  [[NSUserDefaults standardUserDefaults] setObject:user_certname forKey:Defaut_UserCertName];
  [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)setUserCertNo:(NSString *)user_certno {
  if (user_certno == nil || [user_certno length] == 0)
    user_certno = @"";
  [[NSUserDefaults standardUserDefaults] setObject:user_certno forKey:Defaut_UserCertNO];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setMatchListVersion:(NSString *)version {
  if (version == nil || [version length] == 0)
    return;
  [[NSUserDefaults standardUserDefaults] setObject:version forKey:Defaut_Match_University_Version];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setHsUserID:(NSString *)hsUser_id {
  if (hsUser_id == nil || [hsUser_id length] == 0)
    return;
  [[NSUserDefaults standardUserDefaults] setObject:hsUser_id forKey:Defaut_HsUserId];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getUserPassword {
  NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:Default_UserPassword];
  if (password == nil || [password length] == 0) {
    return @"";
  }
  return password;
}

+ (void)setUserPassword:(NSString *)password {
  if (password == nil || [password length] == 0)
    return;
  [[NSUserDefaults standardUserDefaults] setObject:password forKey:Default_UserPassword];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

static NSString *cachedSessionId;

+ (NSString *)getSesionID {
  if (cachedSessionId) {
    return cachedSessionId;
  }
  NSString *m_sid = [SimuUtil getUserPreferenceObjectForKey:Defaut_Sid];
  if (m_sid == nil || [m_sid length] == 0) {
    cachedSessionId = simu_sid;
  } else {
    cachedSessionId = m_sid;
  }
  return cachedSessionId;
}

+ (void)setSesionID:(NSString *)sesion_id {
  if (sesion_id == nil || [sesion_id length] == 0)
    return;
  cachedSessionId = sesion_id;
  [SimuUtil saveUserPreferenceObject:sesion_id forKey:Defaut_Sid];
}

+ (NSString *)getUserNickName {
  NSString *nickname = [SimuUtil getUserPreferenceObjectForKey:@"USER_NICKNAME"];
  if (nickname == nil || [nickname length] == 0) {
    return @"";
  }
  return nickname;
}

+ (void)setUserNiceName:(NSString *)nick_name {
  if (nick_name == nil || [nick_name length] == 0)
    return;

  [SimuUtil saveUserPreferenceObject:nick_name forKey:@"USER_NICKNAME"];
}

static NSString *cachedUserName;

+ (NSString *)getUserName {
  if (cachedUserName) {
    return cachedUserName;
  }
  NSString *username = [SimuUtil getUserPreferenceObjectForKey:@"USER_NAME"];
  if (username == nil || [username length] == 0) {
    cachedUserName = @"";
  } else {
    cachedUserName = username;
  }
  return cachedUserName;
}

+ (void)setUserName:(NSString *)username {
  if (username == nil || [username length] == 0)
    return;
  cachedUserName = username;
  [SimuUtil saveUserPreferenceObject:username forKey:@"USER_NAME"];
}

+ (void)setMarketRefreshTime:(NSString *)refreshTime {
  if (refreshTime == nil || [refreshTime length] == 0)
    return;
  [[NSUserDefaults standardUserDefaults] setObject:refreshTime forKey:REFRESH_TIME_ROW];
}

+ (NSString *)getMarketRefreshTime {
  NSString *refreshTime = [[NSUserDefaults standardUserDefaults] objectForKey:REFRESH_TIME_ROW];
  if (refreshTime == nil || [refreshTime length] == 0) {
    return @"";
  }
  return refreshTime;
}

/** 获得vip等级 */
+ (NSString *)getUserVipType {
  NSString *userVipType = [SimuUtil getUserPreferenceObjectForKey:@"USER_VIP_TYPE"];
  if (userVipType == nil || [userVipType length] == 0) {
    return @"-1";
  }
  return userVipType;
}

/** 存取vip等级 */
+ (void)setUserVipType:(NSString *)vipType {
  if (vipType == nil || [vipType isKindOfClass:[NSNull class]])
    return;

  [SimuUtil saveUserPreferenceObject:vipType forKey:@"USER_VIP_TYPE"];
}

/** 获得stockFirmFlag */
+ (NSString *)getStockFirmFlag {
  NSString *stockFirmFlag = [SimuUtil getUserPreferenceObjectForKey:@"USER_STOCK_FIRM_FLAG"];
  if (stockFirmFlag == nil || [stockFirmFlag length] == 0) {
    return @"";
  }
  return stockFirmFlag;
}

/** 存取stockFirmFlag */
+ (void)setStockFirmFlag:(NSString *)stockFirmFlag {
  if (stockFirmFlag == nil || [stockFirmFlag isKindOfClass:[NSNull class]])
    return;
  [SimuUtil saveUserPreferenceObject:stockFirmFlag forKey:@"USER_STOCK_FIRM_FLAG"];
}

+ (NSString *)getUserSignature {
  NSString *usersignature = [SimuUtil getUserPreferenceObjectForKey:@"USER_SIGNATURE"];
  if (usersignature == nil || [usersignature isKindOfClass:[NSNull class]] || [usersignature length] == 0) {
    return @"";
  }
  return usersignature;
}

+ (void)setUserSignature:(NSString *)signature {
  if (signature == nil || [signature isKindOfClass:[NSNull class]])
    return;

  [SimuUtil saveUserPreferenceObject:signature forKey:@"USER_SIGNATURE"];
}

//设置当前用户手机
+ (void)setUserPhone:(NSString *)phone {
  if (phone == nil || [phone isKindOfClass:[NSNull class]] || [phone length] == 0)
    phone = @"";
  [SimuUtil saveUserPreferenceObject:phone forKey:@"PHONE_NUMBER"];
}

//获取当前用户绑定的手机
+ (NSString *)getUserPhone {
  NSString *phone = [SimuUtil getUserPreferenceObjectForKey:@"PHONE_NUMBER"];
  if (phone == nil || [phone length] == 0) {
    return @"";
  }
  return phone;
}

//得到当前用户总资产
+ (NSString *)getCorUserFound {
  NSString *founds = [SimuUtil getUserPreferenceObjectForKey:@"User_Founds_Cor"];
  if (founds == nil || [founds length] == 0) {
    return @"";
  }
  return founds;
}
//设置当前用户总资产
+ (void)setCorUserFound:(NSString *)founds {
  if (founds == nil || [founds length] == 0)
    return;
  [SimuUtil saveUserPreferenceObject:founds forKey:@"User_Founds_Cor"];
}
+ (void)setBaiduUserId:(NSString *)baiduUserId {
  if (baiduUserId == nil)
    return;
  [SimuUtil saveUserPreferenceObject:baiduUserId forKey:@"BAIDU_UserID"];
};

+ (NSString *)getBaiduUserId {
  return [SimuUtil getUserPreferenceObjectForKey:@"BAIDU_UserID"];
};

+ (void)setUserImageURL:(NSString *)headImageUrl {
  [SimuUtil saveUserPreferenceObject:headImageUrl forKey:@"HEAD_IMAGE_URL"];
}

+ (NSString *)getUserImageURL {
  NSString *userHeadImage = [SimuUtil getUserPreferenceObjectForKey:@"HEAD_IMAGE_URL"];
  if (userHeadImage == nil || [userHeadImage length] == 0) {
    return @"";
  }
  return userHeadImage;
}

/**
 返回用户属性值，对于传入的key，自动附加用户id，这样每个用户的属性保存在不同地方，不互相冲突
 */
+ (id)getUserPreferenceObjectForKey:(NSString *)key {
  NSString *keyWithUid = [key stringByAppendingString:[SimuUtil getUserID]];
  return [[NSUserDefaults standardUserDefaults] objectForKey:keyWithUid];
}

/**
 保存用户属性，对于传入的key，自动附加用户id，这样每个用户的属性保存在不同地方，不互相冲突
 */
+ (void)saveUserPreferenceObject:(NSObject *)object forKey:(NSString *)key {
  NSString *keyWithUid = [key stringByAppendingString:[SimuUtil getUserID]];
  NSUserDefaults *preference = [NSUserDefaults standardUserDefaults];
  [preference setObject:object forKey:keyWithUid];
  [preference synchronize];
}

//版本信息: 前2位+最后4位 = 020405 = 2.4.5
static NSString *const defaultAK = @"0210010010405";
static NSString *ak;
static BOOL isRequestAK = NO;

+ (NSString *)getAK {
  if (!ak) {
    ak = [[NSUserDefaults standardUserDefaults] objectForKey:defaultAK];
  }

  if (ak) {
    return ak;
  } else {
    // request and set new ak
    if (!isRequestAK) {
      isRequestAK = YES;
      [self requestDynamicAK];
    }

    return defaultAK;
  }
}

///请求动态AK
+ (void)requestDynamicAK {
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];

  callback.onSuccess = ^(NSObject *obj) {
    NSLog(@"⭐️动态AK获取成功！");
    NSLog(@"obj:%@", obj);
    isRequestAK = NO;
    DynamicAk *dynamicAk = (DynamicAk *)obj;

    NSUserDefaults *preference = [NSUserDefaults standardUserDefaults];

    if ([dynamicAk.replace intValue] != 0) {
      [preference setObject:dynamicAk.ak forKey:defaultAK];
    } else {
      [preference setObject:defaultAK forKey:defaultAK];
    }
    [preference synchronize];

  };
  callback.onFailed = ^{
    isRequestAK = NO;
    NSLog(@"动态AK请求失败");
  };
  callback.onError = ^(BaseRequestObject *err, NSException *ex) {
    isRequestAK = NO;
    NSLog(@"动态AK错误状态：%@", err.status);
    NSLog(@"动态AK错误信息：%@", err.message);
  };

  NSString *url =
      [user_address stringByAppendingString:@"jhss/member/dynamicAk?ak={ak}&idfa={idfa}"];
  UIDevice *dv = [UIDevice currentDevice];
  NSDictionary *dic = @{
    @"ak" : defaultAK,
    @"idfa" : [dv idfa],
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[DynamicAk class]
             withHttpRequestCallBack:callback];
}

+ (BOOL)isLogined {
  return ![@"-1" isEqualToString:[SimuUtil getUserID]];
}

//完善个人资料
+ (void)setPersonalInfo:(NSString *)taskId {
  [SimuUtil saveUserPreferenceObject:taskId forKey:PersonalInfo_TaskId];
}

//完善个人资料任务ID
+ (NSString *)getPersonalInfo {
  NSString *taskId = [SimuUtil getUserPreferenceObjectForKey:PersonalInfo_TaskId];

  if (taskId == nil || [taskId length] == 0)
    return @"";
  return taskId;
}

//首次分享
+ (void)setFirstShare:(NSString *)taskId {
  [SimuUtil saveUserPreferenceObject:taskId forKey:FirstShare_TaskId];
}

//获取首次分享任务ID
+ (NSString *)getFirstShare {
  NSString *taskId = [SimuUtil getUserPreferenceObjectForKey:FirstShare_TaskId];

  if (taskId == nil || [taskId length] == 0)
    return @"";
  return taskId;
}
//首次关注他人
+ (void)setAttentionOthers:(NSString *)taskId {
  [SimuUtil saveUserPreferenceObject:taskId forKey:FirstAttention_TaskId];
}

//获取首次关注他人任务ID
+ (NSString *)getAttentionOthers {
  NSString *taskId = [SimuUtil getUserPreferenceObjectForKey:FirstAttention_TaskId];
  if (taskId == nil || [taskId length] == 0)
    return @"";
  return taskId;
}

//首次添加自选股
+ (void)setFirstSetAddSelfStock:(NSString *)taskId {
  [SimuUtil saveUserPreferenceObject:taskId forKey:SelfStock_TaskId];
}

//获取添加自选股任务ID
+ (NSString *)getFirstSetAddSelfStock {
  NSString *taskId = [SimuUtil getUserPreferenceObjectForKey:SelfStock_TaskId];

  if (taskId == nil || [taskId length] == 0)
    return @"";
  return taskId;
}

//首次设置股价预警
+ (void)setFirstSetStockAlarm:(NSString *)taskId {
  [SimuUtil saveUserPreferenceObject:taskId forKey:SelfStockAlarm_TaskId];
}

//首次设置股价预警
+ (NSString *)getFirstSetStockAlarm {
  NSString *taskId = [SimuUtil getUserPreferenceObjectForKey:SelfStockAlarm_TaskId];

  if (taskId == nil || [taskId length] == 0)
    return @"";
  return taskId;
}

/*
 *功能：int*1000 ，得到四舍五入的小数字符串
 *参数：data: 乘1000后的值 count: 保留小数位数 msign: yes 带符号 no 不带符号
 */
+ (NSString *)formatDecimal:(NSInteger)data ForDeciNum:(NSInteger)count ForSign:(BOOL)msign {
  if (msign == YES) {
    //带符号
    CGFloat m_fscale = ((CGFloat)data) / 1000;
    NSString *text = nil;
    NSInteger m_nnumber = count;

    if (m_nnumber == 0) {
      text = [NSString stringWithFormat:@"%0.0f", m_fscale];
    } else if (m_nnumber == 1) {
      text = [NSString stringWithFormat:@"%0.1f", m_fscale];

    } else if (m_nnumber == 2) {
      text = [NSString stringWithFormat:@"%0.2f", m_fscale];
    } else if (m_nnumber == 3) {
      text = [NSString stringWithFormat:@"%0.3f", m_fscale];
    } else {
      text = [NSString stringWithFormat:@"%0.4f", m_fscale];
    }
    return text;

  } else {
    //不带符号
    return nil;
  }
}

+ (NSString *)change64iNTtoStringWithUnit:(int64_t)inputnum {
  int64_t m_scale = inputnum;
  //对量进行判断
  NSMutableString *voleumScale = nil;
  if (m_scale >= 100000000) {
    //大于亿，以亿为单位
    NSInteger m_nscale = (m_scale / 100000);
    // CGFloat m_fscale=((CGFloat)m_nscale)/1000;
    voleumScale = [NSMutableString stringWithString:[SimuUtil formatDecimal:m_nscale
                                                                 ForDeciNum:2
                                                                    ForSign:YES]]; //[NSMutableString
    // stringWithFormat:@"%0.3f",m_fscale];
    [voleumScale appendString:@"亿"];
  } else if (m_scale >= 10000) {
    //大于万，以万为单位
    NSInteger m_nscale = (m_scale / 10);
    // CGFloat m_fscale=((CGFloat)m_nscale)/1000;
    voleumScale = [NSMutableString stringWithString:[SimuUtil formatDecimal:m_nscale
                                                                 ForDeciNum:2
                                                                    ForSign:YES]]; //[NSMutableString
    // stringWithFormat:@"%0.3f",m_fscale];
    [voleumScale appendString:@"万"];

  } else {
    NSInteger m_nscale = m_scale;
    voleumScale = [NSMutableString stringWithFormat:@"%ld", (long)m_nscale];
  }
  return voleumScale;
}

+ (NSInteger)getCorRefreshTime {
  NSString *username = [SimuUtil getUserPreferenceObjectForKey:@"REFRESH_TIME"];
  if (username == nil || [username length] == 0) {
    return 10;
  }
  NSArray *array = @[ @"手动刷新", @"5秒", @"10秒", @"20秒", @"30秒" ];
  NSInteger refreshTime = 0;
  NSInteger index = 0;
  for (NSString *obj in array) {
    if ([username isEqualToString:obj]) {
      break;
    }
    index++;
  }
  if (index == 3) {
    refreshTime = 5 * 4;
  } else if (index == 4) {
    refreshTime = 5 * 6;
  } else {
    refreshTime = 5 * index;
  }
  return refreshTime;
}

+ (BOOL)setCorRefreshTime:(NSString *)refreshTime {
  if (refreshTime == nil || [refreshTime length] == 0)
    return NO;
  [SimuUtil saveUserPreferenceObject:refreshTime forKey:@"REFRESH_TIME"];
  return YES;
}

//加入搜索纪录
+ (BOOL)addSearchHistryStockContent:(NSString *)stockCode {
  if (stockCode == nil || [stockCode length] != 8) {
    return NO;
  }
  //查询股票
  NSString *stockCodes = [self getSearchHistryStockContent];

  //  if (stockCodes == nil)
  //    stockCodes = @"";
  ////  stockCode=[stockCode stringByAppendingString:@","];
  //  stockCode=[NSString stringWithFormat:@"%@,",stockCode];
  //  if ([self isSearchHistryStockContent:stockCode] == YES) {
  //    [self deleteSearchHistryStockContent:stockCode];
  //  }
  //
  //  stockCodes = [self getSearchHistryStockContent];
  NSArray *array = [stockCodes componentsSeparatedByString:@","];
  NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:0];
  [resultArray addObject:stockCode];
  for (NSString *str in array) {
    if (str && [str length] > 0) {
      if (![SimuUtil isExist:resultArray andStr:str]) {
        [resultArray addObject:str];
        if ([resultArray count] >= 10) {
          break;
        }

      } else {
        continue;
      }
    }
  }
  NSString *resutStr = [resultArray componentsJoinedByString:@","];
  //  NSString * cor_StockCodes = [stockCode stringByAppendingString:resutStr];
  [SimuUtil saveUserPreferenceObject:resutStr forKey:AC_SearchHistry_StockItem];
  return YES;
}
///是否已经存在
+ (BOOL)isExist:(NSMutableArray *)resultarray andStr:(NSString *)string {
  for (NSString *tt in resultarray) {
    if ([string isEqualToString:tt]) {
      return YES;
    }
  }
  return NO;
}

//得到搜索纪录
+ (NSString *)getSearchHistryStockContent {
  return [SimuUtil getUserPreferenceObjectForKey:AC_SearchHistry_StockItem];
}

+ (BOOL)setSearchHistryStockContent:(NSString *)stockCode {
  [SimuUtil saveUserPreferenceObject:stockCode forKey:AC_SearchHistry_StockItem];
  return YES;
}

+ (NSString *)changeIDtoStr:(id)inputstr {
  if (inputstr == nil || inputstr == NULL || [inputstr isKindOfClass:[NSNull class]]) {
    return @"";
  }

  if ([inputstr isKindOfClass:[NSString class]]) {
    return (NSString *)inputstr;
  }

  if ([inputstr isKindOfClass:[NSNumber class]]) {
    return [((NSNumber *)inputstr)stringValue];
  }

  return [NSString stringWithFormat:@"%@", inputstr];
}

/// YuLing字符串是否为空和都是空格
+ (BOOL)isBlankString:(NSString *)string {
  if (string == nil) {
    return YES;
  }
  if (string == NULL) {
    return YES;
  }
  if ([string isKindOfClass:[NSNull class]]) {
    return YES;
  }
  if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
    return YES;
  }
  return NO;
}

+ (NSString *)changeAbsuluteTimeToRelativeTime:(NSString *)absolutetime {
  if (absolutetime == nil || [absolutetime length] == 0)
    return nil;
  //取得服务器时间
  int j = 0;
  NSMutableArray *timearray = [[NSMutableArray alloc] init];
  for (NSString *obj in [absolutetime componentsSeparatedByString:@" "]) {
    if (j == 0) {
      for (NSString *Item in [obj componentsSeparatedByString:@"-"]) {
        [timearray addObject:Item];
      }
    } else {
      for (NSString *Item in [obj componentsSeparatedByString:@":"]) {
        [timearray addObject:Item];
      }
    }
    j++;
  };
  if ([timearray count] < 6)
    return absolutetime;
  //取得当前时间
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
  NSString *locationString = [formatter stringFromDate:[NSDate date]];
  NSMutableArray *loc_timearray = [[NSMutableArray alloc] init];
  int i = 0;
  for (NSString *obj in [locationString componentsSeparatedByString:@" "]) {
    if (i == 0) {
      for (NSString *Item in [obj componentsSeparatedByString:@"-"]) {
        [loc_timearray addObject:Item];
      }
    } else {
      for (NSString *Item in [obj componentsSeparatedByString:@":"]) {
        [loc_timearray addObject:Item];
      }
    }
    i++;
  };
  //比较年
  int sever_year = [timearray[0] intValue];
  NSInteger loc_year = [loc_timearray[0] integerValue];
  NSInteger sever_month = [timearray[1] intValue];
  NSInteger loc_month = [loc_timearray[1] integerValue];
  NSInteger sever_day = [timearray[2] intValue];
  NSInteger loc_day = [loc_timearray[2] integerValue];
  NSInteger sever_hour = [timearray[3] intValue];
  NSInteger loc_hour = [loc_timearray[3] integerValue];
  NSInteger sever_minite = [timearray[4] intValue];
  NSInteger loc_minite = [loc_timearray[4] integerValue];
  //    int sever_seconds=[[timearray objectAtIndex:5] intValue];
  //    int loc_seconds=[[loc_timearray objectAtIndex:5] intValue];

  NSInteger lenth_minite = labs((loc_hour * 60 + loc_minite) - (sever_hour * 60 + sever_minite));

  if (sever_year != loc_year) {
    //往年
    return [NSString stringWithFormat:@"%@年%@月%@日 %@:%@", timearray[0], timearray[1],
                                      timearray[2], timearray[3], timearray[4]];
  } else if (sever_month != loc_month) {
    //今年其他月份
    return [NSString stringWithFormat:@"%@月%@日 %@:%@", timearray[1], timearray[2], timearray[3], timearray[4]];
  } else if ((sever_day != loc_day)) {
    //本月
    if (labs(sever_day - loc_day) == 1) {
      //昨天
      return [NSString stringWithFormat:@"昨天 %@:%@", timearray[3], timearray[4]];

    } else if (labs(sever_day - loc_day) == 2) {
      //前天
      return [NSString stringWithFormat:@"前天 %@:%@", timearray[3], timearray[4]];
    } else {
      //本月其他日期
      return [NSString stringWithFormat:@"%@月%@日 %@:%@", timearray[1], timearray[2], timearray[3], timearray[4]];
    }
  } else {
    //本日
    if (lenth_minite < 1) {
      return @"刚刚";
    } else if (lenth_minite < 60) {
      return [NSString stringWithFormat:@"%ld分钟之前", (long)lenth_minite];

    } else {
      return [NSString stringWithFormat:@"%@:%@", timearray[3], timearray[4]];
    }
  }
  return nil;
}
+ (UIImage *)getPhotoFromName:(NSString *)name {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  // NSFileManager* fileManager=[NSFileManager defaultManager];
  NSString *uniquePath = [paths[0] stringByAppendingPathComponent:name];
  BOOL blHave = [[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
  if (!blHave) {
    return nil;
  } else {
    NSData *data = [NSData dataWithContentsOfFile:uniquePath];
    UIImage *img = [[UIImage alloc] initWithData:data];
    // NSLog(@" have");
    return img;
  }
}

+ (NSString *)getDateFromCtime:(NSNumber *)ctime {
  NSDateFormatter *formatter;
  NSTimeInterval timeInterval = [ctime longLongValue] / 1000;

  NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
  // 1.获得年月日
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDateComponents *cmp1 = [calendar components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit
                                       fromDate:date];
  NSDateComponents *cmp2 = [calendar components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit
                                       fromDate:[NSDate date]];

  NSTimeInterval newTimeInterval = [[NSDate date] timeIntervalSinceDate:date];

  NSInteger temp = 0;
  if (newTimeInterval < 60) {
    return @"刚刚";
  } else if ((temp = newTimeInterval / 60) < 60) {
    return [NSString stringWithFormat:@"%ld分钟前", (long)temp];
  } else if ((temp = temp / 60) < 24 && [cmp1 day] == [cmp2 day]) {
    formatter = [SimuUtil shareNSDateFormatterWithHHmm];
  } else if ([cmp2 day] - 1 == [cmp1 day] && [cmp1 month] == [cmp2 month]) {
    formatter = [SimuUtil shareNSDateFormatterWithYesterdayHHmm];
  } else if ([cmp2 day] - 2 == [cmp1 day] && [cmp1 month] == [cmp2 month]) {
    formatter = [SimuUtil shareNSDateFormatterWith2DayAgoHHmm];
  } else if ([cmp2 year] == [cmp1 year]) {
    formatter = [SimuUtil shareNSDateFormatterWithMMddHHmm];
  } else {
    formatter = [SimuUtil shareNSDateFormatterWithyyyyMMddHHmm];
  }
  NSString *time = [formatter stringFromDate:date];
  return time;
}

+ (NSString *)getFullDateFromCtime:(NSNumber *)ctime {
  NSDateFormatter *formatter = [SimuUtil shareNSDateFormatterWithyyyyMMddHHmm];
  NSTimeInterval timeInterval = [ctime longLongValue] / 1000;

  NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
  [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
  return [formatter stringFromDate:date];
}

+ (NSString *)getDayDateFromCtime:(NSNumber *)ctime {
  NSDateFormatter *formatter = [SimuUtil shareNSDateFormatterWithyyyyMMddHHmm];
  NSTimeInterval timeInterval = [ctime longLongValue] / 1000;

  NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
  [formatter setDateFormat:@"yyyy-MM-dd"];
  return [formatter stringFromDate:date];
}

//返回服务器0时区时间，格式：2015-05-15 12:02:57 UTC
+ (NSDate *)serverDateUTC0 {
  SimuTradeStatus *instance = [SimuTradeStatus instance];
  NSTimeInterval timeInterval = instance.serverTime / 1000;
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
  return date;
}
// NSdateFormatter单例
+ (NSDateFormatter *)shareNSDateFormatterWithHHmm {
  static NSDateFormatter *formatter;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
  });
  return formatter;
}

+ (NSDateFormatter *)shareNSDateFormatterWithYesterdayHHmm {
  static NSDateFormatter *formatter;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"昨天 HH:mm";
  });
  return formatter;
}

+ (NSDateFormatter *)shareNSDateFormatterWith2DayAgoHHmm {
  static NSDateFormatter *formatter;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"前天 HH:mm";
  });
  return formatter;
}

+ (NSDateFormatter *)shareNSDateFormatterWithMMddHHmm {
  static NSDateFormatter *formatter;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM月dd日 HH:mm";
  });
  return formatter;
}
+ (NSString *)getFullDateFromCtimeWithMMddHHmm:(NSNumber *)ctime {
  NSDateFormatter *formatter = [SimuUtil shareNSDateFormatterWithMMddHHmm];
  NSTimeInterval timeInterval = [ctime longLongValue] / 1000;

  NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
  [formatter setDateFormat:@"MM月dd日 HH:mm"];
  return [formatter stringFromDate:date];
}

+ (NSDateFormatter *)shareNSDateFormatterWithyyyyMMddHHmm {
  static NSDateFormatter *formatter;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
  });
  return formatter;
}

#pragma mark - 颜色转图片方法，创建纯色图片
+ (UIImage *)imageFromColor:(NSString *)color {
  CGRect rect = CGRectMake(0, 0, WIDTH_OF_SCREEN, HEIGHT_OF_SCREEN);
  UIGraphicsBeginImageContext(rect.size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetFillColorWithColor(context, [[Globle colorFromHexRGB:color] CGColor]);
  CGContextFillRect(context, rect);
  UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return img;
}

+ (UIImage *)imageFromColor:(NSString *)color alpha:(CGFloat)alpha {
  CGRect rect = CGRectMake(0, 0, WIDTH_OF_SCREEN, HEIGHT_OF_SCREEN);
  UIGraphicsBeginImageContext(rect.size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetFillColorWithColor(context, [[[Globle colorFromHexRGB:color] colorWithAlphaComponent:alpha] CGColor]);
  CGContextFillRect(context, rect);
  UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return img;
}

+ (UIImage *)imageFromColor:(NSString *)color
                      alpha:(CGFloat)alpha
                      width:(CGFloat)width
                     height:(CGFloat)height;
{
  CGRect rect = CGRectMake(0, 0, width, height);
  UIGraphicsBeginImageContext(rect.size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetFillColorWithColor(context, [[[Globle colorFromHexRGB:color] colorWithAlphaComponent:alpha] CGColor]);
  CGContextFillRect(context, rect);
  UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return img;
}

#pragma mark - 去除首尾空格换行及中间换行
+ (NSString *)stringReplaceSpaceAndNewlinew:(NSString *)string {
  string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
  string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
  return string;
}

///去首尾空格
+ (NSString *)stringReplaceSpace:(NSString *)string {
  string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  return string;
}

#pragma mark - 主线程延迟处理
+ (void)performBlockOnMainThread:(void (^)())block withDelaySeconds:(float)delayInSeconds {
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
  dispatch_after(popTime, dispatch_get_main_queue(), block);
}

#pragma mark - 分线程延迟处理
+ (void)performBlockOnGlobalThread:(void (^)())block withDelaySeconds:(float)delayInSeconds {
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
  dispatch_after(popTime, dispatch_get_global_queue(0, 0), block);
}

#pragma mark - 获取动态字符串
+ (NSAttributedString *)attributedString:(NSString *)string
                                   color:(UIColor *)color
                                   range:(NSRange)range {
  NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
  [attrString addAttribute:NSForegroundColorAttributeName value:color range:range];
  return [attrString copy];
}

///计算字段的大小
+ (CGSize)sizeCalculatedFieldfsize:(CGSize)fsize font:(UIFont *)font str:(NSString *)str {
  return [str sizeWithFont:font constrainedToSize:fsize lineBreakMode:NSLineBreakByCharWrapping];
}

/** UIView转UIImage */
+ (UIImage *)imageWithUIView:(UIView *)view {
  // 创建一个bitmap的context
  // 并把它设置成为当前正在使用的context
  UIGraphicsBeginImageContext(view.bounds.size);
  CGContextRef currnetContext = UIGraphicsGetCurrentContext();
  //[view.layer drawInContext:currnetContext];
  [view.layer renderInContext:currnetContext];
  // 从当前context中创建一个改变大小后的图片
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  // 使当前的context出堆栈
  UIGraphicsEndImageContext();
  return image;
}
@end

@implementation SimuUtil (Width)

#pragma mark - 计算并设置FTCoreTextView宽度
+ (void)widthOfFTCoreTextView:(FTCoreTextView *)view
                      content:(NSString *)content
                         font:(CGFloat)font {
  [view setTextSize:font];
  [view fitToSuggestedHeight];

  CGRect frame = view.frame;
  frame.origin.y -= (view.frame.size.height - 14);
  view.frame = frame;
}

#pragma mark - 计算并重设Label宽度
+ (CGFloat)suggestWidthOfLabel:(UILabel *)label {
  //设置一个行高上限
  CGSize size = CGSizeMake(WIDTH_OF_SCREEN, 2000);
  //计算实际frame大小，并将label的frame变成实际大小
  CGSize labelsize = [label.text sizeWithFont:label.font
                            constrainedToSize:size
                                lineBreakMode:NSLineBreakByCharWrapping];

  return labelsize.width + 1; // pang010导致问题，加1即可
}

+ (void)widthOfLabel:(UILabel *)label font:(CGFloat)font {
  //设置一个行高上限
  CGSize size = CGSizeMake(WIDTH_OF_SCREEN, 2000);
  //计算实际frame大小，并将label的frame变成实际大小
  CGSize labelsize = [label.text sizeWithFont:[UIFont systemFontOfSize:font]
                            constrainedToSize:size
                                lineBreakMode:NSLineBreakByCharWrapping];

  label.font = [UIFont systemFontOfSize:font];
  CGRect frame = label.frame;
  frame.size.width = labelsize.width + 1; // pang010导致问题，加1即可
  label.frame = frame;
}

+ (CGFloat)widthNeededOfLabel:(UILabel *)label font:(CGFloat)font {
  //设置一个行高上限
  CGSize size = CGSizeMake(WIDTH_OF_SCREEN, 2000);
  //计算实际frame大小，并将label的frame变成实际大小
  CGSize labelsize = [label.text sizeWithFont:[UIFont systemFontOfSize:font]
                            constrainedToSize:size
                                lineBreakMode:NSLineBreakByCharWrapping];
  return labelsize.width + 1;
}

#pragma mark - 计算button宽度
+ (void)widthOfButton:(UIButton *)button
                title:(NSString *)title
           titleColor:(UIColor *)color
                 font:(CGFloat)font {
  //设置一个行高上限
  CGSize size = CGSizeMake(WIDTH_OF_SCREEN, 2000);
  //计算实际frame大小，并将label的frame变成实际大小
  CGSize buttonSize = [title sizeWithFont:[UIFont systemFontOfSize:font]
                        constrainedToSize:size
                            lineBreakMode:NSLineBreakByWordWrapping];
  [button setTitle:title forState:UIControlStateNormal];
  button.titleLabel.font = [UIFont systemFontOfSize:font];

  if (color) {
    [button setTitleColor:color forState:UIControlStateNormal];
  }

  CGRect frame = button.frame;
  frame.size.width = buttonSize.width + 1; // pang010导致问题，加1即可
  button.frame = frame;
}

/** 计算label内容的宽高 支持6.0系统的 */
+ (CGSize)labelContentSizeWithContent:(NSString *)string
                             withFont:(float)font
                             withSize:(CGSize)labelSize {
  CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:font]
                   constrainedToSize:labelSize
                       lineBreakMode:NSLineBreakByWordWrapping];
  size = CGSizeMake(size.width + 1, size.height + 5);
  return size;
}
/** 计算label的高度 参数 内容 + 字体大小 + size 只能在 7.0上使用 */
#pragma makr-- 计算label的高度 参数 内容 + 字体大小 + size 只能在 7.0上使用
+ (CGSize)boundingRectWithSize:(NSString *)string withFont:(float)font withSize:(CGSize)labelSize {
  NSDictionary *attribute = @{NSFontAttributeName : [UIFont systemFontOfSize:font]};
  CGSize size =
      [string boundingRectWithSize:labelSize
                           options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine)
                        attributes:attribute
                           context:nil]
          .size;

  size = CGSizeMake(size.width, size.height + 5);
  return size;
}

#pragma mark - 指定位小数转为NSString
+ (NSString *)stringFromFloat:(float)number bits:(unsigned int)bits {
  NSString *formatStr = @"%.";
  formatStr = [formatStr stringByAppendingFormat:@"%df", bits];
  NSString *floatStr = [NSString stringWithFormat:formatStr, number];
  return floatStr;
}
+ (NSString *)getCurrentIP {
  NSString *address = @"error";
  struct ifaddrs *interfaces = NULL;
  struct ifaddrs *temp_addr = NULL;
  int success = 0;
  // retrieve the current interfaces - returns 0 on success
  success = getifaddrs(&interfaces);
  if (success == 0) {
    // Loop through linked list of interfaces
    temp_addr = interfaces;
    while (temp_addr != NULL) {
      if (temp_addr->ifa_addr->sa_family == AF_INET) {
        // Check if interface is en0 which is the wifi connection on the iPhone
        if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
          // Get NSString from C String
          address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
        }
      }
      temp_addr = temp_addr->ifa_next;
    }
  }
  // Free memory
  freeifaddrs(interfaces);
  return address;
}

#pragma mark - 取指定位小数
+ (float)getFloatWithFloat:(float)number bits:(unsigned int)bits {
  return [[self stringFromFloat:number bits:bits] floatValue];
}

@end

#pragma 自选股相关
@implementation SimuUtil (SelfGroup)

+ (NSString *)currentSelectedSelfGroupID {
  return [[NSUserDefaults standardUserDefaults] objectForKey:[[SimuUtil getUserID] stringByAppendingString:CurrentShowedGroupID]];
}

+ (void)saveCurrentSelectedSelfGroupID:(NSString *)groupID {
  [[NSUserDefaults standardUserDefaults] setObject:groupID
                                            forKey:[[SimuUtil getUserID] stringByAppendingString:CurrentShowedGroupID]];
}

@end
