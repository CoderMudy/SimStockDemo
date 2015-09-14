//
//  FirmSaleBuyOrSellInputView.h
//  SimuStock
//
//  Created by Yuemeng on 14-9-22.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

//简单结构：
//股票名称
//显示价格 加减号button
//跌停和涨停
//数量和可卖数量
//买入按钮

// log：2014.9.22：还未有具体UI、数据类，仅先创建UI

#import <UIKit/UIKit.h>
#import "RealTradeStockPriceInfo.h"
#import "WFStockByData.h"
@class PositionResult;

/**选择股票按钮*/
typedef void (^selectStockButtonClickBlock)(void);
/**计算委托数量*/
typedef void (^computeEntrustAmountBlock)(NSString *, NSString *,
                                          BOOL addAndSubtract);
/**买入或卖出点击回调*/
typedef void (^buyOrSellButtonClickBlock)(NSString *, NSString *, NSString *,
                                          NSString *);

/**
 类说明：买入或卖出页面的选股信息输入组件
 */
@interface FirmSaleBuyOrSellInputView : UIView <UIAlertViewDelegate> {
  /**用于判断是购买入还是卖出 */
  BOOL isBuy;
}

/**选股按钮（隐藏的，位于股票代码和名称之下） */
@property(nonatomic, strong) UIButton *selectStockButton;
/**股票代码label */
@property(nonatomic, strong) UILabel *stockCodeLabel;
/**股票名称label */
@property(nonatomic, strong) UILabel *stockNameLabel;
/**减价按钮，每次减少0.01 */
@property(nonatomic, strong) UIButton *subButton;
/**显示股价的文本框 */
@property(nonatomic, strong) UITextField *stockPriceTextField;
/**增加按钮，每次增加0.01 */
@property(nonatomic, strong) UIButton *addButton;
/**减价按钮下面的跌停Label */
@property(nonatomic, strong) UILabel *downStopLabel;
/**加价按钮下面的涨停Label */
@property(nonatomic, strong) UILabel *upStopLabel;
/** - 按钮上的label */
@property(nonatomic, strong) UILabel *stepLabelLeft;
/** + 按钮上的label */
@property(nonatomic, strong) UILabel *stepLabelRight;
/**输入的股票数量文本框 */
@property(nonatomic, strong) UITextField *stockNumberTextField;
/**可买可卖数量，用于下面属性拼接和数量textfield提取对比 */
@property(nonatomic, strong) NSNumber *couldBuyOrSellNumber;
/**显示的可买或可卖数量的label */
@property(nonatomic, strong) UILabel *couldBuyOrSellNumberLabel;
/**买入或卖出button */
@property(nonatomic, strong) UIButton *buyOrSellButton;

/**选择股票按钮*/
@property(nonatomic, copy)
    selectStockButtonClickBlock selectStockButtonClickBlock;
/**计算委托数量*/
@property(nonatomic, copy) computeEntrustAmountBlock computeEntrustAmountBlock;
/**买入或卖出点击回调*/
@property(nonatomic, copy) buyOrSellButtonClickBlock buyOrSellButtonClickBlock;
//判断是 网络数据价格还是手动加减价格
@property(assign, nonatomic) BOOL addAndSubtract;

/**
 初始化此类，必须指定是买入还是卖出页面(非常重要！)
 */
- (id)initWithFrame:(CGRect)frame isBuy:(BOOL)buyOrSell;
/**数据请求完成*/
- (void)dataRequestComplete:(RealTradeStockPriceInfo *)data;

/** 配资界面数据请求完成 */
- (void)capitalDataRequestComplete:(WFStockByInfoData *)data;

/**刷新数据*/
- (void)updateData;

///清空所以数据
- (void)emptyAllData;

@end
