//
//  BuySellViewController.h
//  SimuStock
//
//  Created by 刘小龙 on 15/5/25.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "simuselMonyeButView.h"
#import "SimuleftImagButtonView.h"
#import "simuselMonyeButView.h"
#import "SimuStockInfoView.h"
#import "OpeningTimeView.h"
#import "SimuTradeBaseData.h"
#import "SimuDoDealSubmitData.h"
#import "BaseRequester.h"
#import "StockUtil.h"
#import "SimuIndicatorView.h"
#import "ExpertPlanConst.h"
#import "StockBuySellView.h"


///菊花开始旋转
typedef void (^IndicatorStatr)();
///菊花停止旋转
typedef void (^IndicatorStop)();

@interface BuySellViewController
    : UIViewController <UITextFieldDelegate, SimuleftButtonDelegate,
                        simuselMonyButDelegate> {
  /** 买卖承载页面 */
  UIView *ssvc_baseView;
  /** 股票代码，数量等的输入区域(以scv_bottombackRect未基准) */
  CGRect scv_inputBaseRect;
  /** 股票代码 */
  UILabel *scv_stockCodeLable;
  /** 股票代码输入 */
  UITextField *svc_stockCodeTextField;
  /** 股票名字输入 */
  UITextField *svc_stockNameTextField;

  /** 小滑快 */
  UISlider *scv_littleSliderView;
  //  /** 滑快上方资金数量 */
  //  UILabel *scv_foundsLB;
  //更多选择资金按钮
  simuselMonyeButView *scv_moneySelView;
  /** 股票相关信息 */
  SimuStockInfoView *scv_stockInfoView;
//  /** 闹钟和时间控件 */
//  OpeningTimeView *scvc_openingTimeView;
  /** 上次输入的股票价格 */
  float scv_lastprice;
  /** 资金总量 */
  long long scv_buystockNumber;
  /** 分享按钮 */
  UIButton *shareBut;
  /** 买入查询数据 */
  SimuTradeBaseData *simuBuyQueryData;

  //类型
  StockBuySellType _stockBuySellType;
}

/** 闹钟和时间控件 */
@property(strong, nonatomic) OpeningTimeView *scvc_openingTimeView;

@property(strong, nonatomic) SimuIndicatorView *indicatorView;

///牛人计划
@property(copy, nonatomic) NSString *accountId;
/** targetUid */
@property(copy, nonatomic) NSString *targetUid;

/** 股票代码 */
@property(strong, nonatomic) NSString *tempStockCode;
/** 股票名称 */
@property(strong, nonatomic) NSString *tempStockName;
/** 比赛ID */
@property(strong, nonatomic) NSString *matchId;
/** 股票NO */
@property(strong, nonatomic) NSString *tempStockNumber;
/** 是否从比赛页面进入的，如果是，则不需要请求 */
@property(nonatomic) BOOL isFromMatch;
///菊花开始
@property(copy, nonatomic) IndicatorStatr indicatorStatrAnimation;
///菊花停止
@property(copy, nonatomic) IndicatorStop indicctorStopAnmation;
/** 滑动条和数据展示的 承载页面 */
@property(strong, nonatomic) UIView *sliderView;

///滑块上方的资金显示
@property(strong, nonatomic) UILabel *scv_foundsLB;
/** 滑快上方最小卖出股量 */
@property(strong, nonatomic) UILabel *scv_minNumber;
/** 滑快上方最大卖出股量 */
@property(strong, nonatomic) UILabel *scv_maxNumber;
///判断是 市价还是限价
@property(assign, nonatomic) BOOL marketFixedPrice;

///如果滑动按钮 滑动了做下记录
@property(assign, nonatomic) BOOL sliderFoundsBool;
///记录原发生变化前的总价格
@property(copy, nonatomic) NSString *oldPrice;

/// textFiled 背景框
@property(strong, nonatomic) UIView *backView1;
@property(strong, nonatomic) UIView *backView2;

/** 用来判断是买入 还是 卖出  */
@property(assign, nonatomic) BOOL isBuyOrSell;

/** 用来判断 买入卖出 刷新价格用 */
@property(assign, nonatomic) BOOL sellMarketFiexdBool;

/** 用来判断 是哪市价成交还是限价成交 */
@property(assign, nonatomic) BOOL marketDealBool;
@property(assign, nonatomic) BOOL fixedDealBool;

/** 买入卖出控件 */
@property(strong, nonatomic) StockBuySellView *buySellView;

/** 止盈止损 */
@property(copy, nonatomic) NSString *zhiyingzhisuo;
/*********** 记录资金标签数值 **********/

/** 市价资金标签值  */
@property(assign, nonatomic) NSInteger markeFoundsValue;
/** 限价资金标签值  */
@property(assign, nonatomic) NSInteger fixedFoundsValue;

/** 判断资金按钮有没有被点击 */
@property(assign, nonatomic) BOOL moneyButton;

/** 删除买入页面所有内容 对外提供的清空数据的方法 */
- (void)reset;

/** 设定初始的股票代码和股票名称 */
- (id)initWithFrame:(CGRect)frame
           withStockCode:(NSString *)stockCode
           withStockName:(NSString *)stockName
             withMatchId:(NSString *)matchId
           withBuyOrSell:(BOOL)buyOrSell
         withMarketFixed:(BOOL)marketFixed
           withAccountID:(NSString *)accountId
           withTargetUid:(NSString *)targetUid
    withStockSellBuyType:(StockBuySellType)type;

///对外提供的刷新按钮
- (void)refreshButtonPressDown;

///对外提供从新刷新数据
- (void)againRefreshData;

/** 提供一个新的刷新方式 只刷新价格 */
- (void)refreshPriceForFixedSell;

///判断输入的价格是否在正确的价格区间
- (BOOL)reasonablePrice:(NSString *)priceStr;

/** 输入 YES NO 来重新布局 买入卖出市价和限价时 控件的位置 */
- (void)sendFramePriceAmountWithBuySell:(BOOL)buySell
                         wihtMarkeFixed:(BOOL)marketF;

/** 交易完成后 清空所以数据的方法 */
- (void)followingTransactionClearsData;
/** 看情况 显示分享按钮  */
- (void)showMarketFixedShareButtonWithBool:(BOOL)marketFixed;

/** 加载菊花 大菊花和小菊花 */
- (void)statrNetLoadingView;

/** 停止菊花 菊花和小菊花 */
- (void)stopLoading;

@end
