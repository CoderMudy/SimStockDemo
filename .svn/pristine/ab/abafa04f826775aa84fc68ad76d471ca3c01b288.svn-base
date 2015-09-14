//
//  StockBarsViewController.h
//  SimuStock
//
//  Created by Yuemeng on 14-11-24.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimuIndicatorView.h"
#import "SimuTopToolBarView.h"
#import "LittleCattleView.h"
#import "TopToolBarView.h"
#import "DataArray.h"
#import "MJRefresh.h"
#import "GameAdvertisingViewController.h"
#import "WeiboListViewController.h"
#import "LoginLogoutNotification.h"

@class FriendChatStockTableVC;
@class HotestChatStockTableVC;

/** 聊股吧首页 */
@interface StockBarsViewController
    : UIViewController <TopToolBarViewDelegate, UITableViewDataSource,
                        UITableViewDelegate, SimuIndicatorDelegate,
                        MJRefreshBaseViewDelegate, UIGestureRecognizerDelegate,
                        GameAdvertisingDelegate, ScrollToTopVC> {

  NSTimeInterval times;
  /** 好友圈 聊股吧 最热 */
  TopToolBarView *_topToolBarView;

  /** 广告对象 */
  GameAdvertisingViewController *advViewVC;

  /** 三个表格的承载滑动视图 */
  UIScrollView *_scrollView;

  /** 当前页 */
  NSInteger _currentPage;
  /** 好友圈头标题  */
  UIView *friendHeadView;
  /** 好友圈跑马灯*/
  UIScrollView *friendScrollView;
  //定时器(跑马灯定时器)
  NSTimer *iKLTimer;
  /** 好友圈头标题 */
  UILabel *friendHeadLabel;
  /** 聊股id */
  NSNumber *headTstockId;

  /** 聊股吧表格 */
  UITableView *_stockBarsTableView;

  /** 聊股吧MJ表头*/
  MJRefreshHeaderView *_stockBarsHeaderView;

  /** 刷新计数器，每完成一个请求，-1 */
  NSInteger _requestFinishedCount;

  /** 小牛 */

  LittleCattleView *_stockBarLittleCattleView;

  /** 聊股吧是否已数据绑定 */
  BOOL _isStockBarBinded;
  /** 我关注的股吧列表 */
  DataArray *_myBarsList;
  /** 主题吧 */
  NSMutableArray *_themeBarsList;
  /** 牛人吧 */
  NSMutableArray *_masterBarsList;
  /** 热门个股吧数据数组 */
  NSMutableArray *_hotStockTopicList;
  /** 推荐列表 */
  DataArray *_tweetList;
  /** 跑马灯按钮数组 */
  NSMutableArray *_paomaButtons;

  FriendChatStockTableVC *_friendWeiboListViewController;
  HotestChatStockTableVC *_hotestWeiboListViewController;
}

///登录、退出事件通知
@property(nonatomic, strong) LoginLogoutNotification *loginLogoutNotification;

/** 首页指针 */
@property(strong, nonatomic) SimuMainViewController *simuMainVC;

/** 开始加载，通知父容器*/
@property(copy, nonatomic) CallBackAction beginRefreshCallBack;

/** 结束加载，通知父容器*/
@property(copy, nonatomic) CallBackAction endRefreshCallBack;

/** 获取首页指针 */
- (id)initGetMainObject:(SimuMainViewController *)controller;

/** 发表聊股 */
- (void)publishButtonClick;

/**
 *  是否支持点击状态栏，返回顶部
 *
 *  @param scrollsToTop BOOL 支持=YES
 */
- (void)enableScrollsToTop:(BOOL)scrollsToTop;

@end
