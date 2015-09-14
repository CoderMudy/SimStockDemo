//
//  StockMasterViewController.h
//  SimuStock
//
//  Created by jhss on 13-11-29.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "SimTopBannerView.h"
#import "SimuTouchMoveView.h"
#import "SimuIndicatorView.h"
#import "TopToolBarView.h"
#import "StockMasterTradingViewController.h"
#import "StockHeroRankListViewController.h"
#import "FollowMasterViewController.h"

@class SimuMainViewController;

@interface StockMasterViewController
    : BaseNoTitleViewController <UIScrollViewDelegate, TopToolBarViewDelegate,
                                 SimuIndicatorDelegate> {
  ///当前页面索引
  NSInteger pageIndex;

  /**刷新按钮*/
  UIButton *refreshButton;
  /**是否开通追踪权限*/

  //创建上方导航栏
  TopToolBarView *topToolbarView;

  //创建承载滚动视图
  UIScrollView *_scrollView;

  //创建已清仓列表
  StockMasterTradingViewController *tradingVC;

  StockHeroRankListViewController *heroRankListVC;
  /** 追踪牛人 */
  FollowMasterViewController *followMasterVC;
                                   
}
@property(weak, nonatomic) SimuMainViewController *simuMainVC;

/** 开始加载，通知父容器*/
@property(copy, nonatomic) CallBackAction beginRefreshCallBack;

/** 结束加载，通知父容器*/
@property(copy, nonatomic) CallBackAction endRefreshCallBack;

- (id)initGetMainObject:(SimuMainViewController *)controller
              withFrame:(CGRect)frame;

/** 判断是否开启牛人计划 */
@property (nonatomic)BOOL isOpenMasterPlan;


@end
