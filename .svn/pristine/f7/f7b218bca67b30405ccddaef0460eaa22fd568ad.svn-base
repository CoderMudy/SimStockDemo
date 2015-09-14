//
//  GetStockFirmPositionData.h
//  SimuStock
//
//  Created by moulin wang on 15/4/15.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonFormatRequester.h"
@class HttpRequestCallBack;

/** 优顾实盘头的内容 */
@interface WFFirmHeadInfoData : BaseRequestObject2

/** 总资产（分） */
@property(copy, nonatomic) NSString *totalAsset;
/** 总盈利（分） */
@property(copy, nonatomic) NSString *totalProfit;
/** 可用余额（分 */
@property(copy, nonatomic) NSString *curAmount;
/** 保证金额(分) */
@property(copy, nonatomic) NSString *cashAmount;
/** 预警比例(分) */
@property(copy, nonatomic) NSString *enableAmount;
/** 止损比例(分) */
@property(copy, nonatomic) NSString *exposureAmount;

@end

/** stockList 股票持仓页面 */
@interface WFfirmStockListData : BaseRequestObject2

/** 股票代码 */
@property(copy, nonatomic) NSString *stockCode;
/** 股票名称 */
@property(copy, nonatomic) NSString *stockName;
/** 当前数量 */
@property(copy, nonatomic) NSString *currentAmount;
/** 可用数量 */
@property(copy, nonatomic) NSString *enableAmount;
/** 现价 */
@property(copy, nonatomic) NSString *price;
/** 当前成本 */
@property(copy, nonatomic) NSString *costBalance;
/** 当前市值 */
@property(copy, nonatomic) NSString *marketValue;
/** 盈亏 */
@property(copy, nonatomic) NSString *profit;
/** 盈亏率 */
@property(copy, nonatomic) NSString *profitRate;


@property(strong, nonatomic) NSMutableArray *stockListPositionArray;

@end


@interface GetStockFirmPositionDataAnalysis : JsonRequestObject<Collectionable>
/** 头 */
@property(strong, nonatomic) WFFirmHeadInfoData *firmHeadInfoData;
/** 股票列表 */
@property(strong, nonatomic) WFfirmStockListData *frimStockListData;

@property(strong, nonatomic) NSMutableArray *stockListArray;

@end


@interface GetStockFirmPositionData : NSObject

/**  发送请求 查询实盘页面持仓数据 */
+ (void)requestToSendGetDataWithHsUserId:(NSString *)hsUserId
                     withHomsFundAccount:(NSString *)homsFundAccount
                       withHomsCombineld:(NSString *)homsCombineld
                          withOperatorNo:(NSString *)operatorNo
                            withCallback:(HttpRequestCallBack *)callback;
/** 只请求持仓数据 */
+ (void)requestQueryPositionWithHsUserID:(NSString *)hsUserID
                     withHomsFundAccount:(NSString *)homsFundAccount
                       withHomsCombineld:(NSString *)homsCombineld
                            withCallback:(HttpRequestCallBack *)callback;

@end
