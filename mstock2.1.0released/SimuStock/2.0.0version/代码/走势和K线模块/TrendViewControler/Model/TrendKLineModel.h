//
//  TrendKLineModel.h
//  SimuStock
//
//  Created by Mac on 14-10-31.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"
#import "Globle.h"
#import "NSStringCategory.h"
#import "CustomPageData.h"
#import "NSStringCategory.h"
#import "NSDataCategory.h"

/*
 *类说明:走势数据
 */
@interface TrendData
    : BaseRequestObject <ParseCompressPointPacket, Collectionable>

@property(strong, nonatomic) NSMutableArray *stockTrendArray;
@property(copy, nonatomic) NSString *stockname;      //股票名称
@property(copy, nonatomic) NSString *stockcode;      //股票代码
@property(assign, nonatomic) CGFloat lastClosePrice; //昨收价格
@property(assign, nonatomic) BOOL isListed; //是否停牌 Yes：正常 NO：停牌
                                            /*
                                             *下载股票分时走势数据
                                             */
+ (void)getStockTrendInfo:(NSString *)stringStock
           withStartIndex:(NSString *)startIndex
             withCallback:(HttpRequestCallBack *)callback;

@end

/*
 *资金流向数据
 */
@interface FundsFlowData : BaseRequestObject <ParseCompressPointPacket>

@property(strong, nonatomic) NSMutableArray *dataArray;
///下载股票资金流向数据
+ (void)getFundsFlowInfo:(NSString *)stringStock
            withCallback:(HttpRequestCallBack *)callback;

@end

/*
 *个股报价数据（包含买卖五档）
 */
@interface StockQuotationInfo
    : BaseRequestObject <ParseCompressPointPacket, Collectionable>

@property(strong, nonatomic) NSMutableArray *dataArray;

+ (void)getStockQuotaWithFivePriceInfo:(NSString *)stringStock
                          withCallback:(HttpRequestCallBack *)callback;
@end

/*
 *K线数据日线
 */
@interface KLineDataItemInfo
    : BaseRequestObject <ParseCompressPointPacket, Collectionable>

@property(copy, nonatomic) NSString *stockcode; //股票代码
@property(copy, nonatomic) NSString *type;      // K线类型，日、周、月
@property(copy, nonatomic) NSString *xrdrType;  //复权类型

@property(strong, nonatomic) NSMutableArray *dataArray;

+ (void)getKLineTypesInfo:(NSString *)stockcode
                     type:(NSString *)type
                 xrdrType:(NSString *)xrdrType
             withCallback:(HttpRequestCallBack *)callback;

@end

/*
 *明细
 */
@interface StockTradeDetailInfo
    : BaseRequestObject <ParseCompressPointPacket, Collectionable>

@property(strong, nonatomic) NSMutableArray *dataArray;

+ (void)getStockTradeDetailWithStockCode:(NSString *)stockCode
                            withCallback:(HttpRequestCallBack *)callback;

@end

/*
 *分价
 */
@interface StockPriceStateInfo
    : BaseRequestObject <ParseCompressPointPacket, Collectionable>

@property(strong, nonatomic) NSMutableArray *dataArray;

+ (void)getStockPriceStateWithStockCode:(NSString *)stockCode
                           wichCallback:(HttpRequestCallBack *)callback;
@end

/*
 *5日
 */
@interface Stock5DayStatusInfo
    : BaseRequestObject <ParseCompressPointPacket, Collectionable>
@property(copy, nonatomic) NSString *stockcode;    //股票代码
@property(assign, nonatomic) float lastClosePrice; //昨收价格
@property(assign, nonatomic) BOOL isListed; //是否停牌 Yes：正常 NO：停牌
@property(strong, nonatomic) NSMutableArray *stockTrendArray;
@property(nonatomic) int maxPrice;
@property (nonatomic) int minPrice;
@property (nonatomic) int64_t maxAmount;

+ (void)getStock5DayStatusWithStockCode:(NSString *)stockCode
                           withCallback:(HttpRequestCallBack *)callback;

@end