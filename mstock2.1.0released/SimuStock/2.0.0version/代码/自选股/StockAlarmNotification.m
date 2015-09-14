//
//  StockAlarmNotification.m
//  SimuStock
//
//  Created by Mac on 15/4/20.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "StockAlarmNotification.h"



@implementation StockAlarmNotification

- (id)init {
  if (self = [super init]) {
    [self addObservers];
  }
  return self;
}


- (void)addObservers {
  __weak StockAlarmNotification *weakSelf = self;
  [self addObserverName:AC_SelfStockAlarm_Add withObserver:^(NSNotification *notif) {
    NSDictionary *userInfo = [notif userInfo];
    NSString *stockCode = userInfo[@"data"];
    weakSelf.onAddStockAlarm(stockCode);
  }];
  [self addObserverName:AC_SelfStockAlarm_Remove withObserver:^(NSNotification *notif) {
    NSDictionary *userInfo = [notif userInfo];
    NSString *stockCode = userInfo[@"data"];
    weakSelf.onRemoveStockAlarm(stockCode);
  }];
}

@end
