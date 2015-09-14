//
//  TraceMessageList.h
//  SimuStock
//
//  Created by jhss on 15/6/30.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"
typedef NS_ENUM(NSUInteger, ButtonState) {
  /**买入*/
  STATE_Buy = 1,
  /**卖出*/
  STATE_Sell = 2,
  /**牛人计划开始*/
  STATE_MasterPlanBegin = 3,
  /**牛人计划结束*/
  STATE_MasterPlanOver = 4,
  /**牛人计划退款*/
  STATE_MasterPlanRefund = 5,
  /**牛人计划下架（推给用户）*/
  STATE_MasterPlanShelvesToUser = 6,
  /**牛人计划下架成功（推给牛人）*/
  STATE_MasterPlanSuccess = 7,
  /**牛人计划下架失败（推给牛人）*/
  STATE_MasterPlanFailed = 8,
  /**牛人计划下架（推给牛人创建者）*/
  STATE_MasterPlanShelves = 9
};
@class HttpRequestCallBack;
/*
 *类说明：设置－跟踪信息数据项
 */
@interface TraceMsgData : NSObject <ParseJson>
/** 用户id */
@property(nonatomic, copy) NSString *superUid;
/** 牛人计划账户id */
@property(nonatomic, copy) NSString *accountId;
/** 序列号 */
@property(nonatomic, strong) NSString *seq;

/** 标题 */
@property(nonatomic, strong) NSString *title;

/** 描述 */
@property(nonatomic, copy) NSString *des;

/** 类型 */
@property(nonatomic, strong) NSString *type;

/** 子类型 */
@property(nonatomic, strong) NSString *subType;

/** 来源名称 */
@property(nonatomic, strong) NSString *source;

/** 消息时间 long型毫秒数 */
@property(nonatomic, assign) int64_t time;

/** 消息时间 转化后的字符串格式 */
@property(nonatomic, strong) NSString *mstrTime;

/** 股票代码 */
@property(nonatomic, copy) NSString *stockCode;

/** 股票名称*/
@property(nonatomic, copy) NSString *stockName;

///显示的高度，只计算一次，下次直接复用
@property(nonatomic, strong) NSNumber *height;

@end

@interface TraceMessageList : JsonRequestObject <Collectionable>
/** 跟踪消息数组*/
@property(strong, nonatomic) NSMutableArray *dataArray;
/** 请求追踪消息列表 */
+ (void)requestTraceMessageListWithInput:(NSDictionary *)dic
                            withCallback:(HttpRequestCallBack *)callback;
+ (void)requestRefundWithAccoundId:(NSString *)accountId
                  andWithTargetUid:(NSString *)targetUid
                      withCallback:(HttpRequestCallBack *)callback;
@end
