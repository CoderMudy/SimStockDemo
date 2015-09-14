//
//  simuBottomTrendBarView.h
//  SimuStock
//
//  Created by Mac on 14-8-10.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrendViewController.h"

typedef NS_ENUM(NSUInteger, MarketBottomButtonType) {
  MarketBottomButtonType_Buy = 1,
  MarketBottomButtonType_Sell = 2,
  MarketBottomButtonType_AddPortfolio = 3,
  MarketBottomButtonType_Weibo = 4,
  MarketBottomButtonType_Alarm = 5
};

/** 底部按钮数据类 */
@interface MarketBottomButtonInfo : NSObject

/** 未选中图片名称 */
@property(strong, nonatomic) NSString *notSellectedImageName;

/** 选中图片名称 */
@property(strong, nonatomic) NSString *sellectedImageName;

/**  title */
@property(strong, nonatomic) NSString *titleName;

- (id)initWithTitle:(NSString *)titleName
    withNormalImage:(NSString *)notSellectedImageName
 withHighlightImage:(NSString *)sellectedImageName;

@end

/*
 *类说明：走势K线底部的选择控件
 */
@protocol simuBottomTrendBarViewDelegate <NSObject>

- (void)leftPressDown;

- (void)rightPressDown;
/** 点击中间按钮 */
- (void)pressDownIndex:(NSInteger)index;

@optional
/** 点击发布聊股 */
- (void)distributeVC;
@end

@interface simuBottomTrendBarView : UIView {

  /** 左边按钮 */
  UIButton *leftButton;

  /** 右边按钮 */
  UIButton *rightButton;
}

@property(weak, nonatomic) TrendViewController *delegate;

@property(strong, nonatomic) NSString *matchId;

///区别实盘看行情(没有，买入/卖出)和模拟盘看行情做区分用
@property(nonatomic) BOOL isFirm;
/** 一级类型（详见附录类型说明） */
@property(nonatomic, strong) NSString *firstType;

///实盘看行情没有买入/卖出
- (id)initWithFrame:(CGRect)frame
        withMatchId:(NSString *)matchId
      withFirstType:(NSString *)firstType
          andisFirm:(BOOL)isfirm;

/** 重新设定增删自选股状态 */
- (void)resetSelfStockState:(BOOL)isAddState
     andSelfStockAlarmState:(BOOL)isAlarm;

- (void)resetSelfStockAlarmState:(BOOL)isAlarmState;

/** 设定左右 */
- (void)resetLOrRButton:(BOOL)leftstate RightButton:(BOOL)rightstate;

- (void)setAllButtonArray;

@end
