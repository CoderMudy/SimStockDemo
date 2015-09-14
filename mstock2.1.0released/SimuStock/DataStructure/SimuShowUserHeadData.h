//
//  SimuShowUserHeadData.h
//  SimuStock
//
//  Created by Yuemeng on 14-11-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

@class HttpRequestCallBack;
/** 用户头像 */
@interface SimuShowUserHeadData : JsonRequestObject

/** 头像地址 */
@property (copy,nonatomic) NSString * headpicUrl;
/** 昵称 */
@property (copy,nonatomic) NSString * nickname;
/** 性别 */
@property (copy,nonatomic) NSString * sex;

+ (void)requestSimuShowUserHeadDataWithCallback:(HttpRequestCallBack *)callback;

@end
