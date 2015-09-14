//
//  WFFinancialDetailsData.h
//  SimuStock
//
//  Created by moulin wang on 15/4/23.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonFormatRequester.h"
@class HttpRequestCallBack;

/** 资金流水界面 账户信息 */
@interface WFAccountInfoData : NSObject

/** 资金 */
@property(copy, nonatomic) NSString *amount;
/** id */
@property(copy, nonatomic) NSString *accountID;
/** uid */
@property(copy, nonatomic) NSString *uid;
-(void)jsonToDict:(NSDictionary *)dic;
@end


/** 资金流水界面数据模型 */
@interface WFfinancialDetailsModeData : JsonRequestObject

/** 优顾账户id */
@property(assign, nonatomic) int youguuID;
/** 流水类型 */
@property(copy, nonatomic) NSString *flowType;
/** 流水描述 */
@property(copy, nonatomic) NSString *flowDesc;
/** 流水发生时间 */
@property(copy, nonatomic) NSNumber *flowDatetime;
/** 流水发生金额 */
@property(copy, nonatomic) NSString *flowAmount;
/** 账户余额 */
@property(copy, nonatomic) NSString *accountBalance;

@property(strong, nonatomic) NSMutableArray *array;

@end

@interface WFFinancialDetailsData : NSObject
/**
 *  资金流水明细
 */
+ (void)requestFinancialDetailsModeData:(NSString *)fromld
                           withPageSize:(NSString *)pageSize
                           withCallbacl:(HttpRequestCallBack *)callback;

@end
