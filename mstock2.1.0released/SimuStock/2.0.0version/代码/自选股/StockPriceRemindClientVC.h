//
//  StockPriceRemindClientVC.h
//  SimuStock
//
//  Created by jhss on 15-3-17.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "StockPriceRemindViewController.h"
#import "TrendKLineModel.h"
#import "StockAlarmRuleList.h"



/**提醒设置父控制器*/
@interface StockPriceRemindClientVC : BaseViewController {
  StockPriceRemindViewController *stockPriceRemindVC;
  /**股票代码（6位）*/
  NSString *_stockCode;
  /**股票代码（8位）*/
  NSString *_stockCodeLong;
  /**股票名称*/
  NSString *_stockName;
  /**是否是基金*/
  NSString *_firstType;
  /**比赛id*/
  NSString *_matchId;

  /** 当前页面股票的股价预警信息 */
  StockAlarmRuleList *_stockPriceRemindData;
  
  /** 行情数据 */
  NSDictionary *stockMarketInfo;
}

/** 设定初始的股票代码和股票名称 */
- (id)initWithStockCode:(NSString *)stockCode
          withStockName:(NSString *)stockName
          withFirstType:(NSString *)firstType
            withMatchId:(NSString *)matchId;

/**跳转到股价提醒设置页面*/
+ (void)stockRemindVCWithStockCode:(NSString *)stockCode
                     withStockName:(NSString *)stockName
                     withFirstType:(NSString *)firstType
                       withMatchId:(NSString *)matchId;
@end
