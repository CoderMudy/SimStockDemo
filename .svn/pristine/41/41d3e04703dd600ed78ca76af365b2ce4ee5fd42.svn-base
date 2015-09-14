//
//  WFApplyForWFProduct.h
//  SimuStock
//
//  Created by jhss_wyz on 15/4/17.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonFormatRequester.h"

@class WFGetPostponeDetailInfo;

#pragma mark 申请配资产品合约出参及入参
/** 申请配资产品合约出参 */
@interface WFMakeNewContractResult : JsonRequestObject

@end

/** 申请配资产品合约入参 */
@interface WFMakeNewContractParameter : NSObject

/** 保证金 */
@property(copy, nonatomic) NSString *cashAmount;
/** 借款金额 */
@property(copy, nonatomic) NSString *loanAmount;
/** 产品Id */
@property(copy, nonatomic) NSString *prodId;
/** 借款时长 */
@property(copy, nonatomic) NSString *prodTerm;
/** 总支付金额 */
@property(copy, nonatomic) NSString *totalAmount;
/** 管理费 */
@property(copy, nonatomic) NSString *mgrAmount;

@end

#pragma mark 配资产品合约展期出参及入参
/** 配资产品合约展期出参 */
@interface WFExtendContractResult : JsonRequestObject

@end

/** 配资产品展期合约入参 */
@interface WFExtendContractParameter : NSObject

/** 合约编号 */
@property(copy, nonatomic) NSString *contractNo;
/** 产品Id */
@property(copy, nonatomic) NSString *prodId;
/** 借款时长 */
@property(copy, nonatomic) NSString *prodTerm;
/** 申请说明 */
@property(copy, nonatomic) NSString *orderAbstract;
/** 总支付金额 */
@property(copy, nonatomic) NSString *totalAmount;

@end

#pragma mark 追保出参及入参
/** 追保出参 */
@interface WFAddBailContractResult : JsonRequestObject

@end

/** 追保入参 */
@interface WFAddBailContractParameter : NSObject

/** 合约编号 */
@property(copy, nonatomic) NSString *contractNo;
/** 追保金额 */
@property(copy, nonatomic) NSString *transAmount;
/** 备注 */
@property(copy, nonatomic) NSString *remark;

@end

#pragma mark 查询当前借款合约列表及总资产情况出参及入参
/** 查询当前借款合约列表及总资产情况出参 */
@interface WFCurrentContractList : JsonRequestObject

///是否有配资账户
@property(nonatomic) NSInteger openAccountStatus;
/// 总资产（分）
@property(strong, nonatomic) NSString *totalAsset;
/// 总市值（分）
@property(strong, nonatomic) NSString *totalMarketValue;
/// 总盈利（分）
@property(strong, nonatomic) NSString *totalProfit;
/// 可取金额（分）
@property(strong, nonatomic) NSString *enableWithdraw;
/// 可用余额（分）
@property(strong, nonatomic) NSString *curAmount;
/// 期初账户金额（分）
@property(strong, nonatomic) NSString *beginAmount;
/// 保证金额(单位：分)
@property(strong, nonatomic) NSString *cashAmount;
/// 合约列表
@property(strong, nonatomic) NSMutableArray *list;

/// 是否有配资账号
- (BOOL)hasWFAccount;

@end

/** 借款合约详细信息 */
@interface WFContractInfo : JsonRequestObject

///恒生用户编号
@property(nonatomic, copy) NSString *hsUserId;
/// 合约编号
@property(copy, nonatomic) NSString *contractNo;
/// homs主账户
@property(copy, nonatomic) NSString *homsFundAccount;
/// homs子账户
@property(copy, nonatomic) NSString *homsCombineId;
/// 操作员
@property(copy, nonatomic) NSString *operatorNo;
/// 配资金额
@property(copy, nonatomic) NSString *Amount;
///产品编号
@property(copy, nonatomic) NSString *prodId;
/// 期限
@property(copy, nonatomic) NSString *prodTerm;
/// 合约截止时间
@property(copy, nonatomic) NSString *contractEndDate;
/// 总盈利（分）
@property(copy, nonatomic) NSString *totalProfit;
/// 总资产（分）
@property(copy, nonatomic) NSString *totalAsset;
/// 可用余额（分）
@property(copy, nonatomic) NSString *curAmount;
/// 申请状态（0：审核中,1.审核通过）
@property(nonatomic) NSInteger verifyStatus;

+ (instancetype)contractInfoWithDictionary:(NSDictionary *)dic;
- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
#pragma mark 查询当前借款合约列表中等待审核的接口
/** 查询当前借款合约列表及总资产情况出参 */
@interface WFCurrentContractQueryOrderInfoList
    : JsonRequestObject <Collectionable>
/// 合约列表
@property(copy, nonatomic) NSArray *list;
@property(nonatomic) BOOL isExist;
@end

