//
//  WFCapitalByOrSellOut.h
//  SimuStock
//
//  Created by moulin wang on 15/4/20.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonFormatRequester.h"
@class HttpRequestCallBack;

//解析类
@interface WFCapitalBySellJosnData : JsonRequestObject
/** 委托编号 */
@property(copy, nonatomic) NSString *entrusNo;
/** 委托批号 */
@property(copy, nonatomic) NSString *batchNo;


@end

@interface WFCapitalByOrSellOut : NSObject

//买入 卖出
+ (void)requestCapitalByOrSellWithBoll:(BOOL)isByOrSell
                         withStockCode:(NSString *)stockCode
                             withPrice:(NSString *)price
                            withAmount:(NSString *)amount
                          withCallback:(HttpRequestCallBack *)callback;

@end
