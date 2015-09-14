//
//  ClosedPositionView.h
//  SimuStock
//
//  Created by Mac on 15/8/26.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimuRankClosedPositionPageData.h"
#import "simuBuyViewController.h"
#import "simuSellViewController.h"
#import "FullScreenLogonViewController.h"
#import "TrendViewController.h"
#import "TradeDetailView.h"
#import "AppDelegate.h"

/**
 *  卖出按钮显示逻辑：
 * 1. 比赛历史持仓页面：不显示4个按钮（包括卖出）, 即：比赛id ！= 1
 * 2. 我的交易的已经清仓页面：支持4个按钮，卖出按钮显示逻辑：当前股票在当前用户的持仓中可卖
 * 3. TA的持仓的已经清仓页面：支持4个按钮，卖出按钮显示逻辑：当前股票在当前用户的持仓中可卖
 */

// static CGFloat PositionHeight = 210;

@interface ClosedPositionView : UIView {
  UIView *_infoView;

  UIImageView *_lineView;
  UIView *_uplineView;
  UIView *_downlineView;

  UILabel *profitLabel;
  UILabel *valueLabel;

  BOOL isHidden;
  UIButton *rightButton;

  UILabel *_positionNameLable;
  UILabel *_valueNameLable;


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
@property(nonatomic, strong) ClosedPositionInfo *closedPositionInfo;


- (id)initWithUserId:(NSString *)uid withMatchId:(NSString *)matchId withFrame:(CGRect)frame;

- (void)createButton;
- (void)present:(CGFloat)height;
- (void)presentForPosition:(CGFloat)height;


- (void)setClosedPosition:(ClosedPositionInfo *)closedPositionInfo withFrame:(CGRect)rect;



@end

@interface ClosedPositionCell : UITableViewCell
@property(strong, nonatomic) ClosedPositionView *positionView;
@end
