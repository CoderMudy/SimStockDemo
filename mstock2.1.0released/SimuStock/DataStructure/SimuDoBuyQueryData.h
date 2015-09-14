//
//  SimuDoBuyQueryData.h
//  SimuStock
//
//  Created by Yuemeng on 14-11-17.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SimuTradeBaseData.h"

/** （可能废弃）买入查询数据类，接口：dobuyquery */
@interface SimuDoBuyQueryData : SimuTradeBaseData

+ (void)requestSimuDoBuyQueryDataWithStockCode:(NSString *)stockCode
                                  withCallback:(HttpRequestCallBack *)callback;
@end
