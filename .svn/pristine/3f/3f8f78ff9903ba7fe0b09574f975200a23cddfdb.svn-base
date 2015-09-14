//
//  UserInfoNotificationUtil.h
//  SimuStock
//
//  Created by Mac on 15/6/29.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseNotificationObserverMgr.h"

/** 昵称信息变更通知 */
static NSString *const NT_Nickname_Change = @"NT_Nickname_Change";

/** 头像信息变更通知 */
static NSString *const NT_HeadPic_Change = @"NT_Headpic_Change";

/** 签名信息变更通知 */
static NSString *const NT_Signature_Change = @"NT_Signature_Change";

/** 用户信息变更回调，通知观察者 */
typedef void (^OnUserInfoChanging)();

/** 用户信息变更通知回调管理器 */
@interface UserInfoNotificationUtil : BaseNotificationObserverMgr

/** 昵称信息变更回调，通知观察者 */
@property(copy, nonatomic) OnUserInfoChanging onNicknameChangeAction;

/** 头像信息变更回调，通知观察者 */
@property(copy, nonatomic) OnUserInfoChanging onHeadPicChangeAction;

/** 签名信息变更回调，通知观察者 */
@property(copy, nonatomic) OnUserInfoChanging onSignatureChangeAction;

@end
