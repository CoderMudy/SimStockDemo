//
//  MarketHomeContainerVC.h
//  SimuStock
//
//  Created by Mac on 15/4/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseNoTitleViewController.h"
#import "TopToolBarView.h"
#import "MarketHomeTableViewController.h"
#import "SelfStockTableViewController.h"

@class SimuMainViewController;

/** 行情自选股页面 */
@interface MarketHomeContainerVC
    : BaseNoTitleViewController <UIScrollViewDelegate, TopToolBarViewDelegate,
                                 SimuIndicatorDelegate, ScrollToTopVC> {

  ///创建承载滚动视图
  UIScrollView *_scrollView;

  ///创建行情子VC
  MarketHomeTableViewController *marketViewController;

  ///创建自选股子VC
  SelfStockTableViewController *selfStockViewController;

  ///行情子VC的等待指示器
  SimuIndicatorView *_indicatorView;
}
///创建上方导航栏
@property(nonatomic, strong) TopToolBarView *topToolbarView;
///当前页面索引
@property(assign, nonatomic) NSInteger pageIndex;

/** 开始加载，通知父容器*/
@property(copy, nonatomic) CallBackAction beginRefreshCallBack;

/** 结束加载，通知父容器*/
@property(copy, nonatomic) CallBackAction endRefreshCallBack;

///父控件
@property(nonatomic, weak) SimuMainViewController *simuMainVC;

///初始化
- (id)initGetMainObject:(SimuMainViewController *)controller
              withFrame:(CGRect)frame;

/** 刷新数据，供父容器调用*/
- (void)refreshButtonPressDown;

/** 显示管理自选股 */
- (BOOL)shouldShowManageButton;

/** 管理自选股 */
- (void)manageSelfStocks;

/**
 *  是否支持点击状态栏，返回顶部
 *
 *  @param scrollsToTop BOOL 支持=YES
 */
- (void)enableScrollsToTop:(BOOL)scrollsToTop;

@end
