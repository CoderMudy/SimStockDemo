//
//  BaseBuySellVC.h
//  SimuStock
//
//  Created by 刘小龙 on 15/7/27.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuySellConstant.h"
#import "ExpertPlanConst.h"
#import "SimuIndicatorView.h"
#import "StockBuySellView.h"
@class SimuStockInfoView;
@class SliederBuySellView;
@class ShareButtonForBuySellView;

/** 买卖界面 */
@interface BaseBuySellVC : UIViewController

/** 菊花 */
@property(strong, nonatomic) SimuIndicatorView *indicatorView;

/** 承载滑块 和 股票信息的view */
@property(strong, nonatomic) UIView *sliederStockInfoView;
/** 股票信息界面 */
@property(strong, nonatomic) SimuStockInfoView *stockInfoView;
/** 滑块界面 */
@property(strong, nonatomic) SliederBuySellView *stockSliederView;
/** 买卖输入框 */
@property(strong, nonatomic) StockBuySellView *stockBuySellView;

/** 分享按钮 */
@property(strong, nonatomic) ShareButtonForBuySellView *shareButtonView;

/** 用来判断 是哪市价成交还是限价成交 */
@property(assign, nonatomic) BOOL marketDealBool;
@property(assign, nonatomic) BOOL fixedDealBool;

/** bool值 用来判断 是否从止盈止损界面过来的 */
@property(assign, nonatomic) BOOL profitStopViewBool;


/** 初始化
 *  1.控件大小frame
 *  2.股票代码 股票名称 stockCode  stockName
 *  3.牛人id 计划id  accountId  targetUid
 *  4.是买 还是 卖   buySellType
 *  5.市价 还是 限价 marketFixedType
 *  6.普通用户 还是 牛人用户  userType
 */
- (instancetype)initWithFrame:(CGRect)frame
                withStockCode:(NSString *)stockCode
                withStockName:(NSString *)stockName
                  withMatchId:(NSString *)matchId
                withAccountId:(NSString *)accountId
                withTargetUid:(NSString *)targetUid
              withBuySellType:(BuySellType)buySellType
          withMarketFixedType:(MarketFixedPriceType)marketFixedType
      withStockBuySellForUser:(StockBuySellType)userType;

/** 对外提供一个方法 来改变 价格和数量的位置 */
- (void)sendFramePriceAmountWithBuySell:(BuySellType)buySell
                         wihtMarkeFixed:(MarketFixedPriceType)marketF;
/** 对外提供的刷新方法  */
- (void)externalSupplyRefreshMethod:(BOOL)isEnd;

/** 看情况 显示分享按钮  */
- (void)showMarketFixedShareButtonWithBool:(BOOL)marketFixed;

/** 对外提供的清楚数据的方法 */
- (void)clearAllDataForSubView;

@end
