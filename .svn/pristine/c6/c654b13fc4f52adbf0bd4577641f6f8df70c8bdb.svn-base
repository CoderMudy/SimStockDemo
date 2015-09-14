//
//  WFExtendContract.h
//  SimuStock
//
//  Created by jhss_wyz on 15/4/17.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonFormatRequester.h"
#import "WFApplyForWFProduct.h"

@interface WFExtendContractResult : ApplyForWFProductResult

@end

@interface WFExtendContract : NSObject

#pragma mark 配资产品合约展期调用
/** 配资产品合约展期 */
+ (void)applyForWFProductWithHsUserId:(NSString *)hsUserId
                        andContractNo:(NSString *)contractNo
                            andProdId:(NSString *)prodId
                          andProdTerm:(NSString *)prodTerm
                     andOrderAbstract:(NSString *)orderAbstract
                           andPayType:(NSString *)payType
                       andTotalAmount:(NSString *)totalAmount
                          andCallback:(HttpRequestCallBack *)callback;

@end
