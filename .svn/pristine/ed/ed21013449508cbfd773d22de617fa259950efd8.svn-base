//
//  TrendViewController.h
//  SimuStock
//
//  Created by Mac on 13-9-27.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimuTradeStatus.h"
#import "BaseViewController.h"
#import "simuSellViewController.h"

//协议
#import "simuTabSelView.h"
#import "StockInformationViewController.h"
#import "FTenDataViewController.h"
#import "TrendWeiboViewController.h"
#import "SameStockHeroMainViewController.h"
#import "SecuritiesCurStatusVC.h"

typedef NS_ENUM(NSUInteger, Trend_Page_Type) {

  /** 走势K线页面 */
  TPT_Trend_Mode = 1,

  /** 资讯页面 */
  TPT_Info_Mode,

  /** 牛人页面 */
  TPT_Superman_Mode,

  /** F10页面 */
  TPT_F10_Mode,

  /** 聊股页面 */
  TPT_WB_Mode
};

/*
 *类说明：走势视图
 */
@interface TrendViewController : BaseViewController <UIScrollViewDelegate> {

  UILabel *sbv_codeLable;
  UILabel *sbv_nameLable;

  /** 当前页面类型 */
  Trend_Page_Type tvc_corpagetype;
  /** 分享按钮 */
  UIButton *shareButton;

  //当前动画是否运行
  BOOL tvc_isAnimationRun;

  //当前正在显示的视图
  UIView *tvc_corActiveView;
  //  //新创建但尚未展示的视图
  UIView *tvc_newButNotActiveView;
  //走势页面承载视图和区域
  CGRect tvc_TrendRect;
  CGRect tvc_tradeViewRect;


  //承载视图区域
  CGRect tvc_baseRect;
  //承载视图
  UIView *tvc_baseView;

  //需要切换到的视图控制器
  UIViewController *smvc_toViewController;
  //当前正在展示的视图控制器
  UIViewController *smvc_fromViewController;
  //走势和K线页面

  SecuritiesCurStatusVC *securitiesCurStatusVC;

  //资讯
  StockInformationViewController *tvc_stockInformationVC;
  // F10
  FTenDataViewController *tvc_FTenDataVC;
  //聊股
  TrendWeiboViewController *_weiboViewController;

  ///同股牛人
  SameStockHeroMainViewController *sameStockSupermanVC;

  //涨跌额
  NSString *tvc_upDownPrice;
  //涨跌幅
  NSString *tvc_profit;
  //滚动页面
  UIScrollView *tvc_scrollView;

  //  /** 当前股票序列号 */
  //  NSInteger tvc_index;
}

/** 设置当前的股票数组 */
@property(copy, nonatomic) NSMutableArray *stockCodeArray;

/** 比赛id */
@property(copy, nonatomic) NSString *marchId;

/** 当前股票代码 */
@property(copy, nonatomic) NSString *stockCode;

/** 股票名称 */
@property(copy, nonatomic) NSString *stockName;

/** 股票类型，见StockUtil.h类型定义 */
@property(copy, nonatomic) NSString *firstType;
///是否是实盘看行情（没有 买入/卖出）

@property(nonatomic) BOOL isFirm;

/*当前股票在股票数组中的位置*/ /** 当前股票序列号 */
@property(assign, nonatomic) NSInteger index;

/** 对外创建起始页方法，未完善 */
- (id)initWithStockCode:(NSString *)stockCode
          withStockName:(NSString *)stockName
          withFirstType:(NSString *)firstType
            withMarchId:(NSString *)stockMarchId
          withStartPage:(Trend_Page_Type)pageType;

- (NSString *)getMartchId;

/** 供子页面调用 */
- (void)refreshData:(BOOL)refresh;

/** 点击左边按钮，切换股票 */
- (void)leftPressDown;

/** 点击右边按钮，切换股票 */
- (void)rightPressDown;

/** (YL)点击发布聊股 */
- (void)distributeVC;

/** 显示单只股票详情 */
+ (void)showDetailWithStockCode:(NSString *)stockCode
                  withStockName:(NSString *)stockName
                  withFirstType:(NSString *)firstType
                    withMatchId:(NSString *)matchId;

/** 牛人 显示单只股票详情 */
+ (void)showDetailWithStockCode:(NSString *)stockCode
                  withStockName:(NSString *)stockName
                  withFirstType:(NSString *)firstType
                    withMatchId:(NSString *)matchId withIsExperter:(BOOL)isExpert;

/**(实盘) 显示单只股票详情 */
+ (void)showDetailWithStockCode:(NSString *)stockCode
                  withStockName:(NSString *)stockName
                    withMatchId:(NSString *)matchId
                     withISFirm:(BOOL)isfirm;

+ (void)showDetailWithStockCode:(NSString *)stockCode
                  withStockName:(NSString *)stockName
                  withFirstType:(NSString *)firstType
                    withMatchId:(NSString *)matchId
                  withStartPage:(Trend_Page_Type)startPage;

/** 显示多只股票详情 */
+ (void)showDetailWithStockCode:(NSString *)stockCode
                  withStockName:(NSString *)stockName
                  withFirstType:(NSString *)firstType
                    withMatchId:(NSString *)matchId
                 withStockArray:(NSMutableArray *)dataArray
                      withIndex:(NSInteger)index;

@end
