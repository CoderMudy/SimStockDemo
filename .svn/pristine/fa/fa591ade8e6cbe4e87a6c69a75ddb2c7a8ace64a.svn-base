//
//  VipSectionViewController.h
//  SimuStock
//
//  Created by Mac on 15/5/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "simuTabSelView.h"
#import "StockMasterTradingViewController.h"
#import "BaseWebViewController.h"
#import "ExpertHomePageTbaleVC.h"
@interface VIPStockTradeAdapter : ExpertHomePageAdapter

@end

@interface VIPStockTradeTableViewController : ExpertHomePageTbaleVC

@end

@interface VipSectionViewController
    : BaseViewController <UIScrollViewDelegate> {
  ///当前页面索引
  NSInteger pageIndex;

  ///精选牛人交易
  VIPStockTradeTableViewController *vipOrientedTradesVC;
  ///精选股市资讯
  BaseWebViewController *vipOrientedWebViewVC;

  //创建上方导航栏
  SimuBottomTabView *topToolbarView;

  //创建承载滚动视图
  UIScrollView *_scrollView;
}

@end
