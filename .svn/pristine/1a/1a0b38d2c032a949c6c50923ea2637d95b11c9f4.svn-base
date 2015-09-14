//
//  CPSellStockData.h
//  SimuStock
//
//  Created by jhss_wyz on 15/7/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"
#import "JsonFormatRequester.h"

@interface CPSellStockData : JsonRequestObject

@property(assign, nonatomic) NSInteger ID;
/** 用户id */
@property(assign, nonatomic) NSInteger uid;
/** 账户id */
@property(strong, nonatomic) NSString *accountId;
/** 委托类别（0:限价1:市价2:止盈3:止损） */
@property(assign, nonatomic) NSInteger category;
/** 交易类型（0：股票，1：基金） */
@property(assign, nonatomic) NSInteger tradeType;
/** 代码 */
@property(strong, nonatomic) NSString *stockCode;
/** 名称 */
@property(strong, nonatomic) NSString *stockName;
/** 委托id */
@property(assign, nonatomic) NSString *commissionId;
/** 委托类型（1：买，2：卖，3：撤单，4：分红） */
@property(assign, nonatomic) NSInteger commissionType;
/** 委托价 */
@property(assign, nonatomic) CGFloat commissionPrice;
/** 委托数量 */
@property(assign, nonatomic) NSInteger commissionAmount;
/** 委托时间 */
@property(strong, nonatomic) NSString *commissionTime;
/** 佣金费率 */
@property(assign, nonatomic) CGFloat feeRate;
/** 印花税率 */
@property(assign, nonatomic) CGFloat taxRate;
/** 冻结资金 */
@property(assign, nonatomic) CGFloat frozenFund;
/** 成交价 */
@property(assign, nonatomic) CGFloat concludePrice;
/** 成交时间 */
@property(strong, nonatomic) NSString *concludeTime;
/** 成交数量 */
@property(assign, nonatomic) NSInteger concludeAmount;
/** 佣金 */
@property(assign, nonatomic) CGFloat yongJin;
/** 印花税 */
@property(assign, nonatomic) CGFloat yinHuaShui;
/** 成交量 */
@property(assign, nonatomic) CGFloat cjBalance;
/** 登记股数 */
@property(assign, nonatomic) NSInteger regAmount;
/** 委托状态 */
@property(assign, nonatomic) NSInteger regStatus;
/** token */
@property(assign, nonatomic) NSString *token;

@end

@interface CPSellStockRequest : NSObject

+ (void)requestCPSellStockWithAccountId:(NSString *)accountId
                            andCategory:(NSString *)category
                           andStockCode:(NSString *)stockCode
                               andPrice:(NSString *)price
                              andAmount:(NSString *)amount
                            andCallback:(HttpRequestCallBack *)callback;

@end
