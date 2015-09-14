//
//  StockMatchViewController.h
//  SimuStock
//
//  Created by jhss on 14-5-6.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "SimuMainViewController.h"
//上方导航栏 分栏按钮
#import "TopToolBarView.h"
#import "LoginLogoutNotification.h"
@class ExpertFilterCondition;
#define stockMatch_nav_bar_height 45
#define stockMatch_bottom_bar_height 45

/** 枚举  */
typedef NS_ENUM(NSInteger, MatchStockType) {
  AllMathc = 0,   //所有比赛
  SchoolMatc = 1, //校园比赛
  RewardMatc = 2,
  MyMathc = 3,    //我的比赛
  SearchMatch = 4 //搜索比赛
};

@interface StockMatchViewController
    : UIViewController <UIScrollViewDelegate, TopToolBarViewDelegate, ScrollToTopVC> {
  /** 当前选中的Tab index */
  NSInteger currentTab;
  /** 滚动视图 */
  UIScrollView *_scrollView;
  //上方分栏 导航条
  TopToolBarView *_topToolBarView;
}

@property(nonatomic,strong) ExpertFilterCondition *xxx;

///登录、退出事件通知
@property(nonatomic, strong) LoginLogoutNotification *loginLogoutNotification;

@property(strong, nonatomic) SimuMainViewController *simuMainVC;
/** 开始加载，通知父容器*/
@property(copy, nonatomic) CallBackAction beginRefreshCallBack;
/** 结束加载，通知父容器*/
@property(copy, nonatomic) CallBackAction endRefreshCallBack;
/** 枚举 */
@property(assign, nonatomic) MatchStockType matchType;

- (id)initGetMainObject:(SimuMainViewController *)controller;

/** 创建比赛 */
- (void)createMatch;

/**
 *  是否支持点击状态栏，返回顶部
 *
 *  @param scrollsToTop BOOL 支持=YES
 */
- (void)enableScrollsToTop:(BOOL)scrollsToTop;

@end
