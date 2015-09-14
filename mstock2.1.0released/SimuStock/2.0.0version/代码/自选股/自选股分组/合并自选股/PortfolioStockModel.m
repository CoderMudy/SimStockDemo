//
//  PortfolioStockModel.m
//  SimuStock
//
//  Created by Mac on 15/6/19.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "PortfolioStockModel.h"
#import "FileStoreUtil.h"
#import "PortfolioStockMerge.h"
#import "ModifySelfStockData.h"
#import "SelfStockUtil.h"
#import "StockGroupToolTip.h"

@implementation PortfolioStockLoadSaveUtil

static NSString *const Prefix = @"PortfolioStock";

+ (NSString *)keyWithUserId:(NSString *)userId withType:(QuerySelfStockDataType)type {
  return [NSString stringWithFormat:@"%@_%@_%ld", Prefix, userId, (long)type];
}

+ (void)savePortfolioStock:(QuerySelfStockData *)data
                withUserId:(NSString *)userId
                  withType:(QuerySelfStockDataType)type {
  NSString *key = [PortfolioStockLoadSaveUtil keyWithUserId:userId withType:type];
  [FileStoreUtil saveCacheData:data withKey:key];
}

+ (QuerySelfStockData *)loadPortfolioStockWithUserId:(NSString *)userId
                                            withType:(QuerySelfStockDataType)type {
  NSString *key = [PortfolioStockLoadSaveUtil keyWithUserId:userId withType:type];
  return [FileStoreUtil loadCacheWithKey:key withClassType:[QuerySelfStockData class]];
}

@end

@implementation PortfolioStockModel

+ (PortfolioStockModel *)getTouristPortfolioStockModel {

  static PortfolioStockModel *touristInstance = nil;

  static dispatch_once_t predicate;
  dispatch_once(&predicate, ^{
    touristInstance = [[self alloc] initWithUserId:TouristUserId];
  });

  return touristInstance;
}

+ (PortfolioStockModel *)getPortfolioStockModelByUserId:(NSString *)userId {
  if (userId == nil || userId.length == 0 || [userId isEqualToString:@"-1"]) {
    [NSException raise:@"Error: invalid userId to access PortfolioStockModel" format:@""];
  }

  static PortfolioStockModel *sharedInstance = nil;

  static dispatch_once_t predicate;
  dispatch_once(&predicate, ^{
    sharedInstance = [[self alloc] initWithUserId:userId];
  });
  if (![sharedInstance.userId isEqualToString:userId]) {
    sharedInstance = [[self alloc] initWithUserId:userId];
  }

  return sharedInstance;
}

- (instancetype)initWithUserId:(NSString *)userId {
  if (self = [super init]) {
    self.userId = userId;
    self.local =
        [PortfolioStockLoadSaveUtil loadPortfolioStockWithUserId:userId
                                                        withType:QuerySelfStockDataTypeLocal];
    if ([userId isEqualToString:@"-1"]) {
      self.base = nil;
      if (self.local == nil) {
        self.local = [[QuerySelfStockData alloc] init];
      }
    } else {
      self.base =
          [PortfolioStockLoadSaveUtil loadPortfolioStockWithUserId:userId
                                                          withType:QuerySelfStockDataTypeBase];
    }
    [self.local setGroupAllExist];
    [self.base setGroupAllExist];
  }
  return self;
}

- (void)save {
  if (_base) {
    [PortfolioStockLoadSaveUtil savePortfolioStock:_base
                                        withUserId:_userId
                                          withType:QuerySelfStockDataTypeBase];
  }
  if (_local) {
    [PortfolioStockLoadSaveUtil savePortfolioStock:_local
                                        withUserId:_userId
                                          withType:QuerySelfStockDataTypeLocal];
  }
}

@end

@implementation PortfolioStockManager

+ (PortfolioStockModel *)currentPortfolioStockModel {
  if ([SimuUtil isLogined]) {
    return [PortfolioStockModel getPortfolioStockModelByUserId:[SimuUtil getUserID]];
  } else {
    return [PortfolioStockModel getTouristPortfolioStockModel];
  }
}

