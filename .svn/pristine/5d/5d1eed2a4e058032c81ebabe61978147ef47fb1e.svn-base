//
//  HomePageTableHeaderPresentation.m
//  SimuStock
//
//  Created by Jhss on 15/7/28.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "HomePageTableHeaderPresentation.h"

@implementation HomePageTableHeaderPresentation

- (id)initWithTableHeaderView:(HomePageTableHeaderView *)tableHeaderView
          withTableHeaderData:(HomePageTableHeaderData *)tableHeaderData {
  if (self = [super init]) {
    _tableHeaderView = tableHeaderView;
    _tableHeaderData = tableHeaderData;

    [self resetTableHeaderViews];
    _tableHeaderView.height = [self returnTheHeaderHeight];
  }
  return self;
}
- (void)removeAllViews {
  [self.tableHeaderView removeAllSubviews];
}
/** 返回表头的高度 */
- (CGFloat)returnTheHeaderHeight {
  return self.tableHeaderView.userInfoViewHeight.constant +
         self.tableHeaderView.followAndAttentionHeight.constant +
         self.tableHeaderView.tradeGradeWidgetHeight.constant +
         self.tableHeaderView.profitCurveHeight.constant +
         self.tableHeaderView.userAssetsHeight.constant;
}
/** 隐藏或显示子Views，子类必须实现此方法 */
- (void)resetTableHeaderViews;
{}

//刷新 数据
- (void)refreshTableHeaderInfoData:
    (HomePageTableHeaderData *)refreshTableHeaderData {
}

@end

@implementation HomePageUserPersonalView

- (void)resetTableHeaderViews {
  //隐藏追踪按钮视图
  self.tableHeaderView.followAndAttentionHeight.constant = 0.0f;
  self.tableHeaderView.followAndAttentionView.hidden = YES;

  //隐藏评级控件和盈利曲线
  self.tableHeaderView.tradeGradeWidgetHeight.constant = 0.0f;
  self.tableHeaderView.tradeGradeWidgetView.hidden = YES;
  self.tableHeaderView.profitCurveHeight.constant = 0.0f;
  self.tableHeaderView.profitCurveView.hidden = YES;

  //绑定数据
  if (self.tableHeaderData.userInfoData != nil) {
    //刷新数据
    [self.tableHeaderView.userInfoView bindUserInfoData:self.tableHeaderData];
    [self.tableHeaderView.followAndAttentionView
        bindHomeAtSuperData:self.tableHeaderData];
    [self.tableHeaderView.userAssetsView
        bindTotalAssetsAndOtherDisplayRelatedData:self.tableHeaderData];

    //判断是否加载评级视图
    if (self.tableHeaderData.tradeGradeItem.isNil) {
      self.tableHeaderView.tradeGradeWidgetHeight.constant = 0.0f;
      self.tableHeaderView.tradeGradeWidgetView.hidden = YES;
    } else {
      self.tableHeaderView.tradeGradeWidgetHeight.constant = 60.0f;
      self.tableHeaderView.tradeGradeWidgetView.hidden = NO;
      //绑定数据
      [self.tableHeaderView.tradeGradeWidgetView
          bindUserTradeGradeInfoWithItem:self.tableHeaderData];
    }
    //判断是否加载盈利曲线视图（如果有交易信息，需要绘制盈利曲线，）
    if (self.tableHeaderData.userInfoData.tradeNum > 0) {
      self.tableHeaderView.profitCurveHeight.constant = 205.0f;
      self.tableHeaderView.profitCurveView.hidden = NO;
      [self.tableHeaderView.profitCurveView
          bindPersonalRankInfoData:self.tableHeaderData];
    }
  }
}
- (void)refreshTableHeaderInfoData:
    (HomePageTableHeaderData *)refreshTableHeaderData {
  self.tableHeaderData = refreshTableHeaderData;

  //绑定数据
  if (refreshTableHeaderData.userInfoData != nil) {
    //刷新数据
    [self.tableHeaderView.userInfoView bindUserInfoData:refreshTableHeaderData];
    [self.tableHeaderView.followAndAttentionView
        bindHomeAtSuperData:self.tableHeaderData];
    [self.tableHeaderView.userAssetsView
        bindTotalAssetsAndOtherDisplayRelatedData:refreshTableHeaderData];

    //判断是否加载评级视图
    if (refreshTableHeaderData.tradeGradeItem.isNil) {
      [self resetTableHeaderViews];
      NSLog(@"没有交易评级控件");
    } else {
      //绑定数据
      [self resetTableHeaderViews];
      [self.tableHeaderView.tradeGradeWidgetView
          bindUserTradeGradeInfoWithItem:refreshTableHeaderData];
    }
    //判断是否加载盈利曲线视图（如果有交易信息，需要绘制盈利曲线，）
    if (refreshTableHeaderData.userInfoData.tradeNum > 0) {
      self.tableHeaderView.profitCurveHeight.constant = 205.0f;
      self.tableHeaderView.profitCurveView.hidden = NO;
      [self.tableHeaderView.profitCurveView
          bindPersonalRankInfoData:refreshTableHeaderData];
    }
  }
}

