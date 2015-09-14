//
//  AttentionEventObserver.h
//  SimuStock
//
//  Created by Mac on 15/7/3.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseNotificationObserverMgr.h"

/** 关注、取消关注回调 */
typedef void (^OnAttentionAction)();

/** 关注、取消关注通知回调管理器 */
@interface AttentionEventObserver : BaseNotificationObserverMgr

/** 关注、取消关注回调 */
@property(copy, nonatomic) OnAttentionAction onAttentionAction;

+ (void)postAttentionEvent;

+ (void)postCancelAttentionEvent;

@end
