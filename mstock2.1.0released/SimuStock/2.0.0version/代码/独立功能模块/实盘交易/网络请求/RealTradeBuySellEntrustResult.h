//
//  RealTradeBuySellEntrustResult.h
//  SimuStock
//
//  Created by Mac on 14-9-22.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

@class HttpRequestCallBack;

@interface RealTradeBuySellEntrustResult : JsonRequestObject

/**委托单 */
@property(nonatomic, strong) NSString *commissionid;

/**买入股票 */
+ (void)buyStockWithStockCode:(NSString *)stockCode
                    withPrice:(NSString *)price
                   withAmount:(NSString *)amount
                 WithCallback:(HttpRequestCallBack *)callback;

/**卖出股票 */
+ (void)sellStockWithStockCode:(NSString *)stockCode
                     withPrice:(NSString *)price
                    withAmount:(NSString *)amount
                  WithCallback:(HttpRequestCallBack *)callback;

@end