@end

@implementation HomePageUserOthersView

- (void)resetTableHeaderViews {

  //隐藏评级控件和盈利曲线
  self.tableHeaderView.tradeGradeWidgetHeight.constant = 0.0f;
  self.tableHeaderView.tradeGradeWidgetView.hidden = YES;
  self.tableHeaderView.profitCurveHeight.constant = 0.0f;
  self.tableHeaderView.profitCurveView.hidden = YES;

  //绑定数据
  if (self.tableHeaderData.userInfoData != nil) {
    //判断是否加载评级视图
    if (self.tableHeaderData.tradeGradeItem.isNil) {
      self.tableHeaderView.tradeGradeWidgetHeight.constant = 0.0f;
      self.tableHeaderView.tradeGradeWidgetView.hidden = YES;
    } else {
      self.tableHeaderView.tradeGradeWidgetHeight.constant = 60.0f;
      self.tableHeaderView.tradeGradeWidgetView.hidden = NO;
    }
    //判断是否加载盈利曲线视图（如果有交易信息，需要绘制盈利曲线，）
    if (self.tableHeaderData.userInfoData.tradeNum > 0) {
      self.tableHeaderView.profitCurveHeight.constant = 205.0f;
      self.tableHeaderView.profitCurveView.hidden = NO;
    }
  }
}
- (void)refreshTableHeaderInfoData:
    (HomePageTableHeaderData *)refreshTableHeaderData {
  self.tableHeaderData = refreshTableHeaderData;
  //绑定数据
  if (refreshTableHeaderData.userInfoData != nil) {
    //刷新数据
    [self.tableHeaderView.userInfoView bindUserInfoData:refreshTableHeaderData];
    [self.tableHeaderView.followAndAttentionView
        bindHomeAtSuperData:self.tableHeaderData];
    [self.tableHeaderView.userAssetsView
        bindTotalAssetsAndOtherDisplayRelatedData:refreshTableHeaderData];

    //判断是否加载评级视图
    if (refreshTableHeaderData.tradeGradeItem.isNil) {
      [self resetTableHeaderViews];
        NSLog(@"没有交易评级控件");
    } else {
      //绑定数据
      [self resetTableHeaderViews];
      [self.tableHeaderView.tradeGradeWidgetView
          bindUserTradeGradeInfoWithItem:refreshTableHeaderData];
    }
    //判断是否加载盈利曲线视图（如果有交易信息，需要绘制盈利曲线，）
    if (refreshTableHeaderData.userInfoData.tradeNum > 0) {
      self.tableHeaderView.profitCurveHeight.constant = 205.0f;
      self.tableHeaderView.profitCurveView.hidden = NO;
      [self.tableHeaderView.profitCurveView
          bindPersonalRankInfoData:refreshTableHeaderData];
    }
  }
}

@end