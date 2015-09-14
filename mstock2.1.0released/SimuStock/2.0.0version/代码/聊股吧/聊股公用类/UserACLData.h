//
//  UserACLData.h
//  SimuStock
//
//  Created by Yuemeng on 14/12/26.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

@class HttpRequestCallBack;

/** 用户权限检测 */
@interface UserACLData : JsonRequestObject

/** 角色编号 002:超级管理员 001:版主 @"": 普通用户 */
@property(nonatomic, copy) NSString *num;
/** 角色名称 */
@property(nonatomic, copy) NSString *name;
/** 股吧id列表(内部为NSNumber) */
@property(nonatomic, strong) NSArray *barList;
/** 动作权限列表 */
@property(nonatomic, strong) NSDictionary *actionList;

/******* 额外拓展 *******/
/** 能否全局置顶 */
@property(nonatomic) BOOL enableGlobleTop;
/** 能否取消全局置顶 */
@property(nonatomic) BOOL enableUnGlobleTop;
/** 能否置顶 */
@property(nonatomic) BOOL enableTop;
/** 能否取消置顶 */
@property(nonatomic) BOOL enableUnTop;
/** 能否加精 */
@property(nonatomic) BOOL enableElite;
/** 能否取消加精 */
@property(nonatomic) BOOL enableUnElite;
/** 能否删除 */
@property(nonatomic) BOOL enableDelete;

/** 请求当前用户权限 */
+ (void)requestUserACLDataWithCallback:(HttpRequestCallBack *)callback;

@end
