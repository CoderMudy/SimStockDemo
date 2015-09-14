//
//  PositionInfoView.h
//  SimuStock
//
//  Created by moulin wang on 14-2-12.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimuRankPositionPageData.h"
#import "SimuRankClosedPositionPageData.h"
#import "simuBuyViewController.h"
#import "simuSellViewController.h"
#import "FullScreenLogonViewController.h"
#import "TrendViewController.h"
#import "TradeDetailView.h"
#import "AppDelegate.h"

/**
 *  持仓股票列表：
 * 首页：我的模拟持仓，支持4个按钮，
 *
 * 我的比赛首页：我的持仓，支持4个按钮，买入、卖出按钮需要重新定制，跳转至相邻的Tab页
 * Ta的比赛首页：不支持4个按钮
 *
 * 我的持仓页面：支持4个按钮
 * Ta的持仓：支持4个按钮
 */

typedef void (^BuyOrSellStock)(NSString *stockCode, NSString *stockName, NSString *matchId);

static CGFloat PositionHeight = 210;

@interface PositionInfoView : UIView {
  UIView *_infoView;
  UIView *_lockView;
  UIImageView *_lineView;
  UIView *_uplineView;
  UIView *_downlineView;

  UILabel *profitLabel;
  UILabel *valueLabel;
  UILabel *messageLable;
  BOOL isHidden;
  UIButton *rightButton;

  UILabel *_positionNameLable;
  UILabel *_valueNameLable;
  //锁图片
  UIImageView *_lockimageView;
  //锁背景图片
  UIView *_lockbackView;

  UIButton *_btnBuy;
  UIButton *_btnSell;
  UIButton *_btnMarket;
  UIButton *_btnTradeDetails;
  NSArray *buttonArray;
}

//三角标
@property(nonatomic, strong) UIImageView *triangleImage;

/** 持仓比率 */
@property(nonatomic, strong) UILabel *positionRateLabel;

@property(nonatomic, strong) NSString *matchId;
@property(nonatomic, strong) NSString *uid;
@property(nonatomic, strong) PositionInfo *positionInfo;

@property(nonatomic, copy) BuyOrSellStock buyStockAction;
@property(nonatomic, copy) BuyOrSellStock sellStockAction;

- (id)initWithUserId:(NSString *)uid withMatchId:(NSString *)matchId withFrame:(CGRect)frame;

- (void)createButton;
- (void)present:(CGFloat)height;
- (void)presentForPosition:(CGFloat)height;
- (void)setLockProfit:(NSString *)profit AndValue:(NSString *)value withFrame:(CGRect)rect;
- (void)setLockProfitForTimeOut:(NSString *)profit
                       AndValue:(NSString *)value
                      withFrame:(CGRect)rect;
- (void)setLockProfitForPersonCenter:(NSString *)profit
                            AndValue:(NSString *)value
                           withFrame:(CGRect)rect;
- (void)setPosition:(PositionInfo *)positionInfo
          withFrame:(CGRect)rect
      withTraceFlag:(NSInteger)flag;

//设置持仓追踪过期信息
- (void)setLockProfitForTimeOutForPersonCenter:(NSString *)profit
                                      AndValue:(NSString *)value
                                     withFrame:(CGRect)rect;
@end
