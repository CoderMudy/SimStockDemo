//
//  SimuWaitConter.m
//  SimuStock
//
//  Created by Mac on 14-11-5.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SimuWaitCounter.h"

@implementation SimuWaitCounter

- (id)init {
  self = [super init];
  if (self) {
    _counter = 0;
  }
  return self;
}
//计算增加
- (void)addCounter {
  _counter = _counter + 1;
}
//计数减少
- (void)reduceCounter {
  _counter = _counter - 1;
}
//重置计数
- (void)resetCounter {
  _counter = 0;
}
//取得状态
- (BOOL)isCanStop {
  if (_counter <= 0)
    return YES;
  else
    return NO;
}

@end