/** 查询当前借款合约列表及总资产情况入参 */
@interface WFInquireCurrentContractParameter : NSObject

/** 恒生用户编号 */
@property(copy, nonatomic) NSString *hsUserId;

@end

#pragma mark 获取展期信息出参及入参
/** 获取展期信息出参 */
@interface WFGetPostponeInfoResult : JsonRequestObject

/** 合约编号 */
@property(copy, nonatomic) NSString *contractNo;
/** 配资天数列表 */
@property(copy, nonatomic) NSArray *dayArray;
/** 展期信息列表 */
@property(copy, nonatomic) NSArray *postponeJsonList;
/** 优顾账户余额  */
@property (copy,nonatomic) NSString *ygBalance;

/** 通过展期天数获得对应的展期信息 */
- (WFGetPostponeDetailInfo *)getPostponeDetailInfoWithProdterm:
    (NSString *)prodTerm;

@end

/** 获取展期详细信息出参出参 */
@interface WFGetPostponeDetailInfo : NSObject

/** 每日管理费 */
@property(copy, nonatomic) NSString *dayMgrAmount;
/** 结束时间 */
@property(copy, nonatomic) NSString *endDay;
/** 总管理费 */
@property(copy, nonatomic) NSString *mgrAmount;
/** 配资天数 */
@property(copy, nonatomic) NSString *prodTerm;
/** 开始时间 */
@property(copy, nonatomic) NSString *startDay;
/** 产品编号 */
@property(copy, nonatomic) NSString *prodId;

+ (instancetype)getPostponeDetailInfoWithDictionary:(NSDictionary *)dic;

@end

/** 获取展期信息入参 */
@interface WFGetPostponeInfoParameter : NSObject

/** 合约编号 */
@property(copy, nonatomic) NSString *contractNo;

@end

#pragma mark 获取追保信息出参及入参
/** 获取追保信息出参 */
@interface WFGetCashAmountInfoResult : JsonRequestObject

/** 合约编号 */
@property(copy, nonatomic) NSString *contractNo;
/** 浮动保证金 */
@property(copy, nonatomic) NSString *cashAmount;
/** 平仓线 */
@property(copy, nonatomic) NSString *flatLine;
/** 警戒线 */
@property(copy, nonatomic) NSString *warningLine;
/** 当前资产 */
@property(copy, nonatomic) NSString *totalAsset;
/** 是否需要充值标志位 0：不充值 1：充值 */
@property(assign, nonatomic) BOOL czFlag;
/** 最大充值保证金 */
@property(copy, nonatomic) NSString *addBigPrice;
/** 最小保证金 */
@property(copy, nonatomic) NSString *addLittlePrice;
/** 优顾账户余额 */
@property(copy, nonatomic)NSString *ygBalance;

@end

/** 获取追保信息入参 */
@interface WFGetCashAmountInfoParameter : NSObject

/** 合约编号 */
@property(copy, nonatomic) NSString *contractNo;

@end

@interface WFProductContract : NSObject

#pragma mark 申请配资产品调用
/** 配资产品申请网络请求 */
+ (void)makeWFContractWithProductInfo:(WFMakeNewContractParameter *)product
                          andCallback:(HttpRequestCallBack *)callback;

#pragma mark 配资产品合约展期调用
/** 配资产品合约展期网络请求 */
+ (void)extendWFProductContractWithContractNo:(NSString *)contractNo
                                    andProdId:(NSString *)prodId
                                  andProdTerm:(NSString *)prodTerm
                             andOrderAbstract:(NSString *)orderAbstract
                               andTotalAmount:(NSString *)totalAmount
                                  andCallback:(HttpRequestCallBack *)callback;

#pragma mark 追保调用
/** 追保网络请求 */
+ (void)addWFProductBailContractWithContractNo:(NSString *)contractNo
                                andTransAmount:(NSString *)transAmount
                                     andRemark:(NSString *)remark
                                   andCallback:(HttpRequestCallBack *)callback;

#pragma mark 查询当前借款合约列表及总资产情况调用
/** 查询当前借款合约列表及总资产情况网络请求 */
+ (void)inquireWFProductCurrentContractandCallback:
    (HttpRequestCallBack *)callback;
/** 查询当前是否有带审核中得合约*/
+ (void)inquireWFProductCurrentContractQueryOrderInfoCallback:
    (HttpRequestCallBack *)callback;
#pragma mark 追保调用
/** 追保网络请求 */
+ (void)getPostponeInfoWithContractNo:(NSString *)contractNo
                          andCallback:(HttpRequestCallBack *)callback;

#pragma mark 追保调用
/** 追保网络请求 */
+ (void)getCashAmountInfoWithContractNo:(NSString *)contractNo
                            andCallback:(HttpRequestCallBack *)callback;
@end
