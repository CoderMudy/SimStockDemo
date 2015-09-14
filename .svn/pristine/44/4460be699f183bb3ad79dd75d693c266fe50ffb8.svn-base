//
//  HotStockTopicListData.h
//  SimuStock
//
//  Created by Yuemeng on 14-11-24.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

@class HttpRequestCallBack;

/** 热门个股数据 */
@interface HotStockTopicData : JsonRequestObject

/** 排序 id */
@property(nonatomic, strong) NSNumber *seqId;
/** 股票代码 */
@property(nonatomic, strong) NSString *stockCode;
/** 股票名称 */
@property(nonatomic, strong) NSString *stockName;
/** 股票所属上市公司 logo */
@property(nonatomic, strong) NSString *logo;
/** 最新价 */
@property(nonatomic, strong) NSString *price;
/** 涨跌幅 */
@property(nonatomic, strong) NSString *changeRate;
/** 聊股数 */
@property(nonatomic, strong) NSNumber *postNum;

@end

/** 热门个股数据模型 */
@interface HotStockTopicListData : JsonRequestObject

/** 热门个股数据数组 */
@property(nonatomic, strong) NSMutableArray *dataArray;

/** fromId:起始个股吧ID;为0时 从头开始. reqNum:查询的个股吧个数 */
+ (void)requestHotStockTopicListDataWithFromId:(NSNumber *)fromId
                                    withReqNum:(NSInteger)reqNum
                                  withCallback:(HttpRequestCallBack *)callback;
@end