+ (BOOL)isPortfolioStock:(NSString *)stockCode {
  PortfolioStockModel *model = [PortfolioStockManager currentPortfolioStockModel];
  QuerySelfStockElement *group = [model.local findGroupById:GROUP_ALL_ID];
  return [group.stockCodeArray containsObject:stockCode];
}

+ (void)removePortfolioStock:(NSString *)stockCode withGroupIds:(NSArray *)groups {
  PortfolioStockModel *model = [PortfolioStockManager currentPortfolioStockModel];
  [model.local removePortfolioStock:stockCode withGroupIds:groups];
}

/**
 * 获取对应的resId;
 *
 * @param vipType
 * @return resId
 */
+ (NSInteger)getCustomStockLimit {
  NSInteger vipType = [[SimuUtil getUserVipType] integerValue];
  if (vipType > 0) {
    return CUSTOM_STOCK_LIMIT_VIP;
  } else {
    return CUSTOM_STOCK_LIMIT_UNVIP;
  }
}

+ (void)setPortfolioStock:(NSString *)stockCode inGroupIds:(NSArray *)groups {
  if (stockCode == nil || stockCode.length == 0) {
    return;
  }

  PortfolioStockModel *model = [PortfolioStockManager currentPortfolioStockModel];
  [model.local setPortfolioStock:stockCode inGroupIds:groups];
  [PortfolioStockManager synchronizePortfolioStock];
}

+ (void)setPortfolioStock:(NSString *)stockCode onSuccess:(CallBackAction)successCallback {

  QuerySelfStockData *tempData = [PortfolioStockManager currentPortfolioStockModel].local;
  if ([tempData findGroupById:GROUP_ALL_ID].stockCodeArray.count >=
      [PortfolioStockManager getCustomStockLimit]) {
    [NewShowLabel setMessageContent:@"自选股达到上限"];
    return;
  }

  if ([SimuUtil isLogined]) {
    if (tempData.dataArray.count < 2) {
      [PortfolioStockManager setPortfolioStock:stockCode inGroupIds:@[ GROUP_ALL_ID ]];
      if (successCallback) {
        successCallback();
      }
    } else {
      [StockGroupToolTip showWithEightStockCode:stockCode
          andSureBtnClickBlock:^(NSArray *selectedGroupIds, NSString *eightStockCode) {
            [PortfolioStockManager setPortfolioStock:stockCode inGroupIds:selectedGroupIds];
            if (successCallback) {
              successCallback();
            }
          }
          andCancleBtnClickBlock:^{

          }
          showGroupAll:YES];
    }
  } else {
    [PortfolioStockManager setPortfolioStock:stockCode inGroupIds:@[ GROUP_ALL_ID ]];
    if (successCallback) {
      successCallback();
    }
  }
}

+ (void)synchronizePortfolioStock {
  if (![SimuUtil isExistNetwork]) {
    return;
  }
  NSLog(@"☀️开始同步...");
  [PortfolioStockManager synchronizePortfolioStockWithIncrementFlag:YES];
}

+ (void)synchronizePortfolioStockWithIncrementFlag:(BOOL)incrementFlag {
  if (![SimuUtil isLogined]) {
    PortfolioStockModel *model = [PortfolioStockManager currentPortfolioStockModel];
    [model save];
    [[NSNotificationCenter defaultCenter] postNotificationName:SelfStockChangeNotificationName
                                                        object:nil];
    return;
  }
  PortfolioStockModel *model = [PortfolioStockManager currentPortfolioStockModel];
  // update
  HttpRequestCallBack *callback = [HttpRequestCallBack initWithOwner:model
                                                       cleanCallback:^{
                                                       }];
  callback.onSuccess = ^(NSObject *obj) {
    QuerySelfStockData *server = (QuerySelfStockData *)obj;
    if (server.ver == nil && incrementFlag) {
      NSLog(@"base version is equal to server version");
      server = model.base;
    }
    [PortfolioStockManager mergeWithPortfolioStockModel:model withServer:server];
  };
  callback.onFailed = ^{
  };

  if (incrementFlag) {
    [QuerySelfStockData requestSelfStocksWithCallback:callback];
  } else {
    [QuerySelfStockData requestSelfStocksWithVerstion:@"0" withCallback:callback];
  }
}

