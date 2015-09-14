//
//  UserInfoNotificationUtil.m
//  SimuStock
//
//  Created by Mac on 15/6/29.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "UserInfoNotificationUtil.h"

@implementation UserInfoNotificationUtil

- (id)init {
  if (self = [super init]) {
    [self addObservers];
  }
  return self;
}

- (void)addObservers {
  __weak UserInfoNotificationUtil *weakSelf = self;
  [self addObserverName:NT_Nickname_Change
           withObserver:^(NSNotification *notif) {
             if (weakSelf.onNicknameChangeAction) {
               weakSelf.onNicknameChangeAction();
             }
           }];
  [self addObserverName:NT_HeadPic_Change
           withObserver:^(NSNotification *notif) {
             if (weakSelf.onHeadPicChangeAction) {
               weakSelf.onHeadPicChangeAction();
             }
           }];
  [self addObserverName:NT_Signature_Change
           withObserver:^(NSNotification *notif) {
             if (weakSelf.onSignatureChangeAction) {
               weakSelf.onSignatureChangeAction();
             }
           }];
}

@end
