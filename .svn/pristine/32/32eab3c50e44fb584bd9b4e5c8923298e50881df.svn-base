//
//  HomePageTableHeaderData.h
//  SimuStock
//
//  Created by Jhss on 15/7/28.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeUserInformationData.h"
#import "SimuRankPageData.h"
#import "UserTradeGradeItem.h"
#import "CustomPageData.h"
#import "SimuProfitLinePageData.h"

@interface HomePageTableHeaderData : NSObject

/** user Data */
@property(strong, nonatomic) HomeUserInformationData *userInfoData;
/** 周排行，月排行 */
@property(strong, nonatomic) SimuRankPageData *rankData;
/** 交易评级控件*/
@property(strong, nonatomic) UserTradeGradeItem *tradeGradeItem;
/** 总资产、总排名、持股市值、浮动盈亏、资金余额、聊股数 */
@property(strong, nonatomic) TradeStatisticsData *tradeData;
///比赛id
@property(nonatomic, strong) NSString *matchID;
/** 盈利曲线 */
@property(strong, nonatomic) SimuProfitLinePageData *profitLineData;
///追踪状态
@property(nonatomic, assign) NSInteger traceFlagInt;

@end
