//
//  WithCapitalHome.h
//  SimuStock
//
//  Created by Mac on 15/4/14.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonFormatRequester.h"
@interface WithCapitalIsClose : JsonRequestObject
///配资资金池开关
@property(nonatomic) BOOL isClose;
@end
@interface WithCapitalAvailable : JsonRequestObject
///累计收益
@property(nonatomic) long long income;
///所有用户信息
@property(nonatomic, strong) NSMutableArray *userArray;
@end

/** 1.4 添加大额配资 */
@interface WFAddLargeAmountResult : JsonRequestObject
@end
@interface WFAddLargeAmountParameter : NSObject
/// 配资金额
@property(copy, nonatomic) NSString *financingMoney;
/// 配资天数
@property(copy, nonatomic) NSString *financingDays;
@end

@interface WithCapitalHome : NSObject

/** 1.1判断某用户是否拥有融资账户 */
#pragma mark 用户相关的调用
+ (void)checkWFAccountWithLimit:(NSString *)limit
                   withCallback:(HttpRequestCallBack *)callback;
/// 1.2 判断资金池是否还有资金
+ (void)checkWFISClosewithCallback:(HttpRequestCallBack *)callback;
/** 1.4 添加大额配资 */
+ (void)addWFLargeAccountWithFinancingMoney:(NSString *)financingMoney
                               withCallback:(HttpRequestCallBack *)callback;
@end
