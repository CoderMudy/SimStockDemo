//
//  HotStockBarListData.h
//  SimuStock
//
//  Created by Yuemeng on 14-11-24.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

@class HttpRequestCallBack;

/** 热门股吧数据 */
@interface HotStockBarData : JsonRequestObject

/** 排序id */
@property(nonatomic, strong) NSNumber *seqId;
/** 股吧ID */
@property(nonatomic, strong) NSNumber *barId;
/** 股吧名称 */
@property(nonatomic, strong) NSString *name;
/** 股吧logo */
@property(nonatomic, strong) NSString *logo;
/** 股吧简介 */
@property(nonatomic, strong) NSString *des;
/** 聊股数 */
@property(nonatomic, strong) NSNumber *postNum;

@end

/** 热门聊股吧数据模型 */
@interface HotStockBarListData : JsonRequestObject

/** 热门股吧数据数组 */
@property(nonatomic, strong) NSMutableArray *dataArray;

/** fromId:起始股吧ID;为-1时 从头开始.reqNum:查询的股吧个数 */
/** 0：主题吧和1：牛人吧 */
+ (void)requestHotStockBarListDataWithFromId:(NSNumber *)fromId
                                  withReqNum:(NSInteger)reqNum
                                    withType:(NSInteger)type
                                withCallback:(HttpRequestCallBack *)callback;

/** 所有聊股吧接口 */
+ (void)requestHotStockBarListDataWithFromId:(NSNumber *)fromId
                                  withReqNum:(NSInteger)reqNum
                                withCallback:(HttpRequestCallBack *)callback;



@end
