//
//  SimuRankPageData.h
//  SimuStock
//
//  Created by Mac on 13-8-15.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

@class HttpRequestCallBack;
/**
 *类说明：排名页面数据
 *
 */
@interface SimuRankPageData : JsonRequestObject

/** 总排行 */
@property (nonatomic, strong) NSString *  tRank;

/** 总上升名次 */
@property (nonatomic, strong) NSString * tRise;

/** 总盈利率 */
@property (strong,nonatomic) NSString * tProfit;

/** 周排行 */
@property (nonatomic, strong) NSString * wRank;

/** 周上升名次 */
@property (nonatomic, strong) NSString * wRise;

/** 周盈利率 */
@property (strong,nonatomic) NSString * wProfit;

/** 月总排行 */
@property (nonatomic, strong) NSString * mRank;

/** 月上升名次 */
@property (nonatomic, strong) NSString * mRise;

/** 月盈利率 */
@property (strong,nonatomic) NSString * mProfit;

/** 获取用户的排名信息 */
+ (void)requestRankInfoWithUser:(NSString*) userId withMatchId:(NSString*) matchId withCallback:(HttpRequestCallBack*) callback ;

@end
