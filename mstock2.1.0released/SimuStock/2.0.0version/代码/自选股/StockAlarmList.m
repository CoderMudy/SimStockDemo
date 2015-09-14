//
//  StockAlarmList.m
//  SimuStock
//
//  Created by Mac on 15/4/20.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "StockAlarmList.h"
#import "CacheUtil.h"
#import "StockAlarmNotification.h"
#import "StockAlarmRuleList.h"

@implementation StockAlarmList

-(id)init{
  if (self = [super init]) {
    _alarms = [[NSMutableSet alloc] init];
  }
  return self;
}

- (NSDictionary *)mappingDictionary{
  return @{@"alarms": NSStringFromClass([NSString class])};
}

+ (StockAlarmList *) stockAlarmListWithUserId:(NSString*) uid {
  static StockAlarmList *instance = nil;
  
  if (instance && [instance.uid isEqualToString:uid]) {
    return instance;
  }
  instance = [CacheUtil loadStockAlarmList];
  
  if (instance == nil) {
    instance = [[StockAlarmList alloc] init];
    instance.uid = uid;
  }
  return instance;
}

///加入股票预警
- (void)addSelfStockAlarms:(NSArray *)stockAlarmCodes{
  if (stockAlarmCodes && stockAlarmCodes.count >0 ) {
    [stockAlarmCodes enumerateObjectsUsingBlock:^(AlarmStockItem *item, NSUInteger idx, BOOL *stop) {
      if (![self.alarms containsObject:item.stockCodeLong]) {
        [self.alarms addObject:item.stockCodeLong];
      }
    }];
    [CacheUtil saveStockAlarmList:self];
  }
}

///加入股票预警
- (void)addSelfStockAlarm:(NSString *)stockCode {
  if (![self.alarms containsObject:stockCode]) {
    [self.alarms addObject:stockCode];
    [[NSNotificationCenter defaultCenter]
        postNotificationName:AC_SelfStockAlarm_Add
                      object:nil
                    userInfo:@{
                      @"data" : stockCode
                    }];
    [CacheUtil saveStockAlarmList:self];
  }
}

///删除股价预警
- (void)deleteSelfStockAlarm:(NSString *)stockCode {
  [[NSNotificationCenter defaultCenter]
      postNotificationName:AC_SelfStockAlarm_Remove
                    object:nil
                  userInfo:@{
                    @"data" : stockCode
                  }];
  [self.alarms removeObject:stockCode];
  [CacheUtil saveStockAlarmList:self];
}

///判断是否有设置了股价预警
- (BOOL)isSelfStockAlarm:(NSString *)stockCode{
  return [self.alarms containsObject:stockCode];
}





@end
