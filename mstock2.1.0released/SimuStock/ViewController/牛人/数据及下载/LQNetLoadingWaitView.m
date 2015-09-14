//
//  LQNetLoadingWaitView.m
//  SimuStock
//
//  Created by jhss on 13-11-24.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "LQNetLoadingWaitView.h"

static LQNetLoadingWaitView *lqsharedObj = nil;

@implementation LQNetLoadingWaitView

//新加函数lq
+ (void)waitTitle:(NSString *)waitTitle {
  [[LQNetLoadingWaitView sharedInstance] setTitle:waitTitle];
}
+ (id)sharedInstance {
  @synchronized(self) {
    if (lqsharedObj == nil) {
      lqsharedObj = [[self alloc] init];
    }
  }
  return lqsharedObj;
}
@end
