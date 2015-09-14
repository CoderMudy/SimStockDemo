//
//  GetUserACLData.h
//  SimuStock
//
//  Created by Yuemeng on 14/12/29.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserACLData.h"
#import "LoginLogoutNotification.h"

typedef void (^getUserACLBlock)(UserACLData *);

/** 获取用户权限网络请求单例类 */
@interface GetUserACLData : NSObject

///登录、退出事件通知
@property(nonatomic, strong) LoginLogoutNotification *loginLogoutNotification;

/** 权限数据类 */
@property(nonatomic, strong) UserACLData *userACLData;

/** 在权限数据网络请求完成后会调用的block */
@property(nonatomic, copy) getUserACLBlock getUserACLBlock;

/**
 * ⭐️仅适用于一开始就已登录时获取权限数据。返回单例对象，通过.userACLData方法获取权限数据
 */
+ (instancetype)sharedUserACLData;

/** 适用于未登录转登录时获取权限数据 */
+ (void)checkLoginStatusWithCallBack:(getUserACLBlock)getUserACLBlock;

@end
