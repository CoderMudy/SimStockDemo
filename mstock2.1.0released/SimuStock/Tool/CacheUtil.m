//
//  CacheUtil.m
//  SimuStock
//
//  Created by Mac on 14-11-5.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "CacheUtil.h"
#import "PacketCompressPointFormatRequester.h"
#import "ObjectJsonMappingUtil.h"
#import "FTWCache.h"

@implementation CacheUtil

///用户信息
static NSString *const CACHE_UserInfomation = @"CACHE_UserInfomation";
static const double TIMEOUT_UserInfomation = 60 * 60 * 24 * 30;

///我的关注用户列表
static NSString *const CACHE_AttentionList = @"CACHE_AttentionList";
static const double TIMEOUT_AttentionList = 60 * 60 * 24 * 30;

///首页用户账号和持仓信息
static NSString *const CACHE_ACCOUNT_POSITION = @"userAccountAndPosition";
static const double TIMEOUT_ACCOUNT_POSITION = 60 * 60 * 24 * 3;

///商城资金卡
static NSString *const CACHE_PRODUCT_LIST = @"product_list";
static const double TIMEOUT_PRODUCT_LIST = 60 * 60 * 24 * 3;

///商城道具卡 for app store review
static NSString *const CACHE_PRODUCT_LIST_FOR_REVIEW = @"product_list_for_review";
static const double TIMEOUT_PRODUCT_LIST_FOR_REVIEW = 60 * 60 * 24 * 3;

///商城追踪卡
static NSString *const CACHE_TRACECARD_LIST = @"tracecard_list";
static const double TIMEOUT_TRACECARD_LIST = 60 * 60 * 24 * 3;

///比赛列表
static NSString *const CACHE_MATCH_LIST = @"match_list";
static const double TIMEOUT_MATCH_LIST = 60 * 60 * 24 * 3;

///用户的比赛列表
static NSString *const CACHE_MY_MATCH_LIST = @"my_match_list";
static const double TIMEOUT_MY_MATCH_LIST = 60 * 60 * 24 * 3;

///用户侧边栏的统计数据
static NSString *const CACHE_SLIDER_COUNTER = @"my_slider_counter";
static const double TIMEOUT_SLIDER_COUNTER = 60 * 60 * 24 * 3;

///证券开户列表
static NSString *const CACHE_OPEN_STOCK_ACCOUNT = @"match_list";
static const double TIMEOUT_OPEN_STOCK_ACCOUNT = 60 * 60 * 24 * 3;

///证券登录列表
static NSString *const CACHE_LOGIN_STOCK_ACCOUNT = @"my_match_list";
static const double TIMEOUT_LOGIN_STOCK_ACCOUNT = 60 * 60 * 24 * 3;

///股价预警列表
static NSString *const CACHE_STOCK_ALARMS = @"stock_alarm_list";
static const double TIMEOUT_STOCK_ALARMS = 60 * 60 * 24 * 10;

///配资合约列表
static NSString *const CACHE_WF_CONSTRACT = @"WFCurrentContractList";
static const double TIMEOUT_WF_CONSTRACT = 60 * 60 * 24;

///配资跑马灯
static NSString *const CACHE_WF_MARQUEE = @"WithCapitalAvailable";
static const double TIMEOUT_WF_MARQUEE = 60 * 60 * 24 * 2;

///牛人计划 全新上线列表
static NSString *const CACHE_MASTERPLAN_NEWONLINELIST = @"CACHE_MASTERPLAN_NEWONLINELIST";
static const double TIMEOUT_MASTERPLAN_NEWONLINELIST = 60 * 60 * 24 * 2;

///牛人计划 火热运行列表
static NSString *const CACHE_MASTERPLAN_HOTRUNLIST = @"CACHE_MASTERPLAN_HOTRUNLIST";
static const double TIMEOUT_MASTERPLAN_HOTRUNLIST = 60 * 60 * 24 * 2;

///炒股广告的banner
static NSString *const CACHE_MNCG_BANNER = @"CACHE_MNCG_BANNER";
static const double TIMEOUT_MNCG_BANNER = 60 * 60 * 24 * 2;

+ (NSString *)appVersion {
  static NSString *version;
  static dispatch_once_t predicate;
  dispatch_once(&predicate, ^{
    version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
  });
  return version;
}

+ (NSString *)getUserKey:(NSString *)key {
  NSString *userId = [SimuUtil getUserID];
  if (userId == nil || [@"-1" isEqualToString:userId]) {
    return nil;
  }
  return [NSString stringWithFormat:@"%@_%@", key, [SimuUtil getUserID]];
}

+ (void)saveCacheData:(id)data withKey:(NSString *)key {
  if (key == nil) {
    return;
  }
  NSDictionary *dicData = [ObjectJsonMappingUtil getObjectData:data];
  NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:dicData];
  NSString *keyWithVersion = [NSString stringWithFormat:@"%@_%@", key, [CacheUtil appVersion]];
  [FTWCache setObject:myData forKey:keyWithVersion];
}

