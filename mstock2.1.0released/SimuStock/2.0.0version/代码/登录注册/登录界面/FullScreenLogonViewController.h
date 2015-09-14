//
//  FullScreenLogonViewController.h
//  SimuStock
//
//  Created by jhss on 14-7-13.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^OnLoginCallBack)(BOOL isLogined);//是否是已登录状态

typedef void(^notLoginCallBack)();

@interface FullScreenLogonViewController : BaseViewController

@property(nonatomic, copy) OnLoginCallBack onLoginCallBack;

/** 用户未登录返回消息 */
@property(nonatomic, copy) notLoginCallBack notLoginCallBack;

- (id)initWithOnLoginCallBack:(OnLoginCallBack)onLoginCallBack;

/** 检查登录状态，
 * 如果未登录，显示登录方式选择页面，待登录成功后执行回调block，
 * 否则，直接执行回调block
 */
+ (void)checkLoginStatusWithCallBack:(OnLoginCallBack)block;
/** 增加了未登录检测, isLogined:是否是已登录状态 */
+ (void)checkLoginStatusWithCallBack:(OnLoginCallBack)block notLogin:(notLoginCallBack)notLoginCallBack;


@end
