//
//  ProfitAndStopClienVC.h
//  SimuStock
//
//  Created by jhss on 15/5/25.
//  Copyright (c) 2015年 Mac. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ProfitAndStopView.h"
#import "OpeningTimeView.h"
#import "SimuStockInfoView.h"


///菊花开始旋转
typedef void (^ProfitIndicatorStatr)();
///菊花停止旋转
typedef void (^ProfitIndicatorStop)();

/**止盈止损总VC*/
@interface ProfitAndStopClienVC : UIViewController <UITextFieldDelegate> {
  /** 止盈止损相关信息 */
  ProfitAndStopView *scv_profitAndStopView;
  /** 闹钟和时间控件 */
  OpeningTimeView *scvc_openingTimeView;
  /** 股票相关信息 */
  SimuStockInfoView *scv_stockInfoView;
  /** 可卖总量 */
  long long scv_buystockNumber;
  /** 卖出数据 */
  SimuTradeBaseData *simuSellQueryData;
  /** 上次输入的股票价格 */
  float scv_lastprice;
  ///输入框数组
  NSArray *textField1;
  NSArray *textField2;
  ///滑块开关数组
  NSArray *switchs;
}
/** 记录股票信息 */
@property(strong, nonatomic) NSString *tempStockCode;
@property(nonatomic, strong) NSString *firstType;

@property(strong, nonatomic) NSString *tempStockName;
@property(strong, nonatomic) NSString *tempStockNumber;
/**止盈价*/
@property(strong, nonatomic) NSString *stopWinPri;
/**止盈比例*/
@property(strong, nonatomic) NSString *stopWinRate;
/**止损价*/
@property(strong, nonatomic) NSString *stopLosePri;
/**止损比例*/
@property(strong, nonatomic) NSString *stopLoseRate;
/** 比赛ID */
@property(strong, nonatomic) NSString *scv_marichid;

@property(copy, nonatomic) ProfitIndicatorStatr indiactorStatrAnimation;
@property(copy, nonatomic) ProfitIndicatorStop indiactorStopAnimation;

/** 设定初始的股票代码和股票名称 */
- (id)initWithStockCode:(NSString *)stockCode
          withStockName:(NSString *)stockName
            withMatchId:(NSString *)matchId;

/** 对外刷新 */
- (void)refreshButtonPressDown;
@end
