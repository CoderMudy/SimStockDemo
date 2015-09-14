//
//  ConcernedRequest.m
//  SimuStock
//
//  Created by moulin wang on 14-7-30.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "ConcernedRequest.h"

#import "NewShowLabel.h"
#import "SimuUtil.h"
#import "BaseRequester.h"

@implementation ConcernedRequest

- (void)shareButtonInviteFriendCallbackUserID:(NSString *)userId
                                       status:(NSInteger)status {
  if (![@"-1" isEqualToString:[SimuUtil getUserID]]) {
    if (userId) {
      self.userID = userId;
      if (status == 1) {
        self.statusInt = status;
      } else {
        self.statusInt = 0;
      }
      //已登录
      [self clickAttentionButton];
    }
  }
}
#pragma mark
#pragma mark------点击关注操作------
- (void)clickAttentionButton {
  //关注了其他用户
  @synchronized(self) {
    //用户ID和关注状态 例：1
    NSInteger tempAttentionInt;
    if (self.statusInt) {
      tempAttentionInt = 1;
    } else {
      tempAttentionInt = 0;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(refreshButton:)]) {
      [_delegate refreshButton:1];
    }
    if (![SimuUtil isExistNetwork]) {
      [self showMessage:REQUEST_FAILED_MESSAGE];
      return;
    }
    //取反 例：0
    [self clickAttentionButtonWithSelectedUserID:self.userID
                             withAttentionStatus:
                                 [NSString
                                     stringWithFormat:@"%ld",
                                                      (long)tempAttentionInt]];
  }
}
- (void)clickAttentionButtonWithSelectedUserID:(NSString *)selectedUserid
                           withAttentionStatus:(NSString *)attentionStatus {
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak ConcernedRequest *weakSelf = self;
  callback.onSuccess = ^(NSObject *obj) {
    ConcernedRequest *strongSelf = weakSelf;
    if (strongSelf) {
      if (strongSelf.delegate &&
          [strongSelf.delegate respondsToSelector:@selector(refreshButton:)]) {
        [strongSelf.delegate refreshButton:2];
      }
      [NewShowLabel setMessageContent:((FollowFriendResult *)obj).message];
    }
  };
  //请求错误
  callback.onError = ^(BaseRequestObject *error, NSException *ex) {
    [BaseRequester defaultErrorHandler](error, ex);
    [self showMessage:error.message];
  };
  [FollowFriendResult addCancleFollowWithUid:selectedUserid
                              withFollowFlag:attentionStatus
                                withCallBack:callback];
}

#pragma mark
#pragma mark 创建网络引擎

- (void)showMessage:(NSString *)message {
  if (_delegate && [_delegate respondsToSelector:@selector(refreshButton:)]) {
    [_delegate refreshButton:3];
  }
  [NewShowLabel setMessageContent:message];
}
- (void)dealloc {

  [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
