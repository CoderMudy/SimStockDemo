//
//  WFInquireProductInfo.h
//  SimuStock
//
//  Created by jhss_wyz on 15/4/14.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonFormatRequester.h"

@class WFOneProductInfo;
@class WFProductDetail;

///判断是否某一个字段的配资是否可以申请
@interface WFProductButtonStateData : JsonRequestObject
///金额
@property(nonatomic, copy) NSString *Amount;
///状态 yes 不可选   no 可选

@property(nonatomic) BOOL State;
@end

/** 配资产品查询出参（产品信息集合） */
@interface WFProductListInfo : JsonRequestObject

/// 实盘金额列表(单位：元)
//@property(copy, nonatomic) NSMutableArray *amountArray;
//@property(nonatomic, copy) NSMutableArray *amountArrayUnit;
/// 实盘天数列表
//@property(copy, nonatomic) NSMutableArray *dayArray;
//@property(copy, nonatomic) NSMutableArray *dayArrayUnit;

@property(copy, nonatomic) NSMutableArray *days;

@property(copy, nonatomic) NSMutableArray *amounts;

@property(copy, nonatomic) NSMutableArray *dayStatusA;

@property(strong, nonatomic) NSMutableArray *amountStatusA;

@property(copy, nonatomic) NSMutableDictionary *amountToDays;

///默认选择的金额
@property(nonatomic, copy) NSString *defaultAmount;
///默认选择的天数
@property(nonatomic, copy) NSString *defaultDay;
/** 优顾账户余额 */
@property(nonatomic, copy) NSString *ygBalance;

/// 产品列表
@property(copy, nonatomic) NSArray *productJsonList;

/** 平仓线字典 */
@property(nonatomic, copy) NSDictionary *flatlineDic;
/** 警戒线字典 */
@property(nonatomic, copy) NSDictionary *warnlineDic;

/** 获得所选金额(用户的实盘金额)及天数对应的产品信息 */
- (WFOneProductInfo *)getOneProductInfoWithAmount:(NSString *)loanAmountString
                                           andDay:(NSString *)day;
@end

/** 查询配资产品出参之产品信息 */
@interface WFOneProductInfo : NSObject

/// 产品编码
@property(copy, nonatomic) NSString *prodId;
/// 配资时间
@property(copy, nonatomic) NSString *prodTerm;
/// 配资金额(单位：分)
@property(copy, nonatomic) NSString *financingPrice;
/// 起始时间
@property(copy, nonatomic) NSString *startDay;
/// 结束时间
@property(copy, nonatomic) NSString *endDay;
/// 保证金
@property(copy, nonatomic) NSString *cashAmount;
/// 管理费
@property(copy, nonatomic) NSString *mgrAmount;
/// 总支付金额
@property(copy, nonatomic) NSString *totalAmount;
/// 警戒线
@property(copy, nonatomic) NSString *warningLine;
/// 平仓线
@property(copy, nonatomic) NSString *flatLine;

/** 通过字典创建WFOneProductInfo对象 */
+ (instancetype)oneProductInfoWithDictionary:(NSDictionary *)dic;

@end

@interface WFInquireProductInfo : NSObject

#pragma mark 配资产品查询调用
/** 配资产品查询网络请求 */
+ (void)inquireWFProductInfoWithCallback:(HttpRequestCallBack *)callback;

@end
