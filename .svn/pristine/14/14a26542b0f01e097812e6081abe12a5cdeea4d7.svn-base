//
//  AttentionEventObserver.m
//  SimuStock
//
//  Created by Mac on 15/7/3.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "AttentionEventObserver.h"

///关注成功
static NSString *const AttentionSuccess = @"AttentionSuccess";
///取消关注
static NSString *const CancelAttentionSuccess = @"CancelAttentionSuccess";

@implementation AttentionEventObserver

- (id)init {
  if (self = [super init]) {
    [self addObservers];
  }
  return self;
}

- (void)addObservers {
  __weak AttentionEventObserver *weakSelf = self;
  [self addObserverName:AttentionSuccess
           withObserver:^(NSNotification *notif) {
             weakSelf.onAttentionAction();
           }];

  [self addObserverName:CancelAttentionSuccess
           withObserver:^(NSNotification *notif) {
             weakSelf.onAttentionAction();
           }];
}

+ (void)postAttentionEvent {
  [[NSNotificationCenter defaultCenter] postNotificationName:AttentionSuccess
                                                      object:nil];
}

+ (void)postCancelAttentionEvent {
  [[NSNotificationCenter defaultCenter]
      postNotificationName:CancelAttentionSuccess
                    object:nil];
}

@end