+ (void)mergeWithGroupSource:(QuerySelfStockElement *)groupSource
             WithGroupTarget:(QuerySelfStockElement *)groupTarget {
  __block NSInteger insertIndex = 0;
  [groupSource.stockCodeArray
      enumerateObjectsUsingBlock:^(NSString *stockCode, NSUInteger idx, BOOL *stop) {
        if (![groupTarget.stockCodeArray containsObject:stockCode]) {
          [groupTarget.stockCodeArray insertObject:stockCode atIndex:insertIndex++];
        }
      }];
}

+ (void)mergeWithPortfolioStockModel:(PortfolioStockModel *)model
                          withServer:(QuerySelfStockData *)server {

  QuerySelfStockData *base = model.base;
  QuerySelfStockData *local = model.local;
  if (base == nil) {
    NSLog(@"base not exist, server: %@", [server getUploadPortfolioString]);
    //如果base不存在，需要将local中所有的修改与server合并后上传
    // local = server + local
    QuerySelfStockData *changes = local;
    local = [QuerySelfStockData copy:server];
    QuerySelfStockElement *groupSource = [changes findGroupById:GROUP_ALL_ID];
    QuerySelfStockElement *groupTarget = [local findGroupById:GROUP_ALL_ID];
    [PortfolioStockManager mergeWithGroupSource:groupSource WithGroupTarget:groupTarget];
    base = server;
    model.base = server;
    model.local = local;
  }

  //合并游客的自选股列表
  // local = tourist + local
  PortfolioStockModel *touristModel = [PortfolioStockModel getTouristPortfolioStockModel];
  QuerySelfStockData *changes = touristModel.local;
  if (changes) {
    QuerySelfStockElement *groupSource = [changes findGroupById:GROUP_ALL_ID];
    if (groupSource && groupSource.stockCodeArray.count > 0) {
      QuerySelfStockElement *groupTarget = [local findGroupById:GROUP_ALL_ID];

      [PortfolioStockManager mergeWithGroupSource:groupSource WithGroupTarget:groupTarget];
      [groupSource.stockCodeArray removeAllObjects];
      [touristModel save];
      [model save];
    }
  }

  //服务端没有返回版本号，且本地自选股为空，自动添加2个指数
  BOOL noPortfolioOnServer = server.ver == nil || [@"0" isEqualToString:server.ver];
  QuerySelfStockElement *group = [local findGroupById:GROUP_ALL_ID];
  if (noPortfolioOnServer && group.stockCodeArray.count == 0) {
    [group.stockCodeArray addObject:@"10000001"];
    [group.stockCodeArray addObject:@"20399001"];
  };

  // merge
  QuerySelfStockData *merge = [PortfolioStockMerge mergeBaseQuerySelfStockData:base
                                                      serverQuerySelfStockData:server
                                                       localQuerySelfStockData:local];
  NSString *uploadPortfolioString = [merge getUploadPortfolioString];
  if ([[server getUploadPortfolioString] isEqualToString:uploadPortfolioString]) {
    //本地与服务端一致，不需要上传更新服务器
    model.base = server;
    model.local = [QuerySelfStockData copy:model.base];
    [model save];
    return;
  }

  NSDictionary *dic = @{
    @"portfolio" : uploadPortfolioString,
    @"version" : @([server.ver longLongValue]),
    @"isForce" : @(1)
  };

  NSLog(@"base portfolio stocks: \n%@", [base getUploadPortfolioString]);
  NSLog(@"local portfolio stocks: \n%@", [local getUploadPortfolioString]);
  NSLog(@"server portfolio stocks: \n%@", [server getUploadPortfolioString]);
  NSLog(@"upload portfolio stocks: \n%@", dic);
  // checkin
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onSuccess = ^(NSObject *obj) {
    //上传成功后，修改base和local
    ModifySelfStockData *result = (ModifySelfStockData *)obj;
    model.base.ver = result.ver;
    model.base.dataArray = merge.dataArray;
    model.local = [QuerySelfStockData copy:model.base];
    [model save];
    [[NSNotificationCenter defaultCenter] postNotificationName:SelfStockChangeNotificationName
                                                        object:nil];
  };
  callback.onFailed = ^{
  };

  [ModifySelfStockData requestModifySelfStockDataWithParams:dic callback:callback];
}

@end
