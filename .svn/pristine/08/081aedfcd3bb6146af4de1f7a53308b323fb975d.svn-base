//
//  StockTradeList.h
//  SimuStock
//
//  Created by Mac on 14-11-5.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"
#import "UserListItem.h"

@class HttpRequestCallBack;





/** 侧栏_我的交易 */
@interface MyTradeList : JsonRequestObject<Collectionable>

/** 交易明细数组*/
@property(strong, nonatomic) NSMutableArray *dataArray;

/** 最后一个对象的Id */
@property(assign, nonatomic) NSString* lastObjectId;

@end

@interface StockTradeList : JsonRequestObject <Collectionable>

/** 交易明细数组*/
@property(strong, nonatomic) NSMutableArray *dataArray;

/** 最后一个对象的Id */
@property(assign, nonatomic) NSString *lastObjectId;

/** 交易明细 */
+ (void)requestTradeDetailWithDic:(NSDictionary *)dic
                     withCallback:(HttpRequestCallBack *)callback;

/**  交易明细2*/
+ (void)requestTradeDetailWithUid:(NSString *)uid
                          fromtid:(NSString *)fromId
                           reqnum:(NSString *)reqnum
                      withMatchId:(NSString *)matchId
                     withCallback:(HttpRequestCallBack *)callback;

/** 获取用户主动聊股列表 */
+ (void)requestNewTalksOfUserId:(NSString *)userId
                         fromId:(NSString *)fromId
                         reqNum:(NSString *)reqNum
                   withCallback:(HttpRequestCallBack *)callback;
/**统计分享次数*/
+ (void)shareTimesOfStatisticsWithTalkStockID:(NSString *)talkStockID
                                 withCallback:(HttpRequestCallBack *)callback;
/** 请求分享 */
+ (void)requestShareStockTradeWithTid:(NSNumber *)tid
                     withCallback:(HttpRequestCallBack *)callback;
@end
/** 个人交易总数信息*/
@interface HomeTradeInfoInfo : JsonRequestObject
@property(strong, nonatomic) NSMutableArray *dataArray;

+ (void)getForCompleteTradeStatisticsAuserId:(NSString *)userId
                                     matchID:(NSString *)matchID
                                withCallback:(HttpRequestCallBack *)callback;

@end

/**
 *追踪信息
 */
@interface TracePCInfo : JsonRequestObject
//追踪数量
@property(assign, nonatomic) NSInteger totolCount;
//取得追踪关系
+ (void)queryTheUserToTrackTheRelationshipAuserId:(NSString *)userId
                                          matchID:(NSString *)matchID
                                     withCallback:
                                         (HttpRequestCallBack *)callback;
//增加追踪
+ (void)addTrace:(NSString *)userId
         matchID:(NSString *)matchID
    withCallback:(HttpRequestCallBack *)callback;
//取消追踪
+ (void)delTrace:(NSString *)userId
         matchID:(NSString *)matchID
    withCallback:(HttpRequestCallBack *)callback;

@end

/**
 *股友盈利曲线
 */

@interface PCProfitLine : JsonRequestObject
/** 盈利曲线信息*/
@property(strong, nonatomic) NSMutableArray *dataArray;
//盈利曲线
+ (void)showmyhistoryprofitAuserId:(NSString *)userId
                           matchID:(NSString *)matchID
                      withCallback:(HttpRequestCallBack *)callback;

@end

/**
 *分享信息
 */

@interface ShareInfo : JsonRequestObject

+ (void)refreshShareNumber:(NSString *)url
              withCallback:(HttpRequestCallBack *)callback;

@end
