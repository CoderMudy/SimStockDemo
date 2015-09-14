//
//  ProfitAndStopClienVC.h
//  SimuStock
//
//  Created by tanxuming on 15/5/25.
//  Copyright (c) 2015年 Mac. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ProfitAndStopView.h"
#import "OpeningTimeView.h"
#import "SimuStockInfoView.h"
#import "ExpertPlanConst.h"

///菊花开始旋转
typedef void (^ProfitIndicatorStatr)();
///菊花停止旋转
typedef void (^ProfitIndicatorStop)();
///卖出点击按钮回调
typedef void (^SellButtonClickBlock)();

/**止盈止损总VC*/
@interface ProfitAndStopClientVC : UIViewController <UITextFieldDelegate> {
//  /** 止盈止损相关信息 */
//  ProfitAndStopView *scv_profitAndStopView;
  /** 闹钟和时间控件 */
  OpeningTimeView *_scvc_openingTimeView;
  /** 股票相关信息 */
  SimuStockInfoView *_scv_stockInfoView;
  /** 可卖总量 */
  long long _scv_buystockNumber;
  /** 卖出数据 */
  SimuTradeBaseData *_simuSellQueryData;
  /** 上次输入的股票价格 */
  float _scv_lastprice;
  ///输入框数组
  NSArray *_textField1;
  NSArray *_textField2;
  ///滑块开关数组
  NSArray *_switchs;
  NSString *_format;
}

/** 止盈止损相关信息 */
@property(strong, nonatomic) ProfitAndStopView *scv_profitAndStopView;

/** 记录股票信息 */
@property(strong, nonatomic) NSString *tempStockCode;
/** 股票类型*/
@property(nonatomic, strong) NSString *firstType;
/** 股票名称*/
@property(strong, nonatomic) NSString *tempStockName;
/** 股票数*/
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
/** token */
@property(strong, nonatomic) NSString *token;

/** accountID */
@property(copy, nonatomic) NSString *accountId;
/** targetUid */
@property(strong, nonatomic) NSString *targetUid;
/** 区分 是牛人 还是 用户 */
@property(assign, nonatomic) StockBuySellType userOrExpert;

@property(copy, nonatomic) ProfitIndicatorStatr indiactorStatrAnimation;
@property(copy, nonatomic) ProfitIndicatorStop indiactorStopAnimation;
@property(copy, nonatomic) SellButtonClickBlock sellBtnClickBlock;

@property(strong, nonatomic) SimuIndicatorView *indicatorView;

/** 设定初始的股票代码和股票名称 */
- (id)initWithAccountId:(NSString *)accountId
          withTargetUid:(NSString *)targetUid
          WithStockCode:(NSString *)stockCode
          withStockName:(NSString *)stockName
            withMatchId:(NSString *)matchId
       withUserOrExpert:(StockBuySellType)userOrExpert;

/** 对外刷新 */
- (void)refreshButtonPressDownSDFS;

/** 对外提供 一个 查询接口 */
-(void)clickTheStopButton;

- (void)textFieldDealloc;

@end
