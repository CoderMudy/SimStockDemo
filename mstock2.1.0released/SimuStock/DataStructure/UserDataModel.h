//
//  UserDataModel.h
//  SimuStock
//
//  Created by Mac on 14-11-4.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequestObject.h"

@class HttpRequestCallBack;

/** 类说明：用户相关接口封装 */
@interface UserDataModel : JsonRequestObject



/** 请求重置密码 */
+ (void)resetPasswordWithPhoneNum:(NSString *)phoneNum
                     withPassword:(NSString *)password
                     withCallback:(HttpRequestCallBack *)callback ;

/** 请求重置密码 */
+ (void)authSessionWithCallback:(HttpRequestCallBack *)callback ;

@end
