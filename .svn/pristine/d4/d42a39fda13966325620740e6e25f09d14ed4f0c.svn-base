//
//  StockPersonTransactionViewController.h
//  SimuStock
//
//  Created by moulin wang on 14-4-10.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SimuUtil.h"
#import "AppDelegate.h"
#import "NetLoadingWaitView.h"
#import "SimuIndicatorView.h"
#import "CommonFunc.h"
#import "MJRefresh.h"

#import "Globle.h"
#import "BaseViewController.h"

#import "MakingScreenShot.h"
#import "MakingShareAction.h"
#import "simuBuyViewController.h"
#import "simuSellViewController.h"
#import "DataArray.h"

#import "TopToolBarView.h"
#import "ClosedPositionViewController.h"
#import "StockTradeListViewController.h"

@interface StockPersonTransactionViewController
    : BaseViewController <UIScrollViewDelegate, TopToolBarViewDelegate> {

  NSInteger pageIndex;

  /** 当前滚动页面索引 */
  //  NSInteger pageIndex;

  //对某一行的操作
  NSInteger tempRow;
  //图片截取成功，做分享
  MakingShareAction *shareAction;
  //查询的用户id
  NSString *mpvc_appointuid;
  //昵称
  NSString *mpvc_titleName;

  //暂无更多数据按钮
  UIButton *noDataFootButton;

  ///创建上方导航栏
  TopToolBarView *topToolbarView;

  ///创建承载滚动视图
  UIScrollView *_scrollView;

  //创建已清仓列表
  ClosedPositionViewController *closedPositionVC;
//交易明细
  StockTradeListViewController *stockTradeListViewController;
}

/** 当前股友的userid */
@property(nonatomic, strong) NSString *uid;
@property(nonatomic,strong)NSString *stockCode;

/** 昵称 */
@property(nonatomic, strong) NSString *titleName;

/** 比赛id */
@property(nonatomic, copy) NSString *matchid;

/** 交易页面初始化 */
- (id)initWithUserID:(NSString *)userId
        withUserName:(NSString *)userName
         withMatchID:(NSString *)matchID;

@end
