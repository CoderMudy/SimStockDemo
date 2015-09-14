//
//  UserInformationItem.h
//  SimuStock
//
//  Created by jhss on 13-10-8.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseRequestObject.h"
#import "BaseRequester.h"
#import "UserListItem.h"

@class HttpRequestCallBack;

@interface LoginInfo : JsonRequestObject
/** 用户session */
@property(strong, nonatomic) NSString *sessionId;

/** 用户登陆名 */
@property(strong, nonatomic) NSString *userName;

/** 优顾认证签名 */
@property(strong, nonatomic) NSString *certifySignature;

@property(strong, nonatomic) UserListItem *userInfo;

@end

@interface UserInformationItem : JsonRequestObject

@property(copy, nonatomic) NSString *mMessage;

@property(copy, nonatomic) NSString *mNickName;

@property(copy, nonatomic) NSString *mSessionID;

@property(copy, nonatomic) NSString *mStatus;

@property(copy, nonatomic) NSString *mUserID;

@property(copy, nonatomic) NSString *mPassword;

@property(copy, nonatomic) NSString *mUserName;

@property(copy, nonatomic) NSString *mHeadImage;

@property(strong, nonatomic) NSString *mstockFirmFlag;

+ (void)requestLoginWithUserName:(NSString *)userName
                    withPassword:(NSString *)password
                    withCallback:(HttpRequestCallBack *)callback;

@end