+ (id)loadCacheWithKey:(NSString *)key withClassType:(Class)cls withTimeout:(double)timeout {
  if (key == nil) {
    return nil;
  }
  NSString *keyWithVersion = [NSString stringWithFormat:@"%@_%@", key, [CacheUtil appVersion]];
  @try {
    NSData *data = [FTWCache objectForKey:keyWithVersion withTimeOutSecond:timeout];
    if (data) {
      NSDictionary *dic = (NSDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
      return [[cls alloc] initWithDictionary:dic];
    }
  } @catch (NSException *exception) {
    NSLog(@"%@", exception);
    [FTWCache removeKeyOfObjcet:keyWithVersion];
  }
  return nil;
}

+ (void)saveUserAccountPositions:(UserAccountPageData *)data {
  [CacheUtil saveCacheData:data withKey:[CacheUtil getUserKey:CACHE_ACCOUNT_POSITION]];
}

+ (UserAccountPageData *)loadUserAccountPositions {
  return [CacheUtil loadCacheWithKey:[CacheUtil getUserKey:CACHE_ACCOUNT_POSITION]
                       withClassType:[UserAccountPageData class]
                         withTimeout:TIMEOUT_ACCOUNT_POSITION];
}

+ (void)saveProductList:(ProductList *)data {
  [CacheUtil saveCacheData:data withKey:[CacheUtil getUserKey:CACHE_PRODUCT_LIST]];
}

+ (ProductList *)loadProductList {
  return [CacheUtil loadCacheWithKey:[CacheUtil getUserKey:CACHE_PRODUCT_LIST]
                       withClassType:[ProductList class]
                         withTimeout:TIMEOUT_PRODUCT_LIST];
}

+ (void)savePropListForReview:(PropListForReview *)data {
  [CacheUtil saveCacheData:data withKey:[CacheUtil getUserKey:CACHE_PRODUCT_LIST_FOR_REVIEW]];
}

+ (PropListForReview *)loadPropListForReview {
  return [CacheUtil loadCacheWithKey:[CacheUtil getUserKey:CACHE_PRODUCT_LIST_FOR_REVIEW]
                       withClassType:[PropListForReview class]
                         withTimeout:TIMEOUT_PRODUCT_LIST];
}

+ (void)saveDiamondList:(DiamondList *)data {
  [CacheUtil saveCacheData:data withKey:[CacheUtil getUserKey:CACHE_TRACECARD_LIST]];
}

+ (DiamondList *)loadDiamondList {
  return [CacheUtil loadCacheWithKey:[CacheUtil getUserKey:CACHE_TRACECARD_LIST]
                       withClassType:[DiamondList class]
                         withTimeout:TIMEOUT_TRACECARD_LIST];
}

+ (void)saveStockMatchList:(StockMatchList *)data {
  [CacheUtil saveCacheData:data withKey:CACHE_MATCH_LIST];
}

+ (StockMatchList *)loadStockMatchList {
  return [CacheUtil loadCacheWithKey:CACHE_MATCH_LIST
                       withClassType:[StockMatchList class]
                         withTimeout:TIMEOUT_MATCH_LIST];
}

+ (void)saveMyStockMatchList:(StockMatchList *)data {
  [CacheUtil saveCacheData:data withKey:[CacheUtil getUserKey:CACHE_MY_MATCH_LIST]];
}

+ (StockMatchList *)loadMyStockMatchList {
  return [CacheUtil loadCacheWithKey:[CacheUtil getUserKey:CACHE_MY_MATCH_LIST]
                       withClassType:[StockMatchList class]
                         withTimeout:TIMEOUT_MY_MATCH_LIST];
}

+ (void)saveMySliderCounter:(SliderUserCounterWapper *)data {
  [CacheUtil saveCacheData:data withKey:[CacheUtil getUserKey:CACHE_SLIDER_COUNTER]];
}

+ (SliderUserCounterWapper *)loadMySliderCounter {
  return [CacheUtil loadCacheWithKey:[CacheUtil getUserKey:CACHE_SLIDER_COUNTER]
                       withClassType:[SliderUserCounterWapper class]
                         withTimeout:TIMEOUT_SLIDER_COUNTER];
}

//缓存 证券开户列表
+ (void)saveOpenStockAccountList:(RealTradeSecuritiesCompanyList *)data {
  [CacheUtil saveCacheData:data withKey:CACHE_OPEN_STOCK_ACCOUNT];
}

//证券开户列表
+ (RealTradeSecuritiesCompanyList *)loadOpenStockAccountList {
  return [CacheUtil loadCacheWithKey:CACHE_OPEN_STOCK_ACCOUNT
                       withClassType:[RealTradeSecuritiesCompanyList class]
                         withTimeout:TIMEOUT_OPEN_STOCK_ACCOUNT];
}

//缓存 证券登录列表
+ (void)saveLoginStockAccountList:(RealTradeSecuritiesCompanyList *)data {
  [CacheUtil saveCacheData:data withKey:CACHE_LOGIN_STOCK_ACCOUNT];
}

//证券登录列表
+ (RealTradeSecuritiesCompanyList *)loadLoginStockAccountList {
  return [CacheUtil loadCacheWithKey:CACHE_LOGIN_STOCK_ACCOUNT
                       withClassType:[RealTradeSecuritiesCompanyList class]
                         withTimeout:TIMEOUT_LOGIN_STOCK_ACCOUNT];
}

+ (void)saveStockAlarmList:(StockAlarmList *)data {
  [CacheUtil saveCacheData:data withKey:[CacheUtil getUserKey:CACHE_STOCK_ALARMS]];
}

+ (StockAlarmList *)loadStockAlarmList {
  return [CacheUtil loadCacheWithKey:[CacheUtil getUserKey:CACHE_STOCK_ALARMS]
                       withClassType:[StockAlarmList class]
                         withTimeout:TIMEOUT_STOCK_ALARMS];
}

+ (void)saveWFCurrentContractList:(WFCurrentContractList *)data {
  [CacheUtil saveCacheData:data withKey:[CacheUtil getUserKey:CACHE_WF_CONSTRACT]];
}

+ (WFCurrentContractList *)loadWFCurrentContractList {
  return [CacheUtil loadCacheWithKey:[CacheUtil getUserKey:CACHE_WF_CONSTRACT]
                       withClassType:[WFCurrentContractList class]
                         withTimeout:TIMEOUT_WF_CONSTRACT];
}

+ (void)saveWithFundMarquee:(WithCapitalAvailable *)data {
  [CacheUtil saveCacheData:data withKey:CACHE_WF_MARQUEE];
}

+ (WithCapitalAvailable *)loadWithFundMarquee {
  return [CacheUtil loadCacheWithKey:CACHE_WF_MARQUEE
                       withClassType:[WithCapitalAvailable class]
                         withTimeout:TIMEOUT_WF_MARQUEE];
}

+ (void)saveUserInfomation:(MyInfomationItem *)data {
  [CacheUtil saveCacheData:data withKey:[CacheUtil getUserKey:CACHE_UserInfomation]];
}

+ (MyInfomationItem *)loadUserInfomation {
  return [CacheUtil loadCacheWithKey:[CacheUtil getUserKey:CACHE_UserInfomation]
                       withClassType:[MyInfomationItem class]
                         withTimeout:TIMEOUT_UserInfomation];
}

+ (void)saveMyAttentionList:(MyAttentionList *)data {
  [CacheUtil saveCacheData:data withKey:[CacheUtil getUserKey:CACHE_AttentionList]];
}

+ (MyAttentionList *)loadMyAttentionList {
  return [CacheUtil loadCacheWithKey:[CacheUtil getUserKey:CACHE_AttentionList]
                       withClassType:[MyAttentionList class]
                         withTimeout:TIMEOUT_AttentionList];
}

+ (MyInfomationItem *)myInfomation {
  if ([SimuUtil isLogined]) {
    return [CacheUtil loadUserInfomation];
  } else {
    return nil;
  }
}

+ (NSDictionary *)toDictionaryWithData:(NSData *)data {
  return [JsonFormatRequester toDictionaryWithData:data];
}

+ (NSMutableArray *)toTablesWithData:(NSData *)data {
  return [PacketCompressPointFormatRequester parseComPointPackageTables:data];
}

///缓存全新上线列表
+ (void)saveNewOnlineList:(NewOnlineInfoItem *)data {
  [CacheUtil saveCacheData:data withKey:CACHE_MASTERPLAN_NEWONLINELIST];
}
///加载全新上线列表
+ (NewOnlineInfoItem *)loadNewOnlineList {
  return [CacheUtil loadCacheWithKey:CACHE_MASTERPLAN_NEWONLINELIST
                       withClassType:[NewOnlineInfoItem class]
                         withTimeout:TIMEOUT_MASTERPLAN_NEWONLINELIST];
}

///缓存全新上线列表
+ (void)saveHotRunList:(HotRunInfoDataRequest *)data {
  [CacheUtil saveCacheData:data withKey:CACHE_MASTERPLAN_HOTRUNLIST];
}
///加载全新上线列表
+ (HotRunInfoDataRequest *)loadHotRunList {
  return [CacheUtil loadCacheWithKey:CACHE_MASTERPLAN_HOTRUNLIST
                       withClassType:[HotRunInfoDataRequest class]
                         withTimeout:TIMEOUT_MASTERPLAN_HOTRUNLIST];
}

///缓存模拟炒股广告（banner）
+ (void)saveMncgBanner:(GameAdvertisingData *)data withAdType:(NSInteger)AdList {
  NSString *type = [[NSNumber numberWithInteger:AdList] stringValue];
  NSString *append = [NSString stringWithFormat:@"%@%@", CACHE_MNCG_BANNER, type];
  [CacheUtil saveCacheData:data withKey:append];
}
///加载模拟炒股广告（banner）
+ (GameAdvertisingData *)loadMncgBanner {
  return [CacheUtil loadCacheWithKey:CACHE_MNCG_BANNER
                       withClassType:[GameAdvertisingData class]
                         withTimeout:TIMEOUT_MNCG_BANNER];
}

@end
