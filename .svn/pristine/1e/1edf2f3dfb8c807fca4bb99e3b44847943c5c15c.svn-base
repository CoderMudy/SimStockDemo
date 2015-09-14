//
//  RealTradeStockPriceInfo.h
//  SimuStock
//
//  Created by Mac on 14-9-22.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

@class HttpRequestCallBack;

@interface RealTradeStockPriceInfo : JsonRequestObject

/**股票名称 */
@property(nonatomic, strong) NSString *stockName;

/**股票代码 */
@property(nonatomic, strong) NSString *stockCode;

/**是否停盘 */
@property(nonatomic, assign) int suspend;

/**委托数量 */
@property(nonatomic, strong) NSNumber *entrustAmount;

/**最新价格 */
@property(nonatomic, strong) NSString *latestPrice;

/**最高报价 */
@property(nonatomic, strong) NSString *highPrice;

/**最低价格 */
@property(nonatomic, strong) NSString *lowPrice;

/**昨收 */
@property(nonatomic, strong) NSString *closePrice;

/**开盘价格 */
@property(nonatomic, strong) NSString *openPrice;

/**委托价格 */
@property(nonatomic, strong) NSString *entrustPrice;

/**交易价位 */
@property(nonatomic, strong) NSString *tradePrice;

/**价格：买1、买2、买3、买4、买5 */
@property(nonatomic, strong) NSArray *buyPriceArray;
/**数量：买1、买2、买3、买4、买5 */
@property(nonatomic, strong) NSArray *buyAmountArray;
/**价格：卖1、卖2、卖3、卖4、卖5 */
@property(nonatomic, strong) NSArray *sellPriceArray;
/**数量：卖1、卖2、卖3、卖4、卖5  */
@property(nonatomic, strong) NSArray *sellAmountArray;

/**可买可卖数量计算，价格为空时传入@""，不可传入nil。接口名称: plancount*/
+ (void)computeEntrustAmountWithStockCode:(NSString *)stockCode
                         withEntrustPrice:(NSString *)entrustPrice
                                    isBuy:(BOOL)isBuy
                             WithCallback:(HttpRequestCallBack *)callback;

@end
