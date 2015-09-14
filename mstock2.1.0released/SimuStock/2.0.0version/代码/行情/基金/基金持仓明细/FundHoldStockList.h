//
//  FundHoldStockList.h
//  SimuStock
//
//  Created by Mac on 15/5/11.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"
#import "MarketConst.h"

@class HttpRequestCallBack;

///基金持仓中的一只股票
@interface FundHoldStock : BaseRequestObject2 <ParseJson>

/** 基金基本信息 */
@property(nonatomic, strong) Securities *fund;

@property(nonatomic, assign) long long holdingVol;

@property(nonatomic, assign) CGFloat PCTOfNAVEnd;

@end

///获取基金的持股明细
@interface FundHoldStockList
    : BaseRequestObject <ParseCompressPointPacket, Collectionable>

@property(nonatomic, strong) NSMutableArray *updateDateList;

///基金的持股明细
@property(nonatomic, strong) NSMutableArray *stockInfoList;

///基金代码
@property(nonatomic, strong) NSString *fundCode;

///基金名称
@property(nonatomic, strong) NSString *fundName;

/**
 * 获取基金的持股明细
 */
+ (void)requestHoldStocksWithParameters:(NSDictionary *)dic
                           withCallback:(HttpRequestCallBack *)callback;

@end
