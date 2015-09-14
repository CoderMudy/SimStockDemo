//
//  FirmBySellStatisticsInterface.h
//  SimuStock
//
//  Created by moulin wang on 15/5/14.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequestObject.h"
@class HttpRequestCallBack;

@interface FirmBySellStatisticsInterface : JsonRequestObject

/** 实盘界面 统计买入卖出接口 还有撤单界面 */
+ (void)requestFirmByOrSellStatisticeWithSotckName:(NSString *)stockName
                                     withStockCode:(NSString *)stockCode
                                    withStockPrice:(NSString *)stockPrice
                                   withStockAmount:(NSString *)stockAmount
                                      withByOrSell:(NSString *)isByOrSellOrChenchan
                                      withCallback:
                                          (HttpRequestCallBack *)callback;
@end
