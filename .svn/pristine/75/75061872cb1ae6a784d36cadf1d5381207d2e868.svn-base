//
//  SelfStockUtil.m
//  SimuStock
//
//  Created by Mac on 15/5/27.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SelfStockUtil.h"
#import "SimuUtil.h"

@implementation SelfStockChangeNotification

- (id)init {
  if (self = [super init]) {
    [self addObservers];
  }
  return self;
}

- (void)addObservers {
  __weak SelfStockChangeNotification *weakSelf = self;
  [self addObserverName:SelfStockChangeNotificationName
           withObserver:^(NSNotification *notif) {
             weakSelf.onSelfStockChange();
           }];
}

@end


