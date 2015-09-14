//
//  LoginLogoutNotification.h
//  SimuStock
//
//  Created by Mac on 15/5/6.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseNotificationObserverMgr.h"

/** 登录或者退出回调 */
typedef void (^OnLoginLogout)();

/** 登录或者退出通知回调管理器 */
@interface LoginLogoutNotification : BaseNotificationObserverMgr

/** 登录或者退出回调 */
@property(copy, nonatomic) OnLoginLogout onLoginLogout;

@end
