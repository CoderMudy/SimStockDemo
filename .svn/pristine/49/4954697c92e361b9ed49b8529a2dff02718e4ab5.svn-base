//
//  ModifySelfGroupData.h
//  SimuStock
//
//  Created by Yuemeng on 15/6/17.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

@class HttpRequestCallBack;

/*
 *  更新用户自选股分组信息
 *  状态码，0000 更新分组成功，其他均为失败
 */
@interface ModifySelfGroupData : JsonRequestObject

+ (void)requestSelfStockGroupListDataWithGroupId:(NSString *)groupId
                                   withGroupName:(NSString *)groupName
Callback:(HttpRequestCallBack *)callback;
@property (nonatomic,strong) NSDictionary * dic;

@end
