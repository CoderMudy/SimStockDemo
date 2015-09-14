//
//  PriceBuySellTool.h
//  SimuStock
//
//  Created by 刘小龙 on 15/7/27.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BuySellConstant.h"
/** 买卖数据模型 */
@class SimuTradeBaseData;
@class StockBuySellView;

@interface PriceBuySellTool : NSObject

/** 市价计算方法 或 限价计算方法*/
+ (NSInteger)
marketFixedFoundsShowLableWithSimuTradeData:(SimuTradeBaseData *)data
                            withBuySellType:(MarketFixedPriceType)type;

/** 滑块 滑动时 计算市价 限价 金额 */
+ (NSInteger)fixedSliederFoundsWithNewPrice:(NSString *)price
                                 withAmount:(NSInteger)amount
                          withSimuTradeData:(SimuTradeBaseData *)data
                            withBuySellType:(MarketFixedPriceType)type;

/** 资金选择按钮点击后计算滑块值 */
+ (NSInteger)moneryFoundsForSliederValueWithFunds:(NSInteger)funds
                                withSimuTradeData:(SimuTradeBaseData *)data
                        withStockBuySellTextFiled:
                            (StockBuySellView *)buySellView;

/** 资金选择后 计算 限价市值 */
+ (NSInteger)moreFundsButtonDownWithSimuTradeData:(SimuTradeBaseData *)data
                             withStockBuySellView:
                                 (StockBuySellView *)buySellView
                                       withAmount:(NSInteger)amount;

/** 判断价格是否合理 */
+ (NSString *)reasonablePrice:(NSString *)price
              withBuySellType:(BuySellType)type
            withSimuTradeData:(SimuTradeBaseData *)data;

/** 根据价格变化 来计算 资金值 */
+ (NSInteger)priceChangeCalculationFundsWihtPrcie:(NSString *)price
                                       withAmount:(NSInteger)amout
                                withSimuTradeData:(SimuTradeBaseData *)data;

@end
