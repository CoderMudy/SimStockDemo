//
//  FundCurStatus.h
//  SimuStock
//
//  Created by Mac on 15/5/11.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"
#import "MarketConst.h"
#import "TrendKLineModel.h"

@class HttpRequestCallBack;

/** 基金价格信息 */
@interface FundCurStatus : BaseRequestObject2 <ParseJson>

/** 基金基本信息 */
@property(nonatomic, strong) Securities *fund;

/** 最新价 */
@property(nonatomic, assign) CGFloat curPrice;

/** 涨跌 */
@property(nonatomic, assign) CGFloat change;

/** 涨跌幅 */
@property(nonatomic, assign) CGFloat changePer;

/** 开盘价 */
@property(nonatomic, assign) CGFloat openPrice;

/** 昨收 */
@property(nonatomic, assign) CGFloat closePrice;

/** 最高 */
@property(nonatomic, assign) CGFloat highPrice;

/** 最低 */
@property(nonatomic, assign) CGFloat lowPrice;

/** 成交量 */
@property(nonatomic, assign) long long totalAmount;

/** 成交额 */
@property(nonatomic, assign) double totalMoney;

/** 振幅 */
@property(nonatomic, assign) CGFloat zfPer;

/** 换手率 */
@property(nonatomic, assign) CGFloat hsPer;

/** 量比 */
@property(nonatomic, assign) CGFloat amountScale;

/** 状态（0：正常，1：停牌） */
@property(nonatomic, assign) NSInteger state;

/** 内盘 */
@property(nonatomic, assign) long long inAmount;

/** 外盘 */
@property(nonatomic, assign) long long outAmount;

/** 单位净值 */
@property(nonatomic, assign) CGFloat unitNAV;

/** 累计净值 */
@property(nonatomic, assign) CGFloat accuUnitNAV;

/** 折扣率 */
@property(nonatomic, assign) CGFloat discountRate;

/** 资产净值 */
@property(nonatomic, assign) double NAVEnd;

/** 基金份额 */
@property(nonatomic, assign) double latestShare;

- (NSString *)getChangeValueAndRate;

@end

/** 基金实时行情，包括价格和买5卖5信息 */
@interface FundCurStatusWrapper
    : BaseRequestObject <ParseCompressPointPacket, Collectionable>

/** 基金信息列表 */
@property(nonatomic, strong) NSMutableArray *fundInfoList;

/** 买5卖5信息列表 */
@property(nonatomic, strong) NSMutableArray *top5QuotationList;

/** 买5卖5信息列表 */
@property(nonatomic, strong) StockQuotationInfo *stockQuotationInfo;

/** 请求基金信息 */
+ (void)requestFundCurStatusWithParameters:(NSDictionary *)dic
                              withCallback:(HttpRequestCallBack *)callback;

@end
