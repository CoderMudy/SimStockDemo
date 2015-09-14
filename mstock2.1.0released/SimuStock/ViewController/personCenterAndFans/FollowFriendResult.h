//
//  FollowFriendResult.h
//  SimuStock
//
//  Created by Mac on 14-10-23.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

/** 好友关注代理 */
@protocol FriendFollowDelegate <NSObject>

/** 点击按钮，关注或者取消关注好友 */
- (void)pressButtonWithFollowFlag:(BOOL)isAttention withRow:(NSInteger)index;

@end

@class HttpRequestCallBack;

@interface FollowFriendResult : JsonRequestObject

/** 添加关注或者取消关注操作 */
+ (void)addCancleFollowWithUid:(NSString *)uid
                withFollowFlag:(NSString *)addFollow
                  withCallBack:(HttpRequestCallBack *)callback;

@end
