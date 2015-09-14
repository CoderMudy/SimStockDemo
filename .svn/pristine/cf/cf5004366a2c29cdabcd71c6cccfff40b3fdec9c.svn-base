//
//  ThirdBindingResult.h
//  SimuStock
//
//  Created by jhss on 14-11-14.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"
@class HttpRequestCallBack;
@interface ThirdBindingResult : JsonRequestObject

/** 用户信息*/
@property(copy, nonatomic) NSMutableArray *dataArray;

/** 注册返回用户信息数据*/
- (void)jsonToObject:(NSDictionary *)obj;

/** 三方注册操作 */
+ (void)registerOfThirdPartWithOpenId:(NSString *)openId
                        withLogonType:(NSString *)logonType
                      withNewNickName:(NSString *)newNickName
                      withOldNickName:(NSString *)oldNickName
                        withHeadImage:(NSString *)headImage
                       withInviteCode:(NSString *)inviteCode
                         withCallBack:(HttpRequestCallBack *)callback;
@end
