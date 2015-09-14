//
//  UserAssetsData.h
//  SimuStock
//
//  Created by 刘小龙 on 15/7/6.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"
@class HttpRequestCallBack;

@interface UserAssetsData : JsonRequestObject

/** 账户余额 */
@property(assign, nonatomic) NSInteger amount;

+ (void)requestUserAssetsWithCallback:(HttpRequestCallBack *)callback;

@end
