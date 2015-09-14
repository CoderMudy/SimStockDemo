//
//  NewSelfGroupData.h
//  SimuStock
//
//  Created by Yuemeng on 15/6/17.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

@class HttpRequestCallBack;

/*
 *  新增自选股分组
 *  新增自选股分组，增加自选股之前查询该用户自选股分组数量，如果达到数量上限提示。否则执行添加自选股功能
 *  状态码，0000 添加分组成功，1001 分组已经存在; 1002 自选股分组数量达到上限; 1000 服务端异常 ，其他均为失败
 */
@interface NewSelfGroupData : JsonRequestObject
@property (nonatomic,strong) NSDictionary * dic;


+ (void)requestNewSelfGroupName:(NSString *)groupName
                   WithCallback:(HttpRequestCallBack *)callback;

@end
