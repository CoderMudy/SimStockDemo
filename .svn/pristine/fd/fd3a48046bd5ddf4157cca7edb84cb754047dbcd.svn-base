//
//  IndexCurpriceData.h
//  SimuStock
//
//  Created by Yuemeng on 15/5/14.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"
#import "PacketCompressPointFormatRequester.h"

/*
 *  指数报价接口（包含上涨家数等）
 */
@interface IndexCurpriceData : BaseRequestObject <ParseCompressPointPacket>
///代码（8位内部代码）
@property(nonatomic, copy) NSString *code;
///代码（6位交易所代码）
@property(nonatomic, copy) NSString *stockCode;
///股票名称
@property(nonatomic, copy) NSString *name;
///成交额
@property(nonatomic) double totalMoney;
///上涨家数
@property(nonatomic) int up;
///外盘
@property(nonatomic) int64_t outAmount;
///涨跌幅
@property(nonatomic) float changePer;
///最高
@property(nonatomic) float highPrice;
///市场id
@property(nonatomic) int marketId;
///下跌家数
@property(nonatomic) int down;
///市盈率
@property(nonatomic) float revenue;
///一级类型
@property(nonatomic) int firstType;
///二级类型
@property(nonatomic) int secondType;
///流通市值
@property(nonatomic) int64_t outShare;
///状态（0：正常，1：停牌）
@property(nonatomic) int state;
///涨跌
@property(nonatomic) float change;
///开盘
@property(nonatomic) float openPrice;
///昨收
@property(nonatomic) float closePrice;
///最低
@property(nonatomic) float lowPrice;
///内盘
@property(nonatomic) int64_t inAmount;
///平盘家数
@property(nonatomic) int equ;
///成交量
@property(nonatomic) int64_t totalAmount;
///换手率
@property(nonatomic) float hsPer;
///当前价
@property(nonatomic) float curPrice;
///小数位数
@property(nonatomic) int decimalDigits;
///量比
@property(nonatomic) float amountScale;
///振幅
@property(nonatomic) float zfPer;

+ (void)requestIndexCurpriceDataWithCode:(NSString *)stockCode
                            withCallback:(HttpRequestCallBack *)callback;

@end
