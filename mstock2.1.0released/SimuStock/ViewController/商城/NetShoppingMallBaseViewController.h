//
//  NetShoppingMallBaseViewController.h
//  SimuStock
//
//  Created by jhss on 13-9-18.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "SimTopBannerView.h"
#import "SimuTouchMoveView.h"
//交易
#import "EBPurchase.h"
#import "SimuIndicatorView.h"
#import "RechargeView.h"
#import "TopToolBarView.h"
#import "RoundButtonView.h"
#import "CompetitionCycleView.h"
#import "DataArray.h"
#import "StoreUtil.h"
#import "DiamondTableVC.h"
#import "PropListTableVC.h"

///商城父视图控制器类型
typedef NS_ENUM(NSInteger, ShopMallParentMode) {
  //父视图控制器是根视图控制器
  TMTM_Mode_BaseController,
  //父视图控制器是模拟炒股视图控制器
  TMTM_Mode_MoniStockController,
  //父视图是个人中心视图控制器
  TMTM_Mode_PersonCenterController,
};

///当前商城页面展示情况
typedef NS_ENUM(NSInteger, shopMallShowPageType) {
  //展示钻石充值页面
  Mall_Buy_Diamond_Mode,
  //当前展示的是资金卡购买页面
  smspt_foundCards_mode,
  //当前展示的是其他道具购买页面
  Mall_Buy_Props,
};

@interface NetShoppingMallBaseViewController
    : BaseViewController <UIAlertViewDelegate, TopToolBarViewDelegate,
                          RoundButtonViewDelegate, DiamondRechargeCellDelegate,
                          CompetitionCycleViewDelegate, UIScrollViewDelegate> {

  //商城兑换、支付工具类
  StoreUtil *storeUtil;

  //创建本视图控制器的父视图控制器类型
  ShopMallParentMode parentsType;

  //商城网址
  NSString *productSortUrl;

  //上部工具栏
  TopToolBarView *ssvc_topToolBar;
  //商品页面
  UIView *ssvc_CommodityView;
  //商品选择工具栏
  RoundButtonView *ssvc_roundButtonView;

  //当前页面展示情况
  shopMallShowPageType ssvc_pageTyep;
  //警告窗口
  CompetitionCycleView *ssvc_alartVeiw;
  //未登录充值、商品选中行
  NSInteger tempProductIndex;
  NSString *tempProductID;
  //充值卡/商品切换
  NSInteger tabIndex;
  //资金卡/道具切换
  NSInteger subTabIndex;

  /** 承载scrollView */
  UIScrollView *_scrollView;

  /** 牛头所在的行 */
  NSInteger cattleRow;
  BOOL isBindCattleRow;
  BOOL isSendCattle;
}

/** 充值，钻石页面 */
@property(strong, nonatomic) DiamondTableVC *diamondTableVC;
/** 商城，资金卡 */
@property(strong, nonatomic) PropListTableVC *fundCardTableVC;
@property(strong, nonatomic) PropListTableVC *propTableVC;

@property(copy, nonatomic) SuccessCallBack successBlock;

- (id)initWithType:(ShopMallParentMode)type;

- (id)initWithPageType:(shopMallShowPageType)type;

- (id)initFromSendCattleWithSuccessCallBack:(SuccessCallBack)successCallBack;

+ (void)startMallWithShowPageType:(shopMallShowPageType)type;

@end
