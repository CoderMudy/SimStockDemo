//
//  WithFundingProduct.h
//  SimuStock
//
//  Created by jhss_wyz on 15/4/10.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WithFundingRequester.h"

/** 查询配资产品响应结果 */
@interface WFProductInfoList : BaseWithFundingResponseObject

///产品信息列表
@property(nonatomic, copy) NSString *prodInfoList;

@end

/** 申请配资响应结果 */
@interface WFProdOrderNo : BaseWithFundingResponseObject

///订单编号
@property(nonatomic, copy) NSString *orderNo;

@end

/** 申请合约展期响应结果 */
@interface WFContractExtension : BaseWithFundingResponseObject

@end

#pragma mark
#pragma mark 配资产品相关的调用

@interface WithFundingProduct : NSObject

/** 查询配资产品 */
+ (void)inquireWFProdInfoListWithProdId:(NSString *)prodId
                          andProdStatus:(NSString *)prodStatus
                          andProdTypeId:(NSString *)prodTypeId
                            andCallback:(HttpRequestCallBack *)callback;

/** 申请配资 */
+ (void)applyForWFProdWithUserId:(NSString *)userId
                   andCashAmound:(NSString *)cashAmount
                   andLoanAmount:(NSString *)loanAmount
                       andProdId:(NSString *)prodId
                     andProdTerm:(NSString *)prodTerm
                andOrderAbstract:(NSString *)orderAbstract
                     andCallback:(HttpRequestCallBack *)callback;

/** 申请合约展期 */
+ (void)applyForWFContractExtensionWithUserId:(NSString *)userId
                                andContractNo:(NSString *)contractNo
                                    andProdId:(NSString *)prodId
                                  andProdTerm:(NSString *)prodTerm
                             andOrderAbstract:(NSString *)orderAbstract
                                  andCallback:(HttpRequestCallBack *)callback;

@end
