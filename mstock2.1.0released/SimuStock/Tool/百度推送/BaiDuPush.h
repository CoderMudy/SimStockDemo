//
//  BaiDuPush.h
//  SimuStock
//
//  Created by jhss on 14-11-17.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"
#import "JsonFormatRequester.h"
@interface BaiDuPushRequester:JsonRequestObject
@end
@interface BaiDuPush : JsonRequestObject
/** 推送绑定baidu */
+ (void)pushBindUserUseridWithBaiduUid:(NSString *)baiduUid
                      withBaiduChannel:(NSString *)baiduChannel
                          withCallback:(HttpRequestCallBack *)callback;
///绑定用户
+ (void)pushBindUserWithToken:(NSString *)token
                 withCallback:(HttpRequestCallBack *)callbac;

///解绑用户
+ (void)pushDelBindUserWithCallback:(HttpRequestCallBack *)callback;
@end
