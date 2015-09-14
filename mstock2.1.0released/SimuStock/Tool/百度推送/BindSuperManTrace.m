//
//  BindSuperManTrace.m
//  SimuStock
//
//  Created by jhss on 14-2-26.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BindSuperManTrace.h"
#import "SimuUtil.h"
#import "NewShowLabel.h"
#import "BaiDuPush.h"
@implementation BindSuperManTrace

- (void)getUserIDInfo:(NSString *)baiduUid withString:(NSString *)baiduChannel {
  NSUserDefaults *myUser = [NSUserDefaults standardUserDefaults];
  //存储云推送信息
  if (baiduUid) {
    [myUser setObject:baiduUid forKey:@"BAIDU_UID"];
    [myUser synchronize];
  } else {
    [myUser setObject:@"" forKey:@"BAIDU_UID"];
    [myUser synchronize];
  }
  if (baiduChannel) {
    [myUser setObject:baiduChannel forKey:@"BAIDU_CHANNEL"];
    [myUser synchronize];
  } else {
    [myUser setObject:@"" forKey:@"BAIDU_CHANNEL"];
    [myUser synchronize];
  }
}

- (void)userBindSever {
  [self performSelector:@selector(sendBindInfoToSever)
             withObject:nil
             afterDelay:0.8];
}
//发送请求
- (void)sendBindInfoToSever {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }

  //获得百度uid和channel
  NSUserDefaults *myUser = [NSUserDefaults standardUserDefaults];
  NSString *baiduUid = [myUser objectForKey:@"BAIDU_UID"];
  NSString *baiduChannel = [myUser objectForKey:@"BAIDU_CHANNEL"];

  if (baiduUid && baiduChannel) {
    HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
    callback.onSuccess = ^(NSObject *obj) {

    };
    [BaiDuPush pushBindUserUseridWithBaiduUid:baiduUid
                             withBaiduChannel:baiduChannel
                                 withCallback:callback];
    [SimuUtil setBaiduUserId:baiduUid];
  }
}
//给后台传送Token
- (void)sendApplePushToken {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  NSString *token =
      [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleToken"];
  if (token && token.length > 0) {
    HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
    callback.onSuccess = ^(NSObject *obj) {
    };
    [BaiDuPush pushBindUserWithToken:token withCallback:callback];
  }
}

@end
