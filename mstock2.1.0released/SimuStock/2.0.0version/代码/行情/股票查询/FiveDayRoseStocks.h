//
//  FiveDayRoseStocks.h
//  SimuStock
//
//  Created by Mac on 14-10-29.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"
#import "Globle.h"
#import "PacketCompressPointFormatRequester.h"
#import "NSStringCategory.h"

/*
 *类说明：表格数据结构
 */

@interface RoseStockItem : NSString <ParseJson>

@property(nonatomic, strong) NSString *stockCode;
@property(nonatomic, strong) NSString *stockName;

/** 涨幅 */
@property(nonatomic, strong) NSString *gain;

/** 最新价 */
@property(nonatomic, strong) NSString *curPrice;

/** 价格增量 */
@property(nonatomic, strong) NSString *priceIncrease;

@end

@interface FiveDayRoseStocks : BaseRequestObject <ParseCompressPointPacket,Collectionable>

/** 多条上涨股票 */
@property(strong, nonatomic) NSMutableArray *stocks;

/**
 * 获取五日涨幅榜的股票列表
 */
+ (void)getFiveDayRoseStocksWithParams:(NSDictionary *)dic
                          withCallback:(HttpRequestCallBack *)callback;

@end