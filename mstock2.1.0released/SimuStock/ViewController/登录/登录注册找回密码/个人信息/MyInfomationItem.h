//
//  MyInfomationItem.h
//  SimuStock
//
//  Created by jhss on 13-10-11.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequestObject.h"
#import "UserConst.h"

@class HttpRequestCallBack;

@interface BindStatus : BaseRequestObject2 <ParseJson>
@property(assign, nonatomic) UserBindType type;
@property(strong, nonatomic) NSString *openId;
@property(strong, nonatomic) NSString *token;
@property(strong, nonatomic) NSString *thirdNickname;
@end

@interface MyInfomationItem : JsonRequestObject

@property(strong, nonatomic) NSString *mHeadPic;
@property(strong, nonatomic) NSString *mMethod;
@property(strong, nonatomic) NSString *mNickName;
@property(strong, nonatomic) NSString *mSex;
@property(strong, nonatomic) NSString *mSignature;
@property(strong, nonatomic) NSString *mStyle;
@property(strong, nonatomic) NSString *mUserID;
@property(strong, nonatomic) NSString *mPhoneNumber;
@property(strong, nonatomic) NSString *mUserName;
@property(strong, nonatomic) NSString *mInviteCode;

/** 评级 */
@property(strong, nonatomic) NSString *rating;

/** vip等级 [int] -1 未开通 1 vip 2.svip 3.过期 */
@property(assign, nonatomic) UserVipType vipType;
/** stockFirmFlag	实盘标识 */
@property(strong, nonatomic) NSString *stockFirmFlag;

/** 绑定列表 */
@property(strong, nonatomic) NSMutableDictionary *bindDictionary;


/** 是否可以解绑微信 */
- (BOOL)canUnbindWeixin;

/** 是否可以解绑QQ */
- (BOOL)canUnbindQQ;

/** 是否可以解绑新浪微博 */
- (BOOL)canUnbindSinaWeibo;

/** 请求个人信息 */
+ (void)requestMyInfomationWithCallBack:(HttpRequestCallBack *)callback;
@end

@interface ThirdPartLogon : JsonRequestObject
/** 三方登录_直接登录 */
+ (void)logonDoThirdPartAuthWithUid:(NSString *)uid
                      withLogonType:(NSString *)logonType
                          withToken:(NSString *)token
                       withCallback:(HttpRequestCallBack *)callback;
@end
