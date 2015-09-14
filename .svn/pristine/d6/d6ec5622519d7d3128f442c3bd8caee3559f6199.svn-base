//
//  SimuJoinViewController.h
//  SimuStock
//
//  Created by Mac on 14-8-2.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "simuBuyViewController.h"
#import "simuSellViewController.h"
#import "SimuACountVC.h"
#import "simuCancellationViewController.h"
#import "simumarchToolBarView.h"
#import "MatchWeiboViewController.h"
#import "SimuJoinBottomTabView.h"

/*
 *进入比赛页面
 */
@interface SimuJoinViewController : BaseViewController <simuBottomToolBarViewDelegate> {
  /** 上工具栏 */
  SimTopBannerView *ssvc_topToolBar;

  SimuJoinBottomTabView *bottomToolBar;
  /** 需要切换到的视图控制器 */
  UIViewController *smvc_toViewController;
  /** 当前正在展示的视图控制器 */
  UIViewController *smvc_fromViewController;
  /** 承载页面 */
  UIView *ssvc_baseView;
  /**  marchID */
  NSString *ssvc_marchid;
  /** 名称 */
  NSString *ssvc_marchname;
  /** 账户主页 */
  SimuMacthAccountVC *_userAcountVC;
  /** 买入股票页面 */
  simuBuyViewController *ssvc_buyVC;
  /** 卖出股票页面 */
  simuSellViewController *ssvc_sellVC;
  /** 委托页面 */
  simuCancellationViewController *ssvc_cancellVC;
  /** 聊股页面 */
  MatchWeiboViewController *ssvc_weiboVC;
  /** 委托页面的撤单按钮 */
  UIButton *revokeButton;
  SimuIndicatorView *revokeRefreshButton;
}

- (id)init:(NSString *)march_id Name:(NSString *)march_name;
/** 公用的返回处理 */
@property(nonatomic, copy) onBackButtonPressed commonBackHandler;

@end
