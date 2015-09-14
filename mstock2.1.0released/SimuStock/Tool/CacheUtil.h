//
//  CacheUtil.h
//  SimuStock
//
//  Created by Mac on 14-11-5.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserAccountPageData.h"
#import "MyInfomationItem.h"
#import "SliderUserCounterWapper.h"
#import "StockMatchListItem.h"
#import "RealTradeSecuritiesCompanyList.h"
#import "StockAlarmList.h"
#import "WFProductContract.h"
#import "WithCapitalHome.h"
#import "ProductListItem.h"
#import "MyAttentionInfoItem.h"
#import "NewOnlineInfoData.h"
#import "HotRunInfoItem.h"
#import "GameAdvertisingData.h"

@interface CacheUtil : NSObject

+ (NSString *)getUserKey:(NSString *)key;

+ (id)loadCacheWithKey:(NSString *)key
         withClassType:(Class)cls
           withTimeout:(double)timeout;

+ (void)saveCacheData:(id)data withKey:(NSString *)key;

/** 获取返回的用户信息 */
+ (MyInfomationItem *)myInfomation;

///缓存用户信息
+ (void)saveUserInfomation:(MyInfomationItem *)data;

///加载用户信息
+ (MyInfomationItem *)loadUserInfomation;

///缓存我的关注用户列表
+ (void)saveMyAttentionList:(MyAttentionList *)data;

///加载我的关注用户列表
+ (MyAttentionList *)loadMyAttentionList;

/** 将二进制文件转化为json字典 */
+ (NSDictionary *)toDictionaryWithData:(NSData *)data;

/** 将二进制文件转化为table数组 */
+ (NSMutableArray *)toTablesWithData:(NSData *)data;

///缓存首页用户账号和持仓信息
+ (void)saveUserAccountPositions:(UserAccountPageData *)data;

///加载首页用户账号和持仓信息
+ (UserAccountPageData *)loadUserAccountPositions;

///缓存商城资金卡
+ (void)saveProductList:(ProductList *)data;

///加载商城资金卡
+ (ProductList *)loadProductList;

///缓存商城追踪卡
+ (void)saveDiamondList:(DiamondList *)data;

///加载商城道具卡 for app store review
+ (void)savePropListForReview:(PropListForReview *)data;
///缓存商城道具卡 for app store review
+ (PropListForReview *)loadPropListForReview;

///加载商城追踪卡
+ (DiamondList *)loadDiamondList;

///缓存比赛列表
+ (void)saveStockMatchList:(StockMatchList *)data;

///加载比赛列表
+ (StockMatchList *)loadStockMatchList;

///缓存用户的比赛列表
+ (void)saveMyStockMatchList:(StockMatchList *)data;

///加载用户的比赛列表
+ (StockMatchList *)loadMyStockMatchList;

///缓存用户侧边栏的数据
+ (void)saveMySliderCounter:(SliderUserCounterWapper *)data;

///加载用户侧边栏的数据
+ (SliderUserCounterWapper *)loadMySliderCounter;

///缓存证券开户列表
+ (void)saveOpenStockAccountList:(RealTradeSecuritiesCompanyList *)data;

///加载证券开户列表
+ (RealTradeSecuritiesCompanyList *)loadOpenStockAccountList;

///缓存证券登录列表
+ (void)saveLoginStockAccountList:(RealTradeSecuritiesCompanyList *)data;

///加载证券登录列表
+ (RealTradeSecuritiesCompanyList *)loadLoginStockAccountList;

///缓存股价预警列表
+ (void)saveStockAlarmList:(StockAlarmList *)data;

///加载股价预警列表
+ (StockAlarmList *)loadStockAlarmList;

///缓存配资合约
+ (void)saveWFCurrentContractList:(WFCurrentContractList *)data;

///加载配资合约
+ (WFCurrentContractList *)loadWFCurrentContractList;

///缓存配资合约
+ (void)saveWithFundMarquee:(WithCapitalAvailable *)data;

///加载配资合约
+ (WithCapitalAvailable *)loadWithFundMarquee;

///缓存全新上线列表
+ (void)saveNewOnlineList:(NewOnlineInfoItem *)data;
///加载全新上线列表
+ (NewOnlineInfoItem *)loadNewOnlineList;

///缓存火热运行列表
+ (void)saveHotRunList:(HotRunInfoDataRequest *)data;
///加载火热运行列表
+ (HotRunInfoDataRequest *)loadHotRunList;

///缓存模拟炒股广告（banner）
+ (void)saveMncgBanner:(GameAdvertisingData *)data withAdType:(NSInteger )AdList;
+(GameAdvertisingData *)loadMncgBanner;



@end
